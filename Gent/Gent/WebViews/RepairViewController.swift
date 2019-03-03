//
//  RepairViewController.swift
//  Gent
//
//  Created by Merritt Tidwell on 3/3/19.
//  Copyright © 2019 Christina Sund. All rights reserved.
//

import UIKit
import WebKit

class RepairViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let url1 : URL = URL(string: "https://www.themobilegents.com/repair.html")!
        let request : URLRequest = URLRequest(url: url1)
        
        webView.load(request)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
