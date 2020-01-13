//
//  DivideTests.swift
//  OceanTests
//
//  Created by Tomohiro Kumagai on 2020/01/14.
//

import XCTest

class DivideTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDivide() {

        let v1 = 10235
        let v2 = 2345.236
        
        XCTAssertEqual(v1.half, 5117)
        XCTAssertEqual(v1.quarter, 2558)

        XCTAssertEqual(v2.half, 1172.618)
        XCTAssertEqual(v2.quarter, 586.309)
    }
}
