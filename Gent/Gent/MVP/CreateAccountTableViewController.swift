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
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.isEnabled = false
        
        formLabels = ["Name","Email","Password", "Phone","Carrier", "Serial", "Model"]
        formPlaceholders = ["John Smith","example@email.com","Enter Password","8585551234", "Verizon", "23425555", "iPhone 6s"]
        values = [nil, nil, nil, nil, nil, nil, nil]
        
        tableView.estimatedRowHeight = 30
        
    }

    // MARK: - Table view data source
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
        cell.formLabel.font =
            UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        cell.formLabel.text = formLabels[row]
        cell.formTextField.placeholder = formPlaceholders[row]
        // Secure entry on password field
        if row == 2 { cell.formTextField.isSecureTextEntry = true }
        // Email keyboard on email field
        if row == 1 { cell.formTextField.keyboardType = UIKeyboardType.emailAddress }
        cell.delegate = self
        return cell
    }
 
    @IBAction func submitButton(_ sender: Any) {
    
        print(#function, values)
        
        let email = values[1]
        let name = values[0]
        let phone = values[3]
        let password = values[2]
        let carrier = values[4]
        let serial = values[5]
        let model = values[6]
        
        Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in
            if (error != nil) {
                print(error)
                return
            }
            
            // successfuly authenticated user
            guard let uid = user?.uid else { return }
            
            // Create database reference
            var ref: DatabaseReference!
            ref = Database.database().reference()
            // Create users reference
            let usersRef = ref.child("users").child(uid)
            // Create dictionary with form info
            let values = ["name": name, "email": email, "phone": phone, "carrier": carrier, "sn":serial,"model":model]
            usersRef.updateChildValues(values)
        }
    
    }


    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

// delegate protocol to update model as text fields change
extension CreateAccountTableViewController: FormTableViewCellDelegate {
    func fieldValueChanged(cell: UITableViewCell, textField: UITextField) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        values[indexPath.row] = textField.text
        if values[0] != nil && values[1] != nil && values[2] != nil && values[3] != nil && values[4] != nil && values[5] != nil && values[6] != nil {
            submitButton.isEnabled = true
        }
    }
}
