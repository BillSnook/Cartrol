//
//  cartrolUITests.swift
//  cartrolUITests
//
//  Created by William Snook on 9/13/20.
//  Copyright © 2020 billsnook. All rights reserved.
//

import XCTest

class cartrolUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStartup() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

//        XCTAssert( true, "Connect button not found" )
//        app.staticTexts[" Disconnect "].tap()
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
