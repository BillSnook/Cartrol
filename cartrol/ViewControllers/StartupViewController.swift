//
//  StartupViewController.swift
//  cartrol
//
//  Created by Bill Snook on 1/27/21.
//  Copyright © 2021 billsnook. All rights reserved.
//

import UIKit


class StartupViewController: UIViewController, CommandResponder {
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var pwmTextField: UITextField!
    @IBOutlet weak var pinTextField: UITextField!
    
    var pwmIsValid = false
    var pinIsValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        print( "In viewWillAppear in StartupViewController" )

        self.navigationController?.setNavigationBarHidden( false, animated: true )    // Show it on this page
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        
        targetPort.setCommandResponder( self )

// WFS - on or off during testing, needed for normal operation to get ranger and speed data
        targetPort.sendPi( "A" )    // Get rangeData, shows up in handleReply
    }
    

    override func viewWillDisappear(_ animated: Bool) {

        targetPort.setCommandResponder( nil )

        super.viewWillDisappear( animated )
    }

    // MARK: - Response handlers
    func handleReply(msg: String) {
        
        switch msg[0] {
        case "R":
            let params = msg.split(separator: " ")
            guard params.count >= 3 else { return }
            pwmTextField.text = String(params[1])
            pinTextField.text = String(params[2])
            pwmIsValid = true
            pinIsValid = true
        case "S":
            break
        default:
            break
        }
    }
    
    // MARK: - Control  action methods
    @IBAction func resetAction(_ sender: Any) {

        print( "resetAction" )
        view.endEditing( false )
        targetPort.sendPi( "A" )    // Get rangeData, returns in handleReply which updates textFields
    }
    
    @IBAction func saveAction(_ sender: Any) {
 
        print( "saveAction" )
        view.endEditing( false )
        if ( pwmIsValid && pinIsValid ) {
            targetPort.sendPi( "a \(pwmTextField.text ?? "330") \(pinTextField.text ?? "14")" )    // Copy range data to Pi to save and use
        }
    }

    @IBAction func leftAction(_ sender: Any) {
        
        print( "leftAction" )
        view.endEditing( false )
        var pwm = atoi( pwmTextField.text ) - 1
        if pwm < 280 {
            pwm = 280
        }
        pwmTextField.text = "\(pwm)"
        targetPort.sendPi( "B \(pwmTextField.text ?? "330")" )    // Send PWM value to Pi to use
    }
    
    @IBAction func rightAction(_ sender: Any) {
        
        print( "rightAction" )
        view.endEditing( false )
        var pwm = atoi( pwmTextField.text ) + 1
        if pwm > 380 {
            pwm = 380
        }
        pwmTextField.text = "\(pwm)"
        targetPort.sendPi( "B \(pwmTextField.text ?? "330")" )    // Send PWM value to Pi to use
    }
    
    @IBAction func farLeftAction(_ sender: Any) {
        
        print( "farLeftAction" )
        view.endEditing( false )
        targetPort.sendPi( "C 0" )    // Send Set angle 0 to Pi to use
    }
    
    @IBAction func centerAction(_ sender: Any) {
        
        print( "centerAction" )
        view.endEditing( false )
        targetPort.sendPi( "C 90" )    // Send Set angle 0 to Pi to use
    }
    
    @IBAction func farRightAction(_ sender: Any) {
        
        print( "farRightAction" )
        view.endEditing( false )
        targetPort.sendPi( "C 180" )    // Send Set angle 0 to Pi to use
    }
        
    @IBAction func pwmEditEndAction(_ sender: UITextField) {

        print( "pwmEditEndAction" )
        var newPWM = atoi( sender.text )
        if newPWM < 280 {
            print( "Invalid value, must be >= 280" )
            newPWM = 280
        } else if newPWM > 380 {
            print( "Invalid value, must be <= 380" )
            newPWM = 380
        }
        sender.text = "\(newPWM)"
    }
    
    @IBAction func pinEndEditAction(_ sender: UITextField) {

        print( "pinEndEditAction" )
        let newPin = sender.text
        pinIsValid =  newPin == "0" || newPin == "1" || newPin == "14" || newPin == "15"
        if !pinIsValid {
            print( "Invalid value, must be 0, 1, 14, or 15" )
            sender.text = "14"
        }
    }
    
}
