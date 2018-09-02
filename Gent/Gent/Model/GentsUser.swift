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

typealias completionSuccess = ((_ isSuccessful: Bool, Error?) -> (Swift.Void))

class GentsUser: NSObject {
    
    //MARK: Shared user
    static let shared = GentsUser()
    
    //MARK: Properties
    //private(set) var firebaseUser : User? = firebaseGentsAuth()?.currentUser
    
    private(set) var name: String = ""
    private(set) var email: String = ""
    private(set) var carrier: String = ""
    private(set) var devices: NSMutableArray = []
    private(set) var model: String = ""
    private(set) var phone: String = ""
    private(set) var sn: String = ""
    private(set) var strpCustomerID = ""
    private(set) var mainSubscriptionID = ""
    private(set) var repairCredit = ""
    private(set) var payments : JSON?
    
    //more props
    var customerCtx : STPCustomerContext? = nil
    //var payCtx : STPPaymentContext?
    
    //MARK: - payProcess
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
         //   config.requiredShippingAddressFields = STPContactField.all
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
                
                let ref = firebaseGentsDataBase()?.reference().child("users").child((firebaseGentsAuth()?.currentUser?.uid)!).child("payments")
                
                ref?.childByAutoId().updateChildValues(json!)
                
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
    
    //MARK: - DB connection
    class func firebaseGentsApp() -> FIRApp? {
        
        var app = FIRApp(named: "gentsApp")
        
        if app == nil {
            
            let options = FIROptions.init(contentsOfFile: Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!)
            
            // Configure an alternative FIRApp.
            FIRApp.configure(withName: "gentsApp", options: options!)
            
            // Retrieve a previous created named app.
            app = FIRApp(named: "gentsApp")
            guard app != nil else { assert(false, "Could not retrieve gentsApp"); return nil}
        }
        
        return app
    }
    class func firebaseGentsDataBase() -> FIRDatabase? {
        
        /*guard let app = firebaseGentsApp() else {
            return nil
        }
        
        return Database.database(app: app)*/
        
        return FIRDatabase.database()
    }
    
    class func firebaseGentsAuth() -> FIRAuth? {
        
        /*guard let app = firebaseGentsApp() else {
            return nil
        }
        
        return Auth.auth(app: app)*/
        
        return FIRAuth.auth()
    }
    
    //MARK: - Add A Device
    
    func addDevice( device: Device, initCharge: Int, completion: @escaping completionSuccess ) {
        
        if GentsUser.firebaseGentsAuth()?.currentUser == nil {
            return
        }
       
        
        StripeAPIClient.sharedClient.addSubscription(stripeCutomerId: self.strpCustomerID, initCharge: initCharge  ) { (resp, err) in
            if err == nil {
                let id = resp?["id"] as! String
                device.deviceDictionary["subscriptionId"] = id
                self.updateDatabaseDevice(device: device, completion: { (isOk, err) -> (Void) in
                    if isOk {
                        
                        completion(true, nil)
                    }
                })
                
            }else{
                completion(false, err)
                return
            }
            
        }
        
    }
    
    
    func listInvoicesForSubscription(subscriptionID: String,completion: @escaping STPJSONResponseCompletionBlock ) {
        
        if GentsUser.firebaseGentsAuth()?.currentUser == nil {
            return
        }
        
        StripeAPIClient.sharedClient.listInvoicesSubscription(subscriptionId: subscriptionID) { (resp, err) in
            if err == nil {
                
               print(resp)
                completion(resp, nil)

            }else {
                completion(nil,err)
            }
            
        }
        
    }
    
    
    
    func updateDatabaseDevice (device: Device, completion: @escaping completionSuccess) {
        
        var deviceDict = device.nsDictionary
        
        let currentUser = GentsUser.firebaseGentsAuth()?.currentUser

 
        var  ref: FIRDatabaseReference = (GentsUser.firebaseGentsDataBase()?.reference())!
        
        guard let uuid = currentUser?.uid else {return}
        
        let usersRef = ref.child("users").child(uuid)
        var userData = [String: Any]()
        
        self.devices.add(deviceDict)
        
        userData["devices"] = self.devices
        
        usersRef.updateChildValues(userData, withCompletionBlock: { (err, ref) in //[weak usersRef] (err, ref) in
            if err == nil {
                self.reloadUserData(completion: { isOK in
                    
                    completion(isOK, nil)
                })
            } else {
                completion(false, err)
            }
        })
        
    }
    

    
    //MARK: - Reg_Login_Logout
    func registerUser(withName: String, email: String, password: String, cardToken: STPToken? = nil, initCharge: Int, monthCharge: Int, userData:[String:String], completion: @escaping completionSuccess) {
        
        var userData = userData
        GentsUser.firebaseGentsAuth()?.createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error ?? "unknown error")
                completion(false, error)
                return
            }
            
            guard let uuid = user?.uid else {return}
            
            StripeAPIClient.sharedClient.createStripeCustomer(email: email, cardToken: cardToken, initCharge: initCharge, monthCharge: monthCharge) { resp, err in
                
                guard err == nil else {
                    completion(false, err)
                    return
                }
                
                // Create database reference
                var ref: FIRDatabaseReference = (GentsUser.firebaseGentsDataBase()?.reference())!
                
                // Create users reference
                let usersRef = ref.child("users").child(uuid)
                userData["strp_customer_id"] = resp?["customer"] as? String
                userData["mainSubID"] = resp?["id"] as? String
                userData["email"] = email
                userData["name"] = withName
                usersRef.updateChildValues(userData, withCompletionBlock: { (err, ref) in //[weak usersRef] (err, ref) in
                    if err == nil {
                        self.reloadUserData(completion: { isOK in
                            
                            completion(isOK, nil)
                        })
                    } else {
                        completion(false, err)
                    }
                })
            }
        }
    }
    
    func loginUser(withEmail: String, password: String, completion: @escaping (_ user: GentsUser?) -> Swift.Void) {
        
        func doLogin() {
            let auth = GentsUser.firebaseGentsAuth()
            
            auth?.signIn(withEmail: withEmail, password: password, completion: { (user, error) in
                if error == nil {
                    //let userInfo = ["email": withEmail, "password": password]
                    //UserDefaults.standard.set(userInfo, forKey: "userInformation")
                    
                    //self.firebaseUser = GentsUser.firebaseGentsAuth()?.currentUser
                    self.reloadUserData(completion: { (isOK) in
                        if isOK {
                            completion(self)
                        } else {
                            completion(nil)
                        }
                    })
                } else {
                    //self.firebaseUser = nil
                    
                    if self.strpCustomerID != "" {
                        StripeAPIClient.sharedClient.cusID = self.strpCustomerID
                        self.customerCtx = STPCustomerContext(keyProvider: StripeAPIClient.sharedClient)
                    }
                    
                    completion(nil)
                }
            })
        }
        
        
        if GentsUser.firebaseGentsAuth()?.currentUser != nil {
            if GentsUser.firebaseGentsAuth()?.currentUser?.email == withEmail {
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
    
    func logOutUser(completion: @escaping (Bool) -> (Swift.Void)) {
        
        guard GentsUser.firebaseGentsAuth()?.currentUser != nil else {
            customerCtx?.clearCachedCustomer()
            completion(true)
            return
        }
        
        do {
            try GentsUser.firebaseGentsAuth()?.signOut()
            //UserDefaults.standard.removeObject(forKey: "userInformation")
            customerCtx?.clearCachedCustomer()
            completion(true)
        } catch _ {
            completion(false)
        }
    }
    
    func checkUserVerification(completion: @escaping (Bool) -> (Swift.Void)) {
        GentsUser.firebaseGentsAuth()?.currentUser?.reload(completion: { (_) in
            let status = (GentsUser.firebaseGentsAuth()?.currentUser?.isEmailVerified)!
            completion(status)
        })
    }
    
    func delete() {
        GentsUser.firebaseGentsAuth()?.currentUser?.delete(completion: { (err) in
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
    
    func reloadUserData(completion: @escaping (Bool) -> (Swift.Void)) {
        
        guard let cuser = GentsUser.firebaseGentsAuth()?.currentUser else {
            completion(false)
            return
        }
        
        GentsUser.firebaseGentsDataBase()?.reference().child("users").child(cuser.uid).observe(.value) { snapshot in
            let value = snapshot.value as? NSDictionary
            guard value != nil else {
                completion(false)
                return
            }
            
            let name = value!["name"] as? String ?? ""
            let email = value!["email"] as? String ?? ""
            let carrier = value!["carrier"] as? String ?? ""
            let devices = value!["devices"] as? NSArray ?? []
            let model = value!["model"] as? String ?? ""
            let phone = value!["phone"] as? String ?? ""
            let sn = value!["sn"] as? String ?? ""
            let strpID = value!["strp_customer_id"] as? String ?? ""
            let paymentsRaw = value!["payments"] as Any?
            let mainCredit = value!["mainDeviceCredit"] as? String
            let mainSubId = value!["mainSubID"] as? String
            
            
            self.name = name
            self.email = email
            self.carrier = carrier
            self.model = model
            self.phone = phone
            self.sn = sn
            self.strpCustomerID = strpID
            self.repairCredit = mainCredit ?? ""
            self.mainSubscriptionID = mainSubId ?? ""
            
            let newArray = NSMutableArray(array: devices)
            self.devices = newArray
            
            if paymentsRaw != nil {
                self.payments = JSON.init(rawValue: paymentsRaw!)
            }
            
            if self.strpCustomerID != "" {
                StripeAPIClient.sharedClient.cusID = self.strpCustomerID
                self.customerCtx = STPCustomerContext(keyProvider: StripeAPIClient.sharedClient)
            }
            
            completion(true)
        }
    }
    
    //MARK: - Payments
    
    func pay(amount: Int, description: String, host: UIViewController? = nil, completion: STPErrorBlock? = nil) {
        
        guard GentsUser.firebaseGentsAuth()?.currentUser != nil else {
            print("no valid user logged-in")
            completion?(NSError(domain: "Payment", code: 1, userInfo: nil))
            return
        }
        
        guard customerCtx != nil else {
            print("customer context n/a")
            completion?(NSError(domain: "Payment", code: 2, userInfo: nil))
            return
        }
        
        customerCtx?.clearCachedCustomer()
        customerCtx = STPCustomerContext(keyProvider: StripeAPIClient.sharedClient)
        
        customerCtx?.retrieveCustomer({ [weak self] (cust, err) in
            
            guard cust != nil && err == nil else {
                completion?(NSError(domain: "Payment", code: 3, userInfo: nil))
                return
            }
            
            let card = cust?.defaultSource as? STPCard
            if card != nil {
                self?.payp = (self?.payp.filter { if !$0.isFulfilled { return true }; return false })!
                
                let pp = payProcess(amount: amount, desc: description, customerContext: (self?.customerCtx)!, payCompletion: completion)
                pp.payCtx.hostViewController = host
                self?.payp.append(pp)
                
                pp.pay()
            } else {
                print("should add CC")
                completion?(NSError(domain: "Payment", code: 4, userInfo: nil))
            }
        })
    }
    
    func getPayments() -> FIRDatabaseQuery? {
        
        guard let cuser = GentsUser.firebaseGentsAuth()?.currentUser else {
            return nil
        }
        
        return GentsUser.firebaseGentsDataBase()?.reference().child("users").child(cuser.uid).child("payments").queryOrdered(byChild: "created")
    }
    
    func getPayments(completed: @escaping (JSON?)->()) {
        guard GentsUser.firebaseGentsAuth()?.currentUser != nil && strpCustomerID != "" else {
            completed(nil)
            return
        }
        
        
        Alamofire.request(StripeAPIData.myServer + "/charges_retrieve_dev", method: .get, headers:["cusID": strpCustomerID]).validate().responseJSON { resp in
            
            switch resp.result {
            case .success:
                let json = try? JSON.init(data: resp.data!)
                completed(json)
            case .failure:
                completed(nil)
            }
        }
    }
    
    
    
    
    func addPaymentCard(host: UIViewController?, delegate: STPPaymentContextDelegate? = nil) {
        
        guard customerCtx != nil && host != nil else {
            return
        }
        
        let payContext = STPPaymentContext.init(customerContext: customerCtx!)
        payContext.hostViewController = host
        payContext.delegate = delegate
        payContext.presentPaymentMethodsViewController()
    }
    
    //MARK: - posts
    
    func posts(completion: @escaping (_ json: JSON?)->(Void)) {
        
        GentsUser.firebaseGentsDataBase()?.reference().child("posts").observeSingleEvent(of: .value, with: { dsnap in
            
            let values = dsnap.value
            guard values != nil else {
                completion(nil)
                return
            }
            let json = JSON(values!)
            completion(json)
        })
    }
    
    //MARK: - DB connection listener
    
    static func connectionDetect() {
        let connectedRef = firebaseGentsDataBase()?.reference(withPath: ".info/connected")
        
        connectedRef?.observe(.value, with: { snapshot in
            guard let cuser = firebaseGentsAuth()?.currentUser else {
                return
            }
            
            if let connected = snapshot.value as? Bool, connected {
                print("Gents-Connected")
                firebaseGentsDataBase()?.reference().child("users").child(cuser.uid).keepSynced(true)
            } else {
                print("Gents-Disconnected")
                firebaseGentsDataBase()?.reference().child("users").child(cuser.uid).keepSynced(false)
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
