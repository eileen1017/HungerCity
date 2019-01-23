//
//  Comments.swift
//  HungerCity
//
//  Created by 夏目斑 on 2018/11/30.
//  Copyright © 2018年 Lin Li. All rights reserved.
//

import Foundation
struct Comments {
    let commentID: Int
    let username: String
    let commentTXT: String
    let rating: Int
    let profilePic: String
    
    
    
    init?(dict:[String:Any]) {
        
        commentID = dict["commentID"] as! Int
        username = dict["username"] as! String
        commentTXT = dict["commentTXT"] as! String
        rating = dict["rating"] as! Int
        profilePic = dict["profilePic"] as! String
        
    }
    
}
