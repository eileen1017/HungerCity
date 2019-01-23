//
//  LikeViewController.swift
//  HungerCity
//
//  Created by Lin Li on 11/8/18.
//  Copyright © 2018 Lin Li. All rights reserved.
//

import UIKit

class LikeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    @IBOutlet weak var LikeCollectionView: UICollectionView!
    
    var db:SQLiteDB!
    var restaurantInfo = [Restaurants]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        LikeCollectionView.delegate = self
        LikeCollectionView.dataSource = self
        
        db = SQLiteDB.shared
        initLike()
        LikeCollectionView.reloadData()
        print(restaurantInfo)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
        initLike()
        LikeCollectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:LikeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeCollectionViewCell", for: indexPath) as! LikeCollectionViewCell
        let restaurant = restaurantInfo[restaurantInfo.count - indexPath.row - 1]
        //print("this is restaurant: \(restaurant)")
        cell.likeImage.image = restaurant.mainphoto
        cell.likeRestaurantName.text = " "+restaurant.name
        cell.index = indexPath
        cell.restaurantID = restaurant.id
        cell.delegate = self
        return cell
    }
    
    
    func initLike() {
        restaurantInfo.removeAll()
        let id = UserDefaults.standard.getUserID()
        let sql = "SELECT * FROM restaurants WHERE id IN (SELECT restaurantID FROM like WHERE userID=?)"
        let data = db.query(sql:sql, parameters:[id])
        if data.count>0 {
            do {
                let response = try AllDataRestaurants(data:data)
                for item in response.alldatarestaurants {
                    restaurantInfo.append(item)
                }
                //print("this is response\(response.alldatarestaurants)")
            } catch {}
            
        }
        LikeCollectionView.reloadData()
    }
}

extension LikeViewController:DataCollectionProtocol {
    func deleteData(index: Int, id:Int) {
        let alert = UIAlertController(title: "Delete?", message: "Do you really want to delete this restaurant from your likes?" , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Yes", style: .default, handler:{(action) in
            let userid = UserDefaults.standard.getUserID()
            let sql = "delete from like where userID=\(userid) and restaurantID=\(id)"
            _ = self.db.execute(sql: sql)
            self.initLike()
            self.LikeCollectionView.reloadData()
        }))
        alert.addAction(UIAlertAction(title:"No", style: .default, handler:{(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated:true, completion:nil)
    }
}
