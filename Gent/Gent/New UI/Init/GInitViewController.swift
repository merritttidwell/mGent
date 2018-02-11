//
//  GInitViewController.swift
//  Gent
//
//  Created by Ossama Mikhail on 12/28/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit

class GInitViewController: GUIViewController {
    
    @IBOutlet weak var signupLabel : UILabel?
    @IBOutlet weak var saveLabel : UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        signupLabel?.text = "Sign up to MVP for better \(UIDevice.current.modelName) prices"
        saveLabel?.text = "Save \(11)% on repairs, and get an extra \(22)% when you trade in your phone"
        
        if GentsUser.firebaseGentsAuth()?.currentUser != nil {
            GentsUser.shared.reloadUserData(completion: { isReloaded in
                let sb = UIStoryboard.init(name: "Main_NewDesign", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "tabsController")
                
                self.present(vc, animated: false, completion: nil)
            })
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
    
    @IBAction func unwindToInitView(segue: UIStoryboardSegue) {
        print("unwind")
    }
}
