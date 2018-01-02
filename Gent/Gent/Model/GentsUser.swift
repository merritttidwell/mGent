//
//  User.swift
//  Gent
//
//  Created by Merritt Tidwell on 10/21/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Stripe
import Alamofire
import SwiftyJSON

typealias completionSuccess = (_ isSuccessful: Bool) -> (Void)

class GentsUser: NSObject {
    
    //MARK: Shared user
    static let shared = GentsUser()
    
    //MARK: Properties
    private var firebaseUser : User? = Auth.auth().currentUser
    
    private(set) var name: String = ""
    private(set) var email: String = ""
    private(set) var carrier: String = ""
    private(set) var model: String = ""
    private(set) var phone: String = ""
    private(set) var sn: String = ""
    private(set) var strpCustomerID = ""
    private(set) var payments : JSON?
    
    //more props
    var customerCtx : STPCustomerContext? = nil
    //var payCtx : STPPaymentContext?
    
    var payp = [payProcess]()
    
    class payProcess : NSObject, STPPaymentContextDelegate {
        
        let amount : Int
        let desc : String
        let payCompletion : STPErrorBlock?
        private(set) var isFulfilled = false
        let payCtx : STPPaymentContext
        let cusCtx : STPCustomerContext
        
        init(amount: Int, desc: String, customerContext: STPCustomerContext, payCompletion: STPErrorBlock?) {
            self.amount = amount
            self.desc = desc
            self.payCompletion = payCompletion
            
            self.cusCtx = customerContext
            payCtx = STPPaymentContext(customerContext: cusCtx)
            //payCtx = STPPaymentContext(customerContext: cusCtx, configuration: payProcess.getConfig(), theme: STPTheme.default())
            
            super.init()
            payCtx.delegate = self
            payCtx.paymentAmount = amount
            payCtx.paymentCurrency = "USD"
        }
        
        class func getConfig() -> STPPaymentConfiguration {
            
            let config = STPPaymentConfiguration.shared()
            
            config.publishableKey = StripeAPIData.publishableKey
            config.appleMerchantIdentifier = nil
            config.companyName = "The Mobile Gents"
            config.requiredBillingAddressFields = STPBillingAddressFields.full
            config.requiredShippingAddressFields = PKAddressField.all
            config.shippingType = STPShippingType.shipping
            config.additionalPaymentMethods = .all
            
            return config
            
        }
        
        func pay() {
            
            /*cusCtx.retrieveCustomer({ [weak self] (cus, err) in
                if cus?.defaultSource != nil {
                    self?.payCtx.requestPayment()
                } else {
                    self?.payCtx.presentPaymentMethodsViewController()
                }
            })*/
            
            payCtx.requestPayment()
        }
        
        //MARK: -STPPaymentContextDelegateDelegate
        func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
            print("didFailToLoadWithError")
            print(error)
            
            payCompletion?(error)
        }
        
        func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
            print("paymentContextDidChange")
            //print(paymentContext)
        }
        
        func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
            print("didCreatePaymentResult")
            //print(paymentResult.source.stripeID)
            //print(paymentContext.selectedPaymentMethod)
            
            StripeAPIClient.sharedClient.completeCharge(paymentResult, amount: paymentContext.paymentAmount, description: desc, shippingAddress: nil, shippingMethod: nil) { [unowned self] (json, err) in
                
                let ref = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("payments")
                
                ref.keepSynced(true)
                ref.childByAutoId().updateChildValues(json!)
                ref.keepSynced(false)
                
                completion(err)
                self.payCompletion?(err)
            }
        }
        
        func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
            print("didFinish")
            //print(status)
            
            self.isFulfilled = true
        }
    }
    
    func registerUser(withName: String, email: String, password: String, userData:[String:String], completion: @escaping completionSuccess) {
        
        var userData = userData
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error ?? "unknown error")
                completion(false)
                return
            }
            
            guard let uuid = user?.uid else {return}
            
            StripeAPIClient.sharedClient.createStripeCustomer(email: email) { resp, err in
                
                guard err == nil else {
                    completion(false)
                    return
                }
                
                // Create database reference
                var ref: DatabaseReference!
                ref = Database.database().reference()
                
                // Create users reference
                let usersRef = ref.child("users").child(uuid)
                userData["strp_customer_id"] = resp?["id"] as? String
                userData["email"] = email
                userData["name"] = withName
                usersRef.keepSynced(true)
                usersRef.updateChildValues(userData, withCompletionBlock: { [weak usersRef] (err, ref) in
                    if err == nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                    usersRef?.keepSynced(false)
                })
            }
        }
    }
    
    func loginUser(withEmail: String, password: String, completion: @escaping (_ user: GentsUser?) -> Swift.Void) {
        
        func doLogin() {
            Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
                if error == nil {
                    //let userInfo = ["email": withEmail, "password": password]
                    //UserDefaults.standard.set(userInfo, forKey: "userInformation")
                    
                    self.firebaseUser = Auth.auth().currentUser
                    self.reloadUserData(completion: { (isOK) in
                        if isOK {
                            completion(self)
                        } else {
                            completion(nil)
                        }
                    })
                } else {
                    self.firebaseUser = nil
                    completion(nil)
                }
            })
        }
        
        
        if firebaseUser != nil {
            if firebaseUser?.email == withEmail {
                self.reloadUserData(completion: { (isOK) in
                    if isOK {
                        completion(self)
                    } else {
                        completion(nil)
                    }
                })
            } else {
                self.logOutUser(completion: { (isOK) in
                    if !isOK {
                        completion(nil)
                        return
                    }
                    doLogin()
                })
            }
        } else {
            doLogin()
        }
    }
    
    func logOutUser(completion: @escaping (Bool) -> Swift.Void) {
        do {
            try Auth.auth().signOut()
            //UserDefaults.standard.removeObject(forKey: "userInformation")
            customerCtx?.clearCachedCustomer()
            completion(true)
        } catch _ {
            completion(false)
        }
    }
    
    func checkUserVerification(completion: @escaping (Bool) -> Swift.Void) {
        firebaseUser?.reload(completion: { (_) in
            let status = (self.firebaseUser?.isEmailVerified)!
            completion(status)
        })
    }
    
    func delete() {
        firebaseUser?.delete(completion: { (err) in
            print(err ?? "n/a")
        })
    }
    
    /*init(name: String, email: String, sn: String, stripeID: String) {
        self.firebaseUser = nil
        self.name = name
        self.email = email
        self.strpCustomerID = stripeID
        
        if strpCustomerID != "" {
            StripeAPIClient.sharedClient.cusID = strpCustomerID
            customerCtx = STPCustomerContext(keyProvider: StripeAPIClient.sharedClient)
        }
    }*/
    
    func reloadUserData(completion: @escaping (_ completedSuccessfully: Bool) -> (Swift.Void)) {
        Database.database().reference().child("users").child((firebaseUser?.uid)!).observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? NSDictionary
            
            guard value != nil else {
                completion(false)
                return
            }
            
            let name = value!["name"] as! String
            let email = value!["email"] as! String
            let carrier = value!["carrier"] as! String
            let model = value!["model"] as! String
            let phone = value!["phone"] as! String
            let sn = value!["sn"] as! String
            let strpID = value!["strp_customer_id"] as! String
            let paymentsRaw = value!["payments"] as Any?
            
            guard paymentsRaw != nil else {
                completion(false)
                return
            }
            
            self.name = name
            self.email = email
            self.carrier = carrier
            self.model = model
            self.phone = phone
            self.sn = sn
            
            self.strpCustomerID = strpID
            self.payments = JSON.init(rawValue: paymentsRaw!)
            
            completion(true)
        }
    }
    
    func pay(amount: Int, description: String, host: UIViewController? = nil, completion: STPErrorBlock? = nil) {
        guard customerCtx != nil else {
            print("customer context n/a")
            return
        }
        
        payp = payp.filter { if !$0.isFulfilled { return true }; return false }
        
        let pp = payProcess(amount: amount, desc: description, customerContext: customerCtx!, payCompletion: completion)
        pp.payCtx.hostViewController = host
        payp.append(pp)
        
        pp.pay()
    }
    
    func getPayments() -> DatabaseQuery? {
        
        guard firebaseUser != nil else {
            return nil
        }
        
        //Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("payments").keepSynced(true)
        
        return Database.database().reference().child("users").child(firebaseUser!.uid).child("payments").queryOrdered(byChild: "created")
    }
    
    //MARK: - DB connection listener
    
    static func connectionDetect() {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                print("Connected")
            } else {
                print("Not connected")
            }
        })
    }
    
    //MARK: - Nothing

    //    class func downloadAllUsers(exceptID: String, completion: @escaping (User) -> Swift.Void) {
    //        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
    //            let id = snapshot.key
    //            let data = snapshot.value as! [String: Any]
    //            let credentials = data["credentials"] as! [String: String]
    //            if id != exceptID {
    //                let name = credentials["name"]!
    //                let email = credentials["email"]!
    //                let link = URL.init(string: credentials["profilePicLink"]!)
    //                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
    //                    if error == nil {
    //                        let profilePic = UIImage.init(data: data!)
    //                        let user = User.init(name: name, email: email, id: id, profilePic: profilePic!)
    //                        completion(user)
    //                    }
    //                }).resume()
    //            }
    //        })
    //    }

    /*class func info(forUserID: String, completion: @escaping (GentsUser) -> Swift.Void) {
     Database.database().reference().child("users").child(forUserID).child("credentials").observeSingleEvent(of: .value, with: { (snapshot) in
     if let data = snapshot.value as? [String: String] {
     let name = data["name"]!
     let email = data["email"]!
     let strpID = data["strp_customer_id"]!
     let link = URL.init(string: data["profilePicLink"]!)
     URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
     if error == nil {
     let user = GentsUser.init(name: name, email: email, sn: forUserID, stripeID: strpID)
     completion(user)
     }
     }).resume()
     }
     })
     }*/
}
