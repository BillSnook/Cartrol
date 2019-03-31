//
//  MapViewController.swift
//  cartrol
//
//  Created by William Snook on 3/30/19.
//  Copyright © 2019 billsnook. All rights reserved.
//

import UIKit


protocol SweepParamDelegate {
	
	func newSweepSettings( _ start: Int, _ end: Int, _ inc: Int )

}

class MapViewController: UIViewController, SweepParamDelegate, CommandResponder {

	@IBOutlet var parametersLabel: UILabel!
	
	@IBOutlet var mapView: UIView!
	
	@IBOutlet var b1: UIButton!
	@IBOutlet var b2: UIButton!
	@IBOutlet var b3: UIButton!
	@IBOutlet var b4: UIButton!
	
	var start = 0
	var end = 180
	var increment = 1
	
	var isConnected = false

	override func viewDidLoad() {
		super.viewDidLoad()
		print( "In viewDidLoad in MapViewController" )

		mapView.layer.borderWidth = 2.0
		mapView.layer.borderColor = UIColor.black.cgColor
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear( animated )
		print( "In viewWillAppear in MapViewController" )

		self.navigationController?.setNavigationBarHidden( false, animated: true )	// Show it on this page
		
		setParamLabel()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear( animated )
		print( "In viewDidAppear in MapViewController" )

		targetPort.setCommandResponder( self )
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		
		self.navigationController?.setNavigationBarHidden( true, animated: true )
		
		targetPort.setCommandResponder( nil )

		print( "In viewWillDisappear in MapViewController" )
		super.viewWillDisappear( animated )
	}
	
	override func viewDidDisappear(_ animated: Bool) {

		print( "In viewDidDisappear in MapViewController" )
		super.viewDidDisappear( animated )
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ToSetupMap" {
			if let vc = segue.destination as? SetupViewController {
				vc.delegate = self		// To return sweep specs
			}
		}
	}
	
	// SweepParamDelegate method
	func newSweepSettings(_ start: Int, _ end: Int, _ inc: Int) {
		self.start = start
		self.end = end
		self.increment = inc
		
		print( setParamLabel() )

	}
	
	@discardableResult func setParamLabel() -> String {
		
		let paramString = "Start: \(start), end: \(end), increment: \(increment)"
		parametersLabel.text = paramString
		return paramString
	}
	
	// CommandResponder delegate method
	func handleReply(msg: String) {
		print( "In MapViewController in handleReply: \(msg)" )
		if let _ = parametersLabel.text {
			parametersLabel.text = msg
		}
		let entryArray = msg.split( separator: "\n" )
		print( "entryArray.count: \(entryArray.count)" )
		print( "entryArray[0]]: \(entryArray[0])" )
		print( "entryArray[1]]: \(entryArray[1])" )
		if entryArray[0] == "@Map" {			// Verify we have received a ping map from the Pi
			
			
		}
	}
	
	// Default sweep is 0 - 180º
	
	@IBAction func b1Action(_ sender: Any) {
		print( "In b1Action" )
		// Ping one
		targetPort.sendPi( "N" )	// Send test response command
	}
	
	@IBAction func b2Action(_ sender: Any) {
		print( "In b2Action" )
		// Sweep using current sweep parameters
		// Test - stop
		targetPort.sendPi( "S" )	// Send test response command
	}
	
	@IBAction func b3Action(_ sender: Any) {
		print( "In b3Action" )
		// Setup done by segue - shows dialog to get parameters
	}
	
	@IBAction func b4Action(_ sender: Any) {
		print( "In b4Action" )
		parametersLabel.text = ""		// Clear
	}
	
}
