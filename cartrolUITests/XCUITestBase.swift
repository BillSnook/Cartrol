//
//  XCUITestBase.swift
//  cartrolUITests
//
//  Created by William Snook on 9/13/20.
//  Copyright © 2020 billsnook. All rights reserved.
//

import XCTest

class XCUITestBase: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {

        try super.setUpWithError()

        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {

        app.terminate()
        
        try super.tearDownWithError()
    }

}
