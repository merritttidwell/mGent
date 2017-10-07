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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FirebaseApp.configure()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        formLabels = ["Name","Email","Phone", "Carrier", "Serial", "Model"]
        formPlaceholders = ["John Smith","example@email.com","8585551234", "Verizon", "23425555", "iPhone 6s"]
        
        tableView.estimatedRowHeight = 30

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return formLabels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =            self.tableView.dequeueReusableCell(withIdentifier:
            "FormTableCell", for: indexPath)
            as! FormTableViewCell
        
        let row = indexPath.row
        cell.formLabel.font =
            UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        cell.formLabel.text = formLabels[row]
        cell.formTextField.placeholder = formPlaceholders[row]
        return cell
    }
 
    @IBAction func submitButton(_ sender: Any) {
    
        // let index = IndexPath(row: 0, section: 0)
        // let cell: FormTableViewCell = self.myTableView.cellForRow(at: index) as! FormTableViewCell
        
        
        Auth.auth().createUser(withEmail: "email", password: "password") { (user, error) in
            // ...
        }
    
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
