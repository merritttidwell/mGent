//
//  GNewsTabViewController.swift
//  Gent
//
//  Created by Ossama Mikhail on 12/31/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit
import SwiftyJSON

class GNewsTabViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView?
    var postsJson : JSON? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GentsUser.shared.posts { [weak self] json in
            if json != nil {
                print(json)
                self?.postsJson = JSON(json)
                DispatchQueue.main.async {
                    self?.table?.reloadData()
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - UITablewViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsJson?.array != nil ? (postsJson?.array?.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        let title = cell.viewWithTag(1) as! UILabel
        let date = cell.viewWithTag(2) as! UILabel
        let post = cell.viewWithTag(3) as! UILabel
        
        title.text = postsJson?.arrayValue[indexPath.row]["title"].string
        date.text = postsJson?.arrayValue[indexPath.row]["date"].string
        post.text = postsJson?.arrayValue[indexPath.row]["body"].string
        
        return cell
    }
    
    @IBAction func doSignout() {
        GentsUser.shared.logOutUser { [weak self] isOK in
            
            if isOK {
                self?.performSegue(withIdentifier: "signout", sender: self)
            } else {
                UIHelper.showAlertInView(self!, msg: "Signout failed")
            }
        }
    }
}
