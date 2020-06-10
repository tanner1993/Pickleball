//
//  Player.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/10/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

class Player: NSObject {
    var name: String?
    var email: String?
    var id: String?
    var username: String?
    var exp: Int?
    var state: String?
    var county: String?
    var skill_level: Float?
    var halo_level: Int?
    var court: String?
    var match_wins: Int?
    var match_losses: Int?
    var tourneys_played: Int?
    var tourneys_won: Int?
    var birthdate: Double?
    var age_group: String?
    var sex: String?
    var friend: Int?
    var deviceId: String?
    var challenge: Bool?
    
    
    func getUserFirstAndLastName(fullName: String) -> String {
        var firstName = String()
        var lastName = String()
        var nextName = 0
        for char in fullName {
            if char != " " {
                if nextName == 0 {
                    firstName.append(char)
                } else {
                    lastName.append(char)
                }
            } else {
                lastName.removeAll()
                nextName += 1
            }
        }
        return firstName + " " + lastName
    }
    
    func findLocalPlayers(county: String, completion: @escaping ([Player]?) -> ()) {
        var players = [Player]()
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "county").queryEqual(toValue: county)
        query.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let player = Player()
                    let name = value["name"] as? String ?? "No Name"
                    let username = value["username"] as? String ?? "No Username"
                    let skillLevel = value["skill_level"] as? Float ?? 0.0
                    let exp = value["exp"] as? Int ?? 0
                    let haloLevel = player.haloLevel(exp: exp)
                    let state = value["state"] as? String ?? "No State"
                    let county = value["county"] as? String ?? "No County"
                    let deviceId = value["deviceId"] as? String ?? "none"
                    let sex = value["sex"] as? String ?? "none"
                    let birthdate = value["birthdate"] as? Double ?? 0
                    let ageGroup = player.getAgeGroup(birthdate: birthdate)
                    let matchesWon1 = value["match_wins"] as? Int ?? 0
                    let matchesLost1 = value["match_losses"] as? Int ?? 0
                    let court = value["court"] as? String ?? "none"
                    let challenge = value["challenge"] as? Bool ?? false
                    player.name = name
                    player.username = username
                    player.id = child.key
                    player.skill_level = skillLevel
                    player.halo_level = haloLevel
                    player.state = state
                    player.county = county
                    player.deviceId = deviceId
                    player.sex = sex
                    player.age_group = ageGroup
                    player.match_wins = matchesWon1
                    player.match_losses = matchesLost1
                    player.court = court

                    if player.id != Auth.auth().currentUser?.uid && challenge {
                        players.append(player)
                    }
                }
            }
            let sortedPlayers = players.sorted { p1, p2 in
                return (p1.halo_level!) > (p2.halo_level!)
            }
            completion(sortedPlayers)
        }
    }
    
    func getAgeGroup(birthdate: Double) -> String {
        let now = Double((Date().timeIntervalSince1970))
        let yearsOld = (now - birthdate) / 60.0 / 60.0 / 24.0 / 365.0
        switch yearsOld {
        case 0..<19:
            return "0 - 18"
        case 19..<35:
            return "19 - 34"
        case 35..<50:
            return "35 - 49"
        case 50..<125:
            return "50+"
        default:
            return "no age group"
        }
    }
    
    func acceptFriendRequest(playerId: String, notificationId: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let friendsRef = Database.database().reference()
        
        let childUpdates = ["/\("friends")/\(uid)/\(playerId)/": true, "/\("friends")/\(playerId)/\(uid)/": true] as [String : Any]
        friendsRef.updateChildValues(childUpdates, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if error != nil {
                print("Data could not be saved: \(String(describing: error)).")
                return
            }
            
            Database.database().reference().child("notifications").child(notificationId).removeValue()
            Database.database().reference().child("user_notifications").child(uid).child(notificationId).removeValue()
            
            print("Crazy data 2 saved!")
            
            
        })
    }
    
    func sendFriendRequest(playerId: String, playersDeviceId: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        
        let ref = Database.database().reference()
        let notifications2Ref = ref.child("notifications")
        let childRef = notifications2Ref.childByAutoId()
        let toId = playerId
        let fromId = uid
        let timeStamp = Int(Date().timeIntervalSince1970)
        let values = ["type": "friend", "toId": toId, "fromId" :fromId, "timestamp": timeStamp] as [String : Any]
        childRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if error != nil {
//                let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
//                messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(messageSendFailed, animated: true, completion: nil)
                print("Data could not be saved: \(String(describing: error)).")
                return
            }
            
            let notificationsRef = Database.database().reference()
            let notificationId = childRef.key!
            let childUpdates = ["/\("friends")/\(uid)/\(playerId)/": false, "/\("user_notifications")/\(playerId)/\(notificationId)/": 1] as [String : Any]
            notificationsRef.updateChildValues(childUpdates, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if error != nil {
//                    let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
//                    messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    self.present(messageSendFailed, animated: true, completion: nil)
                    print("Data could not be saved: \(String(describing: error)).")
                    return
                }
                Database.database().reference().child("users").child(uid).child("name").observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value {
                        let nameOnInvite = value as? String ?? "none"
                        let pusher = PushNotificationHandler()
                        pusher.setupPushNotification(deviceId: playersDeviceId, message: "\(nameOnInvite) wants to be your friend", title: "Friend Request")
                        //self.setupPushNotification(deviceId: self.playersDeviceId, nameOnInvite: nameOnInvite)
                    }
                })
                print("Crazy data 2 saved!")
                
                
            })
            
            print("Crazy data saved!")
            
            
        })
    }
    
    func revokeFriend(playerId: String) {
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            Database.database().reference().child("friends").child(uid).child(playerId).removeValue()
            Database.database().reference().child("friends").child(playerId).child(uid).removeValue()
        }
    
    func updatePlayerStats(playerId: String, winner: Int, userIsTeam1: Bool) {
        let user1NameRef = Database.database().reference().child("users").child(playerId)
        user1NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                let playerWins = value["match_wins"] as? Int
                let playerLosses = value["match_losses"] as? Int
                var childUpdates = [String: Any]()
                if userIsTeam1 {
                    childUpdates = ["/\("match_wins")/": winner == 1 ? playerWins! + 1 : playerWins!, "/\("match_losses")/": winner == 1 ? playerLosses! : playerLosses! + 1] as [String : Any]
                } else {
                    childUpdates = ["/\("match_wins")/": winner == 2 ? playerWins! + 1 : playerWins!, "/\("match_losses")/": winner == 2 ? playerLosses! : playerLosses! + 1] as [String : Any]
                }
                user1NameRef.updateChildValues(childUpdates, withCompletionBlock: {
                    (error:Error?, ref:DatabaseReference) in
                    
                    if error != nil {
                        print("Data could not be saved: \(String(describing: error)).")
                        return
                    }
                    
                    print("Crazy data 2 saved!")
                    
                    
                })
            }
        })
    }
    
    func getPlayerNameAndSkill(playerId: String, completion: @escaping (Player?) -> ()) {
    let user1NameRef = Database.database().reference().child("users").child(playerId)
    user1NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
        if let value = snapshot.value as? [String: AnyObject] {
            let playerInfo = Player()
            playerInfo.exp = value["exp"] as? Int
            playerInfo.halo_level = self.haloLevel(exp: playerInfo.exp!)
            playerInfo.name = value["name"] as? String
            playerInfo.skill_level = value["skill_level"] as? Float
            completion(playerInfo)
        }
    })
        
    }
    
    func getFirstAndLastInitial(name: String) -> String {
        var initials = ""
        var finalChar = 0
        for char in name {
            if finalChar == 0 {
                initials.append(char)
            }
            if finalChar == 1 {
                initials.append(char)
                initials.append(".")
                break
            }
            
            if char == " " {
                finalChar = 1
            }
        }
        return initials
    }
}



extension Player {
    
    func levelTitle(level: Int) -> String {
        switch level {
        case 1...4:
            return "Kitchen Resident"
        case 5...9:
            return "Little Dinker"
        case 10...14:
            return "Nasty Nelson"
        case 15...19:
            return "Lobster"
        case 20...24:
            return "Banger"
        case 25...29:
            return "Pro Dinker"
        case 30...34:
            return "Third Shot Drop"
        case 35...39:
            return "Dominator"
        case 40...44:
            return "Champion"
        case 45...49:
            return "Master"
        case 50:
            return "Pickleball Gamer"
        default:
            return "No Rank"
        }
    }
    
    func haloLevel(exp: Int) -> Int {
        switch exp {
        case 0...99:
            return 1
        case 100...199:
            return 2
        case 200...299:
            return 3
        case 300...399:
            return 4
        case 400...499:
            return 5
        case 500...599:
            return 6
        case 600...699:
            return 7
        case 700...799:
            return 8
        case 800...899:
            return 9
        case 900...999:
            return 10
        case 1000...1099:
            return 11
        case 1100...1199:
            return 12
        case 1200...1399:
            return 13
        case 1400...1599:
            return 14
        case 1600...1799:
            return 15
        case 1800...1999:
            return 16
        case 2000...2249:
            return 17
        case 2250...2499:
            return 18
        case 2500...2749:
            return 19
        case 2750...2999:
            return 20
        case 3000...3249:
            return 21
        case 3250...3499:
            return 22
        case 3500...3749:
            return 23
        case 3750...3999:
            return 24
        case 4000...20000:
            return 25
        default:
            return 0
        }
    }
    
    func findExpBounds(exp: Int) -> [Int] {
        switch exp {
        case 0...99:
            return [0,100]
        case 100...199:
            return [100,200]
        case 200...299:
            return [200,300]
        case 300...399:
            return [300,400]
        case 400...499:
            return [400,500]
        case 500...599:
            return [500,600]
        case 600...699:
            return [600,700]
        case 700...799:
            return [700,800]
        case 800...899:
            return [800,900]
        case 900...999:
            return [900,1000]
        case 1000...1099:
            return [1000,1100]
        case 1100...1199:
            return [1100,1200]
        case 1200...1399:
            return [1200,1400]
        case 1400...1599:
            return [1400,1600]
        case 1600...1799:
            return [1600,1800]
        case 1800...1999:
            return [1800,2000]
        case 2000...2249:
            return [2000,2250]
        case 2250...2499:
            return [2250,2500]
        case 2500...2749:
            return [2500,2750]
        case 2750...2999:
            return [2750,3000]
        case 3000...3249:
            return [3000,3250]
        case 3250...3499:
            return [3250,3500]
        case 3500...3749:
            return [3500,3750]
        case 3750...3999:
            return [3750,4000]
        case 4000...20000:
            return [4000,20000]
        default:
            return [0,100]
        }
    }
    
    func calculateChangeExperienceHigher(levelDiff: Int, winOrLose: Bool) -> Int {
        if winOrLose == true {
            switch levelDiff {
            case 0:
                return 100
            case 1:
                return 92
            case 2:
                return 85
            case 3:
                return 79
            case 4:
                return 74
            case 5:
                return 70
            case 6:
                return 66
            case 7:
                return 63
            case 8:
                return 60
            case 9:
                return 58
            case 10:
                return 56
            case 11:
                return 50
            case 12:
                return 40
            case 13:
                return 30
            case 14:
                return 20
            case 15:
                return 15
            default:
                return 10
            }
        } else {
            switch levelDiff {
            case 0:
                return -100
            case 1:
                return -108
            case 2:
                return -115
            case 3:
                return -121
            case 4:
                return -126
            case 5:
                return -130
            case 6:
                return -134
            case 7:
                return -137
            case 8:
                return -140
            case 9:
                return -142
            case 10:
                return -144
            case 11:
                return -146
            case 12:
                return -147
            case 13:
                return -148
            case 14:
                return -149
            case 15:
                return -150
            default:
                return -155
            }
        }
    }
    
    func calculateChangeExperienceLower(levelDiff: Int, winOrLose: Bool) -> Int {
        if winOrLose == true {
            switch levelDiff {
            case 0:
                return 100
            case 1:
                return 108
            case 2:
                return 115
            case 3:
                return 121
            case 4:
                return 126
            case 5:
                return 130
            case 6:
                return 134
            case 7:
                return 137
            case 8:
                return 140
            case 9:
                return 142
            case 10:
                return 144
            case 11:
                return 146
            case 12:
                return 147
            case 13:
                return 148
            case 14:
                return 149
            case 15:
                return 150
            default:
                return 155
            }
        } else {
            switch levelDiff {
            case 0:
                return -100
            case 1:
                return -92
            case 2:
                return -85
            case 3:
                return -79
            case 4:
                return -74
            case 5:
                return -70
            case 6:
                return -66
            case 7:
                return -63
            case 8:
                return -60
            case 9:
                return -58
            case 10:
                return -56
            case 11:
                return -50
            case 12:
                return -40
            case 13:
                return -30
            case 14:
                return -20
            case 15:
                return -15
            default:
                return -10
            }
        }
    }
}
