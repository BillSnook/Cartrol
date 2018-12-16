//
//  DirectViewController.swift
//  cartrol
//
//  Created by William Snook on 11/7/18.
//  Copyright © 2018 billsnook. All rights reserved.
//

import UIKit

class DirectViewController: UIViewController {
	
	var isConnected = false
	
	override func viewDidLoad() {
		super.viewDidLoad()

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear( animated )
		
		self.navigationController?.setNavigationBarHidden( false, animated: true )	// Just hide it on this page
		
		if targetPort.socketConnected {
//			targetPort.sendPi( "" )	// ? Sign in ?
			isConnected = true
		} else {
			// Alert
		}

	}

	override func viewWillDisappear(_ animated: Bool) {
		self.navigationController?.setNavigationBarHidden( true, animated: true )
		
		super.viewWillDisappear( animated )
	}

	// Scan controls
	@IBAction func stopSonarAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "M 0" )
	}
	
	@IBAction func scanAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "M 3" )
	}
	
	@IBAction func sonarAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "M 5" )
	}
	
	@IBAction func pingAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "M 4" )
	}
	
	@IBAction func huntAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "M 6" )	// Stop for now until hunt is ready
	}
	
	// Inner controls
	@IBAction func tlAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 0 3 0 4" )
	}
	
	@IBAction func topAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 0 4 0 4" )
	}

	@IBAction func trAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 0 4 0 3" )
	}

	@IBAction func leftAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 1 4 0 4" )
	}

	@IBAction func centerAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 0 0 0 0" )
	}

	@IBAction func rightAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 0 4 1 4" )
	}

	@IBAction func blAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 1 3 1 4" )
	}

	@IBAction func bottomAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 1 4 1 4" )
	}

	@IBAction func brAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 1 4 1 3" )
	}

	// Outer group
	@IBAction func ttllAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 0 2 0 8" )
	}
	
	@IBAction func ttlAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 0 4 0 8" )
	}
	
	@IBAction func ttAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 0 8 0 8" )
	}
	
	@IBAction func ttrAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }

		targetPort.sendPi( "A 0 8 0 4" )
	}
	
	@IBAction func ttrrAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 0 8 0 2" )
	}
	
	@IBAction func tllAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 0 2 0 5" )
	}
	
	@IBAction func trrAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 0 5 0 2" )
	}
	
	@IBAction func bllAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 1 2 1 5" )
	}
	
	@IBAction func brrAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 1 5 1 2" )
	}
	
	@IBAction func bbllAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 1 2 1 8" )
	}
	
	@IBAction func bblAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 1 4 1 8" )
	}
	
	@IBAction func bbAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 1 8 1 8" )
	}
	
	@IBAction func bbrAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 1 8 1 4" )
	}
	
	@IBAction func bbrrAction(_ sender: UIButton) {
		guard isConnected else { print( "Not connected!" ); return }
		
		targetPort.sendPi( "A 1 8 1 2" )
	}
	
}
