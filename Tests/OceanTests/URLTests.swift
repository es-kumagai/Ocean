//
//  URLTests.swift
//  
//  
//  Created by Tomohiro Kumagai on 2024/01/08
//  
//

import XCTest
@testable import Ocean

final class URLTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExpandEnvironmentVariables() throws {

        let environment = ProcessInfo.processInfo.environment

        let url1 = URL(fileURLWithPath: "$HOME/Downloads")
        let url2 = URL(fileURLWithPath: "$HOMET/Downloads")
        let url3 = URL(fileURLWithPath: "${HOME}T/Downloads")
        let url4 = URL(fileURLWithPath: "${HOMET}/Downloads")

        XCTAssertEqual(url1.expandedEnvironmentVariables?.path(percentEncoded: false), "\(environment["HOME"] ?? "")/Downloads")
        XCTAssertEqual(url2.expandedEnvironmentVariables?.path(percentEncoded: false), "$HOMET/Downloads")
        XCTAssertEqual(url3.expandedEnvironmentVariables?.path(percentEncoded: false), "\(environment["HOME"] ?? "")T/Downloads")
        XCTAssertEqual(url4.expandedEnvironmentVariables?.path(percentEncoded: false), "${HOMET}/Downloads")
    }
}
