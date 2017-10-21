//
//  GentsViewController.swift
//  Gent
//
//  Created by Merritt Tidwell on 10/20/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit

class GentsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //background
        
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = UIImage(named: "wallpaper2")
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
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
