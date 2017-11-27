//
//  GentTests.swift
//  GentTests
//
//  Created by christina schell on 9/25/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import XCTest
@testable import Gent

class GentTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRegisterUser() {
        let data = ["phone" : "6302460328", "carrier" : "Sprint", "email" : "usama.cpp@gmail.com", "model" : "iPhone8P", "name" : "Sam", "sn" : "1234567890"]
        
        let exp = expectation(description: "register")
        
        User.registerUser(withName: "Sam", email: "usama.cpp@gmail.com", password: "sam123", userData: data) { isOK in
            print("Register User = \(isOK)")
            if isOK == false {
                XCTAssert(false)
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (err) in
            
            if err != nil {
                print("testRegisterUser - failed =>")
                print(err)
                XCTAssert(false)
            }
        }
    }
    
    func testLoginUser() {
        let exp = self.expectation(description: "login")
        
        User.loginUser(withEmail: "usama.cpp@gmail.com", password: "sam123") { (user) in
            print("login user = \(String(describing: user))")
            if user == nil {
                XCTAssert(false)
            }
            exp.fulfill()
        }
        
        self.waitForExpectations(timeout: 30) { (err) in
            if err != nil {
                print("testLoginUser - failed =>")
                print(err)
                XCTAssert(false)
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
