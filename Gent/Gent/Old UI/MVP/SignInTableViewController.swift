//
//  SignInTableViewController.swift
//  Gent
//
//  Created by Christina Sund on 10/9/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit
import Firebase

class SignInTableViewController: UITableViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.keyboardType = UIKeyboardType.emailAddress;
        passwordTextField.isSecureTextEntry = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func signIn(emailAdd: String, pass: String) {
        Auth.auth().signIn(withEmail: emailAdd, password: pass) { (user, error) in
            
            if (error != nil) {
                print(error)
                
                let myAlert = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: .alert) //you can change message to whatever you want.
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                myAlert.addAction(okAction)
                self.present(myAlert, animated: true, completion: nil)

                
                return
            }
            print("User Successfully Signed In")
            
        }
    }

    @IBAction func submitButtonPressed(_ sender: Any) {
        print("Submit Pressed")
        let email = emailTextField.text
        let password = passwordTextField.text
        GentsUser.loginUser(withEmail: email!, password: password!) { (user) in
            if ((user) != nil) {
                
                print("user logged in sucessfully")
            }
        }
    
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
