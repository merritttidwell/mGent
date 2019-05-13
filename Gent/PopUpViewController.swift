//
//  PopUpViewController.swift
//  Gent
//
//  Created by Merritt Tidwell on 5/5/19.
//  Copyright © 2019 Christina Sund. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
  
    var isUserLoggedIn = Bool ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if GentsUser.firebaseGentsAuth()?.currentUser == nil {
            //button title return to home
        }else  {
            
        }
    
        // Do any additional setup after loading the view.
    }
    

    @IBAction func buttonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    
    }
    

}
