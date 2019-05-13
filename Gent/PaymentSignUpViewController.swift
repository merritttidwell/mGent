//
//  PaymentSignUpViewController.swift
//  Gent
//
//  Created by Merritt Tidwell on 3/17/18.
//  Copyright © 2018 Christina Sund. All rights reserved.
//

import UIKit
import Stripe


class PaymentSignUpViewController: GUIViewController, STPPaymentCardTextFieldDelegate {

    var paymentCardTextField : STPPaymentCardTextField?
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var name = String()
    var email = String()
    var pwd = String()
    var userData = [String: String] ()
    
    var initalPayment = Float ()
    var monthlyPayment = Float ()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GentsConfig.getPaymentValues { [weak self] json in
            
            guard json != nil else {
                return
            }
            
            //fix later
            
            self?.initalPayment = json!["initPayment"].float!
            self?.monthlyPayment = json!["monthlyPayment"].float!
            
            guard self?.initalPayment != nil && self?.monthlyPayment != nil else {
                return
            }
        }
        
       
        self.activityIndicator.isHidden = true
        
        readUserDefaults()
      
         paymentCardTextField = STPPaymentCardTextField.init(frame: CGRect(x: 10, y: 0, width: view.frame.width - 20, height: 44))
        paymentCardTextField?.delegate = self
     
        cardView.addSubview(paymentCardTextField!)

        
        showPaymentAlert()
        
        
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

        //removed since we are just collecting model
        
        
//        if let tserial = defaults.string(forKey: "serialNumber"){
//            userData["serial"] = tserial
//
//        }
//
//        if let tcarrier = defaults.string(forKey: "carrier"){
//            userData["carrier"] = tcarrier
//        }
//
//        if let tnumber = defaults.string(forKey: "phoneNumber") {
//            userData["number"] = tnumber
//        }
        
        
        
    }
    
    
    // MARK: - STPPaymentCardTextFieldDelegate
   /*
    func paymentCardTextFieldDidBeginEditing(_ textField: STPPaymentCardTextField) {
        OnScreenKBListener.shared.start({ notf in
            UIHelper.animateViewUp(self.view, with: OnScreenKBListener.shared.keyboardHeight)
        })
        UIHelper.animateViewUp(self.view, with: OnScreenKBListener.shared.keyboardHeight)
    }
    
    func paymentCardTextFieldDidEndEditing(_ textField: STPPaymentCardTextField) {
        UIHelper.animateViewDown(self.view)
    }
    */
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        // Toggle buy button state
        signUpButton.isEnabled = textField.isValid
    }
    
    func showPaymentAlert() {
        
        let message = "Dear customer, Kindly be informed that by signing-up with Mobile Gents, you will pay $\(6) monthly"
        
        let alertController = UIAlertController(title: "One More Step", message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "Yes!", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
             self.navigationController?.popToRootViewController(animated: true)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
       
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

                   // let iPay = json!["initPayment"].float
                    let mPay = json!["monthlyPayment"].float

                    guard mPay != nil else {
                        return
                    }

 
                        
                          //  let iCharge = Int((self?.initalPayment)! * 100)
                            let mCharge = Int((self?.monthlyPayment)! * 100)
                    
                            self?.activityIndicator.isHidden = false
                        
                            GentsUser.shared.registerUser(withName: self!.name, email: self!.email, password: self!.pwd, cardToken: ctok, monthCharge: mCharge, userData: self!.userData) { isOK, Error in
                                
                                if isOK {
                                    DispatchQueue.main.async {
                                        self?.activityIndicator.isHidden = false
                                        let sb = UIStoryboard.init(name: "Main_NewDesign", bundle: nil)
                                        let vc = sb.instantiateViewController(withIdentifier: "MainNavVC")
                                        self?.present(vc, animated: false, completion: nil)
                                        
                                    }

                                } else {
                                    DispatchQueue.main.async {
                                        self?.activityIndicator.stopAnimating()
                                        let err = Error?.localizedDescription  ?? "nothing"
                                        
                                        
                                        let alertController = UIAlertController(title: "Error", message: err, preferredStyle: .alert)
                                        
                                        
                                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                            UIAlertAction in
                                            
                                            self?.navigationController?.popToRootViewController(animated: true)
                                        }
                                        
                                        alertController.addAction(okAction)
                                        
                                        self?.present(alertController, animated: true, completion: nil)
                                    }
                                }
                            }
                        
                    
                }
            })
        }
    }

