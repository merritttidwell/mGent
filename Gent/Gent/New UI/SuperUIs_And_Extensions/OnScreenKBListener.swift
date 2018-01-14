//
//  OnScreenKBListener.swift
//  IoTTester
//
//  Created by Ossama Mikhail on 1/20/17.
//  Copyright © 2017 Ossama Mikhail. All rights reserved.
//

import Foundation
import UIKit

typealias onsckbEvent = (Notification)->(Void)

class OnScreenKBListener : NSObject {
    
    static let shared = OnScreenKBListener()
    var isOSKBVisable = false;
    
    var onShowEvent : onsckbEvent? = nil
    var onHideEvent : onsckbEvent? = nil
    
    var keyboardHeight = CGFloat(0)
    
    func start(_ onShow: onsckbEvent?, onHide: onsckbEvent? = nil) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        if onHide != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        }
        
        onShowEvent = onShow
        onHideEvent = onHide
    }
    
    func stop() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        if onHideEvent != nil {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        }
    }
    
    @objc func kbDidShow(_ notif: Notification) {
        
        print("On Screen KB show")
        
        let iFrame = notif.userInfo?[UIKeyboardFrameBeginUserInfoKey]
        let eFrame = notif.userInfo?[UIKeyboardFrameEndUserInfoKey]
        
        print(iFrame!)
        print(eFrame!)
        
        keyboardHeight = (eFrame as! CGRect).height
        
        onShowEvent?(notif)
    }
    
    @objc func kbDidHide(_ notif: Notification) {
        
        print("On Screen KB hide")
        
        onHideEvent?(notif)
    }
}
