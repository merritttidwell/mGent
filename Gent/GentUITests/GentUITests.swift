//
//  GentUITests.swift
//  GentUITests
//
//  Created by christina schell on 9/25/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import XCTest

class GentUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
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
    
    /*func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }*/

    func testSignup() {
        XCUIApplication().buttons["Sign up to MVP"].tap()
        
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        let textField = elementsQuery.children(matching: .textField).element(boundBy: 0)
        textField.tap()
        textField.typeText("Ossama")
        
        let textField2 = elementsQuery.children(matching: .textField).element(boundBy: 1)
        textField2.tap()
        textField2.tap()
        textField2.typeText("Mikhail")
        
        let textField3 = elementsQuery.children(matching: .textField).element(boundBy: 2)
        textField3.tap()
        textField3.tap()
        textField3.typeText("sam@gmail.com")
        
        let textField4 = elementsQuery.children(matching: .textField).element(boundBy: 3)
        textField4.tap()
        textField4.tap()
        textField4.typeText("Sam1234")
        
        let textField5 = elementsQuery.children(matching: .textField).element(boundBy: 4)
        textField5.tap()
        textField5.tap()
        textField5.typeText("Sam1234")
        
        let textField6 = elementsQuery.children(matching: .textField).element(boundBy: 5)
        textField6.tap()
        textField6.tap()
        textField6.typeText("6302460328")
        textField6.swipeUp()
        
        let textField7 = elementsQuery.children(matching: .textField).element(boundBy: 6)
        textField7.tap()
        textField7.tap()
        textField7.typeText("11223344")
        elementsQuery.buttons["Sign up"].tap()
    }
    
    func testSignupWrongPassword() {
        XCUIApplication().buttons["Sign up to MVP"].tap()
        
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        let textField = elementsQuery.children(matching: .textField).element(boundBy: 0)
        textField.tap()
        textField.typeText("Ossama")
        
        let textField2 = elementsQuery.children(matching: .textField).element(boundBy: 1)
        textField2.tap()
        textField2.tap()
        textField2.typeText("Mikhail")
        
        let textField3 = elementsQuery.children(matching: .textField).element(boundBy: 2)
        textField3.tap()
        textField3.tap()
        textField3.typeText("sam@gmail.com")
        
        let textField4 = elementsQuery.children(matching: .textField).element(boundBy: 3)
        textField4.tap()
        textField4.tap()
        textField4.typeText("Sam1234")
        
        let textField5 = elementsQuery.children(matching: .textField).element(boundBy: 4)
        textField5.tap()
        textField5.tap()
        textField5.typeText("Sam12345")
        
        let textField6 = elementsQuery.children(matching: .textField).element(boundBy: 5)
        textField6.tap()
        textField6.tap()
        textField6.typeText("6302460328")
        textField6.swipeUp()
        
        let textField7 = elementsQuery.children(matching: .textField).element(boundBy: 6)
        textField7.tap()
        textField7.tap()
        textField7.typeText("11223344")
        elementsQuery.buttons["Sign up"].tap()
    }
}
