//
//  GMVPTabViewController.swift
//  Gent
//
//  Created by Ossama Mikhail on 12/31/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit
import Stripe
import Firebase
import SwiftyJSON

class GMVPTabViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    
    @IBOutlet weak var lblCredit: UILabel!
    @IBOutlet weak var lblCC: UILabel!
    @IBOutlet weak var lblCCExpDate: UILabel!

 
    var paymentList : [JSON]?
    var deviceDictionary : [String: String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(deviceDictionary)
        
        
        if deviceDictionary != nil {
            self.title = deviceDictionary!["deviceName"] as? String
        }
        
        self.title = "Main"
    
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "wallpaper_edit_shield.png")!)
   
        
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
            
            
            self.updateCC()
            
            GentsUser.shared.getPayments(completed: { [weak self] json in
                self?.paymentList = json?["data"].array
                self?.table.reloadData()
            })
        } else {
            self.view.viewWithTag(1)?.isHidden = true
            self.view.viewWithTag(2)?.isHidden = false
        }
    }
    
    private func updateCC() {
        let cusCtx = GentsUser.shared.customerCtx
        cusCtx?.retrieveCustomer({ [weak self] cus, err in
            guard cus != nil && err == nil else {
                return
            }
            
            let card = cus?.defaultSource as? STPCard
            print(card as Any)
            
            guard card != nil else {
                self?.lblCC.text = "N/A"
                self?.lblCCExpDate.text = "N/A"
                return
            }
            
            self?.lblCC.text = "xxxx-xxxx-xxxx-\((card?.last4)!)"
            self?.lblCCExpDate.text = "\((card?.expMonth)!)/\((card?.expYear)!)"
        })
    }
    

    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if paymentList == nil {
            return 0
        }
        return (paymentList?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath)
        
        let pay = paymentList![indexPath.row]
        let amount = pay["amount"].floatValue / 100.0
        let epoch = pay["created"].doubleValue
        let localTime = UIHelper.UTCToLocal(time: epoch)
        
        let comp = UIHelper.getDateCompnents(date: localTime)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Last payment $\(amount) (\(comp.month)/\(comp.year))"
        } else if indexPath.row == (paymentList?.count)! - 1 {
            cell.textLabel?.text = "First payment $\(amount) (\(comp.month)/\(comp.year))"
        } else {
            cell.textLabel?.text = "Next payment $\(amount) (\(comp.month)/\(comp.year))"
        }
        
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
        
        
        GentsUser.shared.addPaymentCard(host: self)
    }
    
}
