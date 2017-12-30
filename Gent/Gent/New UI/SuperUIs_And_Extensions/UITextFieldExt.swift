//
//  UITextFieldExt.swift
//  Gent
//
//  Created by Ossama Mikhail on 12/29/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit

extension UITextField {
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 3
    }
}
