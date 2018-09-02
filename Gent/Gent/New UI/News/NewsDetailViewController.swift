//
//  NewsDetailViewController.swift
//  Gent
//
//  Created by Merritt Tidwell on 7/29/18.
//  Copyright © 2018 Christina Sund. All rights reserved.
//

import UIKit

class NewsDetailViewController: GUIViewController {

    @IBOutlet weak var newsTV: UITextView!
    var body = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(body)
        
        newsTV.text = body
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
