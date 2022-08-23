//
//  TimerExtraTests.swift
//  TimerExtraTests
//
//  Created by carl on 01/08/2022.
//

import XCTest
@testable import TimerExtra

class TimerExtraTests: XCTestCase {
    
    let timersViewModel: TimersViewModel = TimersViewModel()
    let timerInterval1: TimeInterval = 60
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        timersViewModel.newTimer(seconds: timerInterval1)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTimer() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        XCTAssert(timersViewModel.timers.count == 1, "timersViewModel newTimer failed")
        XCTAssertNotNil(timersViewModel.timers.first?.id, "timersViewModel newTimer id failed")
        XCTAssertNotNil(timersViewModel.timers.first?.start, "timersViewModel newTimer start failed")
        XCTAssert(timersViewModel.timers.first?.timeInterval == 60, "timersViewModel newTimer timeInterval failed")
        XCTAssert(timersViewModel.timers.first?.countDownInSeconds() ?? 0 > 0 && timersViewModel.timers.first?.countDownInSeconds() ?? 0 < timerInterval1, "timersViewModel newTimer countDownInSeconds failed")
    }
    
    func testRemoveTimer() throws {
        if let firstTimer = timersViewModel.timers.first {
            let timerUuidString = firstTimer.id.uuidString
            timersViewModel.removeTimer(uuidString: timerUuidString)
            XCTAssert(timersViewModel.timers.count == 0, "timersViewModel removeTimer failed")
        }
    }

    func testPerformance() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            timersViewModel.newTimer(seconds: timerInterval1)
        }
    }

}
