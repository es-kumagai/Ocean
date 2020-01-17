//
//  ScaleTests.swift
//  OceanTests
//
//  Created by Tomohiro Kumagai on 2020/01/14.
//

import XCTest
@testable import Ocean

class ScaleTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testActualScale() {
    
        XCTAssertEqual(Scale<Int>.actual.value, 1)
        XCTAssertEqual(Scale<Double>.actual, Scale<Double>(1))
    }
    
    func testScaleStructTests() {
        
        typealias DoubleScale = Scale<Double>
        
        let scale1 = DoubleScale(10)
        let scale2 = DoubleScale(20)
        
        XCTAssertEqual(scale1.value, 10)
        XCTAssertEqual(scale2.value, 20)
        XCTAssertNotEqual(scale1.value, 20)
        XCTAssertNotEqual(scale2.value, 10)
        
        let scale3:DoubleScale = 5
        let scale4:DoubleScale = 8.5
        
        XCTAssertEqual(scale3.value, 5)
        XCTAssertEqual(scale4.value, 8.5)
        
        XCTAssertEqual(scale3, 5)
        XCTAssertEqual(scale4, 8.5)
        
        XCTAssertEqual(scale3, DoubleScale(5))
        XCTAssertEqual(scale4, DoubleScale(8.5))
    }
    
    func testScaleOperation() {
        
        typealias DoubleScale = Scale<Double>
        
        let value1 = 1236.0
        let value2 = 2005.0
        
        let scale1 = DoubleScale(2)
        let scale2 = DoubleScale(0.8)
        
        XCTAssertEqual(scale1.applying(to: value1), 2472)
        XCTAssertEqual(value1.scaled(by: scale1), 2472)
        
        XCTAssertEqual(scale2.applying(to: value1), 1236 * 0.8)
        XCTAssertEqual(value1.scaled(by: scale2), 1236 * 0.8)
        
        XCTAssertEqual(scale1.applying(to: value2), 4010)
        XCTAssertEqual(value2.scaled(by: scale1), 4010)
        
        XCTAssertEqual(scale2.applying(to: value2), 1604)
        XCTAssertEqual(value2.scaled(by: scale2), 1604)
    }
}
