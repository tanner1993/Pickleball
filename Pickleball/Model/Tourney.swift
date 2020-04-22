//
//  Tourney.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/24/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

class Tourney: NSObject {
    var name: String?
    var id: String?
    var skill_level: Float?
    var type: String?
    var sex: String?
    var age_group: String?
    var start_date: Double?
    var time: Double?
    var duration: Int?
    var creator: String?
    var state: String?
    var county: String?
    var active: Int?
    var finals1: Int?
    var finals2: Int?
    var winner: Int?
    var yetToView: [String]?
    var notifBubble: Int?
    var regTeams: Int?
    
    func removeCantChallenge(team_1_player_1: String, team_1_player_2: String, team_2_player_1: String, team_2_player_2: String, tourneyId: String) {
        let ref = Database.database().reference().child("tourneys").child(tourneyId)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? NSDictionary {
                if let cantChallenge = value["cant_challenge"] as? [String] {
                    var tourneyCantChallenge = cantChallenge
                    tourneyCantChallenge.remove(at: tourneyCantChallenge.firstIndex(of: team_1_player_1)!)
                    tourneyCantChallenge.remove(at: tourneyCantChallenge.firstIndex(of: team_1_player_2)!)
                    tourneyCantChallenge.remove(at: tourneyCantChallenge.firstIndex(of: team_2_player_1)!)
                    tourneyCantChallenge.remove(at: tourneyCantChallenge.firstIndex(of: team_2_player_2)!)
                    Database.database().reference().child("tourneys").child(tourneyId).child("cant_challenge").setValue(tourneyCantChallenge)
                }
            }
        }, withCancel: nil)
    }
}
