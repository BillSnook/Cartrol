//
//  ConnectViewController.swift
//  cartrol
//
//  Created by William Snook on 5/12/18.
//  Copyright © 2018 billsnook. All rights reserved.
//

import UIKit

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
	let targetPort = Sender()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print( "In viewDidLoad in ConnectViewController" )
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear( animated )
		
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

	@IBAction func doConnectButtonTouch(_ sender: CTButton) {
		print( "In doConnectButtonTouch" )
		responseDisplayTextView.text = "Touch in connectButton for \(String(describing: targetAddressTextField.text))"

		if isConnected {			// If isConnected, we must be disconnecting
			print( "\nDisconnecting from host \(targetAddressTextField.text!)" )
			targetPort.doBreakConnection()
			isConnected = false
			targetAddressTextField.isEnabled = true
			connectButton.setTitle( " Connect ", for:  .normal )
			responseDisplayTextView.text = ""
		} else {					// Else we must be connecting
			if targetAddressTextField.text!.count >= 0 {
				print( "\nConnecting to host \(targetAddressTextField.text!)" )
				targetAddressTextField.isEnabled = false
				connectButton.isEnabled = false
				//				activityIndicator.startAnimating()
				let hostName = self.targetAddressTextField.text!
				DispatchQueue.global( qos: .userInitiated ).async {
					self.isConnected = self.targetPort.doMakeConnection( to: hostName, at: 5555 )
					DispatchQueue.main.async {
						if self.isConnected {
							self.connectButton.setTitle( " Disconnect ", for:  .normal )
						} else {
							self.targetAddressTextField.isEnabled = true
						}
						self.connectButton.isEnabled = true
						//						self.activityIndicator.stopAnimating()
					}
				}
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

