//
//  Device.swift
//  Gent
//
//  Created by Merritt Tidwell on 7/4/18.
//  Copyright © 2018 Christina Sund. All rights reserved.
//

import Foundation

class Device: NSObject {
    
    var deviceDictionary: [String: String]
   
    var deviceName: String
    
    var nsDictionary: NSDictionary {
        return deviceDictionary as NSDictionary
    }
    
    init(deviceName : String, deviceInfo : [String: String]){
        
        self.deviceDictionary = deviceInfo
        self.deviceName = deviceName
    
    }


}

