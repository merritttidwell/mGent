//
//  UIViewControllerExt.swift
//  Gent
//
//  Created by Ossama Mikhail on 12/30/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit

class GUIViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MobileGent"
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
    }
}

class GUITableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
    }
}
