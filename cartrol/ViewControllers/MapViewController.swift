//
//  MapViewController.swift
//  cartrol
//
//  Created by William Snook on 3/30/19.
//  Copyright © 2019 billsnook. All rights reserved.
//

import UIKit


// For testing only - don't try this at home

let sampleString = """
@Map
45   1538
50   1650
55   1573
60   1499
65   1449
70   1449
75   2505
80   2478
85   2479
90   1537
95   1538
100   1564
105   2638
110   2518
115   1539
120   1538
125   1537
130   1535
135   1536

"""

extension Int {
	
	var cm: Int {
		get {
			return self / 29 / 2
		}
		set( newDistance ) {
			self = ( ( newDistance * 2 ) * 29 )
		}
	}
	
	var mm: Int {
		return ( self * 10 ) / 29 / 2
	}
	
	var inch: Int {
		return self / 74 / 2
	}
}

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

typealias SonarMap = Dictionary<Int, SonarEntry>


class MapViewController: UIViewController, SweepParamDelegate, CommandResponder {

	@IBOutlet var parametersLabel: UILabel!
	
	@IBOutlet var mapView: MapView!
	
	@IBOutlet var b1: UIButton!
	@IBOutlet var b2: UIButton!
	@IBOutlet var b3: UIButton!
	@IBOutlet var b4: UIButton!
	
	
	var start = 45
	var end = 135
	var increment = 5
	
	var mapRange: Int = 0

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
		
//		handleReply( msg: sampleString )		// Test

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
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		mapView.updateLayout()
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
	
	// CommandResponder delegate method - data coming from Pi
	func handleReply(msg: String) {
//		print( "In handleReply in MapViewController" )
//		print( "  handleReply message: \(msg)" )
		let listArray = msg.split( separator: "\n" )
		let count = listArray.count
		guard count > 1 else { return }
		if listArray[0] == "@Map" {			// Verify we have received a ping map from the Pi
			var i = 1
			var sonarMap = SonarMap()
			while i < count {
				let entryArray = listArray[i].split( separator: " " )
				i += 1
				if let angle = Int( entryArray[0] ), let uSecDistance = Int( entryArray[1] ) {
					let sonar = SonarEntry( distance: uSecDistance, timeStamp: Date.init( timeIntervalSinceNow: 0 ))
					sonarMap[angle] = sonar
				}
			}
			mapView.mapList = sonarMap
			mapView.showMap( mapRange )
		}
	}
	
	// Sample sweep - for testing purposes
/*
"""
	@Map
	45   1538
	50   1650
	55   1573
	60   1499
	65   1449
	70   1449
	75   2505
	80   2478
	85   2479
	90   1537
	95   1538
	100   1564
	105   2638
	110   2518
	115   1539
	120   1538
	125   1537
	130   1535
	135   1536
	
	@Map
	10  11415
	20  11411
	30  11414
	40  11597
	50  13630
	60  13073
	70  13095
	80   1483
	90   1482
	100   2370
	
	@Map
	70   2059
	75   1321
	80   2060
	85   1737
	90   1321
	95   1298
	100   1292
	105   1317
	110   2123
	
"""
*/
	// Default sweep is 0 - 180º
	
	@IBAction func b1Action(_ sender: Any) {
		print( "In b1Action" )
		// Ping one
		
		targetPort.sendPi( "N \(start) \(end) \(increment)" )	// Send test response command - expect array of angle/distance entries
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
	
	// Map scale methods
	@IBAction func shortRangeScaleAction(_ sender: Any) {
		
		mapRange.cm = 50
		mapView.showMap( mapRange )
	}
	
	@IBAction func optimumRangeScaleAction(_ sender: Any) {

		mapRange.cm = 0
		mapView.showMap( mapRange )
	}
	
	@IBAction func longRangeScaleAction(_ sender: Any) {

		mapRange.cm = 200
		mapView.showMap( mapRange )
	}
}
