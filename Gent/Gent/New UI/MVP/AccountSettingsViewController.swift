//
//  AccountSettingsViewController.swift
//  Gent
//
//  Created by Merritt Tidwell on 7/29/18.
//  Copyright © 2018 Christina Sund. All rights reserved.
//

import UIKit

class AccountSettingsViewController: GUIViewController {

    @IBOutlet weak var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTF.text = GentsUser.shared.email
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
       
        
        GentsUser.shared.logOutUser { [weak self] isOK in
            
            if isOK {
                
                self?.dismiss(animated: true, completion: nil)
            
            
            } else {
                UIHelper.showAlertInView(self!, msg: "Signout failed")
            }
        }
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
