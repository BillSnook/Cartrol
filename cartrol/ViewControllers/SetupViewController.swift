//
//  SetupViewController.swift
//  cartrol
//
//  Created by William Snook on 3/30/19.
//  Copyright © 2019 billsnook. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {
	
	@IBOutlet var startAngleTextField: UITextField?
	@IBOutlet var endAngleTextField: UITextField!
	@IBOutlet var incrementTextField: UITextField!
	
	var delegate: SweepParamDelegate?
	
	var isConnected = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear( animated )
		
		self.navigationController?.setNavigationBarHidden( false, animated: true )	// Show it on this page
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
//		self.navigationController?.setNavigationBarHidden( true, animated: true )
		
		super.viewWillDisappear( animated )
	}

	@IBAction func Save(_ sender: UIBarButtonItem) {
		
		print( "In Save" )
		
		// So save
		if let sweepDelegate = delegate {
			let startAngle = Int( startAngleTextField?.text ?? "0" ) ?? 0
			let endAngle = Int( endAngleTextField.text ?? "0" ) ?? 0
			let increment = Int( incrementTextField.text ?? "0" ) ?? 0
			sweepDelegate.newSweepSettings( startAngle, endAngle, increment )
		}
		// Return here - otherwise we would have to check on back button
		self.navigationController?.popViewController( animated: true )
		
	}
	
	
}
