//
//  ConnectViewController.swift
//  cartrol
//
//  Created by William Snook on 5/12/18.
//  Copyright © 2018 billsnook. All rights reserved.
//

import UIKit


let targetPort = Sender()

class ConnectViewController: UIViewController, CommandResponder {
	
	@IBOutlet var commandView: UIView!
	@IBOutlet var targetAddressTextField: UITextField!
	@IBOutlet var connectButton: CTButton!
	@IBOutlet var commandButton: CTButton!
	@IBOutlet var commandTextField: UITextField!
	@IBOutlet var clearButton: CTButton!
	@IBOutlet var calibrateButton: CTButton!
	@IBOutlet var controlButton: CTButton!
	@IBOutlet var directButton: CTButton!
	@IBOutlet var testStatusButton: CTButton!
	@IBOutlet var testRangeButton: CTButton!
	
	@IBOutlet var test1Button: CTButton!
	@IBOutlet var test2Button: CTButton!
	@IBOutlet var test3Button: CTButton!
	
	@IBOutlet var responseDisplayTextView: UITextView!
	
	var isConnected = true // debug - false
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		print( "In viewDidLoad in ConnectViewController" )

		targetAddressTextField.text = "Develop31"
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear( animated )
//		print( "In viewWillAppear in ConnectViewController" )

		setupButtons()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear( animated )
//		print( "In viewDidAppear in ConnectViewController" )

		targetPort.setCommandResponder( self )

	}
	
	override func viewWillDisappear(_ animated: Bool) {

		targetPort.setCommandResponder( nil )

//		print( "In viewWillDisappear in ConnectViewController" )
		super.viewWillDisappear( animated )
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		
//		print( "In viewDidDisappear in ConnectViewController" )
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
	
	
	// MARK: - Interactions
	
	func handleReply(msg: String) {
		if let oldMsg = responseDisplayTextView.text, !oldMsg.isEmpty {
			responseDisplayTextView.text = oldMsg + "\n" + msg
		} else {
			responseDisplayTextView.text = msg
		}
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
			directButton.isHidden = false
			testStatusButton.isHidden = false
			testRangeButton.isHidden = false
			test1Button.isHidden = false
			test2Button.isHidden = false
			test3Button.isHidden = false
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
			directButton.isHidden = true
			testStatusButton.isHidden = true
			testRangeButton.isHidden = true
			test1Button.isHidden = true
			test2Button.isHidden = true
			test3Button.isHidden = true
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
				connectButton.setTitle( " Cancel", for: .normal )
				print( "\nConnecting to host \(targetAddressTextField.text!)" )
				targetAddressTextField.isEnabled = false
				connectButton.isEnabled = true // false
//				activityIndicator.startAnimating()
				let hostName = self.targetAddressTextField.text!
				isConnected = true		// So we can cancel
				DispatchQueue.global( qos: .userInitiated ).async {
					self.isConnected = targetPort.doMakeConnection( to: hostName, at: 5555 )
					DispatchQueue.main.async {
						self.setupButtons()
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
			!command.isEmpty
//			let priorText = responseDisplayTextView.text
			else { return }
		targetPort.sendPi( command )
	}

	@IBAction func doClearButtonTouch(_ sender: CTButton) {
		print( "In doClearButtonTouch" )
		responseDisplayTextView.text = ""
	}

	@IBAction func doTestStatus(_ sender: CTButton) {

		targetPort.sendPi( "A" )	// Send set status mode command
		usleep( 1000 )
		targetPort.sendPi( "B" )	// Send get status command
	}
	
	@IBAction func doTestRange(_ sender: Any) {

		targetPort.sendPi( "C" )	// Send get range mode command
		usleep( 10000 )
		targetPort.sendPi( "D" )	// Send get range command
	}
	
	@IBAction func doTest1(_ sender: CTButton) {
		print( "In doTest1" )
		targetPort.sendPi( "F 0" )	// Motor relay off
	}
	
	@IBAction func doTest2(_ sender: CTButton) {
		print( "In doTest2" )
		targetPort.sendPi( "F 1" )	// Motor relay on
	}
	
	@IBAction func doTest3(_ sender: CTButton) {
		print( "In doTest3" )
//		targetPort.sendPi( "D" )
	}
}
