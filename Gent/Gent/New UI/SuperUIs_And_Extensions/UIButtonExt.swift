//
//  UIButton.swift
//  Gent
//
//  Created by Ossama Mikhail on 12/27/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit

extension UIButton {

    open override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.titleLabel?.font.familyName != UIGeneralSettings.buttonFontFamilyName {
            self.titleLabel?.font = UIFont.init(name: UIGeneralSettings.buttonFontFamilyName, size: self.titleLabel!.font.pointSize)
        }
        
        if self.tag < 100 {
            self.layer.cornerRadius = 5
            self.clipsToBounds = true
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 2
          
        }
    }
}
