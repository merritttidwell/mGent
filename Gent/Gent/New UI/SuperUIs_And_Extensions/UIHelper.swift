//
//  Helper.swift
//  IoTTester
//
//  Created by Ossama Mikhail on 1/9/17.
//  Copyright © 2017 Ossama Mikhail. All rights reserved.
//

import Foundation
import UIKit

internal class UIHelper {
    
    static func showAlertInView(_ viewController: UIViewController?, title: String = "Error", msg: String) {
        
        let alert = UIAlertController.init(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        viewController?.present(alert, animated: false, completion: nil)
    }
    
    //MARK:Animation
    func animateView(_ view: UIView, directionUp: Bool) {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.duration = directionUp ? 0.3 : 0.5
        animation.repeatCount = 1
        animation.autoreverses = false
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.toValue = directionUp ? view.center.y - 50 : view.center.y
        
        view.layer.add(animation, forKey: "position.y")
    }
    
    func animateView(_ view: UIView, up:Bool, moveValue :CGFloat = 50) {
        let movementDuration = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        view.frame = view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
    class func animateViewUp(_ view: UIView, with: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: { 
            view.frame.origin = CGPoint(x: view.frame.origin.x, y: -with)
        })
    }
    
    class func animateViewDown(_ view: UIView, yValue: CGFloat = 0) {
        UIView.animate(withDuration: 0.3, animations: {
            view.frame.origin = CGPoint(x: view.frame.origin.x, y: yValue)
        })
    }
    
    class func getCurrentDateAndTime() -> (year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) {
        
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year, .hour, .minute, .second], from: date)
        
        return (components.year!, components.month!, components.day!, components.hour!, components.minute!, components.second!)
    }
    
    class func getDateCompnents(date: Date) -> (year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) {
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year, .hour, .minute, .second], from: date)
        
        return (components.year!, components.month!, components.day!, components.hour!, components.minute!, components.second!)
    }
    
    class func getDateCompnents(date: String) -> (year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        let sdate = dateFormatter.date(from: date)!
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year, .hour, .minute, .second], from: sdate)
        
        return (components.year!, components.month!, components.day!, components.hour!, components.minute!, components.second!)
    }
    
    class func convertDictionaryToString(_ dict: [String:AnyObject]) -> String? {
        
        var jsonData: Data?
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions())
        } catch {
            return nil
        }
        
        return NSString.init(data: jsonData!, encoding: String.Encoding.utf8.rawValue) as? String
    }
    
    static var log = "";
    
    class func Log(_ logView: UITextView, logText: String) {
    
        DispatchQueue.main.async {
            print(">> " + logText)
            log = log + (">> " + logText + "\r\n")
            logView.text = log
        }
    }
    
    class func UTCToLocal(time:Double) -> String {
        
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = NSTimeZone.local
        let localDate = dateFormatter.string(from: date)
        
        return localDate
    }
}
