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
		
		targetPort.sendPi( "A 0 3 0 5" )
	}
	
	@IBAction func topAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 0 5 0 5" )
	}

	@IBAction func trAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 0 5 0 3" )
	}

	@IBAction func leftAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 1 4 0 4" )
	}

	@IBAction func centerAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 0 0 0 0" )
	}

	@IBAction func rightAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 0 4 1 4" )
	}

	@IBAction func blAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 1 3 1 5" )
	}

	@IBAction func bottomAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 1 5 1 5" )
	}

	@IBAction func brAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 1 5 1 3" )
	}

}
