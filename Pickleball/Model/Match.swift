//
//  Match.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/6/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

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
    var style: Int?
    var doubles: Bool?
    var seen: Bool?
    var timeOfScores: Double?
    var court: String?
    var liked: Bool?
    var likes: [String]?
    
    func whichPlayerAmI() -> Int {
        guard let uid = Auth.auth().currentUser?.uid else {
            return 0
        }
        switch uid {
        case team_1_player_1:
            return 0
        case team_1_player_2:
            return 1
        case team_2_player_1:
            return 2
        case team_2_player_2:
            return 3
        default:
            return 0
        }
    }
    
    func createRematch(rematchStyle: Int, completion: @escaping (Match2?) -> ()) {
        let timeOfChallenge = Date().timeIntervalSince1970
        let ref = Database.database().reference().child("matches")
        let createMatchRef = ref.childByAutoId()
        var values = [String : Any]()
        if self.doubles! {
            values = ["active": 1, "team_1_player_1": self.team_1_player_1!, "team_1_player_2": self.team_1_player_2!, "team_2_player_1": self.team_2_player_1!, "team_2_player_2": self.team_2_player_2!, "team1_scores": [0, 0, 0, 0, 0], "team2_scores": [0, 0, 0, 0, 0], "time": timeOfChallenge, "style": rematchStyle]
        } else {
            values = ["active": 1, "team_1_player_1": self.team_1_player_1!, "team_2_player_1": self.team_2_player_1!, "team1_scores": [0, 0, 0, 0, 0], "team2_scores": [0, 0, 0, 0, 0], "time": timeOfChallenge, "style": rematchStyle]
        }
        createMatchRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            guard let rematchId = createMatchRef.key else {
                return
            }
                let notificationId = rematchId
            let notificationsRef = Database.database().reference().child("user_matches")
            
            var childUpdates = [String : Any]()
            if self.doubles! {
                if self.team_1_player_2 == "Guest" && self.team_2_player_2 == "Guest" {
                    childUpdates = ["/\(self.team_1_player_1!)/\(notificationId)/": 1, "/\(self.team_2_player_1!)/\(notificationId)/": 1]
                } else if self.team_1_player_2 == "Guest" {
                    childUpdates = ["/\(self.team_1_player_1!)/\(notificationId)/": 1, "/\(self.team_2_player_1!)/\(notificationId)/": 1, "/\(self.team_2_player_2!)/\(notificationId)/": 1]
                } else if self.team_2_player_2 == "Guest" {
                    childUpdates = ["/\(self.team_1_player_1!)/\(notificationId)/": 1, "/\(self.team_1_player_2!)/\(notificationId)/": 1, "/\(self.team_2_player_1!)/\(notificationId)/": 1]
                } else {
                    childUpdates = ["/\(self.team_1_player_1!)/\(notificationId)/": 1, "/\(self.team_1_player_2!)/\(notificationId)/": 1, "/\(self.team_2_player_1!)/\(notificationId)/": 1, "/\(self.team_2_player_2!)/\(notificationId)/": 1]
                }
            } else {
                childUpdates = ["/\(self.team_1_player_1!)/\(notificationId)/": 1, "/\(self.team_2_player_1!)/\(notificationId)/": 1]
            }
            notificationsRef.updateChildValues(childUpdates, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if error != nil {
                    print("Data could not be saved: \(String(describing: error)).")
                    return
                }
                
                print("Crazy data 2 saved!")
                let matchT = Match2()
                matchT.active = 1
                matchT.winner = 0
                matchT.submitter = 0
                matchT.team_1_player_1 = self.team_1_player_1!
                matchT.team_1_player_2 = self.team_1_player_2!
                matchT.team_2_player_1 = self.team_2_player_1!
                matchT.team_2_player_2 = self.team_2_player_2!
                matchT.team1_scores = [0, 0, 0, 0, 0]
                matchT.team2_scores = [0, 0, 0, 0, 0]
                matchT.matchId = rematchId
                matchT.time = timeOfChallenge
                matchT.style = rematchStyle
                matchT.forfeit = 0
                if self.doubles! {
                    matchT.doubles = true
                } else {
                    matchT.doubles = false
                    matchT.team_1_player_2 = "Player not found"
                    matchT.team_2_player_2 = "Player not found"
                }
                completion(matchT)
                
            })
            
        })
    }
    
    func uploadLike() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("matches").child(matchId!).child("likes")
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value {
                var likesUpload = value as? [String] ?? [String]()
                if likesUpload.contains(uid) == false {
                    likesUpload.append(uid)
                    self.likes?.append(uid)
                    if likesUpload.count == 5 {
                        self.notifyPlayerOfLikes()
                    }
                    ref.setValue(likesUpload)
                } else {
                    likesUpload.remove(at: likesUpload.firstIndex(of: uid)!)
                    self.likes!.remove(at: self.likes!.firstIndex(of: uid)!)
                    ref.setValue(likesUpload)
                }
            }
        })
    }
    
    func notifyPlayerOfLikes() {
        Database.database().reference().child("users").child(team_1_player_1!).child("deviceId").observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value {
                let deviceId = value as? String ?? "none"
                let pusher = PushNotificationHandler()
                pusher.setupPushNotification(deviceId: deviceId, message: "5 players have already liked a match you logged", title: "Match Play")
            }
        })
        Database.database().reference().child("users").child(team_2_player_1!).child("deviceId").observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value {
                let deviceId = value as? String ?? "none"
                let pusher = PushNotificationHandler()
                pusher.setupPushNotification(deviceId: deviceId, message: "5 players have already liked a match you logged", title: "Match Play")
            }
        })
    }
    
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
        let childUpdates = ["/\("user_tourneys")/\(player1)/\(tourneyId)/": team_1_player_1 == uid ? 0 : 1, "/\("user_tourneys")/\(player2)/\(tourneyId)/": team_1_player_2 == uid ? 0 : 1, "/\("user_tourneys")/\(player3)/\(tourneyId)/": team_2_player_1 == uid ? 0 : 1, "/\("user_tourneys")/\(player4)/\(tourneyId)/": team_2_player_2 == uid ? 0 : 1, "/\("tourneys")/\(tourneyId)/\("yet_to_view")/": yetToView] as [String : Any]
        notificationsRef.updateChildValues(childUpdates, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if error != nil {
                print("Data could not be saved: \(String(describing: error)).")
                return
            }
            
            print("Model is working!")
            
            
        })
    }
    
    func sendMatchPushNotifications(uid: String, userPlayer1: String, userPlayer2: String, oppPlayer1: String, oppPlayer2: String, message: String, title: String) {
        var idList = [team_1_player_1!, team_1_player_2!, team_2_player_1!, team_2_player_2!]
        var nameOnInvite = String()
        switch uid {
        case team_1_player_1:
            idList.remove(at: 0)
            nameOnInvite = userPlayer1
        case team_1_player_2:
            idList.remove(at: 1)
            nameOnInvite = userPlayer2
        case team_2_player_1:
            idList.remove(at: 2)
            nameOnInvite = oppPlayer1
        case team_2_player_2:
            idList.remove(at: 3)
            nameOnInvite = oppPlayer2
        default:
            print("failedUser")
        }
        let newMessage = "\(nameOnInvite) " + message
        for index in 0...2 {
            Database.database().reference().child("users").child(idList[index]).child("deviceId").observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value {
                    let deviceId = value as? String ?? "none"
                    let pusher = PushNotificationHandler()
                    pusher.setupPushNotification(deviceId: deviceId, message: newMessage, title: title)
                }
            })
        }
    }
    
    func winChecker(user: Int, opp: Int) -> Int {
        if user > opp {
            return 0
        } else {
            return 1
        }
    }
    
    func checkScoresValiditySingle(game1UserScore: String, game1OppScore: String) -> Int {
        var team1Score = Int()
        var team2Score = Int()
        if game1UserScore == "" || game1OppScore == "" {
            return 1
        } else {
            team1Score = Int(game1UserScore)!
            team2Score = Int(game1OppScore)!
        }
        
        if (team1Score < 11 && team2Score < 11) {
            return 2
        } else if (abs(team1Score - team2Score) < 2) {
            return 3
        } else {
            let gameWinner = winChecker(user: team1Score, opp: team2Score)
            
            if gameWinner == 0 {
                winner = 1
                team1_scores = [team1Score, 0, 0, 0, 0]
                team2_scores = [team2Score, 0, 0, 0, 0]
                return 0
            } else if gameWinner == 1 {
                winner = 2
                team1_scores = [team1Score, 0, 0, 0, 0]
                team2_scores = [team2Score, 0, 0, 0, 0]
                return 0
            } else {
                return 10
            }
        }
    }
    
    func checkScoresValidityThree(game1UserScore: String, game1OppScore: String, game2UserScore: String, game2OppScore: String, game3UserScore: String, game3OppScore: String) -> Int {
        var team1Wins = 0
        var team2Wins = 0
        var finalTeam1Scores = [Int]()
        var finalTeam2Scores = [Int]()
        var gameWinners = [Int]()
        if game1UserScore == "" || game1OppScore == "" || game2UserScore == "" || game2OppScore == "" {
            return 1
        } else {
            finalTeam1Scores.append(Int(game1UserScore)!)
            finalTeam2Scores.append(Int(game1OppScore)!)
            finalTeam1Scores.append(Int(game2UserScore)!)
            finalTeam2Scores.append(Int(game2OppScore)!)
        }
        
        if (finalTeam1Scores[0] < 11 && finalTeam2Scores[0] < 11) || (finalTeam1Scores[1] < 11 && finalTeam2Scores[1] < 11) {
            return 2
        } else if (abs(finalTeam1Scores[0] - finalTeam2Scores[0]) < 2) || (abs(finalTeam1Scores[1] - finalTeam2Scores[1]) < 2) {
            return 3
        } else {
            for index in 0...1 {
                gameWinners.append(winChecker(user: finalTeam1Scores[index], opp: finalTeam2Scores[index]))
                if gameWinners[index] == 0 {
                    team1Wins += 1
                } else {
                    team2Wins += 1
                }
            }
            if team1Wins == 2 {
                winner = 1
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                team1_scores = finalTeam1Scores
                team2_scores = finalTeam2Scores
                return 0
            } else if team2Wins == 2 {
                winner = 2
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                team1_scores = finalTeam1Scores
                team2_scores = finalTeam2Scores
                return 0
            }
        }
        
        if game3UserScore == "" || game3OppScore == "" {
            return 6
        } else {
            finalTeam1Scores.append(Int(game3UserScore)!)
            finalTeam2Scores.append(Int(game3OppScore)!)
        }
        
        if finalTeam1Scores[2] < 11 && finalTeam2Scores[2] < 11 {
            return 2
        } else if abs(finalTeam1Scores[2] - finalTeam2Scores[2]) < 2 {
            return 3
        } else {
            gameWinners.append(winChecker(user: finalTeam1Scores[2], opp: finalTeam2Scores[2]))
            if gameWinners[2] == 0 {
                team1Wins += 1
            } else {
                team2Wins += 1
            }
            
            if team1Wins == 2 {
                winner = 1
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                team1_scores = finalTeam1Scores
                team2_scores = finalTeam2Scores
                return 0
            } else if team2Wins == 2 {
                winner = 2
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                team1_scores = finalTeam1Scores
                team2_scores = finalTeam2Scores
                return 0
            }
            return 10
        }
    }
    
    func checkScoresValidityFive(game1UserScore: String, game1OppScore: String, game2UserScore: String, game2OppScore: String, game3UserScore: String, game3OppScore: String, game4UserScore: String, game4OppScore: String, game5UserScore: String, game5OppScore: String) -> Int {
        var team1Wins = 0
        var team2Wins = 0
        var finalTeam1Scores = [Int]()
        var finalTeam2Scores = [Int]()
        var gameWinners = [Int]()
        if game1UserScore == "" || game1OppScore == "" || game2UserScore == "" || game2OppScore == "" || game3UserScore == "" || game3OppScore == "" {
            return 1
        } else {
            finalTeam1Scores.append(Int(game1UserScore)!)
            finalTeam2Scores.append(Int(game1OppScore)!)
            finalTeam1Scores.append(Int(game2UserScore)!)
            finalTeam2Scores.append(Int(game2OppScore)!)
            finalTeam1Scores.append(Int(game3UserScore)!)
            finalTeam2Scores.append(Int(game3OppScore)!)
        }
        
        if (finalTeam1Scores[0] < 11 && finalTeam2Scores[0] < 11) || (finalTeam1Scores[1] < 11 && finalTeam2Scores[1] < 11) || (finalTeam1Scores[2] < 11 && finalTeam2Scores[2] < 11) {
            return 2
        } else if (abs(finalTeam1Scores[0] - finalTeam2Scores[0]) < 2) || (abs(finalTeam1Scores[1] - finalTeam2Scores[1]) < 2) || (abs(finalTeam1Scores[2] - finalTeam2Scores[2]) < 2) {
            return 3
        } else {
            for index in 0...2 {
                gameWinners.append(winChecker(user: finalTeam1Scores[index], opp: finalTeam2Scores[index]))
                if gameWinners[index] == 0 {
                    team1Wins += 1
                } else {
                    team2Wins += 1
                }
            }
            if team1Wins == 3 {
                winner = 1
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                team1_scores = finalTeam1Scores
                team2_scores = finalTeam2Scores
                return 0
            } else if team2Wins == 3 {
                winner = 2
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                team1_scores = finalTeam1Scores
                team2_scores = finalTeam2Scores
                return 0
            }
        }
        
        if game4UserScore == "" || game4OppScore == "" {
            return 4
        } else {
            finalTeam1Scores.append(Int(game4UserScore)!)
            finalTeam2Scores.append(Int(game4OppScore)!)
        }
        
        if finalTeam1Scores[3] < 11 && finalTeam2Scores[3] < 11 {
            return 2
        } else if abs(finalTeam1Scores[3] - finalTeam2Scores[3]) < 2 {
            return 3
        } else {
            gameWinners.append(winChecker(user: finalTeam1Scores[3], opp: finalTeam2Scores[3]))
            if gameWinners[3] == 0 {
                team1Wins += 1
            } else {
                team2Wins += 1
            }
            
            if team1Wins == 3 {
                winner = 1
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                team1_scores = finalTeam1Scores
                team2_scores = finalTeam2Scores
                return 0
            } else if team2Wins == 3 {
                winner = 2
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                team1_scores = finalTeam1Scores
                team2_scores = finalTeam2Scores
                return 0
            }
        }
        if game5UserScore == "" || game5OppScore == "" {
            return 5
        } else {
            finalTeam1Scores.append(Int(game5UserScore)!)
            finalTeam2Scores.append(Int(game5OppScore)!)
        }
        
        if finalTeam1Scores[4] < 11 && finalTeam2Scores[4] < 11 {
            return 2
        } else if abs(finalTeam1Scores[4] - finalTeam2Scores[4]) < 2 {
            return 3
        } else {
            gameWinners.append(winChecker(user: finalTeam1Scores[4], opp: finalTeam2Scores[4]))
            if gameWinners[4] == 0 {
                team1Wins += 1
            } else {
                team2Wins += 1
            }
            
            if team1Wins == 3 {
                winner = 1
                team1_scores = finalTeam1Scores
                team2_scores = finalTeam2Scores
                return 0
            } else if team2Wins == 3 {
                winner = 2
                team1_scores = finalTeam1Scores
                team2_scores = finalTeam2Scores
                return 0
            } else {
                return 10
            }
        }
    }
    
}
