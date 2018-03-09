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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let cardView = self.view.viewWithTag(8)!
        paymentCardTextField = STPPaymentCardTextField.init(frame: cardView.bounds)
        paymentCardTextField?.delegate = self
        cardView.addSubview(paymentCardTextField!)
        
        let btn = self.view.viewWithTag(1002) as! UIButton
        btn.setTitle(UIDevice.current.modelName, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        OnScreenKBListener.shared.start({ notf in
            print(notf)
        }, onHide: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
                        let btn = (self?.view.viewWithTag(1001) as? UIButton)
                        btn?.setTitle(v, for: .normal)
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
                        let btn = (self?.view.viewWithTag(1002) as? UIButton)
                        btn?.setTitle(v, for: .normal)
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
    
    @IBAction private func doSignup() {
        print("sign up")
        
        let fname = (self.view.viewWithTag(1) as? UITextField)?.text ?? ""
        guard fname != "" else {
            self.view.viewWithTag(1)?.layer.borderColor = UIColor.red.cgColor
            UIHelper.showAlertInView(self, msg: "Please complete needed details")
            return
        }
        self.view.viewWithTag(1)?.layer.borderColor = UIColor.black.cgColor
        
        let lname = (self.view.viewWithTag(2) as? UITextField)?.text ?? ""
        guard lname != "" else {
            self.view.viewWithTag(2)?.layer.borderColor = UIColor.red.cgColor
            UIHelper.showAlertInView(self, msg: "Please complete needed details")
            return
        }
        self.view.viewWithTag(2)?.layer.borderColor = UIColor.black.cgColor
        
        let name = fname + " " + lname
        
        let email = (self.view.viewWithTag(3) as? UITextField)?.text ?? ""
        guard email != "" else {
            self.view.viewWithTag(3)?.layer.borderColor = UIColor.red.cgColor
            UIHelper.showAlertInView(self, msg: "Please complete needed details")
            return
        }
        self.view.viewWithTag(3)?.layer.borderColor = UIColor.black.cgColor
        
        let pwd = (self.view.viewWithTag(4) as? UITextField)?.text ?? ""
        let repwd = (self.view.viewWithTag(5) as? UITextField)?.text ?? ""
        guard pwd != "" && pwd == repwd else {
            self.view.viewWithTag(4)?.layer.borderColor = UIColor.red.cgColor
            self.view.viewWithTag(5)?.layer.borderColor = UIColor.red.cgColor
            UIHelper.showAlertInView(self, msg: "Please complete needed details")
            return
        }
        self.view.viewWithTag(4)?.layer.borderColor = UIColor.black.cgColor
        self.view.viewWithTag(5)?.layer.borderColor = UIColor.black.cgColor
        
        let phoneNumber = (self.view.viewWithTag(6) as? UITextField)?.text ?? ""
        guard phoneNumber != "" else {
            self.view.viewWithTag(6)?.layer.borderColor = UIColor.red.cgColor
            UIHelper.showAlertInView(self, msg: "Please complete needed details")
            return
        }
        self.view.viewWithTag(6)?.layer.borderColor = UIColor.black.cgColor
        
        let carrier = (self.view.viewWithTag(1001) as? UIButton)?.currentTitle ?? ""
        guard carrier != "" && carrier.lowercased() != "please select" else {
            self.view.viewWithTag(1001)?.layer.borderColor = UIColor.red.cgColor
            UIHelper.showAlertInView(self, msg: "Please complete needed details")
            return
        }
        self.view.viewWithTag(1001)?.layer.borderColor = UIColor.black.cgColor
        
        let serial = (self.view.viewWithTag(7) as? UITextField)?.text ?? ""
        guard serial != "" else {
            self.view.viewWithTag(7)?.layer.borderColor = UIColor.red.cgColor
            UIHelper.showAlertInView(self, msg: "Please complete needed details")
            return
        }
        self.view.viewWithTag(7)?.layer.borderColor = UIColor.black.cgColor
        
        let model = (self.view.viewWithTag(1002) as? UIButton)?.currentTitle ?? ""
        guard model != "" && model.lowercased() != "default" else {
            self.view.viewWithTag(1002)?.layer.borderColor = UIColor.red.cgColor
            UIHelper.showAlertInView(self, msg: "Please complete needed details")
            return
        }
        self.view.viewWithTag(1002)?.layer.borderColor = UIColor.black.cgColor
        
        print(paymentCardTextField!.cardParams)
        STPAPIClient.shared().createToken(withCard: paymentCardTextField!.cardParams, completion: { (ctok, err) in
            
            guard ctok != nil && err == nil else {
                UIHelper.showAlertInView(self, msg: "Invalid payment card!")
                return
            }
            
            let data = ["email" : email, "name" : name, "phone" : phoneNumber, "mode" : model, "sn" : serial, "carrier" : carrier, "credit" : "0"]
            
            GentsConfig.getPaymentValues { [weak self] json in
                
                guard json != nil else {
                    return
                }
                
                let iPay = json!["initPayment"].float
                let mPay = json!["monthlyPayment"].float
                
                guard iPay != nil && mPay != nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController.init(title: "Payment plan", message: "Dear customer, Kindly be informed that by signing-up with Mobile Gents, you will pay $\(iPay!) as initail payment and $\(mPay!) monthly", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { action in
                        
                        let iCharge = Int(iPay! * 100)
                        let mCharge = Int(mPay! * 100)
                        
                        GentsUser.shared.registerUser(withName: name, email: email, password: pwd, cardToken: ctok, initCharge: iCharge, monthCharge: mCharge, userData: data) { isOK in
                            
                            if isOK {
                                let sb = UIStoryboard.init(name: "Main_NewDesign", bundle: nil)
                                let vc = sb.instantiateViewController(withIdentifier: "tabsController")
                                
                                self?.present(vc, animated: false, completion: nil)
                            } else {
                                UIHelper.showAlertInView(self, msg: "Signup failed!")
                            }
                        }
                    }))
                    
                    alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
                    
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
}
