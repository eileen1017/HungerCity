//
//  LoginViewController.swift
//  HungerCity
//
//  Created by Lin Li on 11/16/18.
//  Copyright © 2018 Lin Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
import FacebookCore
import FacebookLogin
import SwiftyJSON
import FirebaseStorage
import FirebaseDatabase

class LoginViewController: UIViewController {

    var name:String?
    var email:String?
    var profilePicture: UIImage?
    var profilepic: String?
    var db:SQLiteDB!
    var uid: String?
    
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    @IBAction func LoginAsGuest(_ sender: Any) {
        hud.textLabel.text = "Signing in as guest..."
        hud.show(in: view, animated: true)
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                self.hud.dismiss(animated: true)
                print("Login failed with error: ", error)
                return
            }
            self.uid = authResult!.user.uid
            self.name = "Guest"
            self.checkExistence(uid: self.uid!)
            self.hud.dismiss(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    @IBAction func loginAsFacebook(_ sender: Any) {
        hud.textLabel.text = "Logging in with Facebook..."
        hud.show(in: view, animated: true)
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result{
            case .success(grantedPermissions: _, declinedPermissions:_, token: _):
                print("Successfully logged in with facebook")
                self.signIntoFirebase()
            case .failed(let error):
                print(error)
            case .cancelled:
                //print("cancelled")
                self.hud.textLabel.text = "Cancelled"
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func checkExistence(uid: String) {
        print("this is uid of current user: " + uid)
        let sql = "SELECT * FROM profile where uid = \(String(describing: uid))"
        let data = db.query(sql:sql)
        if data.count>0 {
            print(data)
            print("User already exits")
            UserDefaults.standard.setIsLoggedIn(value: data[0]["userID"] as! Int )
        } else {
            createUser(uid:uid,username:self.name!,profilepic:self.profilepic ?? "")
        }
    }
    
    func createUser(uid:String, username:String, profilepic: String) {
        let sql = "insert into profile (uid,username,profilepic) values('\(uid)','\(username)','\(profilepic)')"
        print("sql: \(sql)")
        let result = db.execute(sql: sql)
        print(result)
        UserDefaults.standard.setIsLoggedIn(value: result)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = SQLiteDB.shared
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func closeBTN(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func signIntoFirebase(){
        guard let authenticationToken = AccessToken.current?.authenticationToken else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: authenticationToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            print("Successfully authenticated with firebase")
            self.fetchFacebookUserData()
        }
    }
    
    func fetchFacebookUserData(){
        
        let graphRequestConnection = GraphRequestConnection()
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, picture.type(large)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)
        //setup graph request connection
        graphRequestConnection.add(graphRequest) { (httpResponse, result) in
            switch result{
            case .success(response: let response):
                guard let responseDictionary = response.dictionaryValue else { return }
                let json = JSON(responseDictionary)
                self.uid = json["id"].string
                self.name = json["name"].string
                self.email = json["email"].string
                guard let profilePictureUrl = json["picture"]["data"]["url"].string else { return }
                guard let url = URL(string: profilePictureUrl) else { return }
                //data task session
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let error = error{
                        print(error)
                        return
                    }
                    guard let data = data else { return }
                    self.profilePicture = UIImage(data: data)
                    self.saveUserIntoFirebase()
                }).resume()
                print("this is profilePictureUrl: ", profilePictureUrl)
                self.profilepic = profilePictureUrl
                self.checkExistence(uid: self.uid!)
                break
            case .failed(let err):
                print(err)
                break
            }
        }
        graphRequestConnection.start()
        
    }
    
    func saveUserIntoFirebase(){
        let fileName = UUID().uuidString
        //let
        guard let profilePicture = self.profilePicture else { return }
        guard let uploadData = UIImageJPEGRepresentation(profilePicture, 0.5) else { return }
        Storage.storage().reference().child("profileImages").child(fileName).putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error{
                print(error)
                return
            }
            print("Successfully saved profile picture into firebase database")
        Storage.storage().reference().child("profileImages").child(fileName).downloadURL(completion: { (url, error) in
                guard let profilePictureUrl = url else { return }
                //print(profilePictureUrl)
            let imagURL = profilePictureUrl.absoluteString
                guard let uid = Auth.auth().currentUser?.uid else { return }
                //print(uid)
                let dictionaryValues = ["name": self.name as Any,
                                        "email": self.email as Any,
                                        "profilePictureUrl": imagURL] as [String : Any]
                let values = [uid: dictionaryValues]
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, reference) in
                    if let error = error {
                        print(error)
                        return
                    }
                    print("Successfully saved user into firebase database")
                    self.hud.dismiss(animated: true)
                    self.dismiss(animated: true, completion: nil)
                })
            })
    
            
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

}
