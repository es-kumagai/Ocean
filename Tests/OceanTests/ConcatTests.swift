//
//  ConcatTests.swift
//  OceanTests
//
//  Created by Tomohiro Kumagai on 2021/02/14.
//

import XCTest
@testable import Ocean

class ConcatTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConcatenateData() throws {

        let data1 = "A".data(using: .utf8)!
        let data2 = "B".data(using: .utf8)!
        let data3 = "C".data(using: .utf8)!
        let strings = ["D", "E", "F"]

        let multipleData = [data1, data2, data3]
        
        let condition = 0
        
        let test0 = Data.concat {
            
        }
        
        let test1 = Data.concat {
            
            data1
            data2
        }

        let test2 = Data.concat {

            data1

            if condition == 0 {
            
                data3
            }
            
            data2
        }

        let test3 = Data.concat {

            data1

            switch condition {

            case 0:
                data3

            default:
                nil as Data?
            }

            data2
        }
        
        let test4 = Data.concat {
            
            data1
            data2
            multipleData
        }
        
        let test5 = Data.concat {
            
            data1
            data2
            
            for string in strings {
                
                string.data(using: .utf8)
            }
            
            data3
        }
        
        let test6 = Data.concat {
            
            data1
            
            if condition == 0 {
                
                data2
            }
            
            data3
        }

        let test7 = Data.concat {
            
            data1
            
            if condition != 0 {
                
                data2
            }
            
            data3
        }
        
        let test8 = Data.concat {
            
            data1
            data2
            data3
            DataConcatProcess.dropLast()
        }

        let test9 = Data.concat {
            
            data1
            data2
            data3
            DataConcatProcess.dropLast()
            DataConcatProcess.dropLast()
        }

        let test10 = Data.concat {
            
            data1
            data2
            DataConcatProcess.dropLast()
            data3
        }
        
        let test11 = Data.concat {
            
            data1
            DataConcatProcess.repeating(data2, count: 5)
            data3
        }

        let test12 = Data.concat {
            
            data1
            nil as Data?
            data3
        }
        
        let test13 = Data.concat {
            
        }

        XCTAssertEqual(test0, Data())
        XCTAssertEqual(test1, "AB".data(using: .utf8))
        XCTAssertEqual(test2, "ACB".data(using: .utf8))
        XCTAssertEqual(test3, "ACB".data(using: .utf8))
        XCTAssertEqual(test4, "ABABC".data(using: .utf8))
        XCTAssertEqual(test5, "ABDEFC".data(using: .utf8))
        XCTAssertEqual(test6, "ABC".data(using: .utf8))
        XCTAssertEqual(test7, "AC".data(using: .utf8))
        XCTAssertEqual(test8, "AB".data(using: .utf8))
        XCTAssertEqual(test9, "A".data(using: .utf8))
        XCTAssertEqual(test10, "AC".data(using: .utf8))
        XCTAssertEqual(test11, "ABBBBBC".data(using: .utf8))
        XCTAssertEqual(test12, "AC".data(using: .utf8))
        XCTAssertEqual(test13, "".data(using: .utf8))
    }
}
