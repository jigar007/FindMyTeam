//
//  Game.swift
//  Codebrew2017
//
//  Created by Federico Malesani on 18/3/17.
//  Copyright © 2017 University of Melbourne. All rights reserved.
//
import Foundation

class Game: NSObject {
    
    var uid: String?
    var date: Date?
    var latitude: NSNumber?
    var longitude: NSNumber?
    var organizerUid: String?
    var playersNeeded: NSNumber?
    var sport: String?
    var confirmedPlayers: [String]?
    var price: NSNumber?
}
