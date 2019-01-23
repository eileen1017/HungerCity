//
//  AllDataPhotos.swift
//  HungerCity
//
//  Created by Lin Li on 11/11/18.
//  Copyright © 2018 Lin Li. All rights reserved.
//

import Foundation

struct AllDataPhotos {
    let alldataphotos: [Photos]
    
    init(data:Any) throws {
        let array = data as! [[String:Any]]
        var alldataphotos = [Photos]()
        
        for item in array {
            //print(item)
            guard let alldataphoto = Photos(dict: item) else {continue}
            alldataphotos.append(alldataphoto)
        }
        
        self.alldataphotos = alldataphotos
    }
}
