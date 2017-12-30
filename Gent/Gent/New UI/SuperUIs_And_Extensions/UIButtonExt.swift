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
        
        if self.tag < 1000 {
            
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize.init(width: 5, height: 5)
            self.layer.shadowOpacity = 1
        }
    }
}
