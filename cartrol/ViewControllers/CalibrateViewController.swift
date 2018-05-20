//
//  CalibrateViewController.swift
//  cartrol
//
//  Created by William Snook on 5/12/18.
//  Copyright © 2018 billsnook. All rights reserved.
//

import UIKit


extension String {
	subscript (i: Int) -> Character {
		return self[index(startIndex, offsetBy: i)]
	}
}

@objc class CalibrateViewController: UIViewController, CommandResponder {
	
	@IBOutlet var speedSlider: UISlider!
	@IBOutlet var speedIndexIncrementButton: UIButton!
	@IBOutlet var speedIndexDecrementButton: UIButton!
	@IBOutlet var speedButton: UIButton!
	@IBOutlet var saveButton: CTButton!
	@IBOutlet var showButton: CTButton!
	@IBOutlet var resetButton: CTButton!
	
	@IBOutlet var leftMotorSpeed: UISlider!
	@IBOutlet var rightMotorSpeed: UISlider!

	@IBOutlet var leftStepper: UIStepper!
	@IBOutlet var rightStepper: UIStepper!
	
	@IBOutlet var leftOffsetButton: UIButton!
	@IBOutlet var rightOffsetButton: UIButton!
	
	@IBOutlet var forwardButton: CTButton!
	@IBOutlet var stopButton: CTButton!
	@IBOutlet var reverseButton: CTButton!
	
	@IBOutlet var responseTextView: UITextView!
	
	@IBOutlet var cancelButton: CTButton!
	@IBOutlet var confirmButton: CTButton!
	
	var speedIndex = 0
	var leftAdjust = 0
	var rightAdjust = 0
	
	var speedMax = 8				// Same as SPEED_ARRAY
	var adjustMaxValue = 256
	var adjustStartValue = 128
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		targetPort.setCommandResponder( self )

		print( "In viewDidLoad in CalibrateViewController" )
		
		let statusArray = targetPort.sendPi( "z\n" )
		print( "In viewDidLoad response for status call: \(statusArray)" )
	}
	
	public func setupControls() {
		speedIndex = 1
		speedSlider.value = Float( speedIndex )
		speedSlider.minimumValue = Float(-speedMax + 1)
		speedSlider.maximumValue = Float(speedMax - 1)
		speedSlider.isContinuous = false	// Continuous updates not wanted
		speedButton.setTitle( "\(speedIndex)", for: .normal )
		
		leftAdjust = adjustStartValue
		leftOffsetButton.setTitle( "\(leftAdjust)", for: .normal )
		leftMotorSpeed.minimumValue = Float(0)
		leftMotorSpeed.maximumValue = Float(leftAdjust * 2)
		leftMotorSpeed.value = Float( leftAdjust )
		leftMotorSpeed.isContinuous = false	// Continuous updates not wanted
		leftStepper.minimumValue = Double(0)
		leftStepper.maximumValue = Double(leftAdjust * 2)
		leftStepper.stepValue = Double( 8 )
		leftStepper.value = Double( leftAdjust )
		leftStepper.isContinuous = false	// Continuous updates not wanted

		rightAdjust = adjustStartValue
		rightOffsetButton.setTitle( "\(rightAdjust)", for: .normal )
		rightMotorSpeed.minimumValue = Float(0)
		rightMotorSpeed.maximumValue = Float(rightAdjust * 2)
		rightMotorSpeed.value = Float( rightAdjust )
		rightMotorSpeed.isContinuous = false	// Continuous updates not wanted
		rightStepper.minimumValue = Double(0)
		rightStepper.maximumValue = Double(rightAdjust * 2)
		rightStepper.stepValue = Double( 8 )
		rightStepper.value = Double( rightAdjust )
		rightStepper.isContinuous = false	// Continuous updates not wanted
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear( animated )
		
		print( "In viewWillAppear in CalibrateViewController" )
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear( animated )
		
		print( "In viewDidAppear in CalibrateViewController" )
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		print( "In viewWillDisappear in CalibrateViewController" )
		
		super.viewWillDisappear( animated )
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		print( "In viewDidDisappear in CalibrateViewController" )
		
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

	// MARK: - Motor-specific code next
	
	func handleReply(msg: String) {
		switch msg[0] {
		case "@":
			let paramArray = msg.components(separatedBy: " ")
			guard paramArray.count >= 4 else { return }
			if let testSpeedMax = Int( paramArray[1] ) {
				speedMax = testSpeedMax
			}
			if let testAdjustMaxValue = Int( paramArray[2] ) {
				adjustMaxValue = testAdjustMaxValue
			}
			if let testAdjustStartValue = Int( paramArray[3] ) {
				adjustStartValue = testAdjustStartValue
			}
			print( "In handleReply for getting params with speedMax: \(speedMax), adjustMaxValue: \(adjustMaxValue), adjustStartValue: \(adjustStartValue)" )
			setupControls()
		default:
			if let oldMsg = responseTextView.text {
				responseTextView.text = oldMsg + "\n" + msg
			} else {
				responseTextView.text = msg
			}
		}
	}
	
	
	// Main speed slider moved
	@IBAction func indexValueChanged(_ sender: UISlider) {
		speedIndex = Int(sender.value)
		if ( speedIndex <= -speedMax ) {
			speedIndex = -speedMax + 1
		}
		if ( speedIndex >= speedMax ) {
			speedIndex = speedMax - 1
		}
		speedButton.setTitle( "\(speedIndex)", for: .normal )
		responseTextView.text = targetPort.sendPi( "j \(speedIndex)\n" )
	}
	
	
	@IBAction func doDecrementSpeedIndex(_ sender: UIButton) {
		speedIndex -= 1
		if ( speedIndex <= -speedMax ) {
			speedIndex = -speedMax + 1
		}
		speedSlider.value = Float(speedIndex)
		speedButton.setTitle( "\(speedIndex)", for: .normal )
		responseTextView.text = targetPort.sendPi( "j \(speedIndex)\n" )
	}
	
	@IBAction func doIncrementSpeedIndex(_ sender: UIButton) {
		speedIndex += 1
		if ( speedIndex >= speedMax ) {
			speedIndex = speedMax - 1
		}
		speedSlider.value = Float(speedIndex)
		speedButton.setTitle( "\(speedIndex)", for: .normal )
		responseTextView.text = targetPort.sendPi( "j \(speedIndex)\n" )
	}
	
	@IBAction func doSpeedIndexIncrement(_ sender: UIButton) {
		// This button is for display only for now
	}
	
	@IBAction func doSaveButtonTouch(_ sender: CTButton) {
		responseTextView.text = targetPort.sendPi( "w\n" )
	}
	
	@IBAction func doShowButtonTouch(_ sender: CTButton) {
		responseTextView.text = targetPort.sendPi( "h\n" )
	}
	
	@IBAction func doResetButtonTouch(_ sender: CTButton) {
		responseTextView.text = targetPort.sendPi( "i\n" )
	}
	
	
	@IBAction func leftOffsetValueChanged(_ sender: UISlider) {
		leftAdjust = Int(sender.value)
		if ( leftAdjust <= -adjustMaxValue ) {
			leftAdjust = -adjustMaxValue + 1
		}
		if ( leftAdjust >= adjustMaxValue ) {
			leftAdjust = adjustMaxValue - 1
		}
		leftStepper.value = Double( leftAdjust )
		leftOffsetButton.setTitle( "\(leftAdjust)", for: .normal )
		responseTextView.text = targetPort.sendPi( "l \(leftAdjust)\n" )
	}
	
	@IBAction func rightOffsetValueChanged(_ sender: UISlider) {
		rightAdjust = Int(sender.value)
		if ( rightAdjust <= -adjustMaxValue ) {
			rightAdjust = -adjustMaxValue + 1
		}
		if ( rightAdjust >= adjustMaxValue ) {
			rightAdjust = adjustMaxValue - 1
		}
		rightStepper.value = Double( rightAdjust )
		rightOffsetButton.setTitle( "\(rightAdjust)", for: .normal )
		responseTextView.text = targetPort.sendPi( "k \(rightAdjust)\n" )
	}
	
	@IBAction func leftOffsetStepperChanged(_ sender: UIStepper) {
		leftAdjust = Int(sender.value)
		if ( leftAdjust <= -adjustMaxValue ) {
			leftAdjust = -adjustMaxValue + 1
		}
		if ( leftAdjust >= adjustMaxValue ) {
			leftAdjust = adjustMaxValue - 1
		}
		leftMotorSpeed.value = Float( leftAdjust )
		leftOffsetButton.setTitle( "\(leftAdjust)", for: .normal )
		responseTextView.text = targetPort.sendPi( "k \(leftAdjust)\n" )
	}
	
	@IBAction func rightOffsetStepperChanged(_ sender: UIStepper) {
		rightAdjust = Int(sender.value)
		if ( rightAdjust <= -adjustMaxValue ) {
			rightAdjust = -adjustMaxValue + 1
		}
		if ( rightAdjust >= adjustMaxValue ) {
			rightAdjust = adjustMaxValue - 1
		}
		rightMotorSpeed.value = Float( rightAdjust )
		rightOffsetButton.setTitle( "\(rightAdjust)", for: .normal )
		responseTextView.text = targetPort.sendPi( "k \(rightAdjust)\n" )
	}

	
	@IBAction func doForwardButtonTouch(_ sender: CTButton) {
		responseTextView.text = targetPort.sendPi( "g \(speedIndex)\n" )
	}
	
	@IBAction func doStopButtonTouch(_ sender: CTButton) {
		responseTextView.text = "s"
	}
	
	@IBAction func doReverseButtonTouch(_ sender: CTButton) {
		responseTextView.text = targetPort.sendPi( "g \(-speedIndex)\n" )
	}
	
	@IBAction func doCancelButtonTouch(_ sender: CTButton) {
		print( "In doCancelButtonTouch" )
		guard let nav = self.navigationController else { return }
		nav.popViewController( animated: true )
	}
	
	@IBAction func doConfirmButtonTouch(_ sender: CTButton) {
		print( "In doConfirmButtonTouch" )
		
		// Check to save new speed table now
		guard let nav = self.navigationController else { return }
		nav.popViewController( animated: true )
	}
	
}
