//
//  Post.swift
//  Gent
//
//  Created by Christina Sund on 10/21/17.
//  Copyright © 2017 Christina Sund. All rights reserved.
//

import Foundation

struct Post {
    
    var title: String?
    var body: String?
    // var buttonPath: String?
    
    init(postTitle: String, postBody: String) {
        title = postTitle
        body = postBody
    }
    
}
