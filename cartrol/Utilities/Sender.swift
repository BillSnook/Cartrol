//
//  Sender.swift
//  cartrol
//
//  Created by William Snook on 5/9/18.
//  Copyright © 2018 billsnook. All rights reserved.
//

import UIKit
import Darwin.C


public protocol CommandResponder {
	func handleReply( msg: String )
}


public class Sender {
	
	var socketfd: Int32 = 0
	var socketConnected = false
	var commandResponder: CommandResponder?
	
	public init() {}
	
	public func setCommandResponder( _ responder: CommandResponder? ) {
		commandResponder = responder
	}
	
	deinit {
		if socketConnected {
			socketConnected = false
			if socketfd != 0 {
				close( socketfd )
				socketfd = 0
			}
		}
	}
	
	public func doBreakConnection() {
		if socketConnected {
			socketConnected = false
			if socketfd != 0 {
				close( socketfd )
				socketfd = 0
			}
		}
	}
	
	public func doMakeConnection( to: String, at: UInt16 ) -> Bool {
		
		socketfd = socket( AF_INET, SOCK_STREAM, 0 )		// ipv4, tcp    // SOCK_DGRAM for UDP
		
		guard let targetAddr = doLookup( name: to ) else {
			print( "\nLookup failed for \(to)" )
			return false
		}
		print( "\nFound target address: \(targetAddr)" )
		
		let result = doConnect( targetAddr, port: at )
		guard result >= 0 else {
//			let strerr = strerror( errno )
//			print( "\nConnect failed, error: \(result) - \(String(describing: strerr))" )
			return false
		}
		socketConnected = true
		print( "\nConnected on port \(at) to host \(to) (\(targetAddr))\n" )
		return true
	}
	
	func doLookup( name: String ) -> String? {
		var hints = addrinfo(
			ai_flags: AI_PASSIVE,       // Assign the address of my local host to the socket structures
			ai_family: AF_INET,      	// IPv4
			ai_socktype: SOCK_STREAM,   // TCP -- SOCK_DGRAM for UDP
			ai_protocol: 0, ai_addrlen: 0, ai_canonname: nil, ai_addr: nil, ai_next: nil )
		var servinfo: UnsafeMutablePointer<addrinfo>? = nil		// For the result from the getaddrinfo
		let status = getaddrinfo( name + ".local", "5555", &hints, &servinfo)
		guard status == 0 else {
			let stat = strerror( errno )
			print( "\ngetaddrinfo failed for \(name), status: \(status), error: \(String(describing: stat))" )
			return nil
		}
		
		var target: String?
		var info = servinfo
		while info != nil {					// Check for addresses
			var ipAddressString = [CChar]( repeating: 0, count: Int(INET_ADDRSTRLEN) )
			let sockAddrIn = info!.pointee.ai_addr.withMemoryRebound( to: sockaddr_in.self, capacity: 1 ) { $0 }
			var ipaddr_raw = sockAddrIn.pointee.sin_addr.s_addr
			inet_ntop( info!.pointee.ai_family, &ipaddr_raw, &ipAddressString, socklen_t(INET_ADDRSTRLEN))
			let ipaddrstr = String( cString: &ipAddressString )
			if strlen( ipaddrstr ) < 16 {	// Valid IPV4 address string
				target = ipaddrstr
				break						// Get first valid IPV4 address
			}
			print( "\nGot target address: \(String(describing: target))" )
			info = info!.pointee.ai_next
		}
		freeaddrinfo( servinfo )
		return target
	}
	
	
	func doConnect( _ addr: String, port: UInt16 ) -> Int32 {
		var serv_addr_in = sockaddr_in( sin_len: __uint8_t(MemoryLayout< sockaddr_in >.size), sin_family: sa_family_t(AF_INET), sin_port: port.bigEndian, sin_addr: in_addr( s_addr: inet_addr(addr) ), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0) )
		let serv_addr_len = socklen_t(MemoryLayout.size( ofValue: serv_addr_in ))
		let connectResult = withUnsafeMutablePointer( to: &serv_addr_in ) {
			$0.withMemoryRebound( to: sockaddr.self, capacity: 1 ) {
				connect( socketfd, $0, serv_addr_len )
			}
		}
		if connectResult < 0 {
			let stat = String( describing: strerror( errno ) )
			print("\nERROR connecting, errno: \(errno), \(stat)")
			return connectResult
		}
		
		// Start read thread
		DispatchQueue.global(qos: .userInitiated).async { [weak self] () -> Void in
			while self?.socketfd != 0 {
				var readBuffer: [CChar] = [CChar](repeating: 0, count: 1024)
				
				let rcvLen = read( (self?.socketfd)!, &readBuffer, 1024 )
				if (rcvLen <= 0) {
					if let stat = strerror( errno ) {
						print( "\n\nError reading from socket: \(String( describing: stat ))" )
						break
					}
				} else {
					DispatchQueue.main.async {
						if self?.commandResponder != nil {
							self?.commandResponder?.handleReply( msg: String( cString: readBuffer ) )
						}
					}
				}
			}
		}

		return connectResult
	}
	
	@discardableResult public func sendPi( _ message: String ) -> String {
		
		guard socketConnected else { return "Socket is not connected" }
		let command = message + "\n"
		var writeBuffer: [CChar] = [CChar](repeating: 0, count: 1024)
		strcpy( &writeBuffer, command )
		let len = strlen( &writeBuffer )
		let sndLen = write( socketfd, &writeBuffer, Int(len) )
		if ( sndLen < 0 ) {
			let stat = strerror( errno )
			print( "\n\nERROR writing to socket: \(String( describing: stat ))" )
			return "ERROR writing to socket, returned: \(sndLen)"
		}
		
		return ""
	}

	public func sendCommand( _ message: String, with useResponder: CommandResponder? ) {
		
		guard socketConnected else { return }
		DispatchQueue.global(qos: .userInitiated).async { [weak self] () -> Void in
			
			let command = message + "\n"
			var writeBuffer: [CChar] = [CChar](repeating: 0, count: 1024)
			strcpy( &writeBuffer, command )
			let len = strlen( &writeBuffer )
			
			guard let skt = self?.socketfd else { return }
			let sndLen = write( skt, &writeBuffer, Int(len) )
			if ( sndLen < 0 ) {
				let stat = strerror( errno )
				print( "\n\nERROR writing to socket: \(String( describing: stat ))" )
				return
			}
			var readBuffer = [CChar](repeating: 0, count: 1024)
		
			let rcvLen = read( (self?.socketfd)!, &readBuffer, 1024 )
			if (rcvLen < 0) {
				if let stat = strerror( errno ) {
					print( "\n\nRead \(rcvLen) bytes from socket:  \(String( describing: stat ))" )
				}
			} else {
				DispatchQueue.main.async {
					if useResponder != nil {
						useResponder!.handleReply( msg: String( cString: readBuffer ) )
					} else {
						if self?.commandResponder != nil {
							self!.commandResponder!.handleReply( msg: String( cString: readBuffer ) )
						}
					}
				}
			}
		}
	}
}
