//
//  GSignupViewController.swift
//  Gent
//
//  Created by Ossama Mikhail on 12/30/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit

class GSignupViewController: GUIViewController, UITextFieldDelegate {
    
    var alertController : UIAlertController?
    var isAlertControllerDisplayed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            return
        }
        
        let lname = (self.view.viewWithTag(2) as? UITextField)?.text ?? ""
        guard lname != "" else {
            return
        }
        
        let name = fname + " " + lname
        
        let email = (self.view.viewWithTag(3) as? UITextField)?.text ?? ""
        guard email != "" else {
            return
        }
        
        let pwd = (self.view.viewWithTag(4) as? UITextField)?.text ?? ""
        let repwd = (self.view.viewWithTag(5) as? UITextField)?.text ?? ""
        guard pwd != "" && pwd == repwd else {
            return
        }
        
        let phoneNumber = (self.view.viewWithTag(6) as? UITextField)?.text ?? ""
        guard phoneNumber != "" else {
            return
        }
        
        let carrier = (self.view.viewWithTag(1001) as? UIButton)?.currentTitle ?? ""
        guard carrier != "" && carrier.lowercased() != "please select" else {
            return
        }
        
        let serial = (self.view.viewWithTag(7) as? UITextField)?.text ?? ""
        guard serial != "" else {
            return
        }
        
        let model = (self.view.viewWithTag(1002) as? UIButton)?.currentTitle ?? ""
        guard model != "" && model.lowercased() != "default" else {
            return
        }
        
        let data = ["email" : email, "name" : name, "phone" : phoneNumber, "mode" : model, "sn" : serial, "carrier" : carrier]
        
        GentsUser.shared.registerUser(withName: name, email: email, password: pwd, userData: data) { isOK in
            
            if !isOK {
                UIHelper.showAlertInView(self, msg: "Signup failed!")
            }
        }
    }
}
