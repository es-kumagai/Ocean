import XCTest
@testable import Ocean

class OceanTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Ocean().text, "Hello, World!")
    }


    static var allTests : [(String, (OceanTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
