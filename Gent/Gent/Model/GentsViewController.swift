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
        imageView.image = UIImage(named: "wallpaper_edit_shield")
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
        
        // under construction 
        let imageName = "under_construction"
        let image = UIImage(named: imageName)
        let ucView = UIImageView(image: image!)
        ucView.frame = CGRect(x: 0, y: 0, width: 250, height: 300)
        ucView.center = self.view.center
        //v2.backgroundColor = UIColor.white
        self.view.addSubview(ucView)
        
        ucView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: ucView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: ucView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: ucView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300)
        let heightConstraint = NSLayoutConstraint(item: ucView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 250)
        self.view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        
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
