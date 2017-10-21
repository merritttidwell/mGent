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

class User: NSObject {
    
    //MARK: Properties
    let name: String
    let email: String
    let id: String
    
    //MARK: Methods
    class func registerUser(withName: String, email: String, password: String, userData:[String:String]) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error ?? "unknown error")
                return
            }
            
            guard let uuid = user?.uid else {return}
            
            // Create database reference
            var ref: DatabaseReference!
            ref = Database.database().reference()
            // Create users reference
            let usersRef = ref.child("users").child(uuid)
            usersRef.updateChildValues(userData)
            
        }
        
    }
    
    class func loginUser(withEmail: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            if error == nil {
                let userInfo = ["email": withEmail, "password": password]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                completion(true)
            } else {
                completion(false)
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
                let link = URL.init(string: data["profilePicLink"]!)
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let user = User.init(name: name, email: email, id: forUserID)
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
    
    
    //MARK: Inits
    init(name: String, email: String, id: String) {
        self.name = name
        self.email = email
        self.id = id
    }
}
