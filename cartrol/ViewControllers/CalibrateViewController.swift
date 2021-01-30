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
	
	@IBOutlet var speedIndexSlider: UISlider!
	@IBOutlet var speedIndexIncrementButton: UIButton!
	@IBOutlet var speedIndexDecrementButton: UIButton!
	@IBOutlet var speedIndexButton: UIButton!
	@IBOutlet var saveButton: CTButton!
	@IBOutlet var showButton: CTButton!
	@IBOutlet var resetButton: CTButton!
	
	@IBOutlet var leftMotorSpeedSlider: UISlider!
	@IBOutlet weak var rightMotorSpeedSlider: UISlider!
	
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
	
	var leftAdjust = 0
	var rightAdjust = 0
	
	var speedMax = 8				// Same as SPEED_ARRAY - 1
//	var adjustMaxValueLeft = 256
//	var adjustMaxValueRight = 256
	var adjustRange = 128

	var workingSpeedIndex = 1
	var workingSpeedLeft = 0
	var workingSpeedRight = 0
	
	var savedText: String?

    
	override func viewDidLoad() {
		super.viewDidLoad()
		print( "In viewDidLoad in CalibrateViewController" )
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear( animated )

        self.navigationController?.setNavigationBarHidden( false, animated: true )    // Show it on this page

        setupInitialControls()
}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear( animated )
        
        targetPort.setCommandResponder( self )

// WFS - off during testing, needed for normal operation to get map copy
//		targetPort.sendPi( "Z\n" )	// Get speed array
//		targetPort.sendPi( "J \(workingSpeedIndex)\n" )	// setSpeedTestIndex
	}
	
	override func viewWillDisappear(_ animated: Bool) {

		targetPort.setCommandResponder( nil )
        targetPort.sendPi( "S" )    // Send quick stop all command - no response expected

		super.viewWillDisappear( animated )
	}
	

    public func setupInitialControls() {
		workingSpeedIndex = 1
		speedIndexSlider.value = Float( workingSpeedIndex )
		speedIndexSlider.minimumValue = Float(-speedMax)
		speedIndexSlider.maximumValue = Float(speedMax)
		speedIndexSlider.isContinuous = false	// Continuous updates not wanted
		speedIndexButton.setTitle( "\(workingSpeedIndex)", for: .normal )
		
		leftAdjust = adjustRange
		leftOffsetTextField.text = String( leftAdjust )
		leftOffsetTextField.adjustsFontSizeToFitWidth = true
		leftMotorSpeedSlider.minimumValue = Float(0)
		leftMotorSpeedSlider.maximumValue = Float(leftAdjust * 2)
		leftMotorSpeedSlider.value = Float( leftAdjust )
//		leftMotorSpeedSlider.isContinuous = false	// Continuous updates not wanted
		leftStepper.minimumValue = Double(0)
		leftStepper.maximumValue = Double(leftAdjust * 2)
		leftStepper.stepValue = Double( 8 )
		leftStepper.value = Double( leftAdjust )
		leftStepper.isContinuous = false	// Continuous updates not wanted

		rightAdjust = adjustRange
		rightOffsetTextField.text = String( rightAdjust )
		rightOffsetTextField.adjustsFontSizeToFitWidth = true
		rightMotorSpeedSlider.minimumValue = Float(0)
		rightMotorSpeedSlider.maximumValue = Float(rightAdjust * 2)
		rightMotorSpeedSlider.value = Float( rightAdjust )
//		rightMotorSpeedSlider.isContinuous = false	// Continuous updates not wanted
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
		print( "In changedIndexButton from handleReply for getting params with newSpeedIndex: \(newSpeedIndex), newLeftValue: \(newLeftValue), newRightValue: \(newRightValue)" )
        guard newSpeedIndex < speedMax && newSpeedIndex > -speedMax else { return }
		workingSpeedIndex = newSpeedIndex
		workingSpeedLeft = newLeftValue
		workingSpeedRight = newRightValue
        speedIndexSlider.value = Float( newSpeedIndex )
		speedIndexButton.setTitle( "\(newSpeedIndex)", for: .normal )
		
		leftMotorSpeedSlider.minimumValue = Float(newLeftValue - adjustRange)
		leftMotorSpeedSlider.maximumValue = Float(newLeftValue + adjustRange)
		leftMotorSpeedSlider.value = Float( newLeftValue )
		leftStepper.minimumValue = Double(newLeftValue - adjustRange)
		leftStepper.maximumValue = Double(newLeftValue + adjustRange)
		leftStepper.value = Double( newLeftValue )
		leftOffsetTextField.text = String( newLeftValue )

		rightMotorSpeedSlider.minimumValue = Float(newRightValue - adjustRange)
		rightMotorSpeedSlider.maximumValue = Float(newRightValue + adjustRange)
		rightMotorSpeedSlider.value = Float( newRightValue )
		rightStepper.minimumValue = Double(newRightValue - adjustRange)
		rightStepper.maximumValue = Double(newRightValue + adjustRange)
		rightStepper.value = Double( newRightValue )
		rightOffsetTextField.text = String( newRightValue )
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
	
//	override var prefersStatusBarHidden: Bool {
//		return true
//	}

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
        speedIndexSlider.value = Float(workingSpeedIndex)
		speedIndexButton.setTitle( "\(workingSpeedIndex)", for: .normal )
		targetPort.sendPi( "J \(workingSpeedIndex)\n" )
	}
	
	
	@IBAction func doDecrementSpeedIndex(_ sender: UIButton) {
		if ( workingSpeedIndex > -speedMax ) {
            workingSpeedIndex -= 1
            targetPort.sendPi( "J \(workingSpeedIndex)\n" )
            speedIndexSlider.value = Float(workingSpeedIndex)
            speedIndexButton.setTitle( "\(workingSpeedIndex)", for: .normal )
		}
	}
	
	@IBAction func doIncrementSpeedIndex(_ sender: UIButton) {
        if workingSpeedIndex < speedMax {
            workingSpeedIndex += 1
            targetPort.sendPi( "J \(workingSpeedIndex)\n" )
            speedIndexSlider.value = Float(workingSpeedIndex)
            speedIndexButton.setTitle( "\(workingSpeedIndex)", for: .normal )
        }
	}
	
	@IBAction func doSpeedIndexIncrement(_ sender: UIButton) {
		// This button is for display only for now
	}
	
    @IBAction func doSaveOnExit(_ sender: UIBarButtonItem) {
        print( "In doSaveOnExit nav button" )
        // If needs saving
//        targetPort.sendPi( "W\n" )

        guard let nav = self.navigationController else { return }
        nav.popViewController( animated: true )
    }
    
    @IBAction func doSaveButtonTouch(_ sender: CTButton) {
		targetPort.sendPi( "W\n" )
	}
	
	@IBAction func doShowButtonTouch(_ sender: CTButton) {
		targetPort.sendPi( "H\n" )
	}
	
	@IBAction func doResetButtonTouch(_ sender: CTButton) {
		targetPort.sendPi( "I\n" )
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
		targetPort.sendPi( "L \(leftAdjust)\n" )
	}
	
	@IBAction func rightOffsetValueSet(_ sender: UISlider) {
		print( "In rightOffsetValueSet" )
		targetPort.sendPi( "K \(rightAdjust)\n" )
	}
	
	@IBAction func leftOffsetStepperChanged(_ sender: UIStepper) {
		leftAdjust = Int(sender.value)
		leftMotorSpeedSlider.value = Float( leftAdjust )
		leftOffsetTextField.text = String( leftAdjust )
		targetPort.sendPi( "L \(leftAdjust)\n" )
	}
	
	@IBAction func rightOffsetStepperChanged(_ sender: UIStepper) {
		rightAdjust = Int(sender.value)
		rightMotorSpeedSlider.value = Float( rightAdjust )
		rightOffsetTextField.text = String( rightAdjust )
		targetPort.sendPi( "K \(rightAdjust)\n" )
	}

	@IBAction func doSlowestButtonTouch(_ sender: CTButton) {	// Set forward speed from index 1 as slowest to index 8 as fastest
		targetPort.sendPi( "U\n" )
	}
	
	
	@IBAction func doBuildButtonTouch(_ sender: CTButton) {	// Not used yet
	}
	
	@IBAction func doFastestButtonTouch(_ sender: CTButton) {	// Set forward speed from index 1 as slowest to index 8 as fastest
		targetPort.sendPi( "V\n" )
}
	
	
	@IBAction func doForwardButtonTouch(_ sender: CTButton) {
		targetPort.sendPi( "G \(workingSpeedIndex)\n" )
	}
	
	@IBAction func doStopButtonTouch(_ sender: CTButton) {
		targetPort.sendPi( "S\n" )
	}
	
	@IBAction func doReverseButtonTouch(_ sender: CTButton) {
		targetPort.sendPi( "G \(-workingSpeedIndex)\n" )
	}
	
	// MARK: UITextFieldDelegate
	public func textFieldDidBeginEditing( _ textField: UITextField ) {
		savedText = textField.text
	}
	
	public func textFieldDidEndEditing( _ textField: UITextField ) {
		guard let newText = textField.text,
			let newNumber = Int( newText ),
			newNumber >= 0 && newNumber <= 4096 else {
				textField.text = savedText
				return
		}
		if textField == leftOffsetTextField {
			leftMotorSpeedSlider.value = Float( newNumber )
			leftStepper.value = Double( newNumber )
			targetPort.sendPi( "L \(newNumber)\n" )
		} else {
			rightMotorSpeedSlider.value = Float( newNumber )
			rightStepper.value = Double( newNumber )
			targetPort.sendPi( "K \(newNumber)\n" )
		}
	}
	
	public func textFieldShouldReturn( _ textField: UITextField ) -> Bool {
		textField.endEditing( false )
		return true
	}
	
}
