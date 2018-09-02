//
//  LinesTableViewController.swift
//  Gent
//
//  Created by Merritt Tidwell on 6/3/18.
//  Copyright © 2018 Christina Sund. All rights reserved.
//

import UIKit

class LinesTableViewController: GUITableViewController {

    var deviceDictionary = [String : String] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        print(GentsUser.shared.devices)
        
        
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 1
        }else {
        
        return GentsUser.shared.devices.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if indexPath.section == 0 {
            cell.textLabel?.text = "main"
        }else{
        
            self.deviceDictionary = (GentsUser.shared.devices[indexPath.row] as! NSDictionary) as! [String : String]
            let deviceName = deviceDictionary["deviceName"]
            cell.textLabel?.text = deviceName

        }

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let viewController = UIStoryboard(name: "Main_NewDesign", bundle: nil).instantiateViewController(withIdentifier: "deviceDetail") as? GMVPTabViewController
        
        
        if indexPath.section == 0 {
       
        }else{
         
            viewController?.deviceDictionary = self.deviceDictionary
         
        }
    
        self.navigationController?.pushViewController(viewController!, animated: true)
        
        
        
    }

}
