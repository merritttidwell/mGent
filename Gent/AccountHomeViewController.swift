//
//  AccountHomeViewController.swift
//  Gent
//
//  Created by Merritt Tidwell on 3/6/19.
//  Copyright © 2019 Christina Sund. All rights reserved.
//

import UIKit

class AccountHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet
    var tableView: UITableView!
    let screenNames = ["Connected Devices", "Add New Device", "Account Settings"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        // Do any additional setup after loading the view.
        setUpNavigationBarItems()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "wallpaper_edit_shield.png")!)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        
      
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
