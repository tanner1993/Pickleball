//
//  MatchView.swift
//  Pickleball
//
//  Created by Tanner Rozier on 3/4/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

class MatchView: UIViewController {
    
    var match = Match2()
    var matchId = "none"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        fetchMatch()
    }
    
    func fetchMatch() {
        let matchReference = Database.database().reference().child("matches").child(matchId)
        
        matchReference.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let matchT = Match2()
                let active = value["active"] as? Int ?? 0
                let team_1_player_1 = value["team_1_player_1"] as? String ?? "Player not found"
                let team_1_player_2 = value["team_1_player_2"] as? String ?? "Player not found"
                let team_2_player_1 = value["team_2_player_1"] as? String ?? "Player not found"
                let team_2_player_2 = value["team_2_player_2"] as? String ?? "Player not found"
                let idList = [team_1_player_1, team_1_player_2, team_2_player_1, team_2_player_2]
                self.getPlayerNames(idList: idList)
                let team1_scores = value["team1_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                let team2_scores = value["team2_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                let time = value["time"] as? Double ?? Date().timeIntervalSince1970
                matchT.active = active
                matchT.winner = "nobody"
                matchT.team_1_player_1 = team_1_player_1
                matchT.team_1_player_2 = team_1_player_2
                matchT.team_2_player_1 = team_2_player_1
                matchT.team_2_player_2 = team_2_player_2
                matchT.team1_scores = team1_scores
                matchT.team2_scores = team2_scores
                matchT.matchId = self.matchId
                matchT.time = time
                self.match = matchT
            }
            
        }, withCancel: nil)
    }
    
    func getPlayerNames(idList: [String]) {
        let user1NameRef = Database.database().reference().child("users").child(idList[0])
        user1NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.userPlayer1.text = value["name"] as? String
                //self.winnerConfirmed.text = self.userWinner == 0 ? value["name"] as? String : self.winnerConfirmed.text
            }
        })
        
        let user2NameRef = Database.database().reference().child("users").child(idList[1])
        user2NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.userPlayer2.text = value["name"] as? String
                //self.winnerConfirmed.text = self.userWinner == 0 ? "\(self.winnerConfirmed.text!) & \(value["name"] as? String ?? "none found") Won!" : self.winnerConfirmed.text
            }
        })
        
        let opp1NameRef = Database.database().reference().child("users").child(idList[2])
        opp1NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.oppPlayer1.text = value["name"] as? String
                //self.winnerConfirmed.text = self.userWinner == 1 ? value["name"] as? String : self.winnerConfirmed.text
            }
        })
        
        let opp2NameRef = Database.database().reference().child("users").child(idList[3])
        opp2NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.oppPlayer2.text = value["name"] as? String
                //self.winnerConfirmed.text = self.userWinner == 1 ? "\(self.winnerConfirmed.text!) & \(value["name"] as? String ?? "none found") Won!" : self.winnerConfirmed.text
            }
        })
    }

    let userPlayer1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Teammate 1"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let userPlayer2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Teammate 1"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let oppPlayer1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Teammate 1"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let oppPlayer2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Teammate 1"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let game1UserScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let game2UserScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let game3UserScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let game4UserScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let game5UserScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let game1OppScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let game2OppScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let game3OppScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let game4OppScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let game5OppScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
    }
    
    func setupViews() {
        
        let userPlayer1Loc = calculateButtonPosition(x: 375, y: 75, w: 666, h: 85, wib: 750, hib: 1150, wia: 375, hia: 575)
        view.addSubview(userPlayer1)
        userPlayer1.centerYAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(userPlayer1Loc.Y)).isActive = true
        userPlayer1.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(userPlayer1Loc.X)).isActive = true
        userPlayer1.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.H)).isActive = true
        userPlayer1.widthAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.W)).isActive = true
        
        let userPlayer2Loc = calculateButtonPosition(x: 375, y: 165, w: 666, h: 85, wib: 750, hib: 1150, wia: 375, hia: 575)
        let user2NameRef = Database.database().reference().child("users").child(match.team_1_player_2 ?? "none")
        user2NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.userPlayer2.text = value["name"] as? String
                //self.winnerConfirmed.text = self.userWinner == 0 ? "\(self.winnerConfirmed.text!) & \(value["name"] as? String ?? "none found") Won!" : self.winnerConfirmed.text
            }
        })
        
        view.addSubview(userPlayer2)
        userPlayer2.centerYAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(userPlayer2Loc.Y)).isActive = true
        userPlayer2.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(userPlayer2Loc.X)).isActive = true
        userPlayer2.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer2Loc.H)).isActive = true
        userPlayer2.widthAnchor.constraint(equalToConstant: CGFloat(userPlayer2Loc.W)).isActive = true
        
        let oppPlayer1Loc = calculateButtonPosition(x: 375, y: 381, w: 666, h: 85, wib: 750, hib: 1150, wia: 375, hia: 575)
        let opp1NameRef = Database.database().reference().child("users").child(match.team_2_player_1 ?? "none")
        opp1NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.oppPlayer1.text = value["name"] as? String
                //self.winnerConfirmed.text = self.userWinner == 1 ? value["name"] as? String : self.winnerConfirmed.text
            }
        })
        
        view.addSubview(oppPlayer1)
        oppPlayer1.centerYAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(oppPlayer1Loc.Y)).isActive = true
        oppPlayer1.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(oppPlayer1Loc.X)).isActive = true
        oppPlayer1.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.H)).isActive = true
        oppPlayer1.widthAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.W)).isActive = true
        
        let oppPlayer2Loc = calculateButtonPosition(x: 375, y: 471, w: 666, h: 85, wib: 750, hib: 1150, wia: 375, hia: 575)
        let opp2NameRef = Database.database().reference().child("users").child(match.team_2_player_2 ?? "none")
        opp2NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.oppPlayer2.text = value["name"] as? String
                //self.winnerConfirmed.text = self.userWinner == 1 ? "\(self.winnerConfirmed.text!) & \(value["name"] as? String ?? "none found") Won!" : self.winnerConfirmed.text
            }
        })
        
        view.addSubview(oppPlayer2)
        oppPlayer2.centerYAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(oppPlayer2Loc.Y)).isActive = true
        oppPlayer2.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(oppPlayer2Loc.X)).isActive = true
        oppPlayer2.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer2Loc.H)).isActive = true
        oppPlayer2.widthAnchor.constraint(equalToConstant: CGFloat(oppPlayer2Loc.W)).isActive = true
        
        let game1UserScoreLoc = calculateButtonPosition(x: 407.52, y: 705.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game1UserScore)
        game1UserScore.centerYAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(game1UserScoreLoc.Y)).isActive = true
        game1UserScore.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(game1UserScoreLoc.X)).isActive = true
        game1UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game1UserScoreLoc.H)).isActive = true
        game1UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game1UserScoreLoc.W)).isActive = true
        
        let game1OppScoreLoc = calculateButtonPosition(x: 549.02, y: 705.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game1OppScore)
        game1OppScore.centerYAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(game1OppScoreLoc.Y)).isActive = true
        game1OppScore.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(game1OppScoreLoc.X)).isActive = true
        game1OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game1OppScoreLoc.H)).isActive = true
        game1OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game1OppScoreLoc.W)).isActive = true
        
        let game2UserScoreLoc = calculateButtonPosition(x: 407.52, y: 770.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game2UserScore)
        game2UserScore.centerYAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(game2UserScoreLoc.Y)).isActive = true
        game2UserScore.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(game2UserScoreLoc.X)).isActive = true
        game2UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game2UserScoreLoc.H)).isActive = true
        game2UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game2UserScoreLoc.W)).isActive = true
        
        let game2OppScoreLoc = calculateButtonPosition(x: 549.02, y: 770.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game2OppScore)
        game2OppScore.centerYAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(game2OppScoreLoc.Y)).isActive = true
        game2OppScore.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(game2OppScoreLoc.X)).isActive = true
        game2OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game2OppScoreLoc.H)).isActive = true
        game2OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game2OppScoreLoc.W)).isActive = true
        
        let game3UserScoreLoc = calculateButtonPosition(x: 407.52, y: 835.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game3UserScore)
        game3UserScore.centerYAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(game3UserScoreLoc.Y)).isActive = true
        game3UserScore.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(game3UserScoreLoc.X)).isActive = true
        game3UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game3UserScoreLoc.H)).isActive = true
        game3UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game3UserScoreLoc.W)).isActive = true
        
        let game3OppScoreLoc = calculateButtonPosition(x: 549.02, y: 835.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game3OppScore)
        game3OppScore.centerYAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(game3OppScoreLoc.Y)).isActive = true
        game3OppScore.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(game3OppScoreLoc.X)).isActive = true
        game3OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game3OppScoreLoc.H)).isActive = true
        game3OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game3OppScoreLoc.W)).isActive = true
        
        let game4UserScoreLoc = calculateButtonPosition(x: 407.52, y: 900.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game4UserScore)
        game4UserScore.centerYAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(game4UserScoreLoc.Y)).isActive = true
        game4UserScore.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(game4UserScoreLoc.X)).isActive = true
        game4UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game4UserScoreLoc.H)).isActive = true
        game4UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game4UserScoreLoc.W)).isActive = true
        
        let game4OppScoreLoc = calculateButtonPosition(x: 549.02, y: 900.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game4OppScore)
        game4OppScore.centerYAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(game4OppScoreLoc.Y)).isActive = true
        game4OppScore.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(game4OppScoreLoc.X)).isActive = true
        game4OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game4OppScoreLoc.H)).isActive = true
        game4OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game4OppScoreLoc.W)).isActive = true
        
        let game5UserScoreLoc = calculateButtonPosition(x: 407.52, y: 965.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game5UserScore)
        game5UserScore.centerYAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(game5UserScoreLoc.Y)).isActive = true
        game5UserScore.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(game5UserScoreLoc.X)).isActive = true
        game5UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game5UserScoreLoc.H)).isActive = true
        game5UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game5UserScoreLoc.W)).isActive = true
        
        let game5OppScoreLoc = calculateButtonPosition(x: 549.02, y: 965.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game5OppScore)
        game5OppScore.centerYAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(game5OppScoreLoc.Y)).isActive = true
        game5OppScore.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(game5OppScoreLoc.X)).isActive = true
        game5OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game5OppScoreLoc.H)).isActive = true
        game5OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game5OppScoreLoc.W)).isActive = true
    }
}
