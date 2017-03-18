//
//  Match Detail Layout.swift
//  Codebrew2017
//
//  Created by Thakkar Jigar on 18/3/17.
//  Copyright © 2017 University of Melbourne. All rights reserved.
//

import UIKit

class Match_Detail_Layout: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var typeOfGame: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var loction: UILabel!
    @IBOutlet weak var orgName: UILabel!
    @IBOutlet weak var phoneNum: UILabel!

    @IBOutlet weak var orgPic: UIImageView!
    @IBOutlet weak var noteText: UITextView!

}
