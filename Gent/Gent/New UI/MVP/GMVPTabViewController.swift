//
//  GMVPTabViewController.swift
//  Gent
//
//  Created by Ossama Mikhail on 12/31/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit
import Stripe

class GMVPTabViewController: UIViewController, UITableViewDataSource {
    
    //@IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var lblCredit: UILabel!
    @IBOutlet weak var lblCC: UILabel!
    @IBOutlet weak var lblCCExpDate: UILabel!

    var payctx :STPPaymentContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard GentsUser.shared.customerCtx != nil else {
            payctx = nil
            return
        }
        
        payctx = STPPaymentContext(customerContext: GentsUser.shared.customerCtx!)
        payctx?.hostViewController = self
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
            
            lblCredit.text = "MVP repair credit: $\(GentsUser.shared.repairCredit)"
            
            self.updateCC()
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
            print(card)
            
            guard let cc = card else {
                self?.lblCC.text = "N/A"
                self?.lblCCExpDate.text = "N/A"
                return
            }
            
            self?.lblCC.text = "xxxx-xxxx-xxxx-\((card?.last4)!)"
            self?.lblCCExpDate.text = "\((card?.expMonth)!)/\((card?.expYear)!)"
        })
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
        
        guard payctx != nil else {
            return
        }
        
        GentsUser.shared.pay(amount: 100, description: "test1", host: self) { [unowned self] err in
            print(err as Any)
            
            if err != nil {
                
                let e = err! as NSError
                
                if e.domain == "Payment" && e.code == 4 {
                    DispatchQueue.main.async {
                        //UIHelper.showAlertInView(self, msg: "Payment failed!\nPlease add payment card.")
                        self.payctx?.presentPaymentMethodsViewController()
                    }
                }
            }
        }
    }
}
