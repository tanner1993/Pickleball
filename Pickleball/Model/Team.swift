//
//  Team.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/4/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

class Team: NSObject {
    var player1: String?
    var player1Name: String?
    var player2: String?
    var wins: Int?
    var losses: Int?
    var rank: Int?
    var teamId: String?
    
    func updateTeamWins(tourneyId: String, winner: Int) {
        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("teams")
        let valuesTeam1 = ["rank": rank!, "wins": winner == 1 ? wins! + 1 : wins!, "losses": winner == 2 ? losses! + 1 : losses!, "player1": player1!, "player2": player2 ?? "none"] as [String : Any]
        let childUpdates = ["/\(teamId ?? "none")/": valuesTeam1]
        ref.updateChildValues(childUpdates, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            
            print("Crazy data saved!")
            
            
        })
    }
}
