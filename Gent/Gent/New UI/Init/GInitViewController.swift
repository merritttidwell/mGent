//
//  GInitViewController.swift
//  Gent
//
//  Created by Ossama Mikhail on 12/28/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class GInitViewController: GUIViewController {
    
    @IBOutlet weak var signupLabel : UILabel?
    @IBOutlet weak var saveLabel : UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if GentsUser.firebaseGentsAuth()?.currentUser != nil {
            GentsUser.shared.reloadUserData(completion: { isReloaded in
                let sb = UIStoryboard.init(name: "Main_NewDesign", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "tabsController")
                
                self.present(vc, animated: false, completion: nil)
            })
        } else {
            GentsConfig.getModelConfig(completed: { specs -> (Void) in
                DispatchQueue.main.async { [weak self] in
                    self?.signupLabel?.text = "Sign up to MVP for better \(UIDevice.current.modelName) prices"
                    
                    guard specs != nil else {
                        self?.saveLabel?.text = "Save xx% on repairs, and get an extra xx% when you trade in your phone"
                        return
                    }
                    
                    self?.saveLabel?.text = "Save \(String(describing: specs!["save"]))% on repairs, and get an extra \(String(describing: specs!["extra"]))% when you trade in your phone"
                }
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
