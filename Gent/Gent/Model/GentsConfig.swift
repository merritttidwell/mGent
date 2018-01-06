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
    
    class func firebaseConfigDataBase() -> Database {
        
        let options = FirebaseOptions.init(contentsOfFile: Bundle.main.path(forResource: "GoogleService-Info-ConfigDB", ofType: "plist")!)
        
        // Configure an alternative FIRApp.
        FirebaseApp.configure(name: "configApp", options: options!)
        
        // Retrieve a previous created named app.
        guard let configApp = FirebaseApp.app(name: "configApp")
            else { assert(false, "Could not retrieve configApp") }
        
        
        // Retrieve a Real Time Database client configured against a specific app.
        let configDB = Database.database(app: configApp)
        
        return configDB
    }
    
    func update(completion: @escaping (Bool) -> (Void)) {
        GentsConfig.firebaseConfigDataBase().reference().child("SystemSetup").observeSingleEvent(of: .value) { dsnap in
            completion(true)
            print(dsnap.value)
        }
    }
}
