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

class DeviceDetailViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    

    @IBOutlet weak var lblCCExpDate: UILabel!
    @IBOutlet weak var deviceCreditLabel: UILabel!
    
    @IBOutlet weak var freeScreenRepairLabel: UILabel!
    
    var paymentList : [JSON]?
    var deviceDictionary : [String: String]?
    var user : [String: Any]?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var credit: String
        
        if deviceDictionary != nil {
            self.title = deviceDictionary!["deviceName"]
             credit  = (deviceDictionary!["deviceCredit"])!
        }else {
            self.title = "Main"
        }
     
        GentsUser.fetchCurrentUser { (currentUser) in
            self.user = currentUser
            
            print("currrent User...", self.user)
            self.loadDeviceCredit()


        }
        
    
        loadDeviceCredits()
    
    }
    
    
    func loadDeviceCredit() {
        
        let credit = self.user?["mainPurchaseCredit"] as! String
        
        let attributedText = NSMutableAttributedString(string: "MVP Purchase Credit Available\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)])
        
        attributedText.append(NSAttributedString(string: "$\(credit)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 35), NSAttributedStringKey.foregroundColor: UIColor.blue]))
        
        self.deviceCreditLabel.attributedText = attributedText
        
    }
    
    
    
    func loadDeviceCredits()  {
        
        //need to pull device credit
        
        let attributedText = NSMutableAttributedString(string: "Free Screen Repairs\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)])
         attributedText.append(NSAttributedString(string: "1", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 35), NSAttributedStringKey.foregroundColor: UIColor.blue]))
         attributedText.append(NSAttributedString(string: "2", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 35), NSAttributedStringKey.foregroundColor: UIColor.blue]))
         attributedText.append(NSAttributedString(string: "3", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 35), NSAttributedStringKey.foregroundColor: UIColor.blue]))
        
        
        freeScreenRepairLabel.attributedText = attributedText
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        print(user)
        
        
        if GentsUser.firebaseGentsAuth()?.currentUser != nil {
            self.view.viewWithTag(1)?.isHidden = false
            self.view.viewWithTag(2)?.isHidden = true
            
        //    self.updateCC()
            
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

               // self.lastPaymentDate = dayTimePeriodFormatter.string(from: date as Date)
               // self.lastPaymentAmount = jsonData["amount_due"].intValue/100
             
                self.table.reloadData()

            }
            
    
         }
        
    }
    
//    
//    private func updateCC() {
//        let cusCtx = GentsUser.shared.customerCtx
//        cusCtx?.retrieveCustomer({ [weak self] cus, err in
//            guard cus != nil && err == nil else {
//                return
//            }
//            
//            let card = cus?.defaultSource as? STPCard
//            print(card as Any)
//            
//            guard card != nil else {
//                self?.lblCC.text = "N/A"
//                self?.lblCCExpDate.text = "N/A"
//                return
//            }
//            
//            self?.lblCC.text = "xxxx-xxxx-xxxx-\((card?.last4)!)"
//            self?.lblCCExpDate.text = "\((card?.expMonth)!)/\((card?.expYear)!)"
//        })
//    }
//    

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
         //   cell.textLabel?.text = "Paid $\(lastPaymentAmount).00 on \(lastPaymentDate)"
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
