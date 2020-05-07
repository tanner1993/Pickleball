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
    var end_date: Double?
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
    var style: Int?
    
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
    
    func fetchMatch(tourneyId: String, matchId: String, completion: @escaping (Match2?) -> ()) {
        let matchReference = Database.database().reference().child("tourneys").child(tourneyId).child("matches").child(matchId)
        
        matchReference.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let matchT = Match2()
                let active = value["active"] as? Int ?? 0
                let submitter = value["submitter"] as? Int ?? 0
                let winner = value["winner"] as? Int ?? 0
                let style = value["style"] as? Int ?? 0
                let team_1_player_1 = value["team_1_player_1"] as? String ?? "Player not found"
                let team_1_player_2 = value["team_1_player_2"] as? String ?? "Player not found"
                let team_2_player_1 = value["team_2_player_1"] as? String ?? "Player not found"
                let team_2_player_2 = value["team_2_player_2"] as? String ?? "Player not found"
                //let idList = [team_1_player_1, team_1_player_2, team_2_player_1, team_2_player_2]
                //self.checkUser(player1: team_1_player_1, player2: team_1_player_2, player3: team_2_player_1, player4: team_2_player_2)
                //self.getPlayerNames(idList: idList)
                let team1_scores = value["team1_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                let team2_scores = value["team2_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                let time = value["time"] as? Double ?? Date().timeIntervalSince1970
                let forfeit = value["forfeit"] as? Int ?? 0
                //self.setupCorrectBottom(active: active, submitter: submitter, confirmers: team1_scores, team2: team2_scores, idList: idList, startTime: time, forfeit: forfeit)
                matchT.active = active
                matchT.winner = winner
                matchT.submitter = submitter
                matchT.team_1_player_1 = team_1_player_1
                matchT.team_1_player_2 = team_1_player_2
                matchT.team_2_player_1 = team_2_player_1
                matchT.team_2_player_2 = team_2_player_2
                matchT.team1_scores = team1_scores
                matchT.team2_scores = team2_scores
                matchT.matchId = matchId
                matchT.time = time
                matchT.forfeit = forfeit
                matchT.style = style
                matchT.doubles = team_1_player_2 == "Player not found" ? false : true
                completion(matchT)
            }
            
        }, withCancel: nil)
    }
}
