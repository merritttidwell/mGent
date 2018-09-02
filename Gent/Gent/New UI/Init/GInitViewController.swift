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
    @IBOutlet weak var decorativeView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        
        let sb = UIStoryboard.init(name: "Main_NewDesign", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "tabsController")

        self.present(vc, animated: true, completion: nil)
    
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
        signupLabel?.text = "Sign up to MVP for better \(UIDevice.current.modelName) prices"
        saveLabel?.text = "Save on repairs, and get money back when you trade in your phone"
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "wallpaper_edit_shield.png")!)
                
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
                        self?.saveLabel?.text = "Save on repairs, and get money back when you trade in your phone"
                        return
                    }
                    
                    self?.saveLabel?.text = "Save \(35)% on repairs, and get an extra \(25)% when you trade in your phone"
                    
                    
                  //  self?.saveLabel?.text = "Save \(String(describing: specs!["save"]))% on repairs, and get an extra \(String(describing: specs!["extra"]))% when you trade in your phone"
                
                }
            })
        }
    }
    
    @IBAction func unwindToInitView(segue: UIStoryboardSegue) {
        print("unwind")
    }
}
