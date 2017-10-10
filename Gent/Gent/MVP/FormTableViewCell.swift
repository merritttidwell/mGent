//
//  FormTableViewCell.swift
//  Gent
//
//  Created by Christina Sund on 10/4/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit

// Delegate
protocol FormTableViewCellDelegate: class {
    func fieldValueChanged(cell: UITableViewCell, textField: UITextField)
}


class FormTableViewCell: UITableViewCell {

    weak var delegate: FormTableViewCellDelegate?
    
    @IBOutlet weak var formLabel: UILabel!
    
    @IBOutlet weak var formTextField: UITextField!
    
    // Set up editing changed event and send to delegate
    @IBAction func editingChanged(_ sender: UITextField) {
        delegate?.fieldValueChanged(cell: self, textField: sender)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
