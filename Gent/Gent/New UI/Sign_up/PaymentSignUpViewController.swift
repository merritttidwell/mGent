//
//  PaymentSignUpViewController.swift
//  Gent
//
//  Created by Merritt Tidwell on 3/17/18.
//  Copyright © 2018 Christina Sund. All rights reserved.
//

import UIKit
import Stripe


class PaymentSignUpViewController: UIViewController, STPPaymentCardTextFieldDelegate {

    var paymentCardTextField : STPPaymentCardTextField?
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var name = String()
    var email = String()
    var pwd = String()
    var userData = [String: String] ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.activityIndicator.isHidden = true
        
        readUserDefaults()

        
        paymentCardTextField = STPPaymentCardTextField.init(frame: cardView.bounds)
        paymentCardTextField?.delegate = self
        cardView.addSubview(paymentCardTextField!)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        OnScreenKBListener.shared.start({ notf in
            print(notf)
        }, onHide: nil)
    }

    
    func readUserDefaults () {
        
        let defaults = UserDefaults.standard
        
        if let tname = defaults.string(forKey: "fullName") {
            name = tname
        }
        
        if let temail = defaults.string(forKey: "email") {
            email = temail
        }
       
        if let tpwd = defaults.string(forKey: "password") {
            pwd = tpwd
        }
        
        if let tmodel = defaults.string(forKey: "model") {
            userData["model"] = tmodel
        }
        
        if let tserial = defaults.string(forKey: "serialNumber"){
            userData["serial"] = tserial
            
        }
        
        if let tcarrier = defaults.string(forKey: "carrier"){
            userData["carrier"] = tcarrier
        }
        
        if let tnumber = defaults.string(forKey: "phoneNumber") {
            userData["number"] = tnumber
        }
        
        
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
        signUpButton.isEnabled = textField.isValid
    }
    
    @IBAction private func signUp() {
        print(paymentCardTextField!.cardParams)

        STPAPIClient.shared().createToken(withCard: paymentCardTextField!.cardParams, completion: { (ctok, err) in

                guard ctok != nil && err == nil else {
                    UIHelper.showAlertInView(self, msg: "Invalid payment card!")
                    return
                }
            
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
                        
                        let alert = UIAlertController.init(title: "Payment plan", message: "Dear customer, Kindly be informed that by signing-up with Mobile Gents, you will pay $\(iPay!) as initial payment and $\(mPay!) monthly", preferredStyle: .alert)

                        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { action in
                            self?.activityIndicator.isHidden = false
                            self?.activityIndicator.startAnimating()

                            
                            let iCharge = Int(iPay! * 100)
                            let mCharge = Int(mPay! * 100)
                            
                            GentsUser.shared.registerUser(withName: self!.name, email: self!.email, password: self!.pwd, cardToken: ctok, initCharge: iCharge, monthCharge: mCharge, userData: self!.userData) { isOK in
                                
                                if isOK {
                                    let sb = UIStoryboard.init(name: "Main_NewDesign", bundle: nil)
                                    let vc = sb.instantiateViewController(withIdentifier: "tabsController")

                                    self?.present(vc, animated: false, completion: nil)
                                } else {
                                    self?.activityIndicator.stopAnimating()

                                    UIHelper.showAlertInView(self, msg: "Signup failed!")
                                }
                            }
                        }))

                        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
                        
                        
                        self?.present(alert, animated: true, completion: nil)
                        self?.activityIndicator.isHidden = false

                    }
                }
            })
        }
    }

