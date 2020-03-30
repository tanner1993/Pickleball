//
//  Match.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/6/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

class Match: NSObject {
    var winner: String?
    var time: Double?
    var submitter: String?
    var active: Int?
    var challengerTeamId: String?
    var challengedTeamId: String?
    var matchId: String?
    var tourneyId: String?
    var challengerScores: [Int]?
    var challengedScores: [Int]?
}

class Match2: NSObject {
    var winner: Int?
    var submitter: Int?
    var time: Double?
    var active: Int?
    var forfeit: Int?
    var team_1_player_1: String?
    var team_1_player_2: String?
    var team_2_player_1: String?
    var team_2_player_2: String?
    var matchId: String?
    var team1_scores: [Int]?
    var team2_scores: [Int]?
    
    func sendTourneyNotifications(uid: String, tourneyId: String, tourneyYetToViewMatch: [String]) {
        var yetToView = tourneyYetToViewMatch
        if tourneyYetToViewMatch.contains(team_1_player_1 ?? "none") == false {
            uid != team_1_player_1 ? yetToView.append(team_1_player_1 ?? "none") : print("not here")
        }
        if tourneyYetToViewMatch.contains(team_1_player_2 ?? "none") == false {
            uid != team_1_player_2 ? yetToView.append(team_1_player_2 ?? "none") : print("not here")
        }
        if tourneyYetToViewMatch.contains(team_2_player_1 ?? "none") == false {
            uid != team_2_player_1 ? yetToView.append(team_2_player_1 ?? "none") : print("not here")
        }
        if tourneyYetToViewMatch.contains(team_2_player_2 ?? "none") == false {
            uid != team_2_player_2 ? yetToView.append(team_2_player_2 ?? "none") : print("not here")
        }
        let notificationsRef = Database.database().reference()
        guard let player1 = team_1_player_1, let player2 = team_1_player_2, let player3 = team_2_player_1, let player4 = team_2_player_2 else {
            return
        }
        let childUpdates = ["/\("tourney_notifications")/\(player1)/\(tourneyId)/": team_1_player_1 == uid ? 0 : 1, "/\("tourney_notifications")/\(player2)/\(tourneyId)/": team_1_player_2 == uid ? 0 : 1, "/\("tourney_notifications")/\(player3)/\(tourneyId)/": team_2_player_1 == uid ? 0 : 1, "/\("tourney_notifications")/\(player4)/\(tourneyId)/": team_2_player_2 == uid ? 0 : 1, "/\("tourneys")/\(tourneyId)/\("yet_to_view")/": yetToView] as [String : Any]
        notificationsRef.updateChildValues(childUpdates, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if error != nil {
                print("Data could not be saved: \(String(describing: error)).")
                return
            }
            
            print("Model is working!")
            
            
        })
    }
}
