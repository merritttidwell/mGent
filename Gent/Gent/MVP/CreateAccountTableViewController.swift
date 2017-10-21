//
//  CreateAccountTableViewController.swift
//  Gent
//
//  Created by Christina Sund on 10/4/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit
import Firebase


class CreateAccountTableViewController: UITableViewController {
    
    var formLabels = [String]()
    var formPlaceholders = [String]()
    var values = [String?]()
    var userData = [String: String]()
    
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // submitButton.isEnabled = false
        
        formLabels = ["Name","Email","Password", "Phone","Carrier", "Serial", "Model"]
        formPlaceholders = ["John Smith","example@email.com","Enter Password","8585551234", "Verizon", "23425555", "iPhone 6s"]
        
        tableView.estimatedRowHeight = 30
        
    }
    
  //   MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formLabels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier:
            "FormTableCell", for: indexPath)
            as! FormTableViewCell
        
        let row = indexPath.row
        
        cell.configure(titleLabel: formLabels[row], text: "", placeholder: formPlaceholders[row])
        
        // Secure entry on password field
        if row == 2 { cell.formTextField.isSecureTextEntry = true }
        // Email keyboard on email field
        if row == 1 { cell.formTextField.keyboardType = UIKeyboardType.emailAddress }
        cell.delegate = self
        return cell
    }
    
    @IBAction func submitButton(_ sender: Any) {
        
        createFirebaseUser(userData: userData)
        
    }
    
    internal func createFirebaseUser (userData : [String: String]) {
        
        let email =  userData["email"]  ?? ""
        let password = userData["password"]  ?? ""
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error ?? "unknown error")
                return
            }
            
            guard let uuid = user?.uid else {return}
            
            // Create database reference
            var ref: DatabaseReference!
            ref = Database.database().reference()
            // Create users reference
            let usersRef = ref.child("users").child(uuid)
            usersRef.updateChildValues(self.userData)
            
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

// delegate protocol to update model as text fields change
extension CreateAccountTableViewController: FormTableViewCellDelegate {
    func fieldValueChanged(textField: UITextField, cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let userKey = formLabels[indexPath.row]
        let userValue = textField.text ?? ""
        userData[userKey] = userValue
        
    }
}
