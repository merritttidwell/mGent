//
//  GMVPTabViewController.swift
//  Gent
//
//  Created by Ossama Mikhail on 12/31/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit

class GMVPTabViewController: UIViewController, UITableViewDataSource {
    
    //@IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var lblCredit: UILabel!
    @IBOutlet weak var lblCC: UILabel!
    @IBOutlet weak var lblCCExpDate: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if GentsUser.firebaseGentsAuth()?.currentUser != nil {
            self.view.viewWithTag(1)?.isHidden = false
            self.view.viewWithTag(2)?.isHidden = true
        } else {
            self.view.viewWithTag(1)?.isHidden = true
            self.view.viewWithTag(2)?.isHidden = false
        }
        
        //let lblCredit = self.view.viewWithTag(1)?.subviews[0].viewWithTag(1) as! UILabel
        lblCredit.text = "MVP repair credit: $\(GentsUser.shared.repairCredit)"
        
        //let lblCC = self.view.viewWithTag(1)?.subviews[0].viewWithTag(2) as! UILabel
        lblCC.text = "1234-1234-1234-1234"
        
        lblCCExpDate.text = "11/22"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath)
        
        cell.textLabel?.text = "Last payment $xx (xx/xx)"
        
        return cell
    }
    
    @IBAction func doSignout() {
        GentsUser.shared.logOutUser { [weak self] isOK in
            
            if isOK {
                self?.performSegue(withIdentifier: "signout", sender: self)
            } else {
                UIHelper.showAlertInView(self!, msg: "Signout failed")
            }
        }
    }
    
    @IBAction func editPaymentMethod() {
        print("edit payment method")
    }
}
