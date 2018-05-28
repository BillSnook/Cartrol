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

@objc class CalibrateViewController: UIViewController, CommandResponder, UITextFieldDelegate {
	
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
	
	@IBOutlet var leftOffsetTextField: UITextField!
	@IBOutlet var rightOffsetTextField: UITextField!
	
	@IBOutlet var slowestButton: CTButton!
	@IBOutlet var buildButton: CTButton!
	@IBOutlet var fastestButton: CTButton!
	
	@IBOutlet var forwardButton: CTButton!
	@IBOutlet var stopButton: CTButton!
	@IBOutlet var reverseButton: CTButton!
	
	@IBOutlet var responseTextView: UITextView!
	
	@IBOutlet var cancelButton: CTButton!
	@IBOutlet var confirmButton: CTButton!
	
	var leftAdjust = 0
	var rightAdjust = 0
	
	var speedMax = 8				// Same as SPEED_ARRAY
//	var adjustMaxValueLeft = 256
//	var adjustMaxValueRight = 256
	var adjustRange = 128

	var workingSpeedIndex = 1
	var workingSpeedLeft = 0
	var workingSpeedRight = 0
	
	var savedText: String?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		targetPort.setCommandResponder( self )

		print( "In viewDidLoad in CalibrateViewController" )
		
		targetPort.sendPi( "z\n" )
	}
	
	public func setupInitialControls() {
		workingSpeedIndex = 1
		speedSlider.value = Float( workingSpeedIndex )
		speedSlider.minimumValue = Float(-speedMax + 1)
		speedSlider.maximumValue = Float(speedMax - 1)
		speedSlider.isContinuous = false	// Continuous updates not wanted
		speedButton.setTitle( "\(workingSpeedIndex)", for: .normal )
		
		leftAdjust = adjustRange
		leftOffsetTextField.text = String( leftAdjust )
		leftOffsetTextField.adjustsFontSizeToFitWidth = true
		leftMotorSpeed.minimumValue = Float(0)
		leftMotorSpeed.maximumValue = Float(leftAdjust * 2)
		leftMotorSpeed.value = Float( leftAdjust )
//		leftMotorSpeed.isContinuous = false	// Continuous updates not wanted
		leftStepper.minimumValue = Double(0)
		leftStepper.maximumValue = Double(leftAdjust * 2)
		leftStepper.stepValue = Double( 8 )
		leftStepper.value = Double( leftAdjust )
		leftStepper.isContinuous = false	// Continuous updates not wanted

		rightAdjust = adjustRange
		rightOffsetTextField.text = String( rightAdjust )
		rightOffsetTextField.adjustsFontSizeToFitWidth = true
		rightMotorSpeed.minimumValue = Float(0)
		rightMotorSpeed.maximumValue = Float(rightAdjust * 2)
		rightMotorSpeed.value = Float( rightAdjust )
//		rightMotorSpeed.isContinuous = false	// Continuous updates not wanted
		rightStepper.minimumValue = Double(0)
		rightStepper.maximumValue = Double(rightAdjust * 2)
		rightStepper.stepValue = Double( 8 )
		rightStepper.value = Double( rightAdjust )
		rightStepper.isContinuous = false	// Continuous updates not wanted
	}
	
	public func changedIndexButton( _ parameters: Array<String> ) {
		guard let newSpeedIndex = Int( parameters[1] ),
			  let newLeftValue = Int( parameters[2] ),
			  let newRightValue = Int( parameters[3] ) else { return }
		print( "In handleReply:changedIndexButton for getting params with newSpeedIndex: \(newSpeedIndex), newLeftValue: \(newLeftValue), newRightValue: \(newRightValue)" )
		workingSpeedIndex = newSpeedIndex
		workingSpeedLeft = newLeftValue
		workingSpeedRight = newRightValue
		speedSlider.value = Float( newSpeedIndex )
		speedButton.setTitle( "\(newSpeedIndex)", for: .normal )
		
		leftMotorSpeed.minimumValue = Float(newLeftValue - adjustRange)
		leftMotorSpeed.maximumValue = Float(newLeftValue + adjustRange)
		leftMotorSpeed.value = Float( newLeftValue )
		leftStepper.minimumValue = Double(newLeftValue - adjustRange)
		leftStepper.maximumValue = Double(newLeftValue + adjustRange)
		leftStepper.value = Double( newLeftValue )
		leftOffsetTextField.text = String( newLeftValue )

		rightMotorSpeed.minimumValue = Float(newRightValue - adjustRange)
		rightMotorSpeed.maximumValue = Float(newRightValue + adjustRange)
		rightMotorSpeed.value = Float( newRightValue )
		rightStepper.minimumValue = Double(newRightValue - adjustRange)
		rightStepper.maximumValue = Double(newRightValue + adjustRange)
		rightStepper.value = Double( newRightValue )
		rightOffsetTextField.text = String( newRightValue )
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear( animated )
		
//		print( "In viewWillAppear in CalibrateViewController" )
		targetPort.sendPi( "j \(workingSpeedIndex)\n" )
	}
	
//	override func viewDidAppear(_ animated: Bool) {
//		super.viewDidAppear( animated )
//
//		print( "In viewDidAppear in CalibrateViewController" )
//	}
//
//	override func viewWillDisappear(_ animated: Bool) {
//		print( "In viewWillDisappear in CalibrateViewController" )
//
//		super.viewWillDisappear( animated )
//	}
//
//	override func viewDidDisappear(_ animated: Bool) {
//		print( "In viewDidDisappear in CalibrateViewController" )
//
//		super.viewDidDisappear( animated )
//	}
	
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
		let paramArray = msg.components(separatedBy: " ")
		switch msg[0] {
		case "@":
			guard paramArray.count >= 3 else { return }
			if let testSpeedMax = Int( paramArray[1] ) {
				speedMax = testSpeedMax
			}
			if let testAdjustStartValue = Int( paramArray[2] ) {
				adjustRange = testAdjustStartValue
			}
			print( "In handleReply for getting params with speedMax: \(speedMax), adjustRange: \(adjustRange)" )
			setupInitialControls()
		case "i":
			changedIndexButton( paramArray )
		default:
//			if let oldMsg = responseTextView.text {
//				responseTextView.text = oldMsg + "\n" + msg
//			} else {
				responseTextView.text = msg
//			}
		}
	}
	
	
	// Main speed slider moved
	@IBAction func indexValueChanged(_ sender: UISlider) {
		workingSpeedIndex = Int(sender.value)
		if ( workingSpeedIndex <= -speedMax ) {
			workingSpeedIndex = -speedMax + 1
		}
		if ( workingSpeedIndex >= speedMax ) {
			workingSpeedIndex = speedMax - 1
		}
		speedButton.setTitle( "\(workingSpeedIndex)", for: .normal )
		targetPort.sendPi( "j \(workingSpeedIndex)\n" )
	}
	
	
	@IBAction func doDecrementSpeedIndex(_ sender: UIButton) {
		workingSpeedIndex -= 1
		if ( workingSpeedIndex <= -speedMax ) {
			workingSpeedIndex = -speedMax + 1
		}
		speedSlider.value = Float(workingSpeedIndex)
		speedButton.setTitle( "\(workingSpeedIndex)", for: .normal )
		targetPort.sendPi( "j \(workingSpeedIndex)\n" )
	}
	
	@IBAction func doIncrementSpeedIndex(_ sender: UIButton) {
		workingSpeedIndex += 1
		if ( workingSpeedIndex >= speedMax ) {
			workingSpeedIndex = speedMax - 1
		}
		speedSlider.value = Float(workingSpeedIndex)
		speedButton.setTitle( "\(workingSpeedIndex)", for: .normal )
		targetPort.sendPi( "j \(workingSpeedIndex)\n" )
	}
	
	@IBAction func doSpeedIndexIncrement(_ sender: UIButton) {
		// This button is for display only for now
	}
	
	@IBAction func doSaveButtonTouch(_ sender: CTButton) {
		targetPort.sendPi( "w\n" )
	}
	
	@IBAction func doShowButtonTouch(_ sender: CTButton) {
		targetPort.sendPi( "h\n" )
	}
	
	@IBAction func doResetButtonTouch(_ sender: CTButton) {
		targetPort.sendPi( "i\n" )
	}
	
	
	// L/R slider value changed
	@IBAction func leftOffsetValueChanged(_ sender: UISlider) {
		leftAdjust = Int(sender.value)
		leftStepper.value = Double( leftAdjust )
		leftOffsetTextField.text = String( leftAdjust )
	}
	
	@IBAction func rightOffsetValueChanged(_ sender: UISlider) {
		rightAdjust = Int(sender.value)
		rightStepper.value = Double( rightAdjust )
		rightOffsetTextField.text = String( rightAdjust )
	}
	
	// L/R slider touch up inside
	@IBAction func leftOffsetValueSet(_ sender: UISlider) {
		print( "In leftOffsetValueSet" )
		targetPort.sendPi( "l \(leftAdjust)\n" )
	}
	
	@IBAction func rightOffsetValueSet(_ sender: UISlider) {
		print( "In rightOffsetValueSet" )
		targetPort.sendPi( "k \(rightAdjust)\n" )
	}
	
	@IBAction func leftOffsetStepperChanged(_ sender: UIStepper) {
		leftAdjust = Int(sender.value)
		leftMotorSpeed.value = Float( leftAdjust )
		leftOffsetTextField.text = String( leftAdjust )
		targetPort.sendPi( "l \(leftAdjust)\n" )
	}
	
	@IBAction func rightOffsetStepperChanged(_ sender: UIStepper) {
		rightAdjust = Int(sender.value)
		rightMotorSpeed.value = Float( rightAdjust )
		rightOffsetTextField.text = String( rightAdjust )
		targetPort.sendPi( "k \(rightAdjust)\n" )
	}

	@IBAction func doSlowestButtonTouch(_ sender: CTButton) {	// Set forward speed from index 1 as slowest to index 8 as fastest
	}
	
	
	@IBAction func doBuildButtonTouch(_ sender: CTButton) {	// Not used yet
	}
	
	@IBAction func doFastestButtonTouch(_ sender: CTButton) {	// Set forward speed from index 1 as slowest to index 8 as fastest
	}
	
	
	@IBAction func doForwardButtonTouch(_ sender: CTButton) {
		targetPort.sendPi( "g \(workingSpeedIndex)\n" )
	}
	
	@IBAction func doStopButtonTouch(_ sender: CTButton) {
		targetPort.sendPi( "s\n" )
	}
	
	@IBAction func doReverseButtonTouch(_ sender: CTButton) {
		targetPort.sendPi( "g \(-workingSpeedIndex)\n" )
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
	
	// MARK: UITextFieldDelegate
	public func textFieldDidBeginEditing( _ textField: UITextField ) {
		savedText = textField.text
	}
	
	public func textFieldDidEndEditing( _ textField: UITextField ) {
		guard let newText = textField.text,
			let newNumber = Int( newText ) else {
				textField.text = savedText
				return
		}
		if newNumber >= 0 && newNumber <= 2500 {
			if textField == leftOffsetTextField {
				leftMotorSpeed.value = Float( newNumber )
				leftStepper.value = Double( newNumber )
				targetPort.sendPi( "l \(newNumber)\n" )
			} else {
				rightMotorSpeed.value = Float( newNumber )
				rightStepper.value = Double( newNumber )
				targetPort.sendPi( "k \(newNumber)\n" )
			}
		} else {
			textField.text = savedText
		}
	}
	
	public func textFieldShouldReturn( _ textField: UITextField ) -> Bool {
		textField.endEditing( false )
		return true
	}
	
}
