//
//  MoreInfoViewController.swift
//  HungerCity
//
//  Created by Chengcheng Gan on 2018/12/1.
//  Copyright © 2018年 Lin Li. All rights reserved.
//

import UIKit

class MoreInfoViewController: UIViewController {
    
    var currentRestaurant: Restaurants!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let button = UIButton(frame: CGRect(x: 10, y: view.frame.height - 30, width: 100, height: 20))
        button.backgroundColor = .blue
        button.setTitle("Back", for: [])
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(button)
        
        view.backgroundColor = UIColor.white
        let theTextFrame = CGRect(x: 0, y: 30, width: view.frame.width, height: 30)
        let textView = UILabel(frame: theTextFrame)
        textView.text = "Opening Hours"
        textView.textAlignment = .center
        let mondayFrame = CGRect(x: 0, y: 70, width: view.frame.width, height: 30)
        let mondayView = UILabel(frame: mondayFrame)
        mondayView.text = "Monday " + currentRestaurant.monday
        mondayView.textAlignment = .center
        let tuesdayFrame = CGRect(x: 0, y: 100, width: view.frame.width, height: 30)
        let tuesdayView = UILabel(frame: tuesdayFrame)
        tuesdayView.text = "Tuesday " + currentRestaurant.tuesday
        tuesdayView.textAlignment = .center
        let wednesdayFrame = CGRect(x: 0, y: 130, width: view.frame.width, height: 30)
        let wednesdayView = UILabel(frame: wednesdayFrame)
        wednesdayView.text = "Wednesday " + currentRestaurant.wednesday
        wednesdayView.textAlignment = .center
        let thursdayFrame = CGRect(x: 0, y: 160, width: view.frame.width, height: 30)
        let thursdayView = UILabel(frame: thursdayFrame)
        thursdayView.text = "Thursday " + currentRestaurant.thursday
        thursdayView.textAlignment = .center
        let fridayFrame = CGRect(x: 0, y: 190, width: view.frame.width, height: 30)
        let fridayView = UILabel(frame: fridayFrame)
        fridayView.text = "Friday " + currentRestaurant.friday
        fridayView.textAlignment = .center
        let saturdayFrame = CGRect(x: 0, y: 220, width: view.frame.width, height: 30)
        let saturdayView = UILabel(frame: saturdayFrame)
        saturdayView.text = "Saturday " + currentRestaurant.saturday
        saturdayView.textAlignment = .center
        let sundayFrame = CGRect(x: 0, y: 250, width: view.frame.width, height: 30)
        let sundayView = UILabel(frame: sundayFrame)
        sundayView.text = "Sunday " + currentRestaurant.sunday
        sundayView.textAlignment = .center
        let anotherTextFrame = CGRect(x: 0, y: 290, width: view.frame.width, height: 30)
        let anotherTextView = UILabel(frame: anotherTextFrame)
        anotherTextView.text = "Other Information"
        anotherTextView.textAlignment = .center
        let wifiFrame = CGRect(x: 0, y: 330, width: view.frame.width, height: 30)
        let wifiView = UILabel(frame: wifiFrame)
        wifiView.text = "WIFI: " + currentRestaurant.wifi
        wifiView.textAlignment = .center
        let deliveryFrame = CGRect(x: 0, y: 360, width: view.frame.width, height: 30)
        let deliveryView = UILabel(frame: deliveryFrame)
        deliveryView.text = "Delivery: " + currentRestaurant.delivery
        deliveryView.textAlignment = .center
        let accept_apple_payFrame = CGRect(x: 0, y: 390, width: view.frame.width, height: 30)
        let accept_apple_payView = UILabel(frame: accept_apple_payFrame)
        accept_apple_payView.text = "Accepts Apple Pay: " + currentRestaurant.accepts_apple_pay
        accept_apple_payView.textAlignment = .center
        let accept_credit_cardsFrame = CGRect(x: 0, y: 420, width: view.frame.width, height: 30)
        let accept_credit_cardsView = UILabel(frame: accept_credit_cardsFrame)
        accept_credit_cardsView.text = "Accepts Credit Cards: " + currentRestaurant.accepts_credit_cards
        accept_credit_cardsView.textAlignment = .center
        let alcoholFrame = CGRect(x: 0, y: 450, width: view.frame.width, height: 30)
        let alcoholView = UILabel(frame: alcoholFrame)
        alcoholView.text = "Alcohol: " + currentRestaurant.alcohol
        alcoholView.textAlignment = .center
        let good_for_kidsFrame = CGRect(x: 0, y: 480, width: view.frame.width, height: 30)
        let good_for_kidsView = UILabel(frame: good_for_kidsFrame)
        good_for_kidsView.text = "Good For Kids: " + currentRestaurant.good_for_kids
        good_for_kidsView.textAlignment = .center
        let take_outFrame = CGRect(x: 0, y: 510, width: view.frame.width, height: 30)
        let take_outView = UILabel(frame: take_outFrame)
        take_outView.text = "Take Out: " + currentRestaurant.take_out
        take_outView.textAlignment = .center
        let outdoor_seatingFrame = CGRect(x: 0, y: 540, width: view.frame.width, height: 30)
        let outdoor_seatingView = UILabel(frame: outdoor_seatingFrame)
        outdoor_seatingView.text = "Outdoor Seating: " + currentRestaurant.outdoor_seating
        outdoor_seatingView.textAlignment = .center
        
        view.addSubview(textView)
        view.addSubview(mondayView)
        view.addSubview(tuesdayView)
        view.addSubview(wednesdayView)
        view.addSubview(thursdayView)
        view.addSubview(fridayView)
        view.addSubview(saturdayView)
        view.addSubview(sundayView)
        view.addSubview(anotherTextView)
        view.addSubview(wifiView)
        view.addSubview(deliveryView)
        view.addSubview(accept_apple_payView)
        view.addSubview(accept_credit_cardsView)
        view.addSubview(alcoholView)
        view.addSubview(good_for_kidsView)
        view.addSubview(take_outView)
        view.addSubview(outdoor_seatingView)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
