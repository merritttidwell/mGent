//
//  paymentTestViewController.swift
//  GentTests
//
//  Created by Ossama Mikhail on 12/3/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit

class paymentTestViewController: UIViewController {
    
    var userEmail = ""
    var userPassword = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        User.loginUser(withEmail: "sam2@gmail.com", password: "Sam1234") { [unowned self] (user) in
            print("login user = \(String(describing: user))")
            if user != nil {
                
                //user?.pay(amount: 200, description: "T", host: self)
                user?.pay(amount: 320, description: "T!!!@@!", host: self, completion: { (err) in
                    
                    print(err)
                })
            }
        }
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
        super.viewDidAppear(animated)
        
        /*User.loginUser(withEmail: userEmail, password: userPassword) { [weak self] (user) in
            print("login user = \(String(describing: user))")
            if user == nil {
                return
            }
            
            user?.pay(amount: 500, description: "TT", host: self!, completion: { (err) in
                if err != nil {
                    print("testMakePayment - failed =>")
                    print(err as Any)
                }
            })
        }*/
    }
}
