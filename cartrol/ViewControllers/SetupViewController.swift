//
//  SetupViewController.swift
//  cartrol
//
//  Created by William Snook on 3/30/19.
//  Copyright © 2019 billsnook. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {
	
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
//		self.navigationController?.setNavigationBarHidden( true, animated: true )
		
		super.viewWillDisappear( animated )
	}

	@IBAction func Save(_ sender: UIBarButtonItem) {
		
		print( "In Save" )
		
		// So save
		
		// Return here - otherwise we would have to check on back button
		
		self.navigationController?.popViewController( animated: true )
		
	}
	
	
}
