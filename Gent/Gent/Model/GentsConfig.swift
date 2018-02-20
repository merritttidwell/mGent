//
//  GentsConfig.swift
//  Gent
//
//  Created by Ossama Mikhail on 1/6/18.
//  Copyright © 2018 Christina Sund. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

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
        
        //return Database.database(url: "https://gentconfig.firebaseio.com/")
        return Database.database(app: app)
    }
    
    class func firebaseConfigAuth() -> Auth? {
        
        guard let app = firebaseConfigApp() else {
            return nil
        }
        
        return Auth.auth(app: app)
        //return Auth.auth()
    }
    
    //MARK: - updates
    
    func update(completion: @escaping (Bool) -> (Void)) {
        GentsConfig.firebaseConfigDataBase()?.reference().child("SystemSetup").observeSingleEvent(of: .value) { dsnap in
            completion(true)
            print(dsnap.value)
        }
    }
    
    class func getModelConfig(model: String? = nil, completed: @escaping (JSON?)->(Void)) {
        
        GentsConfig.firebaseConfigDataBase()?.reference().child("SystemSetup/Percents").observeSingleEvent(of: .value, with: { snap in
            var model = model
            let values = snap.value as! NSDictionary
            var specs : [String:Any]?
            if model == nil {
                model = UIDevice.current.modelName.lowercased().replacingOccurrences(of: " ", with: "") as String
            } else {
                model = model?.lowercased().replacingOccurrences(of: " ", with: "")
            }
            for k in values.allKeys {
                if (k as! String).lowercased() == model {
                    specs = values.value(forKey: k as! String) as? [String : Any]
                }
            }
            
            completed(JSON(specs as Any))
        })
    }
    
    class func getPaymentValues(completed: @escaping (JSON?)->(Void)) {
        firebaseConfigDataBase()?.reference().child("SystemSetup/PaymentValues").observeSingleEvent(of: .value, with: { snap in
            completed(JSON.init(snap.value as Any))
        })
    }
    
    /*static func connectionDetect() {
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
    }*/
}
