//
//  cartrolTests.swift
//  cartrolTests
//
//  Created by William Snook on 5/12/18.
//  Copyright © 2018 billsnook. All rights reserved.
//

import XCTest
@testable import cartrol

class cartrolTests: XCTestCase {
    
    var vc: UIViewController?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        vc = UIApplication.shared.keyWindow?.rootViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCase1() {
        if let controllerVC = vc as? ConnectViewController {
            XCTAssertFalse( controllerVC.isConnected, "connected state is true which is wrong")
        } else {
            XCTAssert( true, "wrong viewcontroller found")
        }
    }
        
    func testCase2() {
        if let controllerVC = vc as? ConnectViewController {
            if let title = controllerVC.connectButton.titleLabel?.text {
                XCTAssertEqual( title, "Connected", "connected button is \(title) which is wrong")
            } else {
                XCTAssert( false, "connected button is not found")
            }
        } else {
           XCTAssert( true, "wrong viewcontroller found")
        }
    }
            
    func testCase3() {
        if let controllerVC = vc as? ConnectViewController {
            if let title = controllerVC.commandButton.titleLabel?.text {
                XCTAssertEqual( title, "Send", "command button is \(title) which is wrong")
            } else {
                XCTAssert( false, "command button is not found")
            }
        } else {
           XCTAssert( true, "wrong viewcontroller found")
        }
    }
    
}
