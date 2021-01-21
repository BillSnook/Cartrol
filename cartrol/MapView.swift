//
//  MapView.swift
//  cartrol
//
//  Created by William Snook on 4/3/19.
//  Copyright © 2019 billsnook. All rights reserved.
//

import UIKit

//unsigned int cm = range/29/2;	// 	inches = range/74/2; mm = (range*10)/29/2

class MapView: UIView, UIGestureRecognizerDelegate {
	
	@IBOutlet var legend: UILabel!
	
	@IBOutlet var tap1: UITapGestureRecognizer!
	@IBOutlet var tap2: UITapGestureRecognizer!
	
	var mapList: SonarMap? {
		willSet {
			lastList = mapList
		}
	}
	var lastList: SonarMap?     // Keep a copy for display
	var sortedMapKeys: [Int]?
	
	var mapHeight: CGFloat = 0
	var mapWidth: CGFloat = 0
	
	var mapRange: Int = 0
	var maxDistance:Int = 0
	var minAngle:Int = 0
	var maxAngle:Int = 0
	var incrementAngle: Int = 0
	
	var topOffset: CGFloat = 0
	var availableHeight: CGFloat = 0
	var availableWidth: CGFloat = 0
	
	var sweepOrigin = CGPoint( x: 0, y: 0 )
	
    
	public func updateLayout() {
		
		if ( mapWidth != frame.size.width || mapHeight != frame.size.height ) {		// If changed
			updateMapLayout()
		}
		updateMapList()

	}
	
	public func updateMapLayout() {

		mapWidth = frame.size.width
		mapHeight = frame.size.height	// Includes legend label, nominally 25 pixels high, at top
		print( "In updateMapLayout in MapView, map layout changed: mapWidth = \(mapWidth), mapHeight = \(mapHeight)" )
		topOffset = legend.frame.size.height
		availableHeight = mapHeight - topOffset		// Number of pixels for full range in vertical direction
		availableWidth = mapWidth
		let bottom = mapHeight // Test
		let center = mapWidth / 2.0
		sweepOrigin = CGPoint( x: center, y: bottom )
		DispatchQueue.main.async {
			self.setNeedsDisplay()
		}
	}
	
	public func updateMapList() {
//		print( "In updateMapList in MapView" )
		if let mapList = mapList {
			sortedMapKeys = mapList.keys.sorted()
			if let keys = sortedMapKeys {
//				print( "Min: \(minAngle), max: \(maxAngle)" )
				if keys.count > 2 {
                    if mapList[0]?.distance == 0 {
                        minAngle = keys[1]
                    } else {
                        minAngle = keys[0]
                    }
                    if mapList[keys.count - 1]?.distance == 0 {
                        maxAngle = keys[keys.count - 2]
                    } else {
                        maxAngle = keys[keys.count - 1]
                    }
					incrementAngle = keys[2] - keys[1]
					maxDistance = 0
					for key in keys {
						if let sonarEntry = mapList[key] {
//						    print( "Angle: \(key), distance: \(sonarEntry.distance / 29 / 2) cm, \(sonarEntry.distance / 74 / 2) inches " )
							if sonarEntry.distance > maxDistance {
								maxDistance = sonarEntry.distance
							}
						}
					}
				}
//				print( "  maxDistance: \(maxDistance) uSec, \(maxDistance.cm) cm" )
			}
		}
	}
	
	public func showMap( _ mapScale: Int ) {
		
//		print( "In showMap in MapView" )
		mapRange = mapScale
		updateMapList()
		DispatchQueue.main.async {
			self.legend.text = "Map maximum scale = \(self.mapRange == 0 ? self.maxDistance.cm : self.mapRange.cm) cm, \(self.mapRange == 0 ? self.maxDistance.inch : self.mapRange.inch) inches"
			self.setNeedsDisplay()
		}
	}
	
	override func draw(_ rect: CGRect) {

//		print( "Draw" )
		guard let context = UIGraphicsGetCurrentContext(),
			  let keys = sortedMapKeys else { return }

//		print( "Draw with rect \(rect)" )
		let startRadians = (CGFloat(-minAngle) * 3.1416) / 180.0
		let endRadians = (CGFloat(-maxAngle) * 3.1416) / 180.0
		var mapDistance = maxDistance
		if mapRange != 0 {	// Adjust for different map displays - 50 cm and 2 meters
			mapDistance = mapRange
		}
		let nowColor = UIColor( red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0 ).cgColor
		let lastColor = UIColor( red: 0.5, green: 0.0, blue: 1.0, alpha: 0.7 ).cgColor
//		print( "Draw with minAngle \(minAngle) and maxAngle \(maxAngle)" )
//		print( "Draw with startRadians \(startRadians) and endRadians \(endRadians)" )
		let lineWidth: CGFloat = 0.5
		// Draw background
		context.setLineWidth(lineWidth)
		context.setStrokeColor(UIColor.lightGray.cgColor)
		context.move(to: sweepOrigin)
		context.addArc(center: sweepOrigin, radius: availableHeight, startAngle: startRadians, endAngle: endRadians, clockwise: true )
		context.addLine(to: sweepOrigin)
		context.addArc(center: sweepOrigin, radius: ( availableHeight * 2.0 ) / 3.0, startAngle: startRadians, endAngle: endRadians, clockwise: true )
		context.strokePath()
		context.addArc(center: sweepOrigin, radius: availableHeight / 3.0, startAngle: startRadians, endAngle: endRadians, clockwise: true )
//		context.move(to: sweepOrigin)
		context.strokePath()
		
		// Draw pings
//		context.move(to: sweepOrigin)
		let spread = 0.01 * CGFloat( incrementAngle )
		if let mapListSafe = mapList {
			context.setLineWidth( 2.0 )
			context.setStrokeColor( nowColor )
			for key in keys {
				if let entry = mapListSafe[key] {
					let radians = CGFloat((Double(-key) * 3.1416) / 180.0)
					let radius = CGFloat( entry.distance ) / CGFloat( mapDistance ) * availableHeight
					context.addArc(center: sweepOrigin, radius: radius, startAngle: radians + spread, endAngle: radians - spread, clockwise: true )
					context.strokePath()
				}
			}
		}
		
		if let lastListSafe = lastList {
			context.setLineWidth( 2.0 )
			context.setStrokeColor( lastColor )
			for key in keys {
				if let entry = lastListSafe[key] {
					let radians = CGFloat((Double(-key) * 3.1416) / 180.0)
					let radius = CGFloat( entry.distance ) / CGFloat( mapDistance ) * availableHeight
					context.addArc(center: sweepOrigin, radius: radius, startAngle: radians + spread, endAngle: radians - spread, clockwise: true )
					context.strokePath()
				}
			}
		}
//		context.strokePath()

//		context.fillPath()
	}
	
	func getPosition( angle: CGFloat, distance: CGFloat ) -> CGPoint {
		
		
		
		return CGPoint.zero
	}
	
	// MARK: Touch actions
	@IBAction func tap1Action(_ sender: UITapGestureRecognizer) {
		print( "In tap1Action" )
	}
	
	@IBAction func tap2Action(_ sender: UITapGestureRecognizer) {
		print( "In tap2Action" )
	}
	

}
