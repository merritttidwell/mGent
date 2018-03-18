//
//  GSignupViewController.swift
//  Gent
//
//  Created by Ossama Mikhail on 12/30/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit
import SwiftyJSON
import Stripe

class GSignupViewController: GUIViewController, UITextFieldDelegate, STPPaymentCardTextFieldDelegate {
    
    var alertController : UIAlertController?
    var isAlertControllerDisplayed = false
    
    var paymentCardTextField : STPPaymentCardTextField?
    
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var rePasswordView: UIView!

    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rePasswordTF: UITextField!


    var signUpDict = [String : String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.firstNameView.addBottomBorderWithColor(color: .lightGray, width: 1)
        self.lastNameView.addBottomBorderWithColor(color: .lightGray, width: 1)
        self.emailView.addBottomBorderWithColor(color: .lightGray, width: 1)
        self.passwordView.addBottomBorderWithColor(color: .lightGray, width: 1)
        self.rePasswordView.addBottomBorderWithColor(color: .lightGray, width: 1)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        OnScreenKBListener.shared.start({ notf in
            print(notf)
        }, onHide: nil)
    }
    
 
    
    // MARK: - STPPaymentCardTextFieldDelegate
    
    func paymentCardTextFieldDidBeginEditing(_ textField: STPPaymentCardTextField) {
        OnScreenKBListener.shared.start({ notf in
            UIHelper.animateViewUp(self.view, with: OnScreenKBListener.shared.keyboardHeight)
        })
        UIHelper.animateViewUp(self.view, with: OnScreenKBListener.shared.keyboardHeight)
    }
    
    func paymentCardTextFieldDidEndEditing(_ textField: STPPaymentCardTextField) {
        UIHelper.animateViewDown(self.view)
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        // Toggle buy button state
        let signupButton = self.view.viewWithTag(9) as! UIButton
        signupButton.isEnabled = textField.isValid
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 7 {
            UIHelper.animateViewUp(self.view, with: OnScreenKBListener.shared.keyboardHeight)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIHelper.animateViewDown(self.view)
    }
    
    func checkFieldsValid () -> Bool {
       
        let firstName = firstNameTF?.text ?? ""
        guard firstName != "" else {
            UIHelper.showAlertInView(self, msg: "Please complete needed details")
            return false
        }
        
        let lastName = lastNameTF?.text ?? ""
        guard lastName != "" else {
            UIHelper.showAlertInView(self, msg: "Please complete needed details")
            return false
        }
        
        let fullName = firstName + " " + lastName
     
        signUpDict["fullName"] = fullName
        
        let email = self.emailTF.text ?? ""
        guard email != "" else {
            UIHelper.showAlertInView(self, msg: "Please complete needed details")
            return false
        }
        
        signUpDict["email"] = email
        
        let pwd = passwordTF?.text ?? ""
        let repwd = rePasswordTF.text ?? ""
        guard pwd != "" && pwd == repwd else {
            UIHelper.showAlertInView(self, msg: "Please complete needed details")
            return false
        }
        
        signUpDict["password"] = pwd
        
        return true
        
    }
    
    func saveValues(values : [String: String]) {
        
        let userDefaults = UserDefaults.standard
       
        for (k,v) in values {
            
            userDefaults.setValue(v, forKey: k)

        }

    }

    
    @IBAction private func showPhoneInfoScreen() {
        print("sign up")
        
        if checkFieldsValid()  {
            
            saveValues(values: signUpDict)
            
            self.performSegue(withIdentifier: "showPhoneDetails", sender: nil)
            
        }else {
            
            return
            
        }
        
      
    }
}
