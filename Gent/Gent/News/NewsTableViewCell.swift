//
//  NewsTableViewCell.swift
//  Gent
//
//  Created by Christina Sund on 10/21/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postBody: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    
    @IBAction func getMVP(_ sender: Any) {
    
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
