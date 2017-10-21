//
//  NewsTableViewController.swift
//  Gent
//
//  Created by Christina Sund on 10/21/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import UIKit
import Firebase

class NewsTableViewController: UITableViewController {

    var posts = [Post]()
    var tempPostsArray = ["one","two","three"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempPostsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! NewsTableViewCell

        let ref = Database.database().reference()
        let posts = ref.child("posts")
        let row = indexPath.row
        
        posts.child(tempPostsArray[row]).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let title = value?["title"] as? String ?? ""
            let body = value?["body"] as? String ?? ""
            cell.textLabel?.numberOfLines = 0
            cell.postTitle.text = title
            cell.postBody.text = body
        }) { (error) in
            print(error.localizedDescription)
        }

        return cell
    }

}
