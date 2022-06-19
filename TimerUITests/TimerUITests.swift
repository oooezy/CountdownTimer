//
//  TimerUITests.swift
//  TimerUITests
//
//  Created by 이은지 on 2022/06/19.
//

import XCTest

class TimerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func test_countdownTimer() {
        // XCUIApplication
        let app = XCUIApplication()

        // XCUIElement
        let startButton = app.buttons.matching(identifier: "startButton").element
        startButton.tap()

        let alarmbuttonButton = app.buttons["alarmButton"]
        alarmbuttonButton.tap()

        let button = app.alerts["알림"].scrollViews.otherElements.buttons["확인"]
        button.tap()
        alarmbuttonButton.tap()
        button.tap()

        let resetbuttonButton = app.buttons["resetButton"]
        resetbuttonButton.tap()
        let stopButton = app.buttons.matching(identifier: "stopButton").element
        stopButton.tap()
        resetbuttonButton.tap()
        app.buttons["타이머 시작"].tap()
        app.navigationBars["타이머"].buttons["Back"].tap()
                        
    }
}
