//
//  FormTableViewCell.swift
//  Gent
//
//  Created by Christina Sund on 10/4/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit

class FormTableViewCell: UITableViewCell {

    @IBOutlet weak var formLabel: UILabel!
    
    @IBOutlet weak var formTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
