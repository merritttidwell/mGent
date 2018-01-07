//
//  GentsConfig.swift
//  Gent
//
//  Created by Ossama Mikhail on 1/6/18.
//  Copyright © 2018 Christina Sund. All rights reserved.
//

import Foundation
import Firebase

class GentsConfig: NSObject {
    static let shared = GentsConfig()
    
    var supportedModels : [String]?
    var savePercent : Double?
    var extraPercent : Double?
    
    class func firebaseConfigDataBase() -> Database? {
        
        var configApp = FirebaseApp.app(name: "configApp")
        
        if configApp == nil {
            
            let options = FirebaseOptions.init(contentsOfFile: Bundle.main.path(forResource: "GoogleService-Info-ConfigDB", ofType: "plist")!)
            
            // Configure an alternative FIRApp.
            FirebaseApp.configure(name: "configApp", options: options!)
            
            // Retrieve a previous created named app.
            configApp = FirebaseApp.app(name: "configApp")
            guard configApp != nil else { assert(false, "Could not retrieve configApp"); return nil}
        }
        
        // Retrieve a Real Time Database client configured against a specific app.
        return Database.database(app: configApp!)
    }
    
    func update(completion: @escaping (Bool) -> (Void)) {
        GentsConfig.firebaseConfigDataBase()?.reference().child("SystemSetup").observeSingleEvent(of: .value) { dsnap in
            completion(true)
            print(dsnap.value)
        }
    }
    
    static func connectionDetect() {
        let connectedRef = firebaseConfigDataBase()?.reference(withPath: ".info/connected")
        connectedRef?.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                print("Connected")
                Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).keepSynced(true)
            } else {
                print("Disconnected")
                Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).keepSynced(false)
            }
        })
    }
}
