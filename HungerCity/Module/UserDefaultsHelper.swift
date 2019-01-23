//
//  UserDefaultsHelper.swift
//  HungerCity
//
//  Created by Lin Li on 11/30/18.
//  Copyright © 2018 Lin Li. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func setIsLoggedIn(value:Int) {
        set(value, forKey: "isLoggedIn")
        synchronize()
    }
    
    func getUserID() -> Int {
        return integer(forKey: "isLoggedIn")
    }
    
    func isLoggedIn() -> Bool {
        if integer(forKey: "isLoggedIn") < 1 {
            return false
        } else {
            return true
        }
    }
    
}
