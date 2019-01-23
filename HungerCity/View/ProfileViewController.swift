//
//  ProfileViewController.swift
//  HungerCity
//
//  Created by Lin Li on 11/8/18.
//  Copyright © 2018 Lin Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var db:SQLiteDB!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var ProfileTableView: UITableView!
    let tableViewContents = ["Settings","Reservations","About"]
    
    
    @IBOutlet weak var LoginUsernameBtn: UIButton!
    @IBAction func LoginUsernameBtnAction(_ sender: Any) {
        checkLoggedInUserStatus()
    }
    
    @IBOutlet weak var EditUserProfileBtn: UIButton!
    @IBAction func EditUserProfileBtnAction(_ sender: Any) {
    }
    
    @IBOutlet weak var LogoutBtn: UIButton!
    @IBAction func LogoutBtnAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Logout", message: "Do you want to logout this account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.hud.textLabel.text = "Cancelled"
            self.hud.dismiss(afterDelay: 0, animated: true)
            print("this is userid in userdefault ",UserDefaults.standard.getUserID())
            return
        }))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action: UIAlertAction!) in
            
            do {
                
                try Auth.auth().signOut()
                self.hud.dismiss(afterDelay: 1, animated:true)
                self.checkLoggedInUserStatus()
                self.ProfileImage.image = nil
                UserDefaults.standard.setIsLoggedIn(value: -1)
                
            } catch let error{
                print(error)
            }
        }))
        self.present(alert, animated: true, completion: nil)
        self.hud.textLabel.text = "Logging out..."
        self.hud.show(in: self.view, animated: true)
    }
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoggedInUserStatus()
        ProfileTableView.delegate = self
        ProfileTableView.dataSource = self
        db = SQLiteDB.shared
    }

    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil{
            LoginUsernameBtn.setTitleColor(self.view.tintColor, for: .normal)
            LoginUsernameBtn.setTitle("Login", for: .normal)
            LoginUsernameBtn.isEnabled = true
            EditUserProfileBtn.isEnabled = false
            LogoutBtn.isEnabled = false
        }else{
            LoginUsernameBtn.setTitleColor(.black, for: .normal)
            //LoginUsernameBtn.setTitle("Username", for: .normal)
            LoginUsernameBtn.isEnabled = false
            EditUserProfileBtn.isEnabled = true
            LogoutBtn.isEnabled = true
            displayUserInfo()   // set user name and picture
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        cell.tblContentName.text = tableViewContents[indexPath.row]
        return cell
    }

    // NW
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let curr = tableViewContents[indexPath.row]
        if(curr == "Reservations") {
            performSegue(withIdentifier: "reserve", sender: curr)
        } else if (curr == "About") {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let AVC = storyBoard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
            
            self.present(AVC, animated: true, completion: nil)
        }
    }
    
    // NW
    func displayUserInfo()
    {
        let id = UserDefaults.standard.getUserID()
        print("current Userid is ",id)
        let sql = "select * from profile where userID = \(id)"   // change userID later!!!!!!!!!
        let userInfo = db.query(sql: sql)[0]
        let userName = userInfo["username"] as! String
        LoginUsernameBtn.setTitle(userName, for: .normal)
        let picture = userInfo["profilePic"] as! String
        print("this is picture from db: ", picture)
        if picture != "" {
            guard let url = URL(string: picture) else { return }
            //data task session
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error{
                    print(error)
                    return
                }
                guard let data = data else { return }
                self.ProfileImage.image = UIImage(data: data)
            }).resume()
        }
        else {
            self.ProfileImage.image = #imageLiteral(resourceName: "no-image")
        }
    }
    
    func checkLoggedInUserStatus(){
        //print(Auth.auth().currentUser)
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async {
                //let LVC = LoginViewController()
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let LVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(LVC, animated: true, completion: nil)
            }
        }
    }
    
    // NW
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? ReserveListViewController
        {
            vc.userID = UserDefaults.standard.getUserID()   // change later !!!!!!!!!!!!!!!!!!!!!!!!!
        }
    }
    
}
