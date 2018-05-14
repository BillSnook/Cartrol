//
//  CalibrateViewController.swift
//  cartrol
//
//  Created by William Snook on 5/12/18.
//  Copyright © 2018 billsnook. All rights reserved.
//

import UIKit


class CalibrateViewController: UIViewController {
	
	@IBOutlet var speedSlider: UISlider!
	@IBOutlet var speedLeftButton: UIButton!
	@IBOutlet var speedRightButton: UIButton!
	@IBOutlet var speedButton: UIButton!
	@IBOutlet var saveButton: CTButton!
	@IBOutlet var showButton: CTButton!
	@IBOutlet var resetButton: CTButton!
	
	@IBOutlet var leftMotorSpeed: UISlider!
	@IBOutlet var rightMotorSpeed: UISlider!
	
	@IBOutlet var forwardButton: CTButton!
	@IBOutlet var setupButton: CTButton!
	@IBOutlet var reverseButton: CTButton!
	
	@IBOutlet var responseTextView: UITextView!
	
	@IBOutlet var cancelButton: CTButton!
	@IBOutlet var confirmButton: CTButton!
	
	var speedIndex = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print( "In viewDidLoad in CalibrateViewController" )
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
	
	@IBAction func doSpeedIndexIncrement(_ sender: UIButton) {
		
	}
	
	@IBAction func doSaveButtonTouch(_ sender: CTButton) {
		responseTextView.text = targetPort.sendPi( "w\n" );
	}
	
	@IBAction func doShowButtonTouch(_ sender: CTButton) {
		responseTextView.text = targetPort.sendPi( "h\n" );
	}
	
	@IBAction func doResetButtonTouch(_ sender: CTButton) {
		responseTextView.text = targetPort.sendPi( "i\n" );
	}
	
	@IBAction func doForwardButtonTouch(_ sender: CTButton) {
		responseTextView.text = targetPort.sendPi( "g\(speedIndex)\n" );
	}
	
	@IBAction func doSetupButtonTouch(_ sender: CTButton) {
		responseTextView.text = targetPort.sendPi( "i\n" );
	}
	
	@IBAction func doReverseButtonTouch(_ sender: CTButton) {
		responseTextView.text = targetPort.sendPi( "g\(speedIndex)\n" );
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
