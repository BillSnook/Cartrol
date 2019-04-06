//
//  MapView.swift
//  cartrol
//
//  Created by William Snook on 4/3/19.
//  Copyright © 2019 billsnook. All rights reserved.
//

import UIKit

//unsigned int cm = range/29/2;	// 	inches = range/74/2; mm = (range*10)/29/2

class MapView: UIView {
	
	@IBOutlet var legend: UILabel!
	
	var mapList: SonarMap?
	var sortedMapKeys: [Int]?
	
	var mapHeight: CGFloat = 0
	var mapWidth: CGFloat = 0
	
	var maxDistance:Int = 0
	var minAngle:Int = 0
	var maxAngle:Int = 0
	
	var topOffset: CGFloat = 0
	var availableHeight: CGFloat = 0
	var availableWidth: CGFloat = 0

//	var maxToTop: CGFloat = 0			// Layout params
//	var widthPerDegree: CGFloat = 0
	
	var sweepOrigin = CGPoint( x: 0, y: 0 )
	
	required init?(coder aDecoder: NSCoder) {
		super.init( coder: aDecoder )
		
//		backgroundColor = UIColor.blue
	}
	
	public func updateLayout() {
		
		print( "In updateLayout in MapView" )
		if ( mapWidth != frame.size.width || mapHeight != frame.size.height ) {		// If changed
			updateMapLayout()
			updateMapList()
		}

	}
	
	public func updateMapLayout() {
		print( "In updateMapLayout in MapView" )
		mapWidth = frame.size.width
		mapHeight = frame.size.height	// Includes legend label, nominally 25 pixels high, at top
		print( "  Map layout changed: mapWidth = \(mapWidth), mapHeight = \(mapHeight)" )
		topOffset = legend.frame.size.height
		availableHeight = mapHeight - topOffset		// Number of pixels for full range in vertical direction
		availableWidth = mapWidth
		let bottom = mapHeight
		let center = mapWidth / 2.0
//		let radius = ( mapHeight / 2.0 ) - 20.0
		sweepOrigin = CGPoint( x: center, y: bottom )
		DispatchQueue.main.async {
			self.setNeedsDisplay()
		}
	}
	
	public func updateMapList() {
		print( "In updateMapList in MapView" )
		if let mapList = mapList {
			sortedMapKeys = mapList.keys.sorted()
			if let keys = sortedMapKeys {
				minAngle = keys[0]
				maxAngle = keys[keys.count - 1]
				maxDistance = 0
				for key in keys {
					if let sonarEntry = mapList[key] {
						print( "Angle: \(key), distance: \(sonarEntry.distance / 29 / 2) cm, \(sonarEntry.distance / 74 / 2) inches " )
						if sonarEntry.distance > maxDistance {
							maxDistance = sonarEntry.distance
						}
					}
				}
				maxDistance = Int( CGFloat( maxDistance ) * 0.8 )
				print( "  maxDistance: \(maxDistance) uSec, \(maxDistance.cm) cm" )

				// Height gives us the maximum y values we can use
				// We decrease the frame height we have to work with by the label bottom offset
				// and about 2 pixels at top and bottom of view for clarity
//				maxToTop = CGFloat( maxDistance ) / availableHeight
//				print( "  maxToTop: \(maxToTop) uSec / pixel" )
				
//				let maxCMToTop = CGFloat( maxDistance.cm ) / availableHeight
//				print( "  maxCMToTop: \(maxCMToTop) cm / pixel" )
				
//				let availableWidth = CGFloat( mapWidth - 16	)	// 8 pixel on each side
//				widthPerDegree = availableWidth / CGFloat( maxAngle - minAngle )
//				print( "  availableWidth: \(availableWidth) pixels, per degree: \(widthPerDegree)" )
			}
		}
	}
	
	public func showMap() {
		
		print( "In showMap in MapView" )
		updateMapList()
		let distance = "Maximum distance = \(maxDistance.cm) cm"
		print( "In showMap in MapView: \(distance)" )
		
		DispatchQueue.main.async {
			self.legend.text = distance
			self.setNeedsDisplay()
		}
	}
	
	override func draw(_ rect: CGRect) {

		print( "Draw" )
		guard let context = UIGraphicsGetCurrentContext(),
			  let keys = sortedMapKeys else { return }

		print( "Draw with rect \(rect)" )
		let startRadians = CGFloat((Double(minAngle+180) * 3.1416) / 180.0)
		let endRadians = CGFloat((Double(maxAngle+180) * 3.1416) / 180.0)
		let lineWidth: CGFloat = 0.5
		// Draw background
		context.setLineWidth(lineWidth)
		context.setStrokeColor(UIColor.lightGray.cgColor)
		context.move(to: sweepOrigin)
		context.addArc(center: sweepOrigin, radius: availableHeight, startAngle: startRadians, endAngle: endRadians, clockwise: false )
		context.addLine(to: sweepOrigin)
		context.addArc(center: sweepOrigin, radius: ( availableHeight * 2.0 ) / 3.0, startAngle: startRadians, endAngle: endRadians, clockwise: false )
		context.move(to: sweepOrigin)
		context.addArc(center: sweepOrigin, radius: availableHeight / 3.0, startAngle: startRadians, endAngle: endRadians, clockwise: false )
		context.move(to: sweepOrigin)
		context.strokePath()
		
		// Draw pings
		context.setLineWidth( 1.0 )
		context.setStrokeColor(UIColor.blue.cgColor)
//		context.move(to: sweepOrigin)
		for key in keys {
			if let mapListSafe = mapList,
				let entry = mapListSafe[key] {
				let radians = CGFloat((Double(key+180) * 3.1416) / 180.0)
				let radius = CGFloat( entry.distance ) / CGFloat( maxDistance ) * availableHeight
				context.addArc(center: sweepOrigin, radius: radius, startAngle: radians * 0.995, endAngle: radians * 1.005, clockwise: false )
			}
//			break
		}
		context.strokePath()

//		context.fillPath()
	}
	
	func getPosition( angle: CGFloat, distance: CGFloat ) -> CGPoint {
		
		
		
		return CGPoint.zero
	}
}
