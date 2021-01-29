//
//  StartupViewController.swift
//  cartrol
//
//  Created by Bill Snook on 1/27/21.
//  Copyright © 2021 billsnook. All rights reserved.
//

import UIKit


class StartupViewController: UIViewController {
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var pwmTextField: UITextField!
    @IBOutlet weak var servoPinTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        print( "In viewWillAppear in StartupViewController" )

        self.navigationController?.setNavigationBarHidden( false, animated: true )    // Show it on this page
        
    }

    override func viewWillDisappear(_ animated: Bool) {
    //        self.navigationController?.setNavigationBarHidden( true, animated: true )
        
        super.viewWillDisappear( animated )
    }

    // MARK: - Control methods
    
    @IBAction func resetAction(_ sender: Any) {

        print( "resetAction" )
    }
    
    @IBAction func saveAction(_ sender: Any) {
 
        print( "saveAction" )
    }

    @IBAction func leftAction(_ sender: Any) {
        
        print( "leftAction" )
    }
    
    @IBAction func rightAction(_ sender: Any) {
        
        print( "rightAction" )
    }
    
    @IBAction func farLeftAction(_ sender: Any) {
        
        print( "farLeftAction" )
    }
    
    @IBAction func centerAction(_ sender: Any) {
        
        print( "centerAction" )
    }
    
    @IBAction func farRightAction(_ sender: Any) {
        
        print( "farRightAction" )
    }
        
    @IBAction func pwmValueChangedAction(_ sender: Any) {
        
        print( "pwmValueChangedAction" )
    }
    
    @IBAction func servoPinValueChangedAction(_ sender: Any) {

        print( "servoPinValueChangedAction" )
    }
    
}




