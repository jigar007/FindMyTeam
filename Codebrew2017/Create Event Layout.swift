//
//  Create Event Layout.swift
//  Codebrew2017
//
//  Created by Thakkar Jigar on 18/3/17.
//  Copyright © 2017 University of Melbourne. All rights reserved.
//

import UIKit
import Firebase

class Create_Event_Layout: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var currentUid = String()
    

    @IBOutlet weak var typeOfSport: UITextField!

    @IBOutlet var playerNumber: UITextField!

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var cost: UITextField!
    @IBOutlet weak var noteCreateEvent: UITextView!

    @IBAction func createNewEvent(_ sender: Any) {
        
        let ref = FIRDatabase.database().reference().child("game").childByAutoId()
//        let dateFormatter = DateFormatter()
//        let uid = FIRAuth.auth()?.currentUser?.uid
        
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
        let result = formatter.string(from: date)
        let value = ["sport": typeOfSport.text!, "Date": result, "prices": cost.text!,  "playersNeeded":playerNumber.text!]
        
        ref.updateChildValues(value, withCompletionBlock: {
            (error, ref) in
            if error != nil {
                print(error!)
                return
            } else {
                print("success")
            }
        })
        let location = ["latitude": "10", "longitude": "12"]
        ref.child("location").updateChildValues(location, withCompletionBlock: {
            (error, ref) in
            if error != nil {
                print(error!)
                return
            } else {
                print("success")
            }
        })
        
    }
    func handleSend(){
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            self.currentUid = uid
            

            
        }
    }
    
}
