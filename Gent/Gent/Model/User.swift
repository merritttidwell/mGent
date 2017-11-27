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

typealias completionSuccess = (_ isSuccessful: Bool) -> (Void)

class User: NSObject {
    
    //MARK: Properties
    let name: String
    let email: String
    let id: String
    
    var customerCtx : STPCustomerContext?
    //var payCtx : STPPaymentContext?
    private(set) var strpCustomerID = ""
    
    //MARK: Methods
    class func registerUser(withName: String, email: String, password: String, userData:[String:String], completion: @escaping completionSuccess) {
        
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
                usersRef.updateChildValues(userData, withCompletionBlock: { (err, ref) in
                    if err == nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            }
        }
    }
    
    class func loginUser(withEmail: String, password: String, completion: @escaping (_ user: User?) -> Swift.Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            if error == nil {
                let userInfo = ["email": withEmail, "password": password]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                
                Database.database().reference().child("users").child((user?.uid)!).observeSingleEvent(of: .value) { snapshot in
                    let value = snapshot.value as? NSDictionary
                    
                    guard value != nil else {
                        completion(nil)
                        return
                    }
                    
                    let name = value!["name"] as! String
                    let email = value!["email"] as! String
                    let sn = value!["sn"] as! String
                    let strpID = value!["strp_customer_id"] as! String
                    let usr = User(name: name, email: email, sn: sn, stripeID: strpID)
                    
                    completion(usr)
                }
            } else {
                completion(nil)
            }
        })
    }
    
    class func logOutUser(completion: @escaping (Bool) -> Swift.Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "userInformation")
            completion(true)
        } catch _ {
            completion(false)
        }
    }
    
    class func info(forUserID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("users").child(forUserID).child("credentials").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                let name = data["name"]!
                let email = data["email"]!
                let strpID = data["strp_customer_id"]!
                let link = URL.init(string: data["profilePicLink"]!)
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let user = User.init(name: name, email: email, sn: forUserID, stripeID: strpID)
                        completion(user)
                    }
                }).resume()
            }
        })
    }
    
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
    
    class func checkUserVerification(completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().currentUser?.reload(completion: { (_) in
            let status = (Auth.auth().currentUser?.isEmailVerified)!
            completion(status)
        })
    }
    
    class func delete() {
        Auth.auth().currentUser?.delete(completion: { (err) in
            print(err ?? "N/A")
        })
    }
    
    //MARK: Inits
    init(name: String, email: String, sn: String, stripeID: String) {
        self.name = name
        self.email = email
        self.id = sn
        self.strpCustomerID = stripeID
        
        if strpCustomerID != "" {
            StripeAPIClient.sharedClient.cusID = strpCustomerID
            customerCtx = STPCustomerContext(keyProvider: StripeAPIClient.sharedClient)
            //payCtx = STPPaymentContext(customerContext: customerCtx)
            
            //payCtx.delegate = self
        }
    }
}
