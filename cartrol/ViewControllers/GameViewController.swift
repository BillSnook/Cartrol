//
//  GameViewController.swift
//  cartest
//
//  Created by William Snook on 5/8/18.
//  Copyright © 2018 billsnook. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

	
	override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
		//Looks for single or multiple taps
		let tapScene: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(self.handleSceneTap) )
		tapScene.numberOfTapsRequired = 3
		view.addGestureRecognizer(tapScene)

//		let tapCommand: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(self.handleCommandTap) )
//		commandView.addGestureRecognizer(tapCommand)
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
	
	
	@objc func handleSceneTap() {
		print( "In handleSceneTap" )

		guard let nav = self.navigationController else { return }
		nav.popViewController( animated: true )

	}

}
