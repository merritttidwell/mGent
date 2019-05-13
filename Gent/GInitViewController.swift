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
    
    @IBOutlet weak var mvpBenefitsLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var myView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "wallpaper_edit_shield.png")!)
        
        myView.layer.borderColor = UIColor.lightGray.cgColor
        myView.layer.borderWidth = 3
        
        let fontLarge =  UIFont(descriptor: UIFontDescriptor(name: "Gill Sans", size: 26), size: 26)
        let fontSmall =  UIFont(descriptor: UIFontDescriptor(name: "Gill Sans", size: 18), size: 18)
        
        let attributedText = NSMutableAttributedString(string: "MVP Benefits\n\n", attributes: [NSAttributedStringKey.font: fontLarge, NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue])
        
        attributedText.append(NSAttributedString(string: "3 FREE SCREEN REPLACEMENTS\n\n $150 Purchase Credit for Lost/Stolen Replacement Devices\n\n 30% Discount on Accessory Purchases\n\n 20% Buyback Bonus on Devices Sold to TMG BuyBack Program\n\n 15% Discount on Repairs in TMG Tech AllianceTech Support\n Wireless Consultation Included", attributes: [NSAttributedStringKey.font: fontSmall]))

        mvpBenefitsLabel.attributedText = attributedText
     
    }
    
    
    @IBAction func unwindToInitView(segue: UIStoryboardSegue) {
        print("unwind")
    }
}
