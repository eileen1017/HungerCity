//
//  ReservationViewController.swift
//  HungerCity
//
//  Created by qzj2333 on 2018/11/18.
//  Copyright © 2018年 Lin Li. All rights reserved.
//

import UIKit

// NW
class ReservationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var numberPeoplePicker: UIPickerView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    let peopleNumber = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    var db:SQLiteDB!
    var nPeople = 1
    var date = NSDate() as Date
    var currRest: Restaurants!
    
    @IBAction func dataSelected(_ sender: UIDatePicker)
    {
        date = datePicker.date
    }
    
    @IBAction func confirmButtonClicked(_ sender: UIButton)
    {
        let userid = UserDefaults.standard.getUserID()
        if userid < 1 {
            DispatchQueue.main.async {
                //let LVC = LoginViewController()
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let LVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(LVC, animated: true, completion: nil)
            }
        } else {
        let format = DateFormatter()
        format.timeZone = NSTimeZone.local
        format.dateFormat = "EEEE MM-dd-yyyy HH:mm"
        var resultDate = format.string(from: date)
        
        // adjust minute time
        let minute = Int(resultDate.components(separatedBy: ":")[1])!
        var difference = 0
        if(minute % 30 != 0)
        {
            difference = minute - (minute / 30) * 30
        }
        let newDate = Calendar.current.date(byAdding: .minute, value: -difference, to: date)
        resultDate = format.string(from: newDate!)  // user choosed reservation time
        
        // get day of week
        format.dateFormat = "EEEE"
        let currWeekOfDay = format.string(from: date).lowercased()
        
        // check if today open
        var sql = "SELECT \(currWeekOfDay) FROM restaurants WHERE id = \(currRest.id)"
        let openTime = db.query(sql: sql)[0][currWeekOfDay] as! String
        var canReserve = true
        if(openTime == "Closed")
        {
            canReserve = false;
        }
        else    // if today open, check if time is valid
        {
            let startTime = openTime.components(separatedBy: " - ")[0]
            let endTime = openTime.components(separatedBy: " - ")[1]
            let startAPM = startTime.components(separatedBy: ":")[1].components(separatedBy: " ")[1]
            var startHour = Int(startTime.components(separatedBy: ":")[0])!
            let startMin = Int(startTime.components(separatedBy: ":")[1].components(separatedBy: " ")[0])!
            if (startAPM == "pm" && startHour != 12) || (startAPM == "am" && startHour == 12)
            {
                startHour = startHour + 12
            }
            
            let endAPM = endTime.components(separatedBy: ":")[1].components(separatedBy: " ")[1]
            var endHour = Int(endTime.components(separatedBy: ":")[0])!
            let endMin = Int(endTime.components(separatedBy: ":")[1].components(separatedBy: " ")[0])!
            if(endAPM == "pm" && endHour != 12) || (endAPM == "am" && endHour == 12)
            {
                endHour = endHour + 12
            }
            
            let reserveTime = resultDate.components(separatedBy: " ")
            let reserveHour = Int(reserveTime[2].components(separatedBy: ":")[0])!
            let reserveMin  = Int(reserveTime[2].components(separatedBy: ":")[1])!
            
            if( (reserveHour < startHour) || (reserveHour > endHour) ||
                (reserveHour == startHour && reserveMin < startMin) ||
                (reserveHour == endHour && reserveMin >= endMin))
            {
                canReserve = false
            }
        }
        let userid = UserDefaults.standard.getUserID()
        if(canReserve)
        {
            sql = "INSERT INTO schedule (userID, restaurantID, numOfPeople, reservationTime) VALUES ('\(userid)', '\(currRest.id)', '\(nPeople)', '\(resultDate)')"
            print(self.db.execute(sql: sql))
            print(sql)
            let alert = UIAlertController(title: "Reserved!", message: "You have successfully reserved this restaurant. You can view all your reservations in your profile." , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style: .default, handler:nil))
            present(alert, animated:true, completion:nil)
        }
        else
        {
            let alert = UIAlertController(title: "Sorry!", message: "This restaurant is closing during the time you chose. Please select another time." , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style: .default, handler:nil))
            present(alert, animated:true, completion:nil)
        }
    }
    }
    
    @IBAction func backButton(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func changeMinMaxDate()
    {
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        let today = NSDate()
        datePicker.minimumDate = today.addingTimeInterval(60*60*24*1) as Date   // tomorrow
        datePicker.maximumDate = today.addingTimeInterval(60*60*24*31) as Date    // today + 31 days
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return peopleNumber.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nPeople = Int(peopleNumber[row])!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return peopleNumber[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? RestaurantDetailViewController
        {
            vc.currentRestaurant = currRest
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        numberPeoplePicker.dataSource = self
        numberPeoplePicker.delegate = self
        db = SQLiteDB.shared
        navigationTitle.title = currRest.name
        changeMinMaxDate()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
