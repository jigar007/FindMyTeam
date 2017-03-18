//
//  ViewController.swift
//  Codebrew2017
//
//  Created by Changchang on 18/3/17.
//  Copyright © 2017 University of Melbourne. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }
    
    /**
     Method to check whether user is logged in.
     */
    func checkIfUserIsLoggedIn() {
        
//        if FIRAuth.auth()?.currentUser?.uid != nil {
        if false {
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


}

