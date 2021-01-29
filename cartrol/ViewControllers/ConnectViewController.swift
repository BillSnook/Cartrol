//
//  ConnectViewController.swift
//  cartrol
//
//  Created by William Snook on 5/12/18.
//  Copyright © 2018 billsnook. All rights reserved.
//

import UIKit


let targetPort = Sender()

class ConnectViewController: UIViewController, CommandResponder, UIPickerViewDelegate, UIPickerViewDataSource {
	
	@IBOutlet var commandView: UIView!
    @IBOutlet var devicePickerView: UIPickerView!
	@IBOutlet var connectButton: CTButton!
	@IBOutlet var commandButton: CTButton!
	@IBOutlet var commandTextField: UITextField!
	@IBOutlet var clearButton: CTButton!
	@IBOutlet var calibrateButton: CTButton!
	@IBOutlet var controlButton: CTButton!
	@IBOutlet var directButton: CTButton!
	@IBOutlet var testStatusButton: CTButton!
	@IBOutlet var testRangeButton: CTButton!
	
	@IBOutlet var test1Button: CTButton!
	@IBOutlet var test2Button: CTButton!
	@IBOutlet var test3Button: CTButton!
	
	@IBOutlet var responseDisplayTextView: UITextView!
	
	var isConnected = true  // WFS true for testing UI w/o connection
    var isConnecting = false    // Enables cancelling
    
    let deviceArray = ["Camera01", "Develop00", "Develop01", "Develop30", "Develop31", "Develop32", "Develop40", "Develop50", "Develop60", "Devx", "Hughie", "Dewie", "Louie"]
    
    //  Develop0x       16Gb PiZero
    //  Develop3x       32Gb Pi3
    //  Develop4x       16Gb Pi3
    //  Develop5x       32Gb Pi4 Desktop
    //  Develop6x       16Gb Pi4 Lite
    //  Camera0x        16Gb PiZero
    //  DevX            16Gb Pi3
    
    // 60       Hughie
    // 61       Dewie
    // 62       Louie

    // MARK: - Code
	override func viewDidLoad() {
		super.viewDidLoad()
//		print( "In viewDidLoad in ConnectViewController" )
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear( animated )
//		print( "In viewWillAppear in ConnectViewController" )

		setupButtons()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear( animated )
//		print( "In viewDidAppear in ConnectViewController" )

        targetPort.setCommandResponder( self )
        
        let savedRow = UserDefaults.standard.integer(forKey: "SelectedDeviceRow")
        devicePickerView.selectRow(savedRow, inComponent: 0, animated: true)
	}
	
	override func viewWillDisappear(_ animated: Bool) {

        targetPort.setCommandResponder( nil )

//		print( "In viewWillDisappear in ConnectViewController" )
		super.viewWillDisappear( animated )
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		
//		print( "In viewDidDisappear in ConnectViewController" )
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
	
	
	// MARK: - Interactions
	
	func handleReply(msg: String) {
		if let oldMsg = responseDisplayTextView.text, !oldMsg.isEmpty {
			responseDisplayTextView.text = oldMsg + "\n" + msg
		} else {
			responseDisplayTextView.text = msg
		}
	}
	
	
	func setupButtons() {
        connectButton.isEnabled = true
        devicePickerView.isUserInteractionEnabled = !isConnected
        commandButton.isHidden = !isConnected
        commandTextField.isHidden = !isConnected
        clearButton.isHidden = !isConnected
        calibrateButton.isHidden = !isConnected
        controlButton.isHidden = !isConnected
        directButton.isHidden = !isConnected
        testStatusButton.isHidden = !isConnected
        testRangeButton.isHidden = !isConnected
        test1Button.isHidden = !isConnected
        test2Button.isHidden = !isConnected
        test3Button.isHidden = !isConnected
        responseDisplayTextView.isHidden = !isConnected
		if ( isConnected ) {
			connectButton.setTitle( "Disconnect", for: .normal )
			responseDisplayTextView.text = ""
		} else {
			connectButton.setTitle( "Connect", for: .normal )
		}
	}

	@IBAction func doConnectButtonTouch(_ sender: CTButton) {
		print( "In doConnectButtonTouch" )
        let hostName = deviceArray[devicePickerView.selectedRow(inComponent: 0)]
        responseDisplayTextView.text = "Touch in connectButton for \(hostName)"

		if isConnected {			// If is connected, we must be disconnecting
			print( "\nDisconnecting from host \(hostName)" )
			targetPort.doBreakConnection()
			isConnected = false
			setupButtons()
		} else {
            if !isConnecting {      // Or if not connecting, we must be connecting
                connectButton.setTitle( "Cancel", for: .normal )
                isConnecting = true
                print( "\nConnecting to host \(hostName)" )
                devicePickerView.isUserInteractionEnabled = false
//              activityIndicator.startAnimating()
                DispatchQueue.global( qos: .userInitiated ).async {
                    self.isConnected = targetPort.doMakeConnection( to: hostName, at: 5555 )
                    if !self.isConnecting {
                        self.isConnected = false
                    }
                    self.isConnecting = false
                    DispatchQueue.main.async {
                        self.setupButtons()
//                      self.activityIndicator.stopAnimating()
                    }
                }
            } else {                // else if connecting, we must be cancelling
                if isConnecting {   // If still waiting
                    isConnecting = false
                    print( "\nCancelled connection to host \(hostName)" )
                    connectButton.setTitle( "Connect", for: .normal )

                }
            }
		}
	}

	@IBAction func doCommandButtonTouch(_ sender: CTButton) {
		print( "In doCommandButtonTouch" )
		guard let command = commandTextField.text,
			!command.isEmpty
//			let priorText = responseDisplayTextView.text
			else { return }
		targetPort.sendPi( command )
	}

	@IBAction func doTestStatus(_ sender: CTButton) {

		targetPort.sendPi( "A 1" )	// Send set status mode command
		usleep( 1000 )
		targetPort.sendPi( "B" )	// Send get status command
	}
	
	@IBAction func doTestRange(_ sender: Any) {

		targetPort.sendPi( "C" )	// Send get range mode command
		usleep( 10000 )
		targetPort.sendPi( "D" )	// Send get range command
	}
	
    @IBAction func doClearButtonTouch(_ sender: CTButton) {
        print( "In doClearButtonTouch" )
        responseDisplayTextView.text = ""
    }

	@IBAction func doTest1(_ sender: CTButton) {
		print( "In doTest1, Ping" )
		targetPort.sendPi( "G" )	// doPing
	}
	
	@IBAction func doTest2(_ sender: CTButton) {
		print( "In doTest2, center scanner" )
		targetPort.sendPi( "F 90" )	// Servo at 90 degrees
	}
	
	@IBAction func doTest3(_ sender: CTButton) {
		print( "In doTest3, Stop all" )
		targetPort.sendPi( "S" )    // Stop
	}
    
    // MARK: - Device Picker Delegates and DataSources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        deviceArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return deviceArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        UserDefaults.standard.setValue(row, forKey: "SelectedDeviceRow")
    }

}
