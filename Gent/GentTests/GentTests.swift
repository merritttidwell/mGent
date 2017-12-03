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
    
    let userName = "Sam2"
    let userEmail = "sam2@gmail.com"
    let userPassword = "Sam1234"
    let userData = [
        "phone" : "6302460328",
        "carrier" : "Sprint",
        "model" : "iPhone8P",
        "sn" : "1234567890"
    ]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRegisterUser() {
        let exp = expectation(description: "register")
        
        User.registerUser(withName: userName, email: userEmail, password: userPassword, userData: userData) { isOK in
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
    
    //negative test, should be successful, if re-register existing user failed
    func testReRegisterUser() {
        let exp = expectation(description: "register")
        
        User.registerUser(withName: userName, email: userEmail, password: userPassword, userData: userData) { isOK in
            print("Register User = \(isOK)")
            if isOK == true {
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
        
        User.loginUser(withEmail: userEmail, password: userPassword) { (user) in
            print("login user = \(String(describing: user))")
            if user == nil {
                XCTAssert(false)
            }
            exp.fulfill()
        }
        
        self.waitForExpectations(timeout: 30) { (err) in
            if err != nil {
                print("testLoginUser - failed =>")
                print(err as Any)
                XCTAssert(false)
            }
        }
    }
    
    func testMakePayment() {
        let exp1 = self.expectation(description: "make payment")
        var usr : User?
        
        User.loginUser(withEmail: userEmail, password: userPassword) { (user) in
            print("login user = \(String(describing: user))")
            if user == nil {
                XCTAssert(false)
            }
            usr = user
            exp1.fulfill()
        }
        
        self.waitForExpectations(timeout: 30) { (err) in
            if err != nil {
                print("testMakePayment - failed =>")
                print(err as Any)
                XCTAssert(false)
            }
        }
        
        //make payment
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StripeTest")
        let _ = vc.view
        
        let exp2 = self.expectation(description: "make payment")
        
        usr?.pay(amount: 500, description: "TT", host: vc, completion: { (err) in
            if err != nil {
                print("testMakePayment - failed =>")
                print(err as Any)
                XCTAssert(false)
            }
            
            exp2.fulfill()
        })
        
        self.waitForExpectations(timeout: 30) { (err) in
            if err != nil {
                print("testMakePayment - failed =>")
                print(err as Any)
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
