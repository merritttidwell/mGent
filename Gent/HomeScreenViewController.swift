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
    var screenNames = ["Repair", "Buy Back", "MVP Account"]
    var isMVP = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if GentsUser.firebaseGentsAuth()?.currentUser == nil {
           isMVP = false
           screenNames = ["Repair", "Buy Back", "MVP Benefits"]
        }

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "wallpaper_edit_shield.png")!)
        
        setUpNavigationBarItems()
        
        // Do any additional setup after loading the view.
        
    
    
    }
    
    private func setUpNavigationBarItems() {
        
        let image = UIImage.init(named: "nav")
        let titleImageView = UIImageView(image: image)
        titleImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        titleImageView.contentMode = .scaleAspectFit
        //     titleImageView.backgroundColor = .gray
        navigationItem.titleView = titleImageView
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        
    }
    
    //TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "screenNameCell", for: indexPath)
        
        cell.textLabel?.text = screenNames[indexPath.row]
        cell.textLabel?.font = UIFont(descriptor: UIFontDescriptor(name: "Gill Sans", size: 20), size: 20)
        cell.textLabel?.textAlignment = .center
        
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
            
            if isMVP == false {
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MVPBenefitsHome") as! GInitViewController
                self.navigationController?.show(nextViewController, sender: self)
            }else {
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AccountHomeVC") as! AccountHomeViewController
                self.navigationController?.show(nextViewController, sender: self)
            }
            
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
