
//  RestaurantDetailViewController.swift
//  HungerCity
//
//  Created by Lin Li on 11/10/18.
//  Copyright © 2018 Lin Li. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
extension UIViewController: UITextViewDelegate{
    
}
class RestaurantDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var NavigationItemName: UINavigationItem!
    @IBOutlet weak var restaurantImageCollectionView: UICollectionView!
    
    @IBOutlet weak var restaurantCommentsTableView: SelfSizedTableView!
    
    @IBOutlet var reviewView: UIView!
    @IBOutlet weak var rateStar: RatingController!
    @IBOutlet weak var reviewText: UITextView!
    
    @IBAction func popUpReview(_ sender: Any) {
        let userid = UserDefaults.standard.getUserID()
        if userid < 1 {
            DispatchQueue.main.async {
                //let LVC = LoginViewController()
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let LVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(LVC, animated: true, completion: nil)
            }
        } else {
            
            self.view.addSubview(reviewView)
            reviewView.center = self.view.center
        }
    }
    
    @IBAction func submitReview(_ sender: Any) {
        saveReview()
        self.reviewView.removeFromSuperview()
        self.initComments()
        self.restaurantCommentsTableView.reloadData()
        restaurantCommentsTableView.maxHeight = CGFloat(commentInfo.count * 200 + 200)
    }
    
    @IBAction func cancelReview(_ sender: Any) {
        self.reviewView.removeFromSuperview()
    }
    
    
    @IBOutlet weak var restaurantWebsite: UIButton!
    @IBOutlet weak var restaurantRating: UILabel!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantDescription: UILabel!
    @IBOutlet weak var restaurantPhone: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var restaurantMenu: UILabel!
    @IBOutlet weak var currentWeekdayTime: UILabel!
    // new code for map
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var zoomLevel: Float = 10.0
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    // new code for map
    
    var db:SQLiteDB!
    var imageInfo = [Photos]()
    var commentInfo = [Comments]()
    var name = ""
    var address = ""
    var currentRestaurant: Restaurants!
    var weekday = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantImageCollectionView.delegate = self
        restaurantImageCollectionView.dataSource = self
        //zj
        self.reviewView.layer.cornerRadius = 10
        reviewText.delegate = self
        restaurantCommentsTableView.delegate = self
        restaurantCommentsTableView.dataSource = self
        restaurantWebsite.setTitle(currentRestaurant.website, for: .normal)
        //zj
        restaurantName.text = currentRestaurant.name
        restaurantRating.text = currentRestaurant.avgRating
        restaurantAddress.text = currentRestaurant.address
        restaurantPhone.text = currentRestaurant.phone
        restaurantDescription.text = currentRestaurant.description
        NavigationItemName.title = currentRestaurant.name
        //print("this is currentRestaurant: \(String(describing: currentRestaurant))")
        db = SQLiteDB.shared
        
        let date = Date()
        let calendar = Calendar.current
        let weekdaynumber = calendar.component(.weekday, from: date)
        
        switch weekdaynumber {
        case 1:
            currentWeekdayTime.text = "Today" + "  " + currentRestaurant.sunday
            break
        case 2:
            currentWeekdayTime.text = "Today" + "  " + currentRestaurant.monday
            break
        case 3:
            currentWeekdayTime.text = "Today" + "  " + currentRestaurant.tuesday
            break
        case 4:
            currentWeekdayTime.text = "Today" + "  " + currentRestaurant.wednesday
            break
        case 5:
            currentWeekdayTime.text = "Today" + "  " + currentRestaurant.thursday
            break
        case 6:
            currentWeekdayTime.text = "Today" + "  " + currentRestaurant.friday
            break
        case 7:
            currentWeekdayTime.text = "Today" + "  " + currentRestaurant.saturday
            break
        default:
            break
        }

        
        initPhoto()
        initComments()
        restaurantCommentsTableView.maxHeight = CGFloat(commentInfo.count * 200 + 200)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(rightSwipe)
        // Do any additional setup after loading the view.
        
        //new code for map
        print("The address is \(currentRestaurant.address)")
        let newAddress = currentRestaurant.address.replacingOccurrences(of: " ", with: "+")
        print(newAddress)
        let url = URL(string:"https://maps.googleapis.com/maps/api/geocode/json?address=\(newAddress)&key=AIzaSyDEOS060nUitDwo_SLHSYx24FNNm16ZkAk")
        let data = try! Data(contentsOf: url!)
        //var temp: [Result];
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        var location: [String:Any] = ["No": "result"]
        if let dictionary1 = json as? [String:Any] {
            if let array1 = dictionary1["results"] as? [[String:Any]] {
                let dictionary2 = array1[0]
                if let dictionary3 = dictionary2["geometry"] as? [String:Any] {
                    if let dictionary4 = dictionary3["location"] as? [String:Any] {
                        location = dictionary4;
                    }
                }
            }
        }
        
        longitude = location["lng"] as! Double
        latitude = location["lat"] as! Double
        print("the longitude is \(longitude) and the latitude is \(latitude)")
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoomLevel)
        mapView.camera = camera
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = currentRestaurant.name
        marker.snippet = currentRestaurant.description
        marker.map = mapView
        mapView.settings.myLocationButton = true
        
        self.mapView?.isMyLocationEnabled = true
        self.locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        //new code for map
    }
    
    @IBAction func websiteSelected(_ sender: Any) {
        if let websiteURL = NSURL(string: "http://\(currentRestaurant.website)") {
            UIApplication.shared.open(websiteURL as URL, options: [:], completionHandler: nil)
        }
//        UIApplication.shared.openURL(NSURL(string: currentRestaurant.website)! as URL)
    }
    
    
    //zj
    override func viewDidAppear(_ animated: Bool) {
        initComments()
        restaurantCommentsTableView.reloadData()
        restaurantCommentsTableView.maxHeight = CGFloat(commentInfo.count * 200 + 200)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //zj
    
    //new code for map
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: ((location?.coordinate.latitude)! + latitude) / 2, longitude: ((location?.coordinate.longitude)! + longitude) / 2, zoom: zoomLevel)
        
        self.mapView?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    //new code for map
    
    
    @IBAction func showMore(_ sender: Any) {
        let moreInfoVC = MoreInfoViewController()
        moreInfoVC.currentRestaurant = currentRestaurant
        self.show(moreInfoVC, sender: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
            if let vc = segue.destination as? ReservationViewController
            {
                vc.currRest = currentRestaurant
            }

    }
    
    @IBAction func backSelected(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareSelected(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [restaurantName.text!+"\n",restaurantAddress.text!+"\n",currentRestaurant.website], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    @IBAction func likeSelected(_ sender: Any) {
        let userid = UserDefaults.standard.getUserID()
        if userid < 1 {
            DispatchQueue.main.async {
                //let LVC = LoginViewController()
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let LVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(LVC, animated: true, completion: nil)
            }
        } else {
            if checkforExistence() {
                let alert = UIAlertController(title: "Error!", message: "You have already added to your likes. Check it in likes." , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler:nil))
                present(alert, animated:true, completion:nil)
            } else {
                let alert = UIAlertController(title: "Congrats!", message: "You have successfully added this restaurant to your likes. Check it in likes." , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:"OK", style: .default, handler:nil))
                present(alert, animated:true, completion:nil)
                saveLike()
            }
        
        }
    }
    
    @IBAction func makeACall(_ sender: Any) {
        
        //print(currentRestaurant.phone)
        if let phoneURL = NSURL(string: "tel://\(currentRestaurant.phone)") {
            UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //zj
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CommentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell
        let comment = commentInfo[indexPath.row]
        print("this is comment: \(comment)")
        cell.username.text = comment.username
        let picture = comment.profilePic
        if picture != "" {
            let url = URL(string: picture)
            //data task session
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if let error = error{
                    print(error)
                    return
                }
                guard let data = data else { return }
                cell.userProfilePic.image = UIImage(data: data)
            }).resume()
        }
        else {
            cell.userProfilePic.image = #imageLiteral(resourceName: "no-image")
        }
        //cell.userRating.text = String(comment.rating)
        if comment.rating == 0 {
            cell.userRatingImage.image = #imageLiteral(resourceName: "noStar")
        }
        if comment.rating == 1 {
            cell.userRatingImage.image = #imageLiteral(resourceName: "oneStar")
        }
        if comment.rating == 2 {
            cell.userRatingImage.image = #imageLiteral(resourceName: "twoStar")
        }
        if comment.rating == 3 {
            cell.userRatingImage.image = #imageLiteral(resourceName: "threeStar")
        }
        if comment.rating == 4 {
            cell.userRatingImage.image = #imageLiteral(resourceName: "fourStar")
        }
        if comment.rating == 5 {
            cell.userRatingImage.image = #imageLiteral(resourceName: "fiveStar")
        }
        cell.userComment.text = String(comment.commentTXT)
        
        return cell
    }
    //zj
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:AllPhotosCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllPhotosCollectionViewCell", for: indexPath) as! AllPhotosCollectionViewCell
        let photo = imageInfo[indexPath.row]
        //print("this is restaurant: \(restaurant)")
        cell.CurrentRestaurantImage.image = photo.photo
        return cell
    }
    
    func initPhoto() {
        let id = currentRestaurant.id
        let sql = "SELECT * FROM photos WHERE id=?"
        let data = db.query(sql:sql, parameters:[id])
        if data.count>0 {
            do {
                let response = try AllDataPhotos(data:data)
                for item in response.alldataphotos {
                    imageInfo.append(item)
                }
                //print("this is response\(response.alldatarestaurants)")
            } catch {}
            
        }
    }
    
    func saveLike() {
        let userid = UserDefaults.standard.getUserID()
        let restaurantID = currentRestaurant.id
        let sql = "insert into like(userID,restaurantID) values('\(userid)','\(restaurantID)')"
        print("sql: \(sql)")
        let result = db.execute(sql: sql)
        print(result)
    }
    //zj
    func saveReview() {
        //!!!!!!!!!!!!!!!!!!!!!!!!remember to change the userID!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        //        let sql3 = "SELECT * FROM comments"
        //        let data2 = db.query(sql:sql3)
        //        print(data2)
        
        //judge if the user has made comments before
        let userid = UserDefaults.standard.getUserID()
        let restaurantID = currentRestaurant.id
        let sql2 = "SELECT restaurantID FROM comments WHERE userID=?"
        let data = db.query(sql:sql2, parameters:[userid])
        var i = 0
        var a = 0
        while i < data.count{
            var m = data[i]["restaurantID"]! as! Int
            print(m)
            if (m == restaurantID){
                createAlert(title: "Error!", message: "You have commented on this restaurant before!")
                a += 1
            }
            i += 1
        }
        
        if a == 0{
            //insert comments
            let rating = rateStar.starsRating
            let commentTXT = reviewText.text!
            let sql = "insert into comments(userID,restaurantID,commentTXT,rating) values('\(userid)','\(restaurantID)','\(commentTXT)','\(rating)')"
            let result = db.execute(sql: sql)
            
            
            //update restaurant
            let mySql = "SELECT * from restaurants where id = ?"
            var resInfo = db.query(sql:mySql, parameters:[restaurantID])
            //print(resInfo)
            let num_of_reviews = resInfo[0]["num_of_reviews"]! as! Int + 1
            let totalRating = resInfo[0]["totalRating"]! as! Int + rating
            let avgRating = String(format:"%.1f", Float(totalRating) / Float(num_of_reviews))
            print(num_of_reviews)
            print(totalRating)
            let addSql1 = "update restaurants set num_of_reviews = \(num_of_reviews), totalRating = \(totalRating), avgRating = \(avgRating) where id = \(restaurantID)"
            db.query(sql: addSql1)
            restaurantRating.text = avgRating
//            let addSql2 = "update restaurants set totalRating = \(totalRating) where id = \(restaurantID)"
//            db.query(sql: addSql2)
            //            let SQL = "SELECT * from restaurants where id = 20"
            //            let a = db.query(sql: SQL)
            //            print(a)
            
            
            
            //            let sql3 = "SELECT restaurantID FROM comments WHERE userID=?"
            //            let data2 = db.query(sql:sql3, parameters:[userID])
        }
    }
    func restaurantUpdate(){
        
    }
    func createAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func checkforExistence() -> Bool{
        let userid = UserDefaults.standard.getUserID()
        let restaurantID = currentRestaurant.id
        let sql = "SELECT * FROM like WHERE userID=\(userid) and restaurantID=\(restaurantID)"
        let data = db.query(sql:sql)
        if data.count > 0 {
            return true
        } else {
            return false
        }
        
    }
    func initComments(){
        commentInfo.removeAll()
        let restaurantID = currentRestaurant.id
        let sql = "SELECT c.commentID, c.commentTXT, p.username, c.rating, p.profilePic FROM (comments c) JOIN profile p ON c.userID = p.userID WHERE c.restaurantID=\(restaurantID)"
        let data = db.query(sql:sql)
        if data.count > 0 {
            do {
                let response = try AllDataComments(data:data)
                for item in response.alldatacomments {
                    commentInfo.append(item)
                }
                print("this is response\(commentInfo)")
            } catch {print("there is an error!")}
        }
        restaurantCommentsTableView.reloadData()
        
    }

}

extension UIViewController {
    @objc func swipeAction(swipe:UISwipeGestureRecognizer) {
        switch swipe.direction.rawValue {
        case 1:
            dismiss(animated: true, completion: nil)
            //performSegue(withIdentifier: "backToLeft", sender: self)
        default:
            break
        }
    }
}
