//
//  OceanTests.swift
//  OceanTests
//
//  Created by Tomohiro Kumagai on 12/18/17.
//

import XCTest
@testable import Ocean

extension Notification {
    
    struct A : NotificationProtocol {
        
        var value: String
        var semaphore: DispatchSemaphore
    }
    
    struct B : NotificationProtocol {
        
        var value: String
        var semaphore: DispatchSemaphore
    }
}

class OceanTests: XCTestCase {
    

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReceiveNotification() {

        let semaphoreA1 = DispatchSemaphore(value: 0)
        let semaphoreA2 = DispatchSemaphore(value: 0)
        let semaphoreB1 = DispatchSemaphore(value: 0)
        let semaphoreB2 = DispatchSemaphore(value: 0)
        let semaphoreB3 = DispatchSemaphore(value: 0)

        func wait(_ semaphore: DispatchSemaphore) -> DispatchTimeoutResult {
        
            return semaphore.wait(timeout: .now() + 0.1)
        }
        
        Notification.A(value: "A1", semaphore: semaphoreA1).post()
        XCTAssertEqual(wait(semaphoreA1), .timedOut)

        var tokenA: Notification.Token = Ocean.observe(Notification.A.self) { notification in

            XCTAssertEqual(notification.value, "A2")
            notification.semaphore.signal()
        }
        
        Notification.A(value: "A2", semaphore: semaphoreA2).post()
        XCTAssertEqual(wait(semaphoreA2), .success)
        
        var tokenB: Notification.Token = Ocean.observe(Notification.B.self) { notification in
            
            XCTAssertEqual(notification.value, "B2")
            notification.semaphore.signal()
        }
        
        XCTAssertEqual(wait(semaphoreB1), .timedOut)
        
        Notification.B(value: "B2", semaphore: semaphoreB2).post()
        XCTAssertEqual(wait(semaphoreB2), .success)
        
        tokenB.release()

        Notification.B(value: "B3", semaphore: semaphoreB3).post()
        XCTAssertEqual(wait(semaphoreB3), .timedOut, "Token B was already released.")
    }
}
