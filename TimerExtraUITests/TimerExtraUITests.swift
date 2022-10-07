//
//  TimerExtraUITests.swift
//  TimerExtraUITests
//
//  Created by carl on 01/08/2022.
//

import XCTest

class TimerExtraUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWelcomeMessage() {
        XCTAssertTrue(app.staticTexts["Tap buttons below to add time, then tap Start"].exists)
    }

    func testTimerReset() {
        // Test with tapping 5s first
        let fiveSecondButton = app.buttons["+ 5s"]
        let tenSecondsButton = app.buttons["+ 10s"]
        
        let startButton = app.buttons["00:10    Start"]
        let resetButton = app.buttons["Reset"]
        
        // then reset
        fiveSecondButton.tap()
        resetButton.tap()
        
        // then tapping 10s and start
        tenSecondsButton.tap()
        startButton.tap()
        
        let message = app.staticTexts["00:10"]
        XCTAssertTrue(message.waitForExistence(timeout: 0.1))
        
        let message2 = app.staticTexts["00:05"]
        XCTAssertTrue(message2.waitForExistence(timeout: 4.99))
        
        let message3 = app.staticTexts["00:00"]
        XCTAssertTrue(message3.waitForExistence(timeout: 9.99))
    }
    
    func testTimer1Sec() {
        let oneSecondButton = app.buttons["+ 1 sec"]
        let startButton = app.buttons["00:01    Start"]
        oneSecondButton.tap()
        startButton.tap()
        
        let message = app.staticTexts["00:01"]
        XCTAssertTrue(message.waitForExistence(timeout: 0.1))
        
        let message2 = app.staticTexts["00:00"]
        XCTAssertTrue(message2.waitForExistence(timeout: 0.9))
    }
    
    func testTimer5Sec() {
        let fiveSecondButton = app.buttons["+ 5s"]
        let startButton = app.buttons["00:05    Start"]
        fiveSecondButton.tap()
        startButton.tap()
        
        let message = app.staticTexts["00:05"]
        XCTAssertTrue(message.waitForExistence(timeout: 0.1))
        
        let message2 = app.staticTexts["00:00"]
        XCTAssertTrue(message2.waitForExistence(timeout: 4.99))
    }
    
    func testTimer10Sec() {
        let tenSecondsButton = app.buttons["+ 10s"]
        let startButton = app.buttons["00:10    Start"]
        tenSecondsButton.tap()
        startButton.tap()
        
        let message = app.staticTexts["00:10"]
        XCTAssertTrue(message.waitForExistence(timeout: 0.1))
        
        let message2 = app.staticTexts["00:00"]
        XCTAssertTrue(message2.waitForExistence(timeout: 9.99))
    }
    
    func testTimer30Sec() {
        let thirtySecondsButton = app.buttons["+ 30s"]
        let startButton = app.buttons["00:30    Start"]
        thirtySecondsButton.tap()
        startButton.tap()
        
        let message = app.staticTexts["00:30"]
        XCTAssertTrue(message.waitForExistence(timeout: 0.1))
        
        let message2 = app.staticTexts["00:00"]
        XCTAssertTrue(message2.waitForExistence(timeout: 29.99))
    }
    
    func testTimer1min() {
        let oneMinButton = app.buttons["+ 1 minute"]
        let startButton = app.buttons["01:00    Start"]
        oneMinButton.tap()
        startButton.tap()
        
        let message = app.staticTexts["01:00"]
        XCTAssertTrue(message.waitForExistence(timeout: 0.1))
        
        let message2 = app.staticTexts["00:00"]
        XCTAssertTrue(message2.waitForExistence(timeout: 59.99))
    }
    
    func testTimer5mins() {
        let fiveMinsButton = app.buttons["+ 5 mins"]
        let startButton = app.buttons["05:00    Start"]
        fiveMinsButton.tap()
        startButton.tap()
        
        let message = app.staticTexts["05:00"]
        XCTAssertTrue(message.waitForExistence(timeout: 0.1))
        
        let message2 = app.staticTexts["00:00"]
        XCTAssertTrue(message2.waitForExistence(timeout: (60 * 5) - 0.01))
    }
    
    func testTimer10mins() {
        let tenMinsButton = app.buttons["+ 10 mins"]
        let startButton = app.buttons["10:00    Start"]
        tenMinsButton.tap()
        startButton.tap()
//
//        let message = app.staticTexts["10:00"]
//        XCTAssertTrue(message.waitForExistence(timeout: 0.1))
//
//        let message2 = app.staticTexts["00:00"]
//        XCTAssertTrue(message2.waitForExistence(timeout: 60 * 10))
    }
    
    func testTimer30mins() {
        let thirtyMinsButton = app.buttons["+ 30 mins"]
        let startButton = app.buttons["30:00    Start"]
        thirtyMinsButton.tap()
        startButton.tap()
        
        let message = app.staticTexts["30:00"]
        XCTAssertTrue(message.waitForExistence(timeout: 0.1))
        
        // consider timer test success after 10 mins of counting down
        let message2 = app.staticTexts["20:00"]
        XCTAssertTrue(message2.waitForExistence(timeout: (60 * 10) - 0.01))
    }
    
    func testTimerRemove() {
        // test with 2 timers , 5s and 10 mins
        let fiveSecondButton = app.buttons["+ 5s"]
        let startButton = app.buttons["00:05    Start"]
        fiveSecondButton.tap()
        startButton.tap()
        
        let tenMinsButton = app.buttons["+ 10 mins"]
        let startButton2 = app.buttons["10:00    Start"]
        tenMinsButton.tap()
        startButton2.tap()
        
        // find the first cell, swipe and tap delete (delete 10 mins timer)
        
        let firstCell = app.cells.firstMatch
        firstCell.swipeLeft()
        
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 0.1))
        deleteButton.tap()
        
        // only 5s timers remain and count down to 00:00
        let message = app.staticTexts["09:"]
        XCTAssertTrue(!message.waitForExistence(timeout: 0.1))
        let message2 = app.staticTexts["00:00"]
        XCTAssertTrue(message2.waitForExistence(timeout: 3))
    }
}
