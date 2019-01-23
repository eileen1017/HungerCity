//
//  LikeCollectionViewCell.swift
//  HungerCity
//
//  Created by Lin Li on 11/11/18.
//  Copyright © 2018 Lin Li. All rights reserved.
//

import UIKit

protocol DataCollectionProtocol {
    func deleteData(index:Int, id:Int)
}

class LikeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeRestaurantName: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var delegate: DataCollectionProtocol?
    var index: IndexPath?
    var restaurantID: Int?
    
    
    @IBAction func btnUnlike(_ sender: Any) {
        delegate?.deleteData(index: (index?.row)!, id: restaurantID!)
    }
    
    
    
}
