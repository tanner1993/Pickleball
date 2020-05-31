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
    var teams: [Team]?
    var matches: [Match2]?
    var publicBool: Bool?
    var daysToPlay: Int?
    var invites: [String]?
    var simpleInvites: [String]?
    
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
    
    func observeTourneyTeams(tourneyId: String, completion: @escaping ([Team]?) -> ()) {
        var teams = [Team]()
        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("teams").queryOrdered(byChild: "rank")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                for index in value {
                    let team = Team()
                    let player1Id = index.value["player1"] as? String ?? "Player not found"
                    let player2Id = index.value["player2"] as? String ?? "Player not found"
                    let rank = index.value["rank"] as? Int ?? 100
                    let wins = index.value["wins"] as? Int ?? -1
                    let losses = index.value["losses"] as? Int ?? -1
                    team.player2 = player2Id
                    team.player1 = player1Id
                    team.rank = rank
                    team.wins = wins
                    team.losses = losses
                    team.teamId = index.key
                    teams.append(team)
                }
                let sortedTeams = teams.sorted { p1, p2 in
                    return (p1.rank!) < (p2.rank!)
                }
                completion(sortedTeams)
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
                let timeOfScores = value["timeOfScores"] as? Double ?? Date().timeIntervalSince1970
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
                matchT.timeOfScores = timeOfScores
                completion(matchT)
            }
            
        }, withCancel: nil)
    }
    
    func handleSetupSemifinal1() {
        var team1stIndex = -1
        var team2ndIndex = -1
        var team3rdIndex = -1
        var team4thIndex = -1
        guard let tourneyTeams = teams else {
            return
        }
        for (index, element) in tourneyTeams.enumerated() {
            if element.rank == 1 {
                team1stIndex = index
            } else if element.rank == 2 {
                team2ndIndex = index
            } else if element.rank == 3 {
                team3rdIndex = index
            } else if element.rank == 4 {
                team4thIndex = index
            }
        }
        handleSetupSemifinal2(team_1_player_1: tourneyTeams[team1stIndex].player1!, team_1_player_2: tourneyTeams[team1stIndex].player2!, team_2_player_1: tourneyTeams[team4thIndex].player1!, team_2_player_2: tourneyTeams[team4thIndex].player2!)
        handleSetupSemifinal2(team_1_player_1: tourneyTeams[team2ndIndex].player1!, team_1_player_2: tourneyTeams[team2ndIndex].player2!, team_2_player_1: tourneyTeams[team3rdIndex].player1!, team_2_player_2: tourneyTeams[team3rdIndex].player2!)
        var yetToView2 = [String]()
        for index in yetToView ?? [String]() {
            yetToView2.append(index)
        }
        let userIds = [tourneyTeams[team1stIndex].player1!, tourneyTeams[team1stIndex].player2!, tourneyTeams[team4thIndex].player1!, tourneyTeams[team4thIndex].player2!, tourneyTeams[team2ndIndex].player1!, tourneyTeams[team2ndIndex].player2!, tourneyTeams[team3rdIndex].player1!, tourneyTeams[team3rdIndex].player2!]
        for index in userIds {
            if yetToView2.contains(index) == false {
                yetToView2.append(index)
            }
        }
        
        let notificationsRef = Database.database().reference()
        let childUpdates = ["/\("tourneys")/\(self.id!)/\("yet_to_view")/": yetToView2] as [String : Any]
        notificationsRef.updateChildValues(childUpdates, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if error != nil {
                print("Data could not be saved: \(String(describing: error)).")
                return
            }
            
            print("Crazy data 2 saved!")
            
            
        })
    }
    
    func handleSetupSemifinal2(team_1_player_1: String, team_1_player_2: String, team_2_player_1: String, team_2_player_2: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let userIds = [team_1_player_1, team_1_player_2, team_2_player_1, team_2_player_2]
        
        let timeOfChallenge = Date().timeIntervalSince1970
        let ref = Database.database().reference().child("tourneys").child(id ?? "none").child("matches")
        let createMatchRef = ref.childByAutoId()
        let values = ["style": style ?? 1, "active": 1, "team_1_player_1": team_1_player_1, "team_1_player_2": team_1_player_2, "team_2_player_1": team_2_player_1, "team_2_player_2": team_2_player_2, "team1_scores": [0, 0, 0, 0, 0], "team2_scores": [0, 0, 0, 0, 0], "time": timeOfChallenge] as [String : Any]
        createMatchRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            
            let notificationsRef = Database.database().reference()
            let childUpdates = ["/\("user_tourneys")/\(team_1_player_1)/\(self.id!)/": team_1_player_1 == uid ? 0 : 1, "/\("user_tourneys")/\(team_1_player_2)/\(self.id!)/": team_1_player_2 == uid ? 0 : 1, "/\("user_tourneys")/\(team_2_player_1)/\(self.id!)/": team_2_player_1 == uid ? 0 : 1, "/\("user_tourneys")/\(team_2_player_2)/\(self.id!)/": team_2_player_2 == uid ? 0 : 1] as [String : Any]
            notificationsRef.updateChildValues(childUpdates, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if error != nil {
                    print("Data could not be saved: \(String(describing: error)).")
                    return
                }
                
                let newMessage = "You have made it to semifinals!"
                let title = self.name!
                for index in userIds {
                    Database.database().reference().child("users").child(index).child("deviceId").observeSingleEvent(of: .value, with: {(snapshot) in
                        if let value = snapshot.value {
                            let deviceId = value as? String ?? "none"
                            let pusher = PushNotificationHandler()
                            pusher.setupPushNotification(deviceId: deviceId, message: newMessage, title: title)
                        }
                    })
                }
                
                print("Crazy data 2 saved!")
                
                
            })
            
        })
    }
}
