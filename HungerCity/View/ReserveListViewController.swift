//
//  ReserveListViewController.swift
//  HungerCity
//
//  Created by qzj2333 on 2018/11/30.
//  Copyright © 2018年 Lin Li. All rights reserved.
//

import UIKit

class ReserveListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var reservations:[String] = []
    
    var db:SQLiteDB!
    var userID: Int!
    @IBOutlet weak var table: UITableView!
    
    func displayReservationTable()
    {
        reservations = []
        var sql = "SELECT * FROM schedule WHERE userID = \(userID!)"
        let reserveInfo = db.query(sql:sql)
        for data in reserveInfo
        {
            let n = data["numOfPeople"] as! Int
            let time = data["reservationTime"] as! String
            let id = data["restaurantID"] as! Int
            sql = "SELECT name FROM restaurants WHERE id = \(id)"
            let restName = db.query(sql:sql)[0]["name"] as! String
            let displayInfo = "\(restName): \(n) people at \(time)"
            reservations.append(displayInfo)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return reservations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel!.text = reservations[indexPath.row]
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        // delete from list
        let removeReservationInfo = reservations.remove(at: indexPath.row).components(separatedBy: ": ")
        // get info from the deleted item
        let restName = removeReservationInfo[0]
        let reserveTime = removeReservationInfo[1].components(separatedBy: "at ")[1]
        let reservePeople = removeReservationInfo[1].components(separatedBy: " people")[0]

        // delete from db
        var sql = "SELECT id from restaurants WHERE name = '\(restName)'"
        let restID = db.query(sql: sql)[0]["id"] as! Int
        sql = "DELETE FROM schedule WHERE userID = \(userID!) AND restaurantID = \(restID) AND numOfPeople = '\(reservePeople)' AND reservationTime = '\(reserveTime)'" 
        _ = db.execute(sql:sql)
        
        displayReservationTable()
        table.reloadData()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        db = SQLiteDB.shared
        displayReservationTable()
        table.reloadData()
        print("this is userid in reservation ", userID)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        displayReservationTable()
        table.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
