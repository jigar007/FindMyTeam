//
//  ScheduledMatchesViewController.swift
//  Codebrew2017
//
//  Created by Federico Malesani on 19/3/17.
//  Copyright © 2017 University of Melbourne. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import Contacts

class ScheduledMatchesViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var scheduledMatchesTableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var games = [Game]()
    var firebaseReference: FIRDatabaseReference!
    var userID = FIRAuth.auth()?.currentUser?.uid
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        firebaseReference = FIRDatabase.database().reference()
        
        // Pull To Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(MatchesViewController.refreshData), for: UIControlEvents.valueChanged)
        scheduledMatchesTableView.addSubview(self.refreshControl)
        
        //load data
        refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userID = FIRAuth.auth()?.currentUser?.uid
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
                let confirmedPlayers = dict.value(forKey: "confirmedPlayer") as? [String: AnyObject]
                
                if confirmedPlayers != nil {
                    for i in confirmedPlayers! {
                        let value = i.value
                        
                        newGame.confirmedPlayers.append(value["id"]! as! String)
                        
                        
                    }
                }
//                let confirmedPlayer = dict.value(forKey: "confirmedPlayer") as? NSDictionary
//                
//                if confirmedPlayer != nil {
//                    for (_, value) in confirmedPlayer! {
//                        newGame.confirmedPlayers.append(value as! String)
//                    }
//                }
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
                self.scheduledMatchesTableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! ScheduledTableViewCell
        let game = games[(indexPath as NSIndexPath).row]
        
        //cell configuration
        cell.priceLabel.text = String(format:"%.1f $", game.price!)
        
        let dateFormatterForCell = DateFormatter()
        dateFormatterForCell.dateFormat = "HH a"
        
        cell.mainLabel.text = game.sport

        let location = CLLocation(latitude: game.latitude!, longitude: game.longitude!)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
            } else {
                
                if (placemarks?.count)! > 0 {
                    let pm = placemarks![0]
                    cell.thirdLabel.text =
                        CNPostalAddressFormatter.string(from: self.postalAddressFromAddressDictionary(pm.addressDictionary as! Dictionary<NSObject, AnyObject>), style: .mailingAddress)
                }
                else {
                    print("Problem with the data received from geocoder")
                }
                
            }
        })
        
        let date = game.date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
        cell.secondLabel.text = formatter.string(from: date!)
        
        dateFormatterForCell.dateFormat = "MM"
        var monthStringForCalendar:String?
        let monthNumber = Int(dateFormatterForCell.string(from: game.date! as Date))
        
        if (monthNumber != nil) {
            switch monthNumber! {
            case 01:
                monthStringForCalendar = "JAN"
            case 02:
                monthStringForCalendar = "FEB"
            case 03:
                monthStringForCalendar = "MAR"
            case 04:
                monthStringForCalendar = "APR"
            case 05:
                monthStringForCalendar = "MAY"
            case 06:
                monthStringForCalendar = "JUN"
            case 07:
                monthStringForCalendar = "JUL"
            case 08:
                monthStringForCalendar = "AUG"
            case 09:
                monthStringForCalendar = "SEP"
            case 10:
                monthStringForCalendar = "OCT"
            case 11:
                monthStringForCalendar = "NOV"
            case 12:
                monthStringForCalendar = "DEC"
            default:
                monthStringForCalendar = "ERR"
            }
        } else {
            monthStringForCalendar = "NIL"
        }
        
        cell.thumbnailView.month = monthStringForCalendar! as NSString
        
        dateFormatterForCell.dateFormat = "dd"
        cell.thumbnailView.day = dateFormatterForCell.string(from: game.date! as Date) as NSString
        
        cell.thumbnailView.layer.cornerRadius = cell.thumbnailView.layer.bounds.size.width/2
        cell.thumbnailView.layer.borderColor = UIColor.black.cgColor
        cell.thumbnailView.layer.borderWidth = 1
        cell.thumbnailView.clipsToBounds = true
        cell.thumbnailView.transform = CGAffineTransform(rotationAngle: CGFloat(-0.3))
        
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
        selectedRow = indexPath.item
        performSegue(withIdentifier: "ShowPlayers", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowPlayers") {
            let destinationController = segue.destination as? Match_Detail_Layout
            let players = [Player]()
            print(games[selectedRow!])
            
                
            destinationController?.players = players
            
            

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
