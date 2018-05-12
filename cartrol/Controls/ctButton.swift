//
//  ctButton.swift
//  cartest
//
//  Created by William Snook on 5/12/18.
//  Copyright © 2018 billsnook. All rights reserved.
//

import UIKit

class CTButton: UIButton {
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.backgroundColor = UIColor.cyan
		self.layer.cornerRadius = 6
	}
}
