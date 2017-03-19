//
//  RatePlayerViewController.swift
//  Codebrew2017
//
//  Created by Federico Malesani on 19/3/17.
//  Copyright © 2017 University of Melbourne. All rights reserved.
//

import UIKit

class RatePlayerViewController: UIViewController {

    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    var player = Player()
    
    @IBAction func goBack() {
        self.performSegue(withIdentifier: "unwindBackFromRating", sender: self)
    }
    
    @IBAction func ratePlayer(_ sender: Any) {
        
        player.numberOfRatings = player.numberOfRatings! + 1
        player.rating = player.rating! + (player.rating! - Float(self.ratingControl.playerRating/player.numberOfRatings!))
        
        //TODO: update firebase
        //player.id
        //player.rating
        //player.numberOfRatings
        

        
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.playerName.text = player.name
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
