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
    var points: Int?
    var rank: Int?
    var teamId: String?
    
    func updateTeamWins(tourneyId: String, winner: Int) {
        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("teams")
        let valuesTeam1 = ["wins": winner == 1 ? wins! + 1 : wins!, "losses": winner == 2 ? losses! + 1 : losses!] as [String : Any]
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
    
    func updateTeamRobinWins(tourneyId: String, winner: Bool, pointsGained: Int) {
        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("teams").child(teamId!)
        let valuesTeam1 = ["wins": winner ? wins! + 1 : wins!, "losses": winner ? losses! : losses! + 1, "points": points! + pointsGained] as [String : Any]
        let childUpdates = valuesTeam1
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

class TeamObject: NSObject {
    var teamEntry: [String: Team2]?
}

class Team2: NSObject {
    var player1: String?
    var player2: String?
    var wins: Int?
    var losses: Int?
    var rank: Int?

}
