//
//  AllDataRestaurants.swift
//  dbtest
//
//  Created by Lin Li on 11/9/18.
//  Copyright © 2018 Lin Li. All rights reserved.
//

import Foundation

struct AllDataRestaurants {
    let alldatarestaurants: [Restaurants]
    
    init(data:Any) throws {
        let array = data as! [[String:Any]]
        var alldatarestaurants = [Restaurants]()
        
        for item in array {
            //print(item)
            guard let alldatarestaurant = Restaurants(dict: item) else {continue}
            alldatarestaurants.append(alldatarestaurant)
        }
        
        self.alldatarestaurants = alldatarestaurants
    }
}
