//
//  HomeScreenViewController.swift
//  Gent
//
//  Created by Merritt Tidwell on 3/3/19.
//  Copyright © 2019 Christina Sund. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
@IBOutlet
    var tableView: UITableView!
    let screenNames = ["Repair", "BuyBack", "MVP"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "screenNameCell", for: indexPath)
        
        cell.textLabel?.text = screenNames[indexPath.row]
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main_NewDesign", bundle:nil)

        
        if indexPath.row == 0  {
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RepairViewController") as! RepairViewController

            self.navigationController?.show(nextViewController, sender: self)
            
            
        }
        if indexPath.row == 1 {
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BuyBackViewController") as! BuyBackViewController
            self.navigationController?.show(nextViewController, sender: self)

        
        }
        if indexPath.row ==  2 {
            
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MVPBenefitsHome") as! GInitViewController
            self.navigationController?.show(nextViewController, sender: self)
            
            
        }
    }

}
