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

class GSignupViewController: GUIViewController, UITextFieldDelegate, STPPaymentCardTextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
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

    @IBOutlet weak var devicePickerView: UIPickerView!
    @IBOutlet weak var choseYourDeviceButton: UIButton!
 
    var signUpDict = [String : String]()
    
    let supportedDevices = ["iPhone 10", "iPhone 7", "iPhone 8"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstNameTF.becomeFirstResponder()

        self.firstNameView.addBottomBorderWithColor(color: .lightGray, width: 1)
        self.lastNameView.addBottomBorderWithColor(color: .lightGray, width: 1)
        self.emailView.addBottomBorderWithColor(color: .lightGray, width: 1)
        self.passwordView.addBottomBorderWithColor(color: .lightGray, width: 1)
        self.rePasswordView.addBottomBorderWithColor(color: .lightGray, width: 1)
        
        self.devicePickerView.dataSource = self
        
        devicePickerView.isHidden = true

        setUpNavigationBarItems()
 
    }
    
    private func setUpNavigationBarItems() {
        
        let image = UIImage.init(named: "nav")
        let titleImageView = UIImageView(image: image)
        titleImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        titleImageView.contentMode = .scaleAspectFit
   //     titleImageView.backgroundColor = .gray
        navigationItem.titleView = titleImageView
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        
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
    

    
    //MARK: - PickerViewDelegate
    
    //TODO: make dynamic
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return supportedDevices.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
        return supportedDevices[row]
   
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        choseYourDeviceButton.setTitle(supportedDevices[row], for: .normal)
    
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

//better approach
        
//        let nextTag = textField.tag + 1
//            print(textField.tag)
//        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
//            nextResponder.becomeFirstResponder()
//        } else {
//            textField.resignFirstResponder()
//        }

        if textField == self.firstNameTF {
            
            if (checkFieldNotEmpty(textField: textField)) {
                self.lastNameTF.becomeFirstResponder()

            }
         
        }
        
        if textField == self.lastNameTF {
            if (checkFieldNotEmpty(textField: textField)){
                self.emailTF.becomeFirstResponder()
            }
        }

        
        if textField == self.emailTF {
           
            if isValidEmail(email: self.emailTF.text) {
            self.passwordTF.becomeFirstResponder()
            }else {
                UIHelper.showAlertInView(self, msg: "Please enter a valid email")

            }
            
        }
        
        if textField == self.passwordTF {
            self.rePasswordTF.becomeFirstResponder()
        }
        
        if textField == self.rePasswordTF {
            let secondEntry = self.rePasswordTF.text
            let firstEntry = self.passwordTF.text

            if checkPasswordValid(firstEntry: firstEntry ?? "", secondEntry: secondEntry ?? "") {

                self.devicePickerView.isHidden = false
                textField.resignFirstResponder()
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 7 {
            UIHelper.animateViewUp(self.view, with: OnScreenKBListener.shared.keyboardHeight)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // interesting way to make text views disappear
        
       // UIHelper.animateViewDown(self.view)
    }
    
    
    func checkFieldNotEmpty (textField: UITextField ) -> Bool {
    
        guard textField.text != "" else {
            UIHelper.showAlertInView(self, msg: "Please do not leave required fields blank")
            return false
        }
      
        
        return true
        
    }
    
    func checkPasswordValid (firstEntry: String, secondEntry : String) -> Bool {
        
     
        if firstEntry.count < 6 {
            UIHelper.showAlertInView(self, msg: "Passwords must be 6 characters or more")
            return false
        }
        
        if (firstEntry.elementsEqual(secondEntry)) {
            
            return true
        } else {
            
            UIHelper.showAlertInView(self, msg: "Passwords must match")
            return false
        }
        
        return true
    }
    
    func isValidEmail(email:String?) -> Bool {
        
        guard email != nil else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
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
            UIHelper.showAlertInView(self, msg: "Your passwords don't match, please try again!")
            return false
        }
        
        signUpDict["password"] = pwd
        
        
        // valid check here
        
        signUpDict["model"] = choseYourDeviceButton.titleLabel?.text
        
        
        return true
        
    }
    
    func saveValues(values : [String: String]) {
        
        let userDefaults = UserDefaults.standard
       
        for (k,v) in values {
            
            userDefaults.setValue(v, forKey: k)

        }

    }

    
    //fix this 
    
    @IBAction private func showPhoneInfoScreen() {
        print("sign up")
        
        
        if checkFieldsValid()  {
            
            saveValues(values: signUpDict)
            
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main_NewDesign", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentSignUp") as! PaymentSignUpViewController
          //  let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentSignUp") as!
            self.navigationController?.show(nextViewController, sender: self)
            

            
            
        }else {
            
            return
            
        }
        
      
    }
}

extension String {
    func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
}
