//
//  Sender.swift
//  cartrol
//
//  Created by William Snook on 5/9/18.
//  Copyright © 2018 billsnook. All rights reserved.
//

import UIKit
import Darwin.C

let useDatagramProtocol = true

public protocol CommandResponder {
	func handleReply( msg: String )
}


public class Sender {
	
	var socketfd: Int32 = 0
	var socketConnected = false
    var deadTime = Timer()
    
	var commandResponder: CommandResponder?
	
	public init() {}
	
	public func setCommandResponder( _ responder: CommandResponder? ) {
		commandResponder = responder
	}
	
	deinit {
		if socketConnected {
            sendPi( "#" )               // Sign off device
            usleep( 1000000 )
            deadTime.invalidate()       // Stop sending keep-alive
			socketConnected = false
			if socketfd != 0 {
				close( socketfd )
				socketfd = 0
			}
		}
	}
	
	public func doBreakConnection() {
		if socketConnected {
            sendPi( "#" )               // Sign off device
            usleep( 1000000 )
            deadTime.invalidate()       // Stop sending keep-alive
			socketConnected = false
			if socketfd != 0 {
				close( socketfd )
				socketfd = 0
			}
		}
	}
	
	public func doMakeConnection( to address: String, at port: UInt16 ) -> Bool {
		
        if socketConnected {
            socketConnected = false
            if socketfd != 0 {
                close( socketfd )
                socketfd = 0
            }
        }
        if useDatagramProtocol {
            socketfd = socket( AF_INET, SOCK_DGRAM, 0 )         // ipv4, udp
        } else {
            socketfd = socket( AF_INET, SOCK_STREAM, 0 )        // ipv4, tcp
        }

		guard let targetAddr = doLookup( name: address ) else {
			print( "\nLookup failed for \(address)" )
			return false
		}

        print( "\nFound target address: \(targetAddr), connecting..." )
        let result = doConnect( targetAddr, port: port )
        guard result >= 0 else {
            let strerr = strerror( errno )
            print( "\nConnect failed, error: \(result) - \(String(describing: strerr))" )
            return false
        }
        print( "Connected on socket \(socketfd) on port \(port) address host \(address) (\(targetAddr))\n" )
		socketConnected = true
        
        readThread()    // Loop waiting for input
        
		return true
	}
	
	func doLookup( name: String ) -> String? {
		var hints = addrinfo(
			ai_flags: AI_PASSIVE,       // Assign the address of my local host to the socket structures
			ai_family: AF_INET,      	// IPv4
            ai_socktype: SOCK_DGRAM,   // UDP -- SOCK_STREAM for TCP - Either seem to work here
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
		while info != nil {					// Check for addresses - typically there is only one ipv4 address
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
            print("\nERROR connecting, errno: \(errno), \(stat )")
			return connectResult
		}
        return connectResult
    }
    
    func readThread() {         // Start read thread
		DispatchQueue.global(qos: .userInitiated).async { [weak self] () -> Void in
			while self?.socketfd != 0 {
				var readBuffer: [CChar] = [CChar](repeating: 0, count: 1024)
				var rcvLen = 0
                if useDatagramProtocol {
                    rcvLen = recv(self!.socketfd, &readBuffer, 1024, 0)
                } else {
                    rcvLen = read(self!.socketfd, &readBuffer, 1024 )
                }
				if (rcvLen <= 0) {
                    print( "\n\nConnection lost while receiving" )
                    break
				} else {
                    let str = String( cString: readBuffer, encoding: .utf8 ) ?? "bad data"
//                    print( "\nRead \(rcvLen) bytes from socket \(self!.socketfd), \(str)\n" )
					DispatchQueue.main.async {
						if self?.commandResponder != nil {
							self?.commandResponder?.handleReply( msg: str  )
						}
					}
				}
			}
		}
        DispatchQueue.main.async {
//            self.deadTime.invalidate()
//            self.deadTime = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerStart), userInfo: nil, repeats: false )
            self.sendPi( "@" )
        }
	}
	
	public func sendPi( _ message: String ) {
		
		guard socketConnected else { return }
//        print( "Sent \(message.first! )")
        deadTime.invalidate()
        deadTime = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false )
        let command = message + "\0";
		var writeBuffer: [CChar] = [CChar](repeating: 0, count: 1024)
		strcpy( &writeBuffer, command )
		let len = strlen( command )
        var sndLen = 0
        if useDatagramProtocol {
            sndLen = send( socketfd, &writeBuffer, Int(len), 0 )
        } else {
            sndLen = write( socketfd, &writeBuffer, Int(len) )
        }
		if ( sndLen < 0 ) {
			print( "\n\nConnection lost while sending" )
			return
		}
//        print( "\nWrote to socket \(socketfd)\n" )

		return
	}

    @objc func timerAction() {
        sendPi( "?" )   // Keep-alive
//        print( "?", terminator: "")
    }

    @objc func timerStart() {
        sendPi( "@" )   // Trigger start
        print( "@", terminator: "")
    }

}
