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
    func fieldValueChanged(textField: UITextField, cell: UITableViewCell)
}


class FormTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    weak var delegate: FormTableViewCellDelegate?
    
    @IBOutlet weak var formLabel: UILabel!
    
    @IBOutlet weak var formTextField: UITextField!
    
    // Set up editing changed event and send to delegate
    
    public func configure(titleLabel: String, text: String?, placeholder: String) {
        
        formLabel.text = titleLabel
        formLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        
        formTextField.text = text
        formTextField.placeholder = placeholder
        formTextField.delegate = self
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        delegate?.fieldValueChanged(textField: formTextField, cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

