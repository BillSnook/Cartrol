//
//  ConnectViewController.swift
//  cartrol
//
//  Created by William Snook on 5/12/18.
//  Copyright © 2018 billsnook. All rights reserved.
//

import UIKit


let targetPort = Sender()

class ConnectViewController: UIViewController {

	@IBOutlet var commandView: UIView!
	@IBOutlet var targetAddressTextField: UITextField!
	@IBOutlet var connectButton: CTButton!
	@IBOutlet var commandButton: CTButton!
	@IBOutlet var commandTextField: UITextField!
	@IBOutlet var clearButton: CTButton!
	@IBOutlet var calibrateButton: CTButton!
	@IBOutlet var controlButton: CTButton!
	@IBOutlet var responseDisplayTextView: UITextView!
	
	var isConnected = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print( "In viewDidLoad in ConnectViewController" )
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear( animated )
		
		setupButtons()
		print( "In viewWillAppear in ConnectViewController" )
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear( animated )
		
		print( "In viewDidAppear in ConnectViewController" )
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		print( "In viewWillDisappear in ConnectViewController" )
		
		super.viewWillDisappear( animated )
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		print( "In viewDidDisappear in ConnectViewController" )
		
		super.viewDidDisappear( animated )
	}
	
	override var shouldAutorotate: Bool {
		return true
	}
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		if UIDevice.current.userInterfaceIdiom == .phone {
			return .allButUpsideDown
		} else {
			return .all
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Release any cached data, images, etc that aren't in use.
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	func setupButtons() {
		if ( isConnected ) {
			targetAddressTextField.isEnabled = false
			connectButton.setTitle( " Disconnect ", for: .normal )
			connectButton.isEnabled = true
			commandButton.isHidden = false
			commandTextField.isHidden = false
			clearButton.isHidden = false
			calibrateButton.isHidden = false
			controlButton.isHidden = false
			responseDisplayTextView.isHidden = false
			responseDisplayTextView.text = ""
		} else {
			targetAddressTextField.isEnabled = true
			connectButton.setTitle( " Connect ", for: .normal )
			commandButton.isHidden = true
			commandTextField.isHidden = true
			clearButton.isHidden = true
			calibrateButton.isHidden = true
			controlButton.isHidden = true
			responseDisplayTextView.isHidden = true
		}
	}

	@IBAction func doConnectButtonTouch(_ sender: CTButton) {
		print( "In doConnectButtonTouch" )
		responseDisplayTextView.text = "Touch in connectButton for \(String(describing: targetAddressTextField.text))"

		if isConnected {			// If isConnected, we must be disconnecting
			print( "\nDisconnecting from host \(targetAddressTextField.text!)" )
			targetPort.doBreakConnection()
			isConnected = false
			setupButtons()
		} else {					// Else we must be connecting
			if targetAddressTextField.text!.count > 0 {
				connectButton.setTitle( " Connecting... ", for: .normal )
				print( "\nConnecting to host \(targetAddressTextField.text!)" )
				targetAddressTextField.isEnabled = false
				connectButton.isEnabled = false
////				activityIndicator.startAnimating()
				let hostName = self.targetAddressTextField.text!
				DispatchQueue.global( qos: .userInitiated ).async {
					self.isConnected = targetPort.doMakeConnection( to: hostName, at: 5555 )
					DispatchQueue.main.async {
						self.setupButtons()
//						if self.isConnected {
//							self.connectButton.setTitle( " Disconnect ", for:  .normal )
//						} else {
//							self.targetAddressTextField.isEnabled = true
//						}
////						self.connectButton.isEnabled = true
//						self.activityIndicator.stopAnimating()
					}
				}
			} else { 	// Need a target name
				
			}
		}
	}

	@IBAction func doCommandButtonTouch(_ sender: CTButton) {
		print( "In doCommandButtonTouch" )
		guard let command = commandTextField.text,
			!command.isEmpty,
			let priorText = responseDisplayTextView.text
			else { return }
		let response = targetPort.sendPi( command )
		responseDisplayTextView.text = priorText + response
	}

	@IBAction func doClearButtonTouch(_ sender: CTButton) {
		print( "In doClearButtonTouch" )
		responseDisplayTextView.text = ""
	}

//	@IBAction func doCalibrateButton(_ sender: CTButton) {
//		print( "In doCalibrateButton" )
//		guard let nav = self.navigationController else { return }
//		nav.popViewController( animated: true )
//	}

	@IBAction func doControlButtonTouch(_ sender: CTButton) {
		print( "In doControlButtonTouch" )
		// Go to control spritekit view
//		guard let nav = self.navigationController else { return }
//		nav.popViewController( animated: true )
	}
	
}
