//
//  iJamGuitarUITests.swift
//  iJamGuitarUITests
//
//  Created by Ron Jurincie on 3/2/24.
//

import OSLog
import XCTest

final class iJamGuitarUITests: XCTestCase {
    var app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app.launch()
        
        // set things like interface orientation - required for your tests.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // When
        let addButton = app.buttons["Add"]
       
        // Then
        XCTAssert(addButton.exists)
        addButton.tap()
        
        // When
        let cancelButton = app.buttons["CANCEL"]
        
         // Then
        XCTAssert(cancelButton.exists)
        cancelButton.tap()
    
        XCTAssert(addButton.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
