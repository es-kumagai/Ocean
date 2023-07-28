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
    
    func testReceiveNotification() async {

        #if os(macOS)
        let notificationCenter = NSWorkspace.shared.notificationCenter
        #else
        let notificationCenter = NotificationCenter.default
        #endif
        
        let semaphoreA1 = DispatchSemaphore(value: 0)
        let semaphoreA2 = DispatchSemaphore(value: 0)
        let semaphoreB1 = DispatchSemaphore(value: 0)
        let semaphoreB2 = DispatchSemaphore(value: 0)
        let semaphoreB3 = DispatchSemaphore(value: 0)

        func wait(_ semaphore: DispatchSemaphore) -> DispatchTimeoutResult {
        
            return semaphore.wait(timeout: .now() + 0.1)
        }
        
        Notification.A(value: "A1", semaphore: semaphoreA1).post(to: notificationCenter)
        XCTAssertEqual(wait(semaphoreA1), .timedOut)

        let tokenA: Notification.Token = Ocean.observe(Notification.A.self, on: notificationCenter) { notification in

            XCTAssertEqual(notification.value, "A2")
            notification.semaphore.signal()
        }
        
        let _ = tokenA
        
        Notification.A(value: "A2", semaphore: semaphoreA2).post(to: notificationCenter)
        XCTAssertEqual(wait(semaphoreA2), .success)
        
        let tokenB: Notification.Token = Ocean.observe(Notification.B.self, on: notificationCenter) { notification in
            
            XCTAssertEqual(notification.value, "B2")
            notification.semaphore.signal()
        }
        
        XCTAssertEqual(wait(semaphoreB1), .timedOut)
        
        Notification.B(value: "B2", semaphore: semaphoreB2).post(to: notificationCenter)
        XCTAssertEqual(wait(semaphoreB2), .success)
        
        tokenB.release()
        
        Notification.B(value: "B3", semaphore: semaphoreB3).post(to: notificationCenter)
        XCTAssertEqual(wait(semaphoreB3), .timedOut, "Token B was already released.")
    }
}
