//
//  GUILabel.swift
//  Gent
//
//  Created by Ossama Mikhail on 12/27/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit

extension UILabel {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        if self.font.familyName != UIGeneralSettings.labelFontFamilyName {
            if self.font.fontName.lowercased().hasSuffix("bold") {
                self.font = UIFont.init(name: UIGeneralSettings.labelFontFamilyName + "-Bold", size: self.font.pointSize)
            } else {
                self.font = UIFont.init(name: UIGeneralSettings.labelFontFamilyName, size: self.font.pointSize)
            }
        }
    }
}
