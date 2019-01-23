//
//  HomeViewController.swift
//  HungerCity
//
//  Created by Lin Li on 11/8/18.
//  Copyright © 2018 Lin Li. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UISearchBarDelegate {
    //zj
    
    @IBOutlet weak var hasSearchedRestaurant: UILabel!
    @IBOutlet weak var searchRestaurantCollectionView: UICollectionView!
    
    @IBOutlet weak var rateRestaurantCollectionView: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    //zj
    @IBOutlet weak var recentRestaurantCollectionView: UICollectionView!
    
    @IBOutlet weak var allRestaurantCollectionView: UICollectionView!
    
    var db:SQLiteDB!
    var restaurantInfo = [Restaurants]()
    var ratedrestaurantInfo = [Restaurants]()
    var currentRestaurantId: Int = -1
    var currentRestaurant: Restaurants!
    //zj
    var searchContent: String?
    var searchStatus: Bool = false
    var searchRestaurantInfo = [Restaurants]()
    //zj
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recentRestaurantCollectionView.delegate = self
        recentRestaurantCollectionView.dataSource = self
        allRestaurantCollectionView.delegate = self
        allRestaurantCollectionView.dataSource = self
        rateRestaurantCollectionView.delegate = self
        rateRestaurantCollectionView.dataSource = self
        //zj
        let itemSize = searchView.bounds.width/2 - 10
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 10, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        searchRestaurantCollectionView.collectionViewLayout = layout
        searchRestaurantCollectionView.delegate = self
        searchRestaurantCollectionView.dataSource = self
        searchBar.delegate = self
        //zj
        db = SQLiteDB.shared
        initRestaurant()
        initRatedRestaurant()
        //scrollView.isHidden = true
        searchView.isHidden = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initRestaurant()
        initRatedRestaurant()
        allRestaurantCollectionView.reloadData()
        recentRestaurantCollectionView.reloadData()
        rateRestaurantCollectionView.reloadData()
    }
    
    //zj
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchContent = searchBar.text
        if searchContent == ""{
            searchStatus = false
            scrollView.isHidden = false
            searchView.isHidden = true
        }
        else{
            searchRestaurantInfo=[]
            searchStatus = true
            scrollView.isHidden = true
            searchView.isHidden = false
            let sql = "SELECT * FROM restaurants WHERE name like '%"+searchContent!+"%'"
            //print(sql)
            let data = db.query(sql: sql)
            if data.count>0 {
                do {
                    let response = try AllDataRestaurants(data:data)
                    for item in response.alldatarestaurants {
                        searchRestaurantInfo.append(item)
                    }
                } catch {}
                searchRestaurantCollectionView.isHidden = false
                searchRestaurantCollectionView.reloadData()
            }
            else{
                searchRestaurantCollectionView.isHidden = true
                searchRestaurantInfo = []
                searchRestaurantCollectionView.reloadData()
            }
        }
    }

    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.recentRestaurantCollectionView {
            return 5
        }
        else if collectionView == self.rateRestaurantCollectionView {
            return ratedrestaurantInfo.count
        }
        //zj
        else if collectionView == self.searchRestaurantCollectionView {
            return searchRestaurantInfo.count
        }
        else {
            return restaurantInfo.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.recentRestaurantCollectionView {
            let cell:RecentRestaurantCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentRestaurantCollectionViewCell", for: indexPath) as! RecentRestaurantCollectionViewCell
            let restaurant = restaurantInfo[restaurantInfo.count - indexPath.row - 1]
            //print("this is restaurant: \(restaurant)")
            cell.recentRestaurantImage.image = restaurant.mainphoto
            cell.recentRestaurantName.text = " "+restaurant.name
            return cell
        }
        else if collectionView == self.rateRestaurantCollectionView {
            let cell: RateRestaurantsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RateRestaurantsCollectionViewCell", for: indexPath) as! RateRestaurantsCollectionViewCell
            let restaurant = ratedrestaurantInfo[indexPath.row]
            cell.restaurantName.text = " "+restaurant.name
            cell.restaurantImage.image = restaurant.mainphoto
            
            //print("this is restaurant: \(restaurant)")
            return cell
        }
        //zj
        else if collectionView == self.searchRestaurantCollectionView{
            let cell: SearchRestaurantCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchRestaurantCollectionViewCell", for: indexPath) as! SearchRestaurantCollectionViewCell
            let restaurant = searchRestaurantInfo[indexPath.row]
            cell.searchRestaurantImage.image = restaurant.mainphoto
            cell.searchRestarauntName.text = restaurant.name
            cell.searchRestaurantDescription.text = restaurant.description
            return cell
        }
            //zj
        else {
            let cell: AllRestaurantsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllRestaurantsCollectionViewCell", for: indexPath) as! AllRestaurantsCollectionViewCell
            let restaurant = restaurantInfo[indexPath.row]
            cell.allRestaurantImage.image = restaurant.mainphoto
            cell.allRestaurantName.text = " "+restaurant.name
            cell.allRestaurantDescription.text = " "+restaurant.description
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.recentRestaurantCollectionView {
            currentRestaurant = restaurantInfo[restaurantInfo.count - indexPath.row - 1]
            performSegue(withIdentifier: "RestaurantDetailSegue", sender: currentRestaurant)
        }
        else if collectionView == self.rateRestaurantCollectionView {
            currentRestaurant = ratedrestaurantInfo[indexPath.row]
            performSegue(withIdentifier: "RestaurantDetailSegue", sender: currentRestaurant)
        }
        //zj
        else if collectionView == self.searchRestaurantCollectionView{
            currentRestaurant = searchRestaurantInfo[indexPath.row]
            performSegue(withIdentifier: "RestaurantDetailSegue", sender: currentRestaurant)
        }
        //zj
        else {
            currentRestaurant = restaurantInfo[indexPath.row]
            performSegue(withIdentifier: "RestaurantDetailSegue", sender: currentRestaurant)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RestaurantDetailSegue" {
            let destination = segue.destination as? RestaurantDetailViewController
            destination!.currentRestaurant = currentRestaurant
            


        }
    }
    
    func initRatedRestaurant() {
        ratedrestaurantInfo.removeAll()
        let data = db.query(sql: "select * from restaurants ORDER BY avgRating DESC LIMIT 5")
        if data.count>0 {
            //response = try AllDataRestaurants(data:data)
            do {
                let response = try AllDataRestaurants(data:data)
                for item in response.alldatarestaurants {
                    ratedrestaurantInfo.append(item)
                }
            } catch {}
            
        }
    }
    
    
    func initRestaurant() {
        restaurantInfo.removeAll()
        let data = db.query(sql: "select * from restaurants")
        if data.count>0 {
            //response = try AllDataRestaurants(data:data)
            do {
                let response = try AllDataRestaurants(data:data)
                for item in response.alldatarestaurants {
                    restaurantInfo.append(item)
                    //zj
                    searchRestaurantInfo.append(item)
                    //zj
                }
            } catch {}
            
        }
        
        
    }

}

