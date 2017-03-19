//
//  Match Detail Layout.swift
//  Codebrew2017
//
//  Created by Thakkar Jigar on 18/3/17.
//  Copyright © 2017 University of Melbourne. All rights reserved.
//

import UIKit
import UIKit
import Firebase
import CoreLocation
import Contacts

class Match_Detail_Layout: UIViewController, UITableViewDelegate,  UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var payersId = [String]()
    var players = [Player]()
    var confirmedPlayers = [String]()
    var firebaseReference: FIRDatabaseReference!
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        firebaseReference = FIRDatabase.database().reference()
        
        //load data
        refreshData()
    }
    
    func refreshData() {
        self.players = [Player]()
        print("!!!!!!!!!!!!")
        print(confirmedPlayers)
        for playerID in confirmedPlayers {
            firebaseReference.child("users").child(playerID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let player = Player()
                let value = snapshot.value as? NSDictionary
                player.id = playerID
                player.age = value?["age"] as? String
                player.name = value?["name"] as? String
                print("-------------------------------")
                print(player.name)
                print("-------------------------------")
                player.email = value?["email"] as? String
                player.phone = value?["phone"] as? String
                let ratingString = value?["rating"] as? String
                player.rating = Float(ratingString!)
                print("RATING = " + ratingString!)
                player.numberOfRatings = value?["ratingsNumber"] as? Int
                player.image = value?["image"] as? String
                self.players.append(player)
                print(self.players)
                print ("PLAYER COUNT:" + String(self.players.count))

                OperationQueue.main.addOperation({() -> Void in
                    self.tableView.reloadData()
                })
            })
            
        }
        
        
        
        
//        firebaseReference.child("game").observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get all the games
//            //print(snapshot)
//            let value = snapshot.value as? NSDictionary//[String:AnyObject]//NSDictionary
//            
//            for (key, val) in value! {
//                print (key)
//                print (val)
//                let newGame = Game()
//                newGame.uid = key as? String
//                
//                let dict : NSDictionary = val as! NSDictionary
//                
//                newGame.organizerUid = dict.value(forKey: "organizer") as! String?
//                newGame.sport = dict.value(forKey: "sport") as! String?
//                var temp = dict.value(forKey: "price") as! String?
//                newGame.price = Double (temp!)
//                temp = dict.value(forKey: "playersNeeded") as! String?
//                newGame.playersNeeded = Int(temp!)
//                
//                let stringDate = dict.value(forKey: "date") as! String?
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
//                newGame.date = dateFormatter.date(from: stringDate!)
//                
//                let location = dict.value(forKey: "location") as! NSDictionary
//                
//                temp = location.value(forKey: "latitude") as! String?
//                newGame.latitude = Double(temp!)
//                temp = location.value(forKey: "longitude") as! String?
//                newGame.longitude = Double(temp!)
//                let confirmedPlayer = dict.value(forKey: "confirmedPlayer") as? NSDictionary
//                
//                if confirmedPlayer != nil {
//                    for (_, value) in confirmedPlayer! {
//                        newGame.confirmedPlayers?.append(value as! String)
//                    }
//                }
//                //
//                //if ((self.userID) != nil) {
//                //if (self.userID != newGame.organizerUid) {
//                // if !(newGame.confirmedPlayers?.contains(self.userID!))! {
//                self.games.append(newGame)
//                //}
//                //}
//                //}
//                
//                print("GAMES:")
//                print(self.games.count)
//                //
//                //                for (key2,val2) in (val as? NSDictionary)! {
//                //
//                //                    print (key2)
//                //                    print (val2)
//                //                }
//            }
//            
//            
//            //            if value != nil {
//            //                for (key, val) in value! {
//            //                    print(val["confirmedPlayer"])
//            //
//            ////                    var newGame : Game
//            ////                    newGame.uid =
//            //                    print("-----------")
//            //                }
//            //            }
//            //
//            //            let username = value?["username"] as? String ?? ""
//            
//            //let user = User.init(username: username)
//            // ...
//            
//            OperationQueue.main.addOperation({() -> Void in
//                self.availableMatchesTableView.reloadData()
//            })
//        }) { (error) in
//            print(error.localizedDescription)
//        }
    }
    
    //MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //using custom cell
        print ("PLAYER COUNT AGAIN:" + String(self.players.count))
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCustomCell", for: indexPath) as! PlayerTableViewCell
        let player = players[(indexPath as NSIndexPath).row]
        
        cell.ageLabel.text = player.age
        cell.nameLabel.text = player.name
        cell.phoneNumberLabel.text = player.phone
        cell.playerImageView.image = UIImage(named: "defaultPhoto")
        cell.ratingLabel.text = String(format:"%.1f ⭐️", player.rating! )
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        if (trips != nil) {
        //            return trips!.count
        //        } else {
        //            return 0
        //        }
        return players.count
    }
    
    //MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //TODO: add rating segue
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        performSegue(withIdentifier: "RatePlayer", sender: tableView.cellForRow(at: indexPath))
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - UIScrollView Delegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("Scroll")
        if (scrollView.panGestureRecognizer.translation(in: scrollView.superview).y>0 ){
            //            print("up")
            navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            //            print("down")
            //navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    @IBAction func unwindBackFromRating(segue: UIStoryboardSegue) {
        self.performSegue(withIdentifier: "unwindBackFromRating", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "RatePlayer") {
            if let destinationController = segue.destination as? RatePlayerViewController {
                //let cell = self.tableView.cellForRow(at: self.tableView.indexPathForSelectedRow!) as? PlayerTableViewCell
                //let player = players[(indexPath as NSIndexPath).row]
                let indexPath = self.tableView.indexPathForSelectedRow!
                destinationController.player = self.players[(indexPath as NSIndexPath).row]
            }
        }
    }
}
