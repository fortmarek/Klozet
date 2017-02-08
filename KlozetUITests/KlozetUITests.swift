//
//  KlozetUITests.swift
//  KlozetUITests
//
//  Created by Marek Fořt on 13/08/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import XCTest
import MapKit

class KlozetUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        XCUIDevice.shared().orientation = .portrait
        XCUIDevice.shared().orientation = .portrait
        
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func tesdS() {
        
        let app = XCUIApplication()
        
        
        
        
        
        let annotation = app.otherElements["Divadelní 2-10"]
        annotation.tap()
        
    }
    
    func testSnaps() {
        
        let app = XCUIApplication()
        
        
    
        let predicate = NSPredicate(format: "exists == 1")

        let query = app.otherElements["My Location"]
        //let query = app.otherElements["Moje poloha"]
        
        expectation(for: predicate, evaluatedWith: query, handler: nil)
        waitForExpectations(timeout: 30, handler: nil)
        
        let annotation = app.otherElements["U Radnice 10/2, Restaurant Kotleta"]
        annotation.tap()
        
        snapshot("main-screen")
        
        app.navigationBars["Klozet"].buttons["List"].tap()
        //app.navigationBars["Klozet"].buttons["Seznam"].tap()
        
        snapshot("list")
        
        _ = self.expectation(
            for: NSPredicate(format: "self.count = 1"),
            evaluatedWith: XCUIApplication().tables,
            handler: nil)
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
        let cells = XCUIApplication().tables.cells
        cells.element(boundBy: 4).tap()
        
        _ = self.expectation(
            for: NSPredicate(format: "self.count = 1"),
            evaluatedWith: XCUIApplication().tables,
            handler: nil)
        self.waitForExpectations(timeout: 5.0, handler: nil)
        
        let detailCells = app.tables.cells
        detailCells.element(boundBy: 1).press(forDuration: 5)
        
        snapshot("detail")
    }
    
}
