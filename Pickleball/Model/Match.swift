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
    var style: Int?
    var doubles: Bool?
    
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
                return -1
            }
        }
    }
    
}
