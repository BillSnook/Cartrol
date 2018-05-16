//
//  CalibrateViewController.swift
//  cartrol
//
//  Created by William Snook on 5/12/18.
//  Copyright © 2018 billsnook. All rights reserved.
//

import UIKit


let SPEED_ARRAY = 8

@objc class CalibrateViewController: UIViewController {
	
	@IBOutlet var speedSlider: UISlider!
	@IBOutlet var speedIndexIncrementButton: UIButton!
	@IBOutlet var speedIndexDecrementButton: UIButton!
	@IBOutlet var speedButton: UIButton!
	@IBOutlet var saveButton: CTButton!
	@IBOutlet var showButton: CTButton!
	@IBOutlet var resetButton: CTButton!
	
	@IBOutlet var rightMotorSpeed: UISlider!
	@IBOutlet var leftMotorSpeed: UISlider!
	
	@IBOutlet var forwardButton: CTButton!
	@IBOutlet var stopButton: CTButton!
	@IBOutlet var reverseButton: CTButton!
	
	@IBOutlet var responseTextView: UITextView!
	
	@IBOutlet var cancelButton: CTButton!
	@IBOutlet var confirmButton: CTButton!
	
	var speedIndex = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print( "In viewDidLoad in CalibrateViewController" )
		
		let statusArray = targetPort.sendPi( "z\n" )
		print( "In viewDidLoad response for status call: \(statusArray)" )
		
		speedSlider.value = 0
		speedSlider.minimumValue = Float(-SPEED_ARRAY + 1)
		speedSlider.maximumValue = Float(SPEED_ARRAY - 1)
//		speedSlider.addTarget(self, action: Selector("indexValueChanged:"), for: .valueChanged)
		
		speedButton.setTitle( "\(speedIndex)", for: .normal )
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

	@IBAction func indexValueChanged(_ sender: UISlider) {
		speedIndex = Int(sender.value)
		if ( speedIndex <= -SPEED_ARRAY ) {
			speedIndex = -SPEED_ARRAY + 1
		}
		if ( speedIndex >= SPEED_ARRAY ) {
			speedIndex = SPEED_ARRAY - 1
		}
		speedButton.setTitle( "\(speedIndex)", for: .normal )
		responseTextView.text = targetPort.sendPi( "j \(speedIndex)\n" )
	}
	
	@IBAction func doDecrementSpeedIndex(_ sender: UIButton) {
		speedIndex -= 1
		if ( speedIndex <= -SPEED_ARRAY ) {
			speedIndex += 1
			return
		}
		speedSlider.value = Float(speedIndex)
		speedButton.setTitle( "\(speedIndex)", for: .normal )
		responseTextView.text = targetPort.sendPi( "j \(speedIndex)\n" )
	}
	
	@IBAction func doIncrementSpeedIndex(_ sender: UIButton) {
		speedIndex += 1
		if ( speedIndex >= SPEED_ARRAY ) {
			speedIndex -= 1
			return
		}
		speedSlider.value = Float(speedIndex)
		speedButton.setTitle( "\(speedIndex)", for: .normal )
		responseTextView.text = targetPort.sendPi( "j \(speedIndex)\n" )
	}
	
	@IBAction func doSpeedIndexIncrement(_ sender: UIButton) {
		
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
	
	@IBAction func doForwardButtonTouch(_ sender: CTButton) {
		responseTextView.text = targetPort.sendPi( "g\(speedIndex)\n" )
	}
	
	@IBAction func doStopButtonTouch(_ sender: CTButton) {
		responseTextView.text = "s"
	}
	
	@IBAction func doReverseButtonTouch(_ sender: CTButton) {
		responseTextView.text = targetPort.sendPi( "g\(speedIndex)\n" )
	}
	
	@IBAction func doCancelButtonTouch(_ sender: CTButton) {
		print( "In doCancelButtonTouch" )
		guard let nav = self.navigationController else { return }
		nav.popViewController( animated: true )
	}
	
	@IBAction func doConfirmButtonTouch(_ sender: CTButton) {
		print( "In doConfirmButtonTouch" )
		
		// Save new speed table now
		guard let nav = self.navigationController else { return }
		nav.popViewController( animated: true )
	}
	
}
