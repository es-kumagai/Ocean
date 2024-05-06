//
//  Encoding.swift
//  
//  
//  Created by Tomohiro Kumagai on 2024/05/05
//  
//

import XCTest
@testable import Ocean
import Swim

final class EncodingTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testBase32Encoding() throws {
                
        let text1 = "Hello!"
        let text2 = "EZ-NET"
        let text3 = "API Design Guidelines"

        let data1 = text1.data(using: .utf8)!
        let data2 = text2.data(using: .utf8)!
        let data3 = text3.data(using: .utf8)!
        
        let encodedData1 = Base32.encoding(data1)
        let encodedData2 = Base32.encoding(data2)
        let encodedData3 = Base32.encoding(data3)

        let encodedString1 = String(data: encodedData1, encoding: .ascii)
        let encodedString2 = String(data: encodedData2, encoding: .ascii)
        let encodedString3 = String(data: encodedData3, encoding: .ascii)

        let encodedString4 = data1.base32EncodedString()
        let encodedString5 = data2.base32EncodedString()
        let encodedString6 = data3.base32EncodedString()

        XCTAssertEqual(encodedString1, "JBSWY3DPEE======")
        XCTAssertEqual(encodedString2, "IVNC2TSFKQ======")
        XCTAssertEqual(encodedString3, "IFIESICEMVZWSZ3OEBDXK2LEMVWGS3TFOM======")

        XCTAssertEqual(encodedString1, encodedString4)
        XCTAssertEqual(encodedString2, encodedString5)
        XCTAssertEqual(encodedString3, encodedString6)

        let decodedData1 = Data(base32Encoded: encodedData1)
        let decodedData2 = Data(base32Encoded: encodedData2)
        let decodedData3 = Data(base32Encoded: encodedData3)
        
        XCTAssertEqual(decodedData1, data1)
        XCTAssertEqual(decodedData2, data2)
        XCTAssertEqual(decodedData3, data3)
        
        let decodedText1 = decodedData1.map { String(data: $0, encoding: .utf8) }
        let decodedText2 = decodedData2.map { String(data: $0, encoding: .utf8) }
        let decodedText3 = decodedData3.map { String(data: $0, encoding: .utf8) }
        
        XCTAssertEqual(decodedText1, text1)
        XCTAssertEqual(decodedText2, text2)
        XCTAssertEqual(decodedText3, text3)
    }
    
    func testBase32Coding() throws {
        
        let encodedString1 = "2A6H5LW5GZ5TKO64UKGPT5QTPQNECHBV"
        let encodedString2 = "2A6H5LW5GZ5TKO64UKGPT5QTPQNECHBVOLA4M"

        let decodedData1 = Data(base32Encoded: encodedString1.data(using: .ascii)!)!
        let reEncodedData1 = Base32.encoding(decodedData1)
        let reEncodedString1 = String(data: reEncodedData1, encoding: .ascii)!

        let decodedData2 = Data(base32Encoded: encodedString2.data(using: .ascii)!)!
        let reEncodedData2 = Base32.encoding(decodedData2)
        let reEncodedString2 = String(data: reEncodedData2, encoding: .ascii)!

        XCTAssertEqual("\(encodedString1)", reEncodedString1)
        XCTAssertEqual("\(encodedString2)===", reEncodedString2)
    }
}
