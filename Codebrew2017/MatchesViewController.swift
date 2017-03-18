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
    //let userID = FIRAuth.auth()?.currentUser?.uid
    
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
        //get data from firebase
        firebaseReference.child("game").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get all the games
            let value = snapshot.value as? NSDictionary
            
            //print (value!)
//            if value != nil {
//                for organizedGame in value! {
//                    print
//                }
//            }
//            
//            let username = value?["username"] as? String ?? ""
            
            //let user = User.init(username: username)
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
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
