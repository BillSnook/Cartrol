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


class SonarEntry {
	var distance = 0
	var timeStamp = Date.init( timeIntervalSinceNow: 0 )
	
	init( distance: Int, timeStamp: Date ) {
		self.distance = distance
		self.timeStamp = timeStamp
	}
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

	var sonarMap = [Int: SonarEntry]()
	
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
		let listArray = msg.split( separator: "\n" )
		let count = listArray.count
		guard count > 1 else { return }
		print( "listArray.count: \(count)" )
		print( "listArray[0]]: \(listArray[0])" )
		print( "Before sonarMap.count: \(sonarMap.count)" )
		if listArray[0] == "@Map" {			// Verify we have received a ping map from the Pi
			var i = 1
			while i < count {
				let entryArray = listArray[i].split( separator: " " )
				i += 1
				if let angle = Int( entryArray[0] ), let distance = Int( entryArray[1] ) {
					let sonar = SonarEntry( distance: distance, timeStamp: Date.init( timeIntervalSinceNow: 0 ))
					sonarMap[angle] = sonar
				}
			}
		}
		print( "After  sonarMap.count: \(sonarMap.count)" )
		
		// Update map display with latest sonarMap
		
	}
	
	// Default sweep is 0 - 180º
	
	@IBAction func b1Action(_ sender: Any) {
		print( "In b1Action" )
		// Ping one
		targetPort.sendPi( "N" )	// Send test response command - expect array of angle/distance entries
	}
	
	@IBAction func b2Action(_ sender: Any) {
		print( "In b2Action" )
		// Sweep using current sweep parameters
		// Test - stop
		targetPort.sendPi( "S" )	// Send test stop all command
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
