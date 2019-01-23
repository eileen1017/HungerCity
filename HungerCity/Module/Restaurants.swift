//
//  Restaurants.swift
//  dbtest
//
//  Created by Lin Li on 11/9/18.
//  Copyright © 2018 Lin Li. All rights reserved.
//

import Foundation
import UIKit

struct Restaurants {
    let id: Int
    let name: String
    let address: String
    let phone: String
    let description: String
    let website: String
    let monday: String
    let tuesday: String
    let wednesday: String
    let thursday: String
    let friday: String
    let saturday: String
    let sunday: String
    let mainphoto: UIImage
    let avgRating: String
    let wifi: String
    let delivery: String
    let accepts_apple_pay: String
    let accepts_credit_cards: String
    let good_for_kids: String
    let alcohol: String
    let take_out: String
    let outdoor_seating: String
    
    init?(dict:[String:Any]) {
        
        id = dict["id"] as! Int
        name = dict["name"] as! String
        address = dict["address"] as! String
        phone = dict["phone"] as! String
        description = dict["description"] as! String
        website = dict["website"] as! String
        monday = dict["monday"] as! String
        tuesday = dict["tuesday"] as! String
        wednesday = dict["wednesday"] as! String
        thursday = dict["thursday"] as! String
        friday = dict["friday"] as! String
        saturday = dict["saturday"] as! String
        sunday = dict["sunday"] as! String
        mainphoto = UIImage(data:dict["mainpic"] as! Data)!
        avgRating = dict["avgRating"] as! String
        wifi = dict["wifi"] as! String
        delivery = dict["delivery"] as! String
        accepts_apple_pay = dict["accepts_apple_pay"] as! String
        accepts_credit_cards = dict["accepts_credit_cards"] as! String
        good_for_kids = dict["good_for_kids"] as! String
        alcohol = dict["alcohol"] as! String
        take_out = dict["take_out"] as! String
        outdoor_seating = dict["outdoor_seating"] as! String
    }

}
