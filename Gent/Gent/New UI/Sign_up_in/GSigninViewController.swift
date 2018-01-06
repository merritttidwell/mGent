//
//  GSigninViewController.swift
//  Gent
//
//  Created by Ossama Mikhail on 12/31/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit

class GSigninViewController: GUIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidAppear(_ animated: Bool) {
        GentsUser.shared.loginUser(withEmail: "sam10@gmail.com", password: "Sam1234") { (guser) in
            
            GentsUser.shared.pay(amount: 1010, description: "test paymet for Sam10", host: self, completion: {err in
                
                if err == nil {
                    print("SUCCEEDED")
                }
            })
            
            print(guser)
        }
    }

}
