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
    var latitude: Double?
    var longitude: Double?
    var organizerUid: String?
    var playersNeeded: Int?
    var sport: String?
    var confirmedPlayers: [String]?
    var price: Double?
}
