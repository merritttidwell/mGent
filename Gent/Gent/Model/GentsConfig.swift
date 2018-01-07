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
    
    //MARK: - DB connection
    class func firebaseConfigApp() -> FirebaseApp? {
        
        var app = FirebaseApp.app(name: "configApp")
        
        if app == nil {
            
            let options = FirebaseOptions.init(contentsOfFile: Bundle.main.path(forResource: "GoogleService-Info-ConfigDB", ofType: "plist")!)
            
            // Configure an alternative FIRApp.
            FirebaseApp.configure(name: "configApp", options: options!)
            
            // Retrieve a previous created named app.
            app = FirebaseApp.app(name: "configApp")
            guard app != nil else { assert(false, "Could not retrieve configApp"); return nil}
        }
        
        return app
    }
    
    class func firebaseConfigDataBase() -> Database? {
        
        guard let app = firebaseConfigApp() else {
            return nil
        }
        
        return Database.database(url: "https://gentconfig.firebaseio.com/")
    }
    
    class func firebaseConfigAuth() -> Auth? {
        
        guard let app = firebaseConfigApp() else {
            return nil
        }
        
        //return Auth.auth(app: app)
        return Auth.auth()
    }
    
    //MARK: - updates
    
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
                print("Config-Connected")
                firebaseConfigDataBase()?.reference().keepSynced(true)
            } else {
                print("Config-Disconnected")
                firebaseConfigDataBase()?.reference().keepSynced(false)
            }
        })
    }
}
