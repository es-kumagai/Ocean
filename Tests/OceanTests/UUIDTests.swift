//
//  UUIDTests.swift
//  OceanTests
//
//  Created by Tomohiro Kumagai on 2020/01/13.
//

import XCTest
@testable import Ocean

class UUIDTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUUIDGenerate() {
        
        let uuid1 = Ocean.UUID()
        let uuid1String = String(uuid1)
        
        print("Auto Generated UUID : \(uuid1String)")
        
        XCTAssertTrue(uuid1String.count == 36)
        
        
        let uuid2String = "D7EE438F-1713-4B6A-8784-827727BA090B"
        let uuid2 = Ocean.UUID(string: uuid2String)!
        let uuid2_1 = Ocean.UUID(string: uuid2String)!
        
        XCTAssertEqual(String(uuid2), uuid2String)
        
        let uuid3String = "???E438F-1713-4B6A-8784-827727BA090B"
        let uuid3 = Ocean.UUID(string: uuid3String)
        
        XCTAssertTrue(uuid3 == nil)
        
        
        let uuid4:Ocean.UUID = "3472941B-812E-4136-8389-3DE6C9FC494F"
        
        XCTAssertTrue(String(uuid4) == "3472941B-812E-4136-8389-3DE6C9FC494F")
        
        // 文字列リテラルからの変換は、間違った値の場合は即落ち
        //        let uuid5:Swim.UUID = "???2941B-812E-4136-8389-3DE6C9FC494F"
        
        let uuid6: Ocean.UUID = nil
        
        XCTAssertTrue(uuid6.isNull)
        XCTAssertEqual(uuid6, Ocean.UUID.Null)
        
        let uuid7 = uuid4
        let uuid8:Ocean.UUID = "DA5900E0-25A4-4C84-9ADC-C82A66D92E4A"
        
        XCTAssertEqual(uuid7, uuid4)
        
        
        XCTAssertEqual(uuid2, uuid2_1)
        XCTAssertEqual(uuid4, uuid7)
        XCTAssertTrue(uuid2 > uuid4)
        XCTAssertTrue(uuid2 > uuid6)
        XCTAssertTrue(uuid4 > uuid6)
        XCTAssertTrue(uuid4 < uuid8)
        XCTAssertTrue(uuid2 < uuid8)
        
        XCTAssertTrue(uuid2 >= uuid2_1)
        XCTAssertTrue(uuid4 >= uuid7)
        XCTAssertTrue(uuid2 <= uuid2_1)
        XCTAssertTrue(uuid4 <= uuid7)
        
        XCTAssertTrue(uuid2 >= uuid4)
        XCTAssertTrue(uuid2 >= uuid6)
        XCTAssertTrue(uuid4 >= uuid6)
        XCTAssertTrue(uuid4 <= uuid8)
        XCTAssertTrue(uuid2 <= uuid8)
        
        XCTAssertFalse(uuid1.isNull)
        XCTAssertFalse(uuid2.isNull)
        XCTAssertFalse(uuid2_1.isNull)
        XCTAssertFalse(uuid4.isNull)
        XCTAssertTrue(uuid6.isNull)
        XCTAssertFalse(uuid7.isNull)
        XCTAssertFalse(uuid8.isNull)
    }
}
