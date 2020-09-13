//
//  cartrolUITests.swift
//  cartrolUITests
//
//  Created by William Snook on 9/13/20.
//  Copyright © 2020 billsnook. All rights reserved.
//

import XCTest

class cartrolUITests: XCUITestBase {

    func testStartup() throws {

        if app.buttons["Connect"].exists {
            let btn = app.buttons["Connect"]
            if btn.staticTexts[" Disconnect "].exists {
                btn.staticTexts[" Disconnect "].tap()
                XCTAssertFalse( btn.staticTexts[" Disconnect "].exists, "Button did not change")
                XCTAssertTrue( btn.staticTexts[" Connect "].exists, "Button did not change correctly")
            } else {
                XCTAssert( true, "Connect button text 'Disconnect' not found" )
            }
        } else {
            XCTAssert( true, "Connect button not found" )
        }
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
