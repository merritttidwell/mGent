//
//  GSigninViewController.swift
//  Gent
//
//  Created by Ossama Mikhail on 12/31/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit

class GSigninViewController: GUIViewController {
    
    @IBOutlet weak var tfEmail : UITextField?
    @IBOutlet weak var tfPassword : UITextField?

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
        /*GentsUser.shared.loginUser(withEmail: "sam10@gmail.com", password: "Sam1234") { (guser) in
            
            GentsUser.shared.pay(amount: 1010, description: "test paymet for Sam10", host: self, completion: {err in
                
                if err == nil {
                    print("SUCCEEDED")
                }
            })
            
            print(guser)
        }*/
    }
    
    @IBAction func doLogin() {
        print("login")
        
        let grp = DispatchGroup()
        grp.enter()
        var isOK = false
        
        GentsUser.shared.loginUser(withEmail: tfEmail?.text ?? "", password: tfPassword?.text ?? "") { guser in
            if guser != nil {
                isOK = true
            }
            
            grp.leave()
        }
        
        grp.notify(queue: .main) {
            if isOK {
                
                print("login succeeded")
                
                let sb = UIStoryboard.init(name: "Main_NewDesign", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "tabsController")
                
                //self.navigationController?.pushViewController(vc, animated: false)
                
                self.present(vc, animated: false, completion: nil)
                
                //self.performSegue(withIdentifier: "signin", sender: self)
            } else {
                UIHelper.showAlertInView(self, msg: "Login Failed!\nPlease check email / password")
            }
        }
    }

}
