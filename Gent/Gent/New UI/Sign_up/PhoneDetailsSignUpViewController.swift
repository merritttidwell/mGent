//
//  PhoneDetailsSignUpViewController.swift
//  Gent
//
//  Created by Merritt Tidwell on 3/17/18.
//  Copyright © 2018 Christina Sund. All rights reserved.
//

import UIKit

class PhoneDetailsSignUpViewController: UIViewController {

    var alertController : UIAlertController?
    var isAlertControllerDisplayed = false
    var userInfoDict = [String: String] ()
    
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var carrierView: UIView!
    @IBOutlet weak var serialView: UIView!
    @IBOutlet weak var modelView: UIView!
    
    @IBOutlet weak var modelButton: UIButton!
    @IBOutlet weak var carrierButton: UIButton!
    
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var serialNumberTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelButton?.setTitle(UIDevice.current.modelName, for: .normal)
   
        phoneNumberView.addBottomBorderWithColor(color: .lightGray, width: 1)
        carrierView.addBottomBorderWithColor(color: .lightGray, width: 1)
        serialView.addBottomBorderWithColor(color: .lightGray, width: 1)
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

                            self?.carrierButton?.setTitle(v, for: .normal)
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
        
        let phoneNumber = phoneNumberTF?.text ?? ""
        guard phoneNumber != "" else {
            UIHelper.showAlertInView(self, msg: "Please complete needed details")
            return false
        }
        
        let serialNumber = serialNumberTF?.text ?? ""
        guard serialNumber != "" else {
            UIHelper.showAlertInView(self, msg: "Please complete needed details")
            return false
        }

        let carrier = carrierButton.titleLabel?.text ?? ""
        guard carrier != "" && carrier != "Choose your Carrier" else {
            UIHelper.showAlertInView(self, msg: "Please complete needed details")
            return false
        }
        
        
        userInfoDict["carrier"] = carrier
        userInfoDict["model"] = modelButton.titleLabel?.text
        userInfoDict["phoneNumber"] = phoneNumber
        userInfoDict["serialNumber"] = serialNumber
        
        return true
        
    }
    
    func saveValues(values : [String: String]) {
        
        let userDefaults = UserDefaults.standard
        
        for (k,v) in values {
            
            userDefaults.setValue(v, forKey: k)
            
        }
        
    }
    
    
    @IBAction private func showPayment() {
        
        if checkFieldsValid()  {
            
            saveValues(values: userInfoDict)
            
            self.performSegue(withIdentifier: "showPayment", sender: nil)
            
        }else {
            
            return
            
        }
        
        
    }
    

}
