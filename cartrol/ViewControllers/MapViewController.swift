//
//  MapViewController.swift
//  cartrol
//
//  Created by William Snook on 3/30/19.
//  Copyright © 2019 billsnook. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

	@IBOutlet var b1: UIButton!
	@IBOutlet var b2: UIButton!
	@IBOutlet var b3: UIButton!
	@IBOutlet var b4: UIButton!
	
	
	
	var isConnected = false

	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear( animated )
		
		self.navigationController?.setNavigationBarHidden( false, animated: true )	// Show it on this page
		
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
	
	// Default sweep is 0 - 180º
	
	@IBAction func b1Action(_ sender: Any) {
		print( "In b1Action" )
	}
	
	@IBAction func b2Action(_ sender: Any) {
		print( "In b2Action" )
	}
	
	@IBAction func b3Action(_ sender: Any) {
		print( "In b3Action" )
		// Setup - show dialog to get parameters
	}
	
	@IBAction func b4Action(_ sender: Any) {
		print( "In b4Action" )
	}
	
}
