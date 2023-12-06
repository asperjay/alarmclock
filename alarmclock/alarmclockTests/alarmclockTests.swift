//
//  alarmclockTests.swift
//  alarmclockTests
//
//  Created by Jasper Elsley on 8/3/23.
//

import XCTest
@testable import alarmclock

final class alarmclockTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNotificationScheduling() throws {
        let testDate = Date()
        let testTitle = "Test Notification"
        let testBody = "test"
        scheduleNotification(date: testDate, title: testTitle, body: testBody)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
