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
    
    let userName = "Sam10 Mikhail"
    let userEmail = "samxx2@gmail.com"
    let userPassword = "pwd123"
    let userData = [
        "phone" : "6302460328",
        "carrier" : "Sprint",
        "model" : "iPhone8P",
        "sn" : "1234567890"
    ]
    
    var usr : GentsUser?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let testName = self.testRun?.test.name
        
        print(testName)
        
        if testName == "-[GentTests testMakePayment]" || testName == "-[GentTests testGetPaymentsList]" || testName == "-[GentTests testFirebaseOfflineSupport]" {
            let exp =  self.expectation(description: "user login")
            GentsUser.shared.loginUser(withEmail: userEmail, password: userPassword, completion: { [weak self] (usr) in
                
                self?.usr = usr
                exp.fulfill()
            })
            
            self.waitForExpectations(timeout: 30) { (err) in
                print(err)
            }
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRegisterUser() {
        let exp = expectation(description: "register")
        
        GentsUser.shared.registerUser(withName: userName, email: userEmail, password: userPassword, userData: userData) { isOK in
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
        
        GentsUser.shared.registerUser(withName: userName, email: userEmail, password: userPassword, userData: userData) { isOK in
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
        
        GentsUser.shared.loginUser(withEmail: userEmail, password: userPassword) { (user) in
            print("login user = \(String(describing: user))")
            if user == nil {
                XCTAssert(false)
            }
            print("user result =")
            print(user!)
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
        //user payment method should be created first
        let exp = self.expectation(description: "make payment")
        
        let host = UIApplication.shared.keyWindow?.rootViewController
        self.usr?.pay(amount: 500, description: "UT", host: host, completion: { (err) in
            
            if err != nil {
                XCTAssert(false)
            }
            exp.fulfill()
        })
        
        self.waitForExpectations(timeout: 40) { (err) in
            if err != nil {
                print("testMakePayment - failed =>")
                print(err as Any)
                XCTAssert(false)
            }
        }
    }
    
    func testGetPaymentsList() {
        
        let exp = self.expectation(description: "get payment")
        
        let query = self.usr?.getPayments()
        
        if query == nil {
            XCTAssert(false)
        }
        
        query?.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.childrenCount == 0 {
                XCTAssert(false)
                return
            }
            
            for charge in snapshot.children.reversed() {
                print(charge)
            }
            
            exp.fulfill()
        })
        
        self.waitForExpectations(timeout: 30) { (err) in
            if err != nil {
                print("testGetPaymentsList - failed =>")
                print(err as Any)
                XCTAssert(false)
            }
        }
    }
    
    func testFirebaseOfflineSupport() {
        
        //turn wifi off first, can use "Network Link Conditioner"
        
        let exp = self.expectation(description: "get payment")
        
        let paymentsQuery = usr?.getPayments()
        
        paymentsQuery?.observeSingleEvent(of: .value, with: { (snap) in
 
            if snap.value == nil {
                print("testFirebaseOfflineSupport - failed =>")
                XCTAssert(false)
            }
            
            print(snap)
            exp.fulfill()
        })
        
        self.waitForExpectations(timeout: 30) { (err) in
            if err != nil {
                print("testFirebaseOfflineSupport - failed =>")
                print(err as Any)
                XCTAssert(false)
            }
        }
    }
    
    func testGetGentsConfig() {
        
        let exp = self.expectation(description: "get payment")
        
        GentsConfig.shared.update { isOK in
            
            if !isOK {
                print("testGetGentsConfig - failed =>")
                XCTAssert(false)
            }
            
            exp.fulfill()
        }
        
        self.waitForExpectations(timeout: 30) { (err) in
            if err != nil {
                print("testGetGentsConfig - failed =>")
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
