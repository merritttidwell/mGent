//
//  NotSignedInViewController.swift
//  Gent
//
//  Created by Merritt Tidwell on 7/29/18.
//  Copyright © 2018 Christina Sund. All rights reserved.
//

import UIKit

class NotSignedInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
    
        
        self.dismiss(animated: true) {
            
             let vc = UIStoryboard(name: "Main_NewDesign", bundle: nil).instantiateViewController(withIdentifier: "init") as? GInitViewController
            
        
            self.present(vc!, animated: true, completion: nil)
            
            
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
