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
    @IBOutlet weak var numberOfplayers: UITextField!

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var cost: UITextField!
    @IBOutlet weak var noteCreateEvent: UITextView!

    func handleSend(){
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            self.currentUid = uid
            
            let ref = FIRDatabase.database().reference().child("game").child("2")
            let value = ["type": typeOfSport.text, "number of player": numberOfplayers.text, "location": location.text,"Date": date.text, "time": time.text, "cost": cost.text, "note": noteCreateEvent.text]
            
            ref.updateChildValues(value, withCompletionBlock: {
                    (error, ref) in
                    if error != nil {
                        print(error!)
                        return
                    } else {
                        
                    }
            })
            
        }
    }
    
}
