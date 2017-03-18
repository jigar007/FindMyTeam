//
//  MatchesViewController.swift
//  Codebrew2017
//
//  Created by Federico Malesani on 18/3/17.
//  Copyright © 2017 University of Melbourne. All rights reserved.
//

import UIKit
import Firebase

class MatchesViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var availableMatchesTableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var games = [Game]()
    var firebaseReference: FIRDatabaseReference!
    let userID = FIRAuth.auth()?.currentUser?.uid
    
//    @IBAction func showInMap(_ sender: AnyObject) {
//        performSegue(withIdentifier: "GoToMap", sender: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        firebaseReference = FIRDatabase.database().reference()
        
        // Pull To Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(MatchesViewController.refreshData), for: UIControlEvents.valueChanged)
        availableMatchesTableView.addSubview(self.refreshControl)
        
        //load data
        refreshData()
    }
    
    func refreshData() {
        self.games = [Game]()
        //get data from firebase
        firebaseReference.child("game").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get all the games
            print(snapshot)
            let value = snapshot.value as? [String:AnyObject]//NSDictionary

           print(value)
            
            for (key, val) in value! {
                print (key)
                print (val)
                let newGame = Game()
                newGame.uid = key as? String
                
                let dict : NSDictionary = val as! NSDictionary
                
                newGame.organizerUid = dict.value(forKey: "organizer") as! String?
                newGame.sport = dict.value(forKey: "sport") as! String?
                newGame.price = dict.value(forKey: "price") as! NSNumber?
                newGame.playersNeeded = dict.value(forKey: "playersNeeded") as! NSNumber?
                newGame.date = Date() //TODO fix with real date
                
                let location = dict.value(forKey: "location") as! NSDictionary
                
                newGame.latitude = location.value(forKey: "latitude") as! NSNumber?
                newGame.longitude = location.value(forKey: "longitude") as! NSNumber?
                
                let confirmedPlayer = dict.value(forKey: "confirmedPlayer") as? NSDictionary
                
                if confirmedPlayer != nil {
                    for (_, value) in confirmedPlayer! {
                        newGame.confirmedPlayers?.append(value as! String)
                    }
                }
//                
                if (self.userID != newGame.organizerUid) {
                    if !(newGame.confirmedPlayers?.contains(self.userID!))! {
                        self.games.append(newGame)
                    }
                }
//                
//                for (key2,val2) in (val as? NSDictionary)! {
//                    
//                    print (key2)
//                    print (val2)
//                }
            }
            
//            if value != nil {
//                for (key, val) in value! {
//                    print(val["confirmedPlayer"])
//                    
////                    var newGame : Game
////                    newGame.uid =
//                    print("-----------")
//                }
//            }
//
//            let username = value?["username"] as? String ?? ""
            
            //let user = User.init(username: username)
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.availableMatchesTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //using custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchTableViewCell", for: indexPath) as! MatchTableViewCell
        let game = games[(indexPath as NSIndexPath).row]
        
        cell.locationLabel = nil
        cell.organizerImageView = nil
        cell.priceLabel = nil
        cell.sportTypeLable = nil
        cell.timeLabel = nil
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        if (trips != nil) {
        //            return trips!.count
        //        } else {
        //            return 0
        //        }
        return games.count
    }
    
    //MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
}
