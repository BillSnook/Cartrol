//
//  DirectViewController.swift
//  cartrol
//
//  Created by William Snook on 11/7/18.
//  Copyright © 2018 billsnook. All rights reserved.
//

import UIKit

class DirectViewController: UIViewController {
	
	var isConnected = false
	
	override func viewDidLoad() {
		super.viewDidLoad()

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear( animated )
		
		self.navigationController?.setNavigationBarHidden( false, animated: true )	// Just hide it on this page
		
		if targetPort.socketConnected {
//			targetPort.sendPi( "" )	// ? Sign in ?
			isConnected = true
		} else {
			// Alert
		}

	}

	override func viewWillDisappear(_ animated: Bool) {
		self.navigationController?.setNavigationBarHidden( true, animated: true )
		
		super.viewWillDisappear( animated )
	}

	@IBAction func tlAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "0 1 2" )	// Left
		targetPort.sendPi( "1 1 4" )	// Right
	}
	
	@IBAction func topAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "0 1 4" )	// Left
		targetPort.sendPi( "1 1 4" )	// Right
	}

	@IBAction func trAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "0 1 4" )	// Left
		targetPort.sendPi( "1 1 2" )	// Right
	}

	@IBAction func leftAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "0 0 3" )	// Left
		targetPort.sendPi( "1 1 3" )	// Right
	}

	@IBAction func centerAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "s" )
	}

	@IBAction func rightAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "0 1 3" )	// Left
		targetPort.sendPi( "1 0 3" )	// Right
	}

	@IBAction func blAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "0 1 2" )	// Right
		targetPort.sendPi( "1 1 4" )	// Right
	}

	@IBAction func bottomAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "0 1 4" )	// Right
		targetPort.sendPi( "1 1 4" )	// Right
	}

	@IBAction func brAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "0 1 4" )	// Left
		targetPort.sendPi( "1 1 2" )	// Right
	}

}
