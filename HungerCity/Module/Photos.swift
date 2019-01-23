//
//  Photos.swift
//  HungerCity
//
//  Created by Lin Li on 11/11/18.
//  Copyright © 2018 Lin Li. All rights reserved.
//

import Foundation
import UIKit

struct Photos {
    let id: Int
    let photo: UIImage
    
    init?(dict:[String:Any]) {
        
        id = dict["id"] as! Int
        photo = UIImage(data:dict["photo"] as! Data)!
        
    }
    
}
