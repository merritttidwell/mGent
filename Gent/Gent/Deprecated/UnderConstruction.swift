//
//  UnderConstruction.swift
//  Gent
//
//  Created by Christina Sund on 10/23/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit

class UnderConstruction: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var underConImage: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("UnderConstruction", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    

}
