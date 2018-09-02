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

    @IBOutlet weak var deviceCreditLabel: UILabel!
    
    var paymentList : [JSON]?
    var deviceDictionary : [String: String]?
    var lastPaymentDate =  String()
    var lastPaymentAmount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var creditString: String
        var credit: String
        
        if deviceDictionary != nil {
            self.title = deviceDictionary!["deviceName"]
             credit  = (deviceDictionary!["deviceCredit"])!
             creditString = "MVP Credit $\(credit)"
        }else {
            self.title = "Main"
             credit = String(GentsUser.shared.repairCredit)
             creditString = "MVP Credit $\(credit)"
        }
    
        self.deviceCreditLabel.text = creditString
        
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
            
            var subscriptionID = String()
            
            if deviceDictionary == nil {

                 subscriptionID = GentsUser.shared.mainSubscriptionID
                
            } else {
                
                subscriptionID = deviceDictionary!["subscriptionId"]!

            }

         
            GentsUser.shared.listInvoicesForSubscription(subscriptionID: subscriptionID) { (json, err) in
                let jsonData = JSON(json!)
                let date = NSDate(timeIntervalSince1970: TimeInterval(jsonData["date"].intValue))
                let dayTimePeriodFormatter = DateFormatter()
                dayTimePeriodFormatter.dateFormat = "MMM dd YYYY"

                self.lastPaymentDate = dayTimePeriodFormatter.string(from: date as Date)
                self.lastPaymentAmount = jsonData["amount_due"].intValue/100
             
                self.table.reloadData()

            }
            
    
         
            
//            GentsUser.shared.getPayments(subscriptionID: subscriptionID, completed: { [weak self] json in
//                self?.paymentList = json?["data"].array
//                self?.table.reloadData()
//            })
//        } else {
//            self.view.viewWithTag(1)?.isHidden = true
//            self.view.viewWithTag(2)?.isHidden = false
//        }
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
      
    
        return 1
        
        //    return (paymentList?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath)
        
       // let pay = paymentList![indexPath.row]
       // let amount = pay["amount"].floatValue / 100.0
        //let epoch = pay["created"].doubleValue
        //let localTime = UIHelper.UTCToLocal(time: epoch)
        
        //let comp = UIHelper.getDateCompnents(date: localTime)
    
        ///more work here
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Paid $\(lastPaymentAmount).00 on \(lastPaymentDate)"
        } else {
           // cell.textLabel?.text = "Next payment of $\(amount) due (\(comp.month)/\(comp.year))"
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
