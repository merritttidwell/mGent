//
//  PhoneDetailsSignUpViewController.swift
//  Gent
//
//  Created by Merritt Tidwell on 3/17/18.
//  Copyright © 2018 Christina Sund. All rights reserved.
//

import UIKit

class PhoneDetailsSignUpViewController: GUIViewController {

    var alertController : UIAlertController?
    var isAlertControllerDisplayed = false
    var userInfoDict = [String: String] ()
    var deviceName = String()
    
  
    @IBOutlet weak var modelView: UIView!
    @IBOutlet weak var nickNameView: UIView!
    
    @IBOutlet weak var modelButton: UIButton!
    @IBOutlet weak var nickNameTF: UITextField!
    
    @IBOutlet weak var addPhoneDetailsButton: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityView.isHidden = true

        
        if GentsUser.firebaseGentsAuth()?.currentUser == nil {
           
            nickNameView.isHidden = true
            addPhoneDetailsButton.setTitle("Add Main Device", for: .normal)

        } else {
            
            self.title = "Add New Device"
            addPhoneDetailsButton.setTitle("Add Device", for: .normal)
        }

        modelButton?.setTitle(UIDevice.current.modelName, for: .normal)
   
        modelView.addBottomBorderWithColor(color: .lightGray, width: 1)
    
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        OnScreenKBListener.shared.start({ notf in
            print(notf)
        }, onHide: nil)
    }

    @IBAction private func selectCarrier() {
     print("select carrier")
    
            guard !isAlertControllerDisplayed else {
                return
            }
    
            alertController = UIAlertController.init(title: "Carrier", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
    
            GentsConfig.firebaseConfigDataBase()?.reference().child("SystemSetup/Carriers").observeSingleEvent(of: .value, with: { dsnap in
    
                DispatchQueue.main.async { [weak self] in
    
                    let values = dsnap.value as? [String]
    
                    guard values != nil else {
                        self?.isAlertControllerDisplayed = false
                        return
                    }
    
                    for v in values! {
                        self?.alertController?.addAction(UIAlertAction.init(title: v, style: UIAlertActionStyle.default, handler: { action in

                            self?.isAlertControllerDisplayed = false
                        }))
                    }
    
                    self?.alertController?.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
                        self?.isAlertControllerDisplayed = false
                    }))
    
                    guard self != nil && self?.alertController != nil else {
                        self?.isAlertControllerDisplayed = false
                        return
                    }
                    self?.present(self!.alertController!, animated: true, completion: nil)
                }
            })
        }
    
        @IBAction private func selectModel() {
            print("select model")
    
            guard !isAlertControllerDisplayed else {
                return
            }
    
            alertController = UIAlertController.init(title: "Model", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
    
            GentsConfig.firebaseConfigDataBase()?.reference().child("SystemSetup/SupportedModels").observeSingleEvent(of: .value, with: { dsnap in
    
                DispatchQueue.main.async { [weak self] in
    
                    let values = dsnap.value as? [String]
    
                    guard values != nil else {
                        self?.isAlertControllerDisplayed = false
                        return
                    }
    
                    for v in values! {
                        self?.alertController?.addAction(UIAlertAction.init(title: v, style: UIAlertActionStyle.default, handler: { action in

                            self?.modelButton?.setTitle(v, for: .normal)
                            self?.isAlertControllerDisplayed = false
                        }))
                    }
    
                    self?.alertController?.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
                        self?.isAlertControllerDisplayed = false
                    }))
    
                    guard self != nil && self?.alertController != nil else {
                        self?.isAlertControllerDisplayed = false
                        return
                    }
                    self?.present(self!.alertController!, animated: true, completion: nil)
                }
            })
        }

    func checkFieldsValid () -> Bool {
        
        self.deviceName = nickNameTF.text ?? "Main"
        
        userInfoDict["model"] = modelButton.titleLabel?.text
        userInfoDict["deviceName"] = self.deviceName
        
        return true
        
    }
    
    func saveValues(values : [String: String]) {

        
        for (k,v) in values {
            let userDefaults = UserDefaults.standard

            userDefaults.setValue(v, forKey: k)
            
        }
        
    }
    
    //really should be renamed to add phone details
    @IBAction private func showPayment() {
        
        if checkFieldsValid() != true {
            
            ///show invlaid field alert
            return
        }
        
        if (GentsUser.firebaseGentsAuth()?.currentUser != nil){
            return
        }else{

            saveValues(values: userInfoDict)
            
            self.performSegue(withIdentifier: "showPayment", sender: nil)
            
            }
            
        }

    func addDeviceAndSubscription() {

            self.activityView.startAnimating()
        
            userInfoDict["deviceCredit"] = "140"
            let device = Device(deviceName: self.deviceName, deviceInfo: userInfoDict)
            
        GentsUser.shared.addDevice(device: device, initCharge: 4000, completion: { (isOk, err) -> (Void) in
                if (isOk) {
                    self.activityView.stopAnimating()
                    self.navigationController?.popToRootViewController(animated: true)

                }else {
                    
                    
                    //shower error
                    self.activityView.stopAnimating()

                }
           
            })
        
    }
    
    

}
