//
//  MatchesViewController.swift
//  Codebrew2017
//
//  Created by Federico Malesani on 18/3/17.
//  Copyright © 2017 University of Melbourne. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import Contacts

class MatchesViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var availableMatchesTableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var games = [Game]()
    var firebaseReference: FIRDatabaseReference!
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    @IBAction func showInMap(_ sender: AnyObject) {
        performSegue(withIdentifier: "GoToMap", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }
    @IBAction func logout(_ sender: UIBarButtonItem) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error{
            print(error)
        }
        let navigationController = UINavigationController(rootViewController: LoginRegisterController())
        present(navigationController, animated: true, completion: nil)
    }
    
    /**
     Method to check whether user is logged in.
     */
    func checkIfUserIsLoggedIn() {
        
        if FIRAuth.auth()?.currentUser?.uid != nil {
            // User is logged in
            // Do nothing currently
        } else {
            // User is not logged in
            let navigationController = UINavigationController(rootViewController: LoginRegisterController())
            present(navigationController, animated: true, completion: nil)
            //            let loginRegisterController = LoginRegisterController()
            //            present(loginRegisterController, animated: true, completion: nil)
        }
    }
    
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
            //print(snapshot)
            let value = snapshot.value as? NSDictionary//[String:AnyObject]//NSDictionary
            
            for (key, val) in value! {
                print (key)
                print (val)
                let newGame = Game()
                newGame.uid = key as? String
                
                let dict : NSDictionary = val as! NSDictionary
                
                newGame.organizerUid = dict.value(forKey: "organizer") as! String?
                newGame.sport = dict.value(forKey: "sport") as! String?
                var temp = dict.value(forKey: "price") as! String?
                newGame.price = Double (temp!)
                temp = dict.value(forKey: "playersNeeded") as! String?
                newGame.playersNeeded = Int(temp!)
                
                let stringDate = dict.value(forKey: "date") as! String?
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
                newGame.date = dateFormatter.date(from: stringDate!)
                
                let location = dict.value(forKey: "location") as! NSDictionary
                
                temp = location.value(forKey: "latitude") as! String?
                newGame.latitude = Double(temp!)
                temp = location.value(forKey: "longitude") as! String?
                newGame.longitude = Double(temp!)
                let confirmedPlayer = dict.value(forKey: "confirmedPlayer") as? NSDictionary
                
                if confirmedPlayer != nil {
                    for (_, value) in confirmedPlayer! {
                        newGame.confirmedPlayers?.append(value as! String)
                    }
                }
//                
                //if ((self.userID) != nil) {
                //if (self.userID != newGame.organizerUid) {
                   // if !(newGame.confirmedPlayers?.contains(self.userID!))! {
                        self.games.append(newGame)
                    //}
                //}
                //}
                
                print("GAMES:")
                print(self.games.count)
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
            
            OperationQueue.main.addOperation({() -> Void in
                self.availableMatchesTableView.reloadData()
            })
        }) { (error) in
            print(error.localizedDescription)
        }
        //self.availableMatchesTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //using custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCustomCell", for: indexPath) as! MatchTableViewCell
        let game = games[(indexPath as NSIndexPath).row]

        
        let location = CLLocation(latitude: game.latitude!, longitude: game.longitude!)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
            } else {
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks![0] 
                cell.locationLabel.text =
                    CNPostalAddressFormatter.string(from: self.postalAddressFromAddressDictionary(pm.addressDictionary as! Dictionary<NSObject, AnyObject>), style: .mailingAddress)
            }
            else {
                print("Problem with the data received from geocoder")
            }
                
            }
        })
        
        cell.organizerImageView = nil
        cell.sportTypeLable.text = game.sport
        
        let date = game.date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
        cell.timeLabel.text = formatter.string(from: date!)
        
        cell.priceLabel.text = String(format:"%.1f $", game.price!)
        
        return cell
    }
    
    func postalAddressFromAddressDictionary(_ addressdictionary: Dictionary<NSObject,AnyObject>) -> CNMutablePostalAddress {
        let address = CNMutablePostalAddress()
        
        address.street = addressdictionary["Street" as NSObject] as? String ?? ""
        address.state = addressdictionary["State" as NSObject] as? String ?? ""
        address.city = addressdictionary["City" as NSObject] as? String ?? ""
        address.country = addressdictionary["Country" as NSObject] as? String ?? ""
        address.postalCode = addressdictionary["ZIP" as NSObject] as? String ?? ""
        
        return address
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //join a match
        let joinAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Join!", handler: { (action, indexPath) -> Void in
            
            //TODO: update firebase and reload data
            
        })
        //getItAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        joinAction.backgroundColor = UIColor.green
        //productsTableView.setEditing(false, animated: true)
        return [joinAction]
    }


    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "GoToMap") {
            if let destinationNavigationController = segue.destination as? UINavigationController {
                let targetController = destinationNavigationController.topViewController as! MapViewController
                targetController.games = games
            }
        }
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
}
