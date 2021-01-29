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
//        print( "In viewDidAppear in StartupViewController" )
        
        targetPort.setCommandResponder( self )

// WFS - on or off during testing, needed for normal operation to get ranger and speed data
        targetPort.sendPi( "a" )    // Get range data
    }
    

    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden( true, animated: true )
        targetPort.setCommandResponder( nil )

        super.viewWillDisappear( animated )
    }

    // MARK: - Control methods
    
    func handleReply(msg: String) {
        
        switch msg[0] {
        case "R":
            let params = msg.split(separator: " ")
            guard params.count >= 3 else { return }
//            let pwm = Int(params[1])
//            let pin = Int(params[2])
            pwmTextField.text = String(params[1])
            pinTextField.text = String(params[2])
        default:
            break
        }
    }
    

    
    @IBAction func resetAction(_ sender: Any) {

        print( "resetAction" )
        view.endEditing( false )
        pwmTextField.text = "330"
        pinTextField.text = "14"
    }
    
    @IBAction func saveAction(_ sender: Any) {
 
        print( "saveAction" )
        view.endEditing( false )
        targetPort.sendPi( "b \(pwmTextField.text ?? "330") \(pinTextField.text ?? "14")" )    // Copy range data to Pi to save and use
    }

    @IBAction func leftAction(_ sender: Any) {
        
        print( "leftAction" )
        view.endEditing( false )
        var pwm = atoi( pwmTextField.text ) - 1
        if pwm < 300 {
            pwm = 300
        }
        pwmTextField.text = "\(pwm)"
    }
    
    @IBAction func rightAction(_ sender: Any) {
        
        print( "rightAction" )
        view.endEditing( false )
        var pwm = atoi( pwmTextField.text ) + 1
        if pwm > 360 {
            pwm = 360
        }
        pwmTextField.text = "\(pwm)"
    }
    
    @IBAction func farLeftAction(_ sender: Any) {
        
        print( "farLeftAction" )
        view.endEditing( false )
    }
    
    @IBAction func centerAction(_ sender: Any) {
        
        print( "centerAction" )
        view.endEditing( false )
    }
    
    @IBAction func farRightAction(_ sender: Any) {
        
        print( "farRightAction" )
        view.endEditing( false )
    }
        
    @IBAction func pwmEditEndAction(_ sender: UITextField) {

        print( "pwmEditEndAction" )
        var newPWM = atoi( sender.text )
        if newPWM <= 300 {
            print( "Invalid value, must be >= 300" )
            newPWM = 300
        } else if newPWM >= 360 {
            print( "Invalid value, must be <= 360" )
            newPWM = 360
        }
        sender.text = "\(newPWM)"
    }
    
    @IBAction func pinEndEditAction(_ sender: UITextField) {

        print( "pinEndEditAction" )
        let newPin = sender.text
        if newPin == "0" || newPin == "1" || newPin == "14" || newPin == "15" {
        } else {
            print( "Invalid value, must be 0, 1, 14, or 15" )
            sender.text = "14"
        }
    }
    
}
