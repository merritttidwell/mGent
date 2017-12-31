//
//  GSignupViewController.swift
//  Gent
//
//  Created by Ossama Mikhail on 12/30/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit

class GSignupViewController: GUIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfFirstName : UITextField?
    @IBOutlet weak var tfLastName : UITextField?
    @IBOutlet weak var tfEmail : UITextField?
    @IBOutlet weak var tfPassword : UITextField?
    @IBOutlet weak var tfRePassword : UITextField?
    @IBOutlet weak var tfPhoneNumber : UITextField?
    @IBOutlet weak var tfCarrier : UITextField?
    @IBOutlet weak var tfSerial : UITextField?
    @IBOutlet weak var tfModel : UITextField?

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
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    @IBAction private func doSignup() {
        
    }
}
