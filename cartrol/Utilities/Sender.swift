//
//  Sender.swift
//  cartrol
//
//  Created by William Snook on 5/9/18.
//  Copyright © 2018 billsnook. All rights reserved.
//

import Foundation
import Darwin.C


public class Sender {
	
	var socketfd: Int32 = 0
	var socketConnected = false
	
	public init() {
	}
	
	deinit {
		if socketConnected {
			socketConnected = false
			close( socketfd )
		}
	}
	
	public func doBreakConnection() {
		if socketConnected {
			socketConnected = false
			close( socketfd )
		}
	}
	
	public func doMakeConnection( to: String, at: UInt16 ) -> Bool {
		
		socketfd = socket( AF_INET, SOCK_STREAM, 0 )		// ipv4, tcp
		
		guard let targetAddr = doLookup( name: to ) else {
			print( "\nLookup failed for \(to)" )
			return false
		}
		//		print( "\nFound target address: \(targetAddr!)" )
		
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
			ai_socktype: SOCK_STREAM,   // TCP
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
		}
		
		return connectResult
	}
	
	public func sendPi( _ message: String ) -> String {
		
		guard socketConnected else { return "Socket is not connected" }
		let command = message + "\n"
		var writeBuffer: [CChar] = [CChar](repeating: 0, count: 256)
		strcpy( &writeBuffer, command )
		let len = strlen( &writeBuffer )
		let sndLen = write( socketfd, &writeBuffer, Int(len) )
		if ( sndLen < 0 ) {
			let stat = strerror( errno )
			print( "\n\nERROR writing to socket: \(String( describing: stat ))" )
			return "ERROR writing to socket"
		}
		
		var readBuffer: [CChar] = [CChar](repeating: 0, count: 256)
		let rcvLen = read( socketfd, &readBuffer, 255 )
		if (rcvLen < 0) {
			if let stat = strerror( errno ) {
				print( "\n\nERROR reading from socket:  \(String( describing: stat ))" )
			}
			return "ERROR reading from socket"
		}
		return String( cString: readBuffer )
	}
}

