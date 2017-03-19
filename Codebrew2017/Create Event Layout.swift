//
//  Create Event Layout.swift
//  Codebrew2017
//
//  Created by Thakkar Jigar on 18/3/17.
//  Copyright © 2017 University of Melbourne. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class Create_Event_Layout: UIViewController {
    
    var currentUid = String()
    

    @IBOutlet weak var typeOfSport: UITextField!

    @IBOutlet var playerNumber: UITextField!

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var cost: UITextField!
    
    var datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        datePicker.datePickerMode=UIDatePickerMode.dateAndTime
        datePicker.minimumDate = Date()
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(showSelectedDate))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.date.inputView = datePicker
        self.date.inputAccessoryView = toolBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        location.borderStyle = UITextBorderStyle.roundedRect
        date.borderStyle = UITextBorderStyle.roundedRect
        typeOfSport.borderStyle = UITextBorderStyle.roundedRect
        playerNumber.borderStyle = UITextBorderStyle.roundedRect
        cost.borderStyle = UITextBorderStyle.roundedRect
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showSelectedDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
        let resultString = formatter.string(from: datePicker.date)
        date.text = resultString
        date.resignFirstResponder()
    }
    
    @IBAction func createNewEvent(_ sender: Any) {
        
        let ref = FIRDatabase.database().reference().child("game").childByAutoId()
        //let dateFormatter = DateFormatter()
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
//        let result = formatter.string(from: date)
        let value = ["sport": typeOfSport.text!, "Date": date.text!, "prices": cost.text!,  "playersNeeded":playerNumber.text!, "organizer": uid] as [String : Any]

        ref.updateChildValues(value, withCompletionBlock: {
            (error, ref) in
            if error != nil {
                print(error!)
                return
            } else {
                print("success")
            }
        })
        
        let address = self.location.text //"1 Infinite Loop, CA, USA"
        let geocoder = CLGeocoder()
        var locationWithLatAndLong = ["latitude": "10", "longitude": "12"]
        
        geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                locationWithLatAndLong.updateValue(String(coordinates.latitude), forKey: "latitude")
                locationWithLatAndLong.updateValue(String(coordinates.longitude), forKey: "longitude")
            }
        })
        
        
        ref.child("location").updateChildValues(locationWithLatAndLong, withCompletionBlock: {
            (error, ref) in
            if error != nil {
                print(error!)
                return
            } else {
                print("success")
            }
        })
        
    }

    
}
