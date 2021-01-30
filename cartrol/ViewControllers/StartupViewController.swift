//
//  StartupViewController.swift
//  cartrol
//
//  Created by Bill Snook on 1/27/21.
//  Copyright © 2021 billsnook. All rights reserved.
//

import UIKit


enum SpeedDirection: Int {
    case forward
    case reverse
}

struct SpeedEntry {
    var left = 0
    var right = 0
}

let SpeedMotorMaxValue = 4096.0


class StartupViewController: UIViewController, CommandResponder {
    
    @IBOutlet weak var pwmTextField: UITextField!
    @IBOutlet weak var pinTextField: UITextField!
    
    var pwmIsValid = false
    var pinIsValid = false
    
    @IBOutlet weak var speedDirectionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var speedIndexStepper: UIStepper!
    @IBOutlet weak var speedIndexTextField: UITextField!
    @IBOutlet weak var speedLeftMotorTextField: UITextField!
    @IBOutlet weak var speedRightMotorTextField: UITextField!
    
    @IBOutlet weak var speedLeftMotorStepper: UIStepper!
    @IBOutlet weak var speedLeftMotorBigStepper: UIStepper!
    @IBOutlet weak var speedRightMotorStepper: UIStepper!
    @IBOutlet weak var speedRightMotorBigStepper: UIStepper!
    
    
    var speedArray = [Int: SpeedEntry]()
    var speedArrayMax = 0
    var speedArrayHasChanged = false    // Needs saving
    var calibrationSpeedIndex = 0       // Current working index
    var calibrationSpeedDirection = SpeedDirection.forward
    var oldIndexValue = 0.0

    // MARK: - VC methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )

        self.navigationController?.setNavigationBarHidden( false, animated: true )    // Show it on this page
        
        initMotorSteppers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        
        targetPort.setCommandResponder( self )

// WFS - on or off during testing, needed for normal operation to get ranger and speed data
        targetPort.sendPi( "A" )    // Get rangeData, shows up in handleReply, updates textFields

        // Setup placeholder speed array until the right one is loaded
        var i = 0
        speedArrayMax = 9
        while i < speedArrayMax {
            speedArray[i] = SpeedEntry( left: 512 * i, right: 512 * i )
            i += 1;
        }
        i = -1
        while i > -speedArrayMax {
            speedArray[i] = SpeedEntry( left: 512 * -i, right: 512 * -i )
            i -= 1;
        }
        speedArrayHasChanged = false
        updateSpeedDisplayFor( index: 1 )
        
        speedIndexStepper.value = 1.0
        speedIndexStepper.minimumValue = Double(-speedArrayMax + 1)
        speedIndexStepper.maximumValue = Double(speedArrayMax - 1)

// WFS Off for testing
//        targetPort.sendPi( "D" )    // Get speedArray, returns in handleReply, updates textFields
    }
    

    override func viewWillDisappear(_ animated: Bool) {

        targetPort.setCommandResponder( nil )
        targetPort.sendPi( "S" )    // Send quick stop all command - no response expected

        super.viewWillDisappear( animated )
    }

    // MARK: - Response handler
    func handleReply(msg: String) {
        
        switch msg[0] {
        case "R":
            let params = msg.split(separator: " ")
            guard params.count == 3 else { return }
            pwmTextField.text = String(params[1])
            pinTextField.text = String(params[2])
            pwmIsValid = true
            pinIsValid = true
        case "S":
            let params = msg.split(separator: "\n")
            let header = params[0].split(separator: " ")
            guard header.count == 2 else { return }
            let spdArrayMax = String( header[1] )
            speedArrayMax = Int( spdArrayMax ) ?? 9
            for paramString in params {
                let entry = paramString.split(separator: " ")
                if entry[0] != "S" {
                    let index = Int( String( entry[0] ) )
                    let left = Int( String( entry[1] ) )
                    let right = Int( String( entry[2] ) )
                    guard index != nil, left != nil, right != nil else { return }
                    speedArray[index!] = SpeedEntry( left: left!, right: right! )
                }
            }
            speedArrayHasChanged = false
            updateSpeedDisplayFor( index: 1 )
            
            speedIndexStepper.value = 1.0
            speedIndexStepper.minimumValue = Double(-speedArrayMax + 1)
            speedIndexStepper.maximumValue = Double(speedArrayMax - 1)

            break
        default:
            break
        }
    }
    
    // MARK: - Scanner Alignment action methods
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
    
    // MARK: - Speed Alignment action methods

    @IBAction func speedResetAction() {

        print( "speedResetAction" )
        view.endEditing( false )
        speedArrayHasChanged = false
        targetPort.sendPi( "D" )    // Get speedArray, returns in handleReply which updates textFields
    }
    
    @IBAction func speedSaveAction() {
        
        for (key, spdEntry) in speedArray {
            let setPiSpeedEntry = "E \(key) \(spdEntry.left) \(spdEntry.right)"
            targetPort.sendPi( setPiSpeedEntry )    // Set speedarray entry
        }
        targetPort.sendPi( "e" )    // Fill in speedarray

        speedArrayHasChanged = false
    }
    
    @IBAction func speedDirectionAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == SpeedDirection.forward.rawValue {
            calibrationSpeedDirection = .forward
        } else {
            calibrationSpeedDirection = .reverse
        }
        calibrationSpeedIndex = -calibrationSpeedIndex
        updateMotors()
    }
    
    @IBAction func speedIndexStepAction(_ sender: UIStepper) {
        
        let value = sender.value
        if value == Double(speedArrayMax - 2) { // If decremented from max value
            sender.value = 1.0
        } else if value == 2.0 {                // If incremented from 1
            sender.value = Double(speedArrayMax - 1)
        } else if value == 0.0 {                // If decremented from 1 or incremented from -1
            if oldIndexValue > 0.0 {            // If decremented from 1
                sender.value = -1.0
            } else {                            // Else incremented from -1
                sender.value = 1.0
            }
        } else if value == -2.0 {               // If decremented from -1
            sender.value = Double(-speedArrayMax + 1)
        } else if value == Double(-speedArrayMax + 2) { // If incremented from min value
            sender.value = -1.0
        } else {
            sender.value = 1.0
        }
        oldIndexValue = value
        updateSpeedDisplayFor( index: Int(sender.value) )
    }
    
    @IBAction func speedLeftMotorEditAction(_ sender: UITextField) {

        guard let text = sender.text, let power = Int( text ) else { return }
        updateLeftMotor( powerLevel: power  )
    }
    
    @IBAction func speedRightMotorEditAction(_ sender: UITextField) {
        
        guard let text = sender.text, let power = Int( text ) else { return }
        updateRightMotor( powerLevel: power  )
    }
    
    @IBAction func speedLeftMotorStepAction(_ sender: UIStepper) {
        let power = Int(sender.value)
        updateLeftMotor( powerLevel: power  )
    }
    
    @IBAction func speedRightMotorStepAction(_ sender: UIStepper) {
        let power = Int(sender.value)
        updateRightMotor( powerLevel: power  )
    }
    
    @IBAction func speedLeftMotorStepXAction(_ sender: UIStepper) {
        let power = Int(sender.value)
        updateLeftMotor( powerLevel: power  )
    }
    
    @IBAction func speedRightMotorStepXAction(_ sender: UIStepper) {
        let power = Int(sender.value)
        updateRightMotor( powerLevel: power  )

    }
    
    @IBAction func speedRunAction() {
    }
    
    @IBAction func speedStopAction() {
        targetPort.sendPi( "S" )    // Quick stop
    }
    
    @IBAction func speedReturnAction() {
    }
    
    // MARK: - Speed Alignment utilities
    func updateSpeedDisplayFor( index: Int ) {

        calibrationSpeedDirection = index > 0 ? .forward : .reverse
        calibrationSpeedIndex = index

        updateMotors()
    }
    
    func initMotorSteppers() {
        
        speedLeftMotorStepper.minimumValue = 0.0
        speedLeftMotorStepper.maximumValue = SpeedMotorMaxValue
        speedLeftMotorStepper.value = 0.0
        speedLeftMotorStepper.stepValue = 4.0

        speedLeftMotorBigStepper.minimumValue = 0.0
        speedLeftMotorBigStepper.maximumValue = SpeedMotorMaxValue
        speedLeftMotorBigStepper.value = 0.0
        speedLeftMotorBigStepper.stepValue = 64.0

        speedRightMotorStepper.minimumValue = 0.0
        speedRightMotorStepper.maximumValue = SpeedMotorMaxValue
        speedRightMotorStepper.value = 0.0
        speedRightMotorStepper.stepValue = 4.0

        speedRightMotorBigStepper.minimumValue = 0.0
        speedRightMotorBigStepper.maximumValue = SpeedMotorMaxValue
        speedRightMotorBigStepper.value = 0.0
        speedRightMotorBigStepper.stepValue = 64.0
    }

    func updateMotors() {       // Index has changed
        
        speedDirectionSegmentedControl.selectedSegmentIndex = calibrationSpeedDirection.rawValue
        speedIndexTextField.text = "\(calibrationSpeedIndex)"
        updateLeftControls(powerLevel: speedArray[calibrationSpeedIndex]?.left ?? 512 )
        updateRightControls(powerLevel: speedArray[calibrationSpeedIndex]?.right ?? 512 )

    }
    
    func updateLeftControls( powerLevel: Int ) {   // Power level has changed
        
        speedLeftMotorTextField.text = String( powerLevel )
        speedLeftMotorStepper.value = Double( powerLevel )
        speedLeftMotorBigStepper.value = Double( powerLevel )
    }
    
    func updateLeftMotor( powerLevel: Int ) {   // Power level has changed
        
        speedArrayHasChanged = true
        speedArray[calibrationSpeedIndex]?.left = powerLevel
        updateLeftControls( powerLevel: powerLevel )
    }
    
    func updateRightControls( powerLevel: Int ) {   // Power level has changed
        
        speedRightMotorTextField.text = String( powerLevel )
        speedRightMotorStepper.value = Double( powerLevel )
        speedRightMotorBigStepper.value = Double( powerLevel )
    }

    func updateRightMotor( powerLevel: Int ) {  // Power level has changed
        
        speedArrayHasChanged = true
        speedArray[calibrationSpeedIndex]?.right = powerLevel
        updateRightControls( powerLevel: powerLevel )
    }


}
