//
//  LikeHelper.swift
//  HungerCity
//
//  Created by Lin Li on 11/18/18.
//  Copyright © 2018 Lin Li. All rights reserved.
//

import Foundation


import Foundation
import UIKit

struct Likes {
    let userid: Int
    let restaurantid: Int
    
    init?(dict:[String:Any]) {
        
        userid = dict["userID"] as! Int
        restaurantid = dict["restaurantID"] as! Int
        
    }
    
}
