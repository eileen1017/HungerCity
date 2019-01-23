//
//  AllComments.swift
//  HungerCity
//
//  Created by 夏目斑 on 2018/11/30.
//  Copyright © 2018年 Lin Li. All rights reserved.
//

import Foundation
struct AllDataComments {
    let alldatacomments: [Comments]
    
    init(data:Any) throws {
        let array = data as! [[String:Any]]
        var alldatacomments = [Comments]()
        
        for item in array {
            //print(item)
            guard let alldatacomment = Comments(dict: item) else {continue}
            alldatacomments.append(alldatacomment)
        }
        
        self.alldatacomments = alldatacomments
    }
}
