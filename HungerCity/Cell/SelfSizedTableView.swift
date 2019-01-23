//
//  SelfSizedTableView.swift
//  HungerCity
//
//  Created by Lin Li on 11/30/18.
//  Copyright © 2018 Lin Li. All rights reserved.
//


import UIKit

class SelfSizedTableView: UITableView {
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = max(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}
