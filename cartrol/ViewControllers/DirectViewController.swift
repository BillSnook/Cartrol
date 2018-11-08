//
//  DirectViewController.swift
//  cartrol
//
//  Created by William Snook on 11/7/18.
//  Copyright © 2018 billsnook. All rights reserved.
//

import UIKit

class DirectViewController: UIViewController {
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear( animated )
		
		self.navigationController?.setNavigationBarHidden( false, animated: true )	// Just hide it on this page
	}

	override func viewWillDisappear(_ animated: Bool) {
		self.navigationController?.setNavigationBarHidden( true, animated: true )
		
		super.viewWillDisappear( animated )
	}

}
