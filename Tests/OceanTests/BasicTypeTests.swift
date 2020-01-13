//
//  BasicTypeTests.swift
//  OceanTests
//
//  Created by Tomohiro Kumagai on 2020/01/14.
//

import XCTest
@testable import Ocean

class BasicTypeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMargin() {

        let m1 = Margin(margin: 10)
        let m2 = Margin(margin: 30)
        let m3 = Margin(margin: 10)
        
        XCTAssertEqual(m1, m3)
        XCTAssertNotEqual(m1, m2)
        
        XCTAssertEqual(m1.top, 10)
        XCTAssertEqual(m1.bottom, 10)
        XCTAssertEqual(m1.left, 10)
        XCTAssertEqual(m1.right, 10)
        
        XCTAssertEqual(m2.top, 30)
        XCTAssertEqual(m2.bottom, 30)
        XCTAssertEqual(m2.left, 30)
        XCTAssertEqual(m2.right, 30)
        
        XCTAssertEqual(m3.top, 10)
        XCTAssertEqual(m3.bottom, 10)
        XCTAssertEqual(m3.left, 10)
        XCTAssertEqual(m3.right, 10)
        
        let m4 = IntMargin(vertical: 40, horizontal: 10)
        
        XCTAssertEqual(m4.top, 40)
        XCTAssertEqual(m4.bottom, 40)
        XCTAssertEqual(m4.left, 10)
        XCTAssertEqual(m4.right, 10)
        
        XCTAssertNotEqual(m4, m1)
        XCTAssertNotEqual(m4, m2)
        XCTAssertNotEqual(m4, m3)
        XCTAssertEqual(m4, m4)
        
        let m5 = IntMargin(top: 10, horizontal: 40, bottom: 20)
        
        XCTAssertEqual(m5.top, 10)
        XCTAssertEqual(m5.bottom, 20)
        XCTAssertEqual(m5.left, 40)
        XCTAssertEqual(m5.right, 40)

        XCTAssertNotEqual(m5, m1)
        XCTAssertNotEqual(m5, m2)
        XCTAssertNotEqual(m5, m3)
        XCTAssertNotEqual(m5, m4)
        XCTAssertEqual(m5, m5)

        let m6 = IntMargin(top: 40, right: 10, bottom: 40, left: 10)
        
        XCTAssertEqual(m6.top, 40)
        XCTAssertEqual(m6.bottom, 40)
        XCTAssertEqual(m6.left, 10)
        XCTAssertEqual(m6.right, 10)
        
        XCTAssertNotEqual(m6, m1)
        XCTAssertNotEqual(m6, m2)
        XCTAssertNotEqual(m6, m3)
        XCTAssertEqual(m6, m4)
        XCTAssertNotEqual(m6, m5)
        XCTAssertEqual(m6, m6)
        
        let m7 = IntMargin(top: 40, right: 30, bottom: 20, left: 10)
        
        XCTAssertEqual(m7.top, 40)
        XCTAssertEqual(m7.bottom, 20)
        XCTAssertEqual(m7.left, 10)
        XCTAssertEqual(m7.right, 30)
        
        XCTAssertNotEqual(m7, m1)
        XCTAssertNotEqual(m7, m2)
        XCTAssertNotEqual(m7, m3)
        XCTAssertNotEqual(m7, m4)
        XCTAssertNotEqual(m7, m5)
        XCTAssertNotEqual(m7, m6)
        XCTAssertEqual(m7, m7)
    }
}
