//
//  MainAccountTableViewController.swift
//  Gent
//
//  Created by Merritt Tidwell on 6/2/18.
//  Copyright © 2018 Christina Sund. All rights reserved.
//

import UIKit

class MainAccountTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (GentsUser.firebaseGentsAuth()?.currentUser == nil) {
            
            
            self.dismiss(animated: true) {
                
                let vc = UIStoryboard(name: "Main_NewDesign", bundle: nil).instantiateViewController(withIdentifier: "signup") as UIViewController
                
                
            }
            
             let vc = UIStoryboard(name: "Main_NewDesign", bundle: nil).instantiateViewController(withIdentifier: "notSignedInVC") as? NotSignedInViewController
            
            self.present(vc!, animated: true, completion: nil)
            
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if indexPath.row == 0 {
        cell.textLabel?.text = "Connected Devices"
        }
       
        if indexPath.row == 1 {
        cell.textLabel?.text = "Add a Device"
        
        }
        if indexPath.row == 2 {
            cell.textLabel?.text = "Account Settings"
        }
        
        return cell
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        if indexPath.row == 0 {
            let viewController = UIStoryboard(name: "Main_NewDesign", bundle: nil).instantiateViewController(withIdentifier: "LinesTVC") as UIViewController

            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        if indexPath.row == 1 {
            let viewController = UIStoryboard(name: "Main_NewDesign", bundle: nil).instantiateViewController(withIdentifier: "addPhoneDetails") as UIViewController
            
            self.navigationController?.pushViewController(viewController, animated: true)
        
        }
        
        if indexPath.row == 2 {
            let viewController = UIStoryboard(name: "Main_NewDesign", bundle: nil).instantiateViewController(withIdentifier: "accountSettings") as UIViewController
            
            self.navigationController?.pushViewController(viewController, animated: true)
            
            
            
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

}
