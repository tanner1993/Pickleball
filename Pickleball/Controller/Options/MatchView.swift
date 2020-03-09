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
    var player = Player()
    var matchId = "none"
    var confirmMatchScoresWidthAnchor: NSLayoutConstraint?
    var confirmMatchScoresCenterXAnchor: NSLayoutConstraint?
    var backgroundImageCenterYAnchor: NSLayoutConstraint?
    var finalTeam1Scores = [Int]()
    var finalTeam2Scores = [Int]()
    var gameWinners = [Int]()
    var winner = 0
    var team1Wins = 0
    var team2Wins = 0
    var userIsTeam1 = true
    var team1_P1_Exp = -1
    var team1_P2_Exp = -1
    var team2_P1_Exp = -1
    var team2_P2_Exp = -1
    var team1_P1_Lev = -1
    var team1_P2_Lev = -1
    var team2_P1_Lev = -1
    var team2_P2_Lev = -1

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
                let submitter = value["submitter"] as? Int ?? 0
                let winner = value["winner"] as? Int ?? 0
                let team_1_player_1 = value["team_1_player_1"] as? String ?? "Player not found"
                let team_1_player_2 = value["team_1_player_2"] as? String ?? "Player not found"
                let team_2_player_1 = value["team_2_player_1"] as? String ?? "Player not found"
                let team_2_player_2 = value["team_2_player_2"] as? String ?? "Player not found"
                let idList = [team_1_player_1, team_1_player_2, team_2_player_1, team_2_player_2]
                self.getPlayerNames(idList: idList)
                let team1_scores = value["team1_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                let team2_scores = value["team2_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                self.setupCorrectBottom(active: active, submitter: submitter, confirmers: team1_scores, team2: team2_scores, idList: idList)
                let time = value["time"] as? Double ?? Date().timeIntervalSince1970
                matchT.active = active
                matchT.winner = winner
                matchT.submitter = submitter
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
    
    @objc func handleConfirm(sender: UIButton) {
        if match.active == 0 {
            performConfirmActive0(whichOne: sender.tag)
        } else if match.active == 1 {
            print("confirming scores")
            performConfirmActive1()
        } else if match.active == 2 {
            performConfirmActive2()
        }
    }
    
    func checkIfMatchReady() -> Int {
        for index in 0...3 {
            if match.team1_scores![index] != 1 {
                return 0
            }
        }
        return 1
    }
    
    @objc func handleReject(sender: UIButton) {
        if match.active == 0 {
            performRejectActive0(whichOne: sender.tag)
        } else if match.active == 2 {
            
        }
    }
    
    func setupCorrectBottom(active: Int, submitter: Int, confirmers: [Int], team2: [Int], idList: [String]) {
        guard let uid = Auth.auth().currentUser?.uid, let whichPerson = idList.firstIndex(of: uid) else {
            return
        }
        
        if whichPerson == 0 || whichPerson == 1 {
            userIsTeam1 = true
        } else {
            userIsTeam1 = false
        }
        
        let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1045, w: 532, h: 68, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        if active == 0 && confirmers[whichPerson] == 0 {
            confirmMatchScores.tag = whichPerson
            confirmMatchScoresImage.image = UIImage(named: "confirm_or_reject_match")
            view.addSubview(confirmMatchScoresImage)
            confirmMatchScoresImage.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
            confirmMatchScoresImage.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
            confirmMatchScoresImage.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
            confirmMatchScoresImage.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
            
            view.addSubview(confirmMatchScores)
            confirmMatchScores.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
            confirmMatchScoresCenterXAnchor = confirmMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X + (confirmMatchScoresLoc.W / 4)))
            confirmMatchScoresCenterXAnchor?.isActive = true
            confirmMatchScores.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
            confirmMatchScoresWidthAnchor = confirmMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W / 2))
            confirmMatchScoresWidthAnchor?.isActive = true
            
            view.addSubview(rejectMatchScores)
            //rejectMatchScores.backgroundColor = .red
            rejectMatchScores.tag = whichPerson
            rejectMatchScores.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
            rejectMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X - (confirmMatchScoresLoc.W / 4))).isActive = true
            rejectMatchScores.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
            rejectMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W / 2)).isActive = true
        } else if active == 1 {
            confirmMatchScoresImage.image = UIImage(named: "confirm_match_scores")
            view.addSubview(confirmMatchScoresImage)
            confirmMatchScoresImage.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
            confirmMatchScoresImage.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
            confirmMatchScoresImage.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
            confirmMatchScoresImage.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
            
            view.addSubview(confirmMatchScores)
            confirmMatchScores.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
            confirmMatchScoresCenterXAnchor = confirmMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X))
            confirmMatchScoresCenterXAnchor?.isActive = true
            confirmMatchScores.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
            confirmMatchScoresWidthAnchor = confirmMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W))
            confirmMatchScoresWidthAnchor?.isActive = true
        } else if active == 2 {
            if userIsTeam1 && submitter == 1 || userIsTeam1 == false && submitter == 2 {
                confirmMatchScores.isEnabled = false
                confirmMatchScoresImage.image = UIImage(named: "waiting_confirm")
                view.addSubview(confirmMatchScoresImage)
                confirmMatchScoresImage.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
                confirmMatchScoresImage.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
                confirmMatchScoresImage.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
                confirmMatchScoresImage.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
                
                view.addSubview(confirmMatchScores)
                confirmMatchScores.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
                confirmMatchScoresCenterXAnchor = confirmMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X))
                confirmMatchScoresCenterXAnchor?.isActive = true
                confirmMatchScores.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
                confirmMatchScoresWidthAnchor = confirmMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W))
                confirmMatchScoresWidthAnchor?.isActive = true
                disableScores(team1Scores: confirmers, team2Scores: team2)
            } else {
                confirmMatchScores.isEnabled = true
                rejectMatchScores.isEnabled = true
                confirmMatchScoresImage.image = UIImage(named: "reject_confirm_scores")
                view.addSubview(confirmMatchScoresImage)
                confirmMatchScoresImage.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
                confirmMatchScoresImage.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
                confirmMatchScoresImage.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
                confirmMatchScoresImage.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
                
                view.addSubview(confirmMatchScores)
                confirmMatchScores.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
                confirmMatchScoresCenterXAnchor = confirmMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X + (confirmMatchScoresLoc.W / 4)))
                confirmMatchScoresCenterXAnchor?.isActive = true
                confirmMatchScores.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
                confirmMatchScoresWidthAnchor = confirmMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W / 2))
                confirmMatchScoresWidthAnchor?.isActive = true
                
                view.addSubview(rejectMatchScores)
                //rejectMatchScores.backgroundColor = .red
                rejectMatchScores.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
                rejectMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X - (confirmMatchScoresLoc.W / 4))).isActive = true
                rejectMatchScores.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
                rejectMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W / 2)).isActive = true
                disableScores(team1Scores: confirmers, team2Scores: team2)
            }
        }
//                if match.active == 0 {
//        
//                    view.addSubview(confirmMatchScoresImage)
//                    confirmMatchScoresImage.image = UIImage(named: "confirm_match_scores")
//                    confirmMatchScoresImage.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
//                    confirmMatchScoresImage.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
//                    confirmMatchScoresImage.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
//                    confirmMatchScoresImage.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
//        
//                    view.addSubview(confirmMatchScores)
//                    confirmMatchScores.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
//                    confirmMatchScoresCenterXAnchor = confirmMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X))
//                    confirmMatchScoresCenterXAnchor?.isActive = true
//                    confirmMatchScores.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
//                    confirmMatchScoresWidthAnchor = confirmMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W))
//                    confirmMatchScoresWidthAnchor?.isActive = true
//                    print(confirmMatchScoresLoc.W)
//                } else if match.active == 1 && match.submitter == userTeam?.teamId {
//                    confirmMatchScoresImage.image = UIImage(named: "waiting_confirm")
//                    view.addSubview(confirmMatchScoresImage)
//                    confirmMatchScoresImage.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
//                    confirmMatchScoresImage.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
//                    confirmMatchScoresImage.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
//                    confirmMatchScoresImage.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
//                } else if match.active == 1 && match.submitter == oppTeam?.teamId {
//                    confirmMatchScoresImage.image = UIImage(named: "reject_confirm")
//                    view.addSubview(confirmMatchScoresImage)
//                    confirmMatchScoresImage.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
//                    confirmMatchScoresImage.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
//                    confirmMatchScoresImage.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
//                    confirmMatchScoresImage.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
//    
//                    view.addSubview(confirmMatchScores)
//                    //confirmMatchScores.backgroundColor = .yellow
//                    confirmMatchScores.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
//                    confirmMatchScoresCenterXAnchor = confirmMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X + (confirmMatchScoresLoc.W / 4)))
//                    confirmMatchScoresCenterXAnchor?.isActive = true
//                    confirmMatchScores.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
//                    confirmMatchScoresWidthAnchor = confirmMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W / 2))
//                    confirmMatchScoresWidthAnchor?.isActive = true
//    
//                    view.addSubview(rejectMatchScores)
//                    //rejectMatchScores.backgroundColor = .red
//                    rejectMatchScores.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
//                    rejectMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X - (confirmMatchScoresLoc.W / 4))).isActive = true
//                    rejectMatchScores.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
//                    rejectMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W / 2)).isActive = true
//                }
    }
    
    func getPlayerNames(idList: [String]) {
        let user1NameRef = Database.database().reference().child("users").child(idList[0])
        user1NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.userPlayer1.text = value["name"] as? String
                let playerExp = value["exp"] as? Int
                self.team1_P1_Exp = playerExp!
                self.team1_P1_Lev = self.player.haloLevel(exp: playerExp!)
                //self.winnerConfirmed.text = self.userWinner == 0 ? value["name"] as? String : self.winnerConfirmed.text
            }
        })
        
        let user2NameRef = Database.database().reference().child("users").child(idList[1])
        user2NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.userPlayer2.text = value["name"] as? String
                let playerExp = value["exp"] as? Int
                self.team1_P2_Exp = playerExp!
                self.team1_P2_Lev = self.player.haloLevel(exp: playerExp!)
                //self.winnerConfirmed.text = self.userWinner == 0 ? "\(self.winnerConfirmed.text!) & \(value["name"] as? String ?? "none found") Won!" : self.winnerConfirmed.text
            }
        })
        
        let opp1NameRef = Database.database().reference().child("users").child(idList[2])
        opp1NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.oppPlayer1.text = value["name"] as? String
                let playerExp = value["exp"] as? Int
                self.team2_P1_Exp = playerExp!
                self.team2_P1_Lev = self.player.haloLevel(exp: playerExp!)
                //self.winnerConfirmed.text = self.userWinner == 1 ? value["name"] as? String : self.winnerConfirmed.text
            }
        })
        
        let opp2NameRef = Database.database().reference().child("users").child(idList[3])
        opp2NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.oppPlayer2.text = value["name"] as? String
                let playerExp = value["exp"] as? Int
                self.team2_P2_Exp = playerExp!
                self.team2_P2_Lev = self.player.haloLevel(exp: playerExp!)
                //self.winnerConfirmed.text = self.userWinner == 1 ? "\(self.winnerConfirmed.text!) & \(value["name"] as? String ?? "none found") Won!" : self.winnerConfirmed.text
            }
        })
    }
    
    let backgroundImage: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.image = UIImage(named: "match_info_display")
        bi.isUserInteractionEnabled = true
        return bi
    }()

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
    
    let confirmMatchScores: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.alpha = 0.05
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        return button
    }()
    
    let rejectMatchScores: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.alpha = 0.05
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleReject), for: .touchUpInside)
        return button
    }()
    
    let confirmMatchScoresImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let winnerConfirmed: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Teammate 1"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
    }
    
    func setupViews() {
        
        view.addSubview(backgroundImage)
        backgroundImageCenterYAnchor = backgroundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        backgroundImageCenterYAnchor?.isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalToConstant: 575).isActive = true
        
        let userPlayer1Loc = calculateButtonPosition(x: 375, y: 75, w: 666, h: 85, wib: 750, hib: 1150, wia: 375, hia: 575)
        view.addSubview(userPlayer1)
        userPlayer1.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(userPlayer1Loc.Y)).isActive = true
        userPlayer1.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(userPlayer1Loc.X)).isActive = true
        userPlayer1.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.H)).isActive = true
        userPlayer1.widthAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.W)).isActive = true
        
        let userPlayer2Loc = calculateButtonPosition(x: 375, y: 165, w: 666, h: 85, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(userPlayer2)
        userPlayer2.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(userPlayer2Loc.Y)).isActive = true
        userPlayer2.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(userPlayer2Loc.X)).isActive = true
        userPlayer2.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer2Loc.H)).isActive = true
        userPlayer2.widthAnchor.constraint(equalToConstant: CGFloat(userPlayer2Loc.W)).isActive = true
        
        let oppPlayer1Loc = calculateButtonPosition(x: 375, y: 381, w: 666, h: 85, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(oppPlayer1)
        oppPlayer1.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(oppPlayer1Loc.Y)).isActive = true
        oppPlayer1.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(oppPlayer1Loc.X)).isActive = true
        oppPlayer1.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.H)).isActive = true
        oppPlayer1.widthAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.W)).isActive = true
        
        let oppPlayer2Loc = calculateButtonPosition(x: 375, y: 471, w: 666, h: 85, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(oppPlayer2)
        oppPlayer2.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(oppPlayer2Loc.Y)).isActive = true
        oppPlayer2.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(oppPlayer2Loc.X)).isActive = true
        oppPlayer2.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer2Loc.H)).isActive = true
        oppPlayer2.widthAnchor.constraint(equalToConstant: CGFloat(oppPlayer2Loc.W)).isActive = true
        
        let game1UserScoreLoc = calculateButtonPosition(x: 407.52, y: 705.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game1UserScore)
        game1UserScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game1UserScoreLoc.Y)).isActive = true
        game1UserScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game1UserScoreLoc.X)).isActive = true
        game1UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game1UserScoreLoc.H)).isActive = true
        game1UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game1UserScoreLoc.W)).isActive = true
        
        let game1OppScoreLoc = calculateButtonPosition(x: 549.02, y: 705.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game1OppScore)
        game1OppScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game1OppScoreLoc.Y)).isActive = true
        game1OppScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game1OppScoreLoc.X)).isActive = true
        game1OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game1OppScoreLoc.H)).isActive = true
        game1OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game1OppScoreLoc.W)).isActive = true
        
        let game2UserScoreLoc = calculateButtonPosition(x: 407.52, y: 770.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game2UserScore)
        game2UserScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game2UserScoreLoc.Y)).isActive = true
        game2UserScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game2UserScoreLoc.X)).isActive = true
        game2UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game2UserScoreLoc.H)).isActive = true
        game2UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game2UserScoreLoc.W)).isActive = true
        
        let game2OppScoreLoc = calculateButtonPosition(x: 549.02, y: 770.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game2OppScore)
        game2OppScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game2OppScoreLoc.Y)).isActive = true
        game2OppScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game2OppScoreLoc.X)).isActive = true
        game2OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game2OppScoreLoc.H)).isActive = true
        game2OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game2OppScoreLoc.W)).isActive = true
        
        let game3UserScoreLoc = calculateButtonPosition(x: 407.52, y: 835.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game3UserScore)
        game3UserScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game3UserScoreLoc.Y)).isActive = true
        game3UserScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game3UserScoreLoc.X)).isActive = true
        game3UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game3UserScoreLoc.H)).isActive = true
        game3UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game3UserScoreLoc.W)).isActive = true
        
        let game3OppScoreLoc = calculateButtonPosition(x: 549.02, y: 835.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game3OppScore)
        game3OppScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game3OppScoreLoc.Y)).isActive = true
        game3OppScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game3OppScoreLoc.X)).isActive = true
        game3OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game3OppScoreLoc.H)).isActive = true
        game3OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game3OppScoreLoc.W)).isActive = true
        
        let game4UserScoreLoc = calculateButtonPosition(x: 407.52, y: 900.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game4UserScore)
        game4UserScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game4UserScoreLoc.Y)).isActive = true
        game4UserScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game4UserScoreLoc.X)).isActive = true
        game4UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game4UserScoreLoc.H)).isActive = true
        game4UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game4UserScoreLoc.W)).isActive = true
        
        let game4OppScoreLoc = calculateButtonPosition(x: 549.02, y: 900.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game4OppScore)
        game4OppScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game4OppScoreLoc.Y)).isActive = true
        game4OppScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game4OppScoreLoc.X)).isActive = true
        game4OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game4OppScoreLoc.H)).isActive = true
        game4OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game4OppScoreLoc.W)).isActive = true
        
        let game5UserScoreLoc = calculateButtonPosition(x: 407.52, y: 965.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game5UserScore)
        game5UserScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game5UserScoreLoc.Y)).isActive = true
        game5UserScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game5UserScoreLoc.X)).isActive = true
        game5UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game5UserScoreLoc.H)).isActive = true
        game5UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game5UserScoreLoc.W)).isActive = true
        
        let game5OppScoreLoc = calculateButtonPosition(x: 549.02, y: 965.75, w: 115, h: 55, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(game5OppScore)
        game5OppScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game5OppScoreLoc.Y)).isActive = true
        game5OppScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game5OppScoreLoc.X)).isActive = true
        game5OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game5OppScoreLoc.H)).isActive = true
        game5OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game5OppScoreLoc.W)).isActive = true
    }
    
    func performRejectActive0(whichOne: Int) {
        Database.database().reference().child("matches").child(matchId).removeValue()
        Database.database().reference().child("notifications").child(matchId).removeValue()
        Database.database().reference().child("user_notifications").child(match.team_1_player_1!).child(matchId).removeValue()
        Database.database().reference().child("user_notifications").child(match.team_1_player_2!).child(matchId).removeValue()
        Database.database().reference().child("user_notifications").child(match.team_2_player_1!).child(matchId).removeValue()
        Database.database().reference().child("user_notifications").child(match.team_2_player_2!).child(matchId).removeValue()
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        
        let ref = Database.database().reference()
        let notifications2Ref = ref.child("notifications")
        let childRef = notifications2Ref.childByAutoId()
        let toId = match.team_1_player_1!
        let fromId = uid
        let timeStamp = Int(Date().timeIntervalSince1970)
        let values = ["type": "reject_match", "toId": toId, "fromId" :fromId, "timestamp": timeStamp] as [String : Any]
        childRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if error != nil {
                let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(messageSendFailed, animated: true, completion: nil)
                print("Data could not be saved: \(String(describing: error)).")
                return
            }
            
            let notificationsRef = Database.database().reference()
            let notificationId = childRef.key!
            let childUpdates = ["/\("user_notifications")/\(toId)/\(notificationId)/": 1] as [String : Any]
            notificationsRef.updateChildValues(childUpdates, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if error != nil {
                    let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(messageSendFailed, animated: true, completion: nil)
                    print("Data could not be saved: \(String(describing: error)).")
                    return
                }
                
                print("Crazy data 2 saved!")
                
                
            })
            
            print("Crazy data saved!")
            
            
        })
    }
    
    func performConfirmActive0(whichOne: Int) {
        let ref = Database.database().reference().child("matches").child(matchId).child("team1_scores")
        match.team1_scores![whichOne] = 1
        ref.setValue(match.team1_scores)
        let matchReady = checkIfMatchReady()
        if matchReady == 0 {
            confirmMatchScoresImage.image = UIImage(named: "waiting_match_start")
            confirmMatchScores.isEnabled = false
            rejectMatchScores.isEnabled = false
        } else {
            let matchActiveRef = Database.database().reference().child("matches").child(matchId)
            match.team1_scores = [0, 0, 0, 0, 0]
            
            let childUpdates = ["/\("team1_scores")/": match.team1_scores, "/\("active")/": 1] as [String : Any]
            matchActiveRef.updateChildValues(childUpdates, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if error != nil {
                    let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(messageSendFailed, animated: true, completion: nil)
                    print("Data could not be saved: \(String(describing: error)).")
                    return
                }
                
                self.match.active = 1
                
                print("Crazy data 2 saved!")
                
                
            })
            
            let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1045, w: 532, h: 68, wib: 750, hib: 1150, wia: 375, hia: 575)
            confirmMatchScoresImage.image = UIImage(named: "confirm_match_scores")
            rejectMatchScores.isEnabled = false
            
            
            confirmMatchScoresCenterXAnchor?.constant = CGFloat(confirmMatchScoresLoc.X)
            confirmMatchScoresWidthAnchor?.constant = CGFloat(confirmMatchScoresLoc.W)
        }
    }
    
    func performConfirmActive1() {
        game1UserScore.resignFirstResponder()
        game2UserScore.resignFirstResponder()
        game3UserScore.resignFirstResponder()
        game4UserScore.resignFirstResponder()
        game5UserScore.resignFirstResponder()
        game1OppScore.resignFirstResponder()
        game2OppScore.resignFirstResponder()
        game3OppScore.resignFirstResponder()
        game4OppScore.resignFirstResponder()
        game5OppScore.resignFirstResponder()
        confirmMatchScores.flash()
        finalTeam1Scores.removeAll()
        finalTeam2Scores.removeAll()
        gameWinners.removeAll()
        let scoresValidation = checkScoresValidity()
        
        switch scoresValidation {
        case 0:
            let values = ["winner": winner, "active": 2, "submitter": userIsTeam1 ? 1 : 2, "team_1_player_1": match.team_1_player_1!, "team_1_player_2": match.team_1_player_2!, "team_2_player_1": match.team_2_player_1!, "team_2_player_2": match.team_2_player_2!, "team1_scores": finalTeam1Scores, "team2_scores": finalTeam2Scores] as [String : Any]
            let ref = Database.database().reference().child("matches").child(matchId)
            ref.updateChildValues(values, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if let error = error {
                    print("Data could not be saved: \(error).")
                    return
                }
                
                print("Data saved successfully!")
                self.match.active = 2
                self.match.winner = self.winner
                self.match.submitter = self.userIsTeam1 ? 1 : 2
                self.match.team1_scores = self.finalTeam1Scores
                self.match.team2_scores = self.finalTeam2Scores
                
            })
            
            let newalert = UIAlertController(title: "Awesome", message: "\(winner)", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: resetupviews))
            self.present(newalert, animated: true, completion: nil)
            confirmMatchScores.isEnabled = false
            confirmMatchScoresImage.image = UIImage(named: "waiting_confirm")
        case 1:
            let newalert = UIAlertController(title: "Sorry", message: "At least 3 games need to be completed in order to determine the winner of a match", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
        case 2:
            let newalert = UIAlertController(title: "Sorry", message: "A team must score at least 11 points to determine the winner of a game", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
        case 3:
            let newalert = UIAlertController(title: "Sorry", message: "A team must win each game by 2", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
        case 4:
            let newalert = UIAlertController(title: "Sorry", message: "A team needs to win at least 3 games before a winner of the match can be determined and game 4 has no scores", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
        case 5:
            let newalert = UIAlertController(title: "Sorry", message: "A team needs to win at least 3 games before a winner of the match can be determined and game 5 has no scores", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
        default:
            let newalert = UIAlertController(title: "Sorry", message: "Nothing worked", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            
        }
    }
    
    func performConfirmActive2() {
        let values = ["active": 3] as [String : Any]
        let ref = Database.database().reference().child("matches").child(matchId)
        ref.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            
            print("Data saved successfully!")
            self.match.active = 3
            self.updatePlayerStats()
            
            
        })
        let newalert = UIAlertController(title: "Awesome", message: "Match Confirmed", preferredStyle: UIAlertController.Style.alert)
        newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: resetupviews))
        self.present(newalert, animated: true, completion: nil)
        confirmMatchScoresImage.image = UIImage(named: "winner_confirm")
        let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1045, w: 532, h: 68, wib: 750, hib: 1150, wia: 375, hia: 575)
        view.addSubview(winnerConfirmed)
        winnerConfirmed.text = match.winner == 1 ? "\(userPlayer1.text!) & \(userPlayer2.text!) won!" : "\(oppPlayer1.text!) & \(oppPlayer2.text!) won!"
        winnerConfirmed.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
        winnerConfirmed.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
        winnerConfirmed.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
        winnerConfirmed.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
    }
    
    func updatePlayerStats() {
        updateExperience()
        let user1NameRef = Database.database().reference().child("users").child(match.team_1_player_1!)
        user1NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                let playerWins = value["match_wins"] as? Int
                let playerLosses = value["match_losses"] as? Int
                let childUpdates = ["/\("match_wins")/": self.match.winner == 1 ? playerWins! + 1 : playerWins!, "/\("match_losses")/": self.match.winner == 1 ? playerLosses! : playerLosses! + 1] as [String : Any]
                user1NameRef.updateChildValues(childUpdates, withCompletionBlock: {
                    (error:Error?, ref:DatabaseReference) in
                    
                    if error != nil {
                        let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                        messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(messageSendFailed, animated: true, completion: nil)
                        print("Data could not be saved: \(String(describing: error)).")
                        return
                    }
                    
                    print("Crazy data 2 saved!")
                    
                    
                })
            }
        })
        
        let user2NameRef = Database.database().reference().child("users").child(match.team_1_player_2!)
        user2NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                let playerWins = value["match_wins"] as? Int
                let playerLosses = value["match_losses"] as? Int
                let childUpdates = ["/\("match_wins")/": self.match.winner == 1 ? playerWins! + 1 : playerWins!, "/\("match_losses")/": self.match.winner == 1 ? playerLosses! : playerLosses! + 1] as [String : Any]
                user2NameRef.updateChildValues(childUpdates, withCompletionBlock: {
                    (error:Error?, ref:DatabaseReference) in
                    
                    if error != nil {
                        let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                        messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(messageSendFailed, animated: true, completion: nil)
                        print("Data could not be saved: \(String(describing: error)).")
                        return
                    }
                    
                    print("Crazy data 2 saved!")
                    
                    
                })
            }
        })
        
        let opp1NameRef = Database.database().reference().child("users").child(match.team_2_player_1!)
        opp1NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                let playerWins = value["match_wins"] as? Int
                let playerLosses = value["match_losses"] as? Int
                let childUpdates = ["/\("match_wins")/": self.match.winner == 2 ? playerWins! + 1 : playerWins!, "/\("match_losses")/": self.match.winner == 2 ? playerLosses! : playerLosses! + 1] as [String : Any]
                opp1NameRef.updateChildValues(childUpdates, withCompletionBlock: {
                    (error:Error?, ref:DatabaseReference) in
                    
                    if error != nil {
                        let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                        messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(messageSendFailed, animated: true, completion: nil)
                        print("Data could not be saved: \(String(describing: error)).")
                        return
                    }
                    
                    print("Crazy data 2 saved!")
                    
                    
                })
            }
        })
        
        let opp2NameRef = Database.database().reference().child("users").child(match.team_2_player_2!)
        opp2NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                let playerWins = value["match_wins"] as? Int
                let playerLosses = value["match_losses"] as? Int
                let childUpdates = ["/\("match_wins")/": self.match.winner == 2 ? playerWins! + 1 : playerWins!, "/\("match_losses")/": self.match.winner == 2 ? playerLosses! : playerLosses! + 1] as [String : Any]
                opp2NameRef.updateChildValues(childUpdates, withCompletionBlock: {
                    (error:Error?, ref:DatabaseReference) in
                    
                    if error != nil {
                        let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                        messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(messageSendFailed, animated: true, completion: nil)
                        print("Data could not be saved: \(String(describing: error)).")
                        return
                    }
                    
                    print("Crazy data 2 saved!")
                    
                    
                })
            }
        })
    }
    
    @objc func resetupviews(action: UIAlertAction) {
        if match.active != 3 {
            disableScores(team1Scores: match.team1_scores!, team2Scores: match.team2_scores!)
        }
    }
    
    func winChecker(user: Int, opp: Int) -> Int {
        if user > opp {
            return 0
        } else {
            return 1
        }
    }
    
    func checkScoresValidity() -> Int {
        team1Wins = 0
        team2Wins = 0
        if game1UserScore.text == "" || game1OppScore.text == "" || game2UserScore.text == "" || game2OppScore.text == "" || game3UserScore.text == "" || game3OppScore.text == "" {
            return 1
        } else {
            finalTeam1Scores.append(Int(game1UserScore.text!)!)
            finalTeam2Scores.append(Int(game1OppScore.text!)!)
            finalTeam1Scores.append(Int(game2UserScore.text!)!)
            finalTeam2Scores.append(Int(game2OppScore.text!)!)
            finalTeam1Scores.append(Int(game3UserScore.text!)!)
            finalTeam2Scores.append(Int(game3OppScore.text!)!)
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
                return 0
            } else if team2Wins == 3 {
                winner = 2
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                return 0
            }
        }
        
        if game4UserScore.text == "" || game4OppScore.text == "" {
            return 4
        } else {
            finalTeam1Scores.append(Int(game4UserScore.text!)!)
            finalTeam2Scores.append(Int(game4OppScore.text!)!)
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
                return 0
            } else if team2Wins == 3 {
                winner = 2
                finalTeam1Scores.append(0)
                finalTeam2Scores.append(0)
                return 0
            }
        }
        if game5UserScore.text == "" || game5OppScore.text == "" {
            return 5
        } else {
            finalTeam1Scores.append(Int(game5UserScore.text!)!)
            finalTeam2Scores.append(Int(game5OppScore.text!)!)
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
                return 0
            } else if team2Wins == 3 {
                winner = 2
                return 0
            } else {
                return -1
            }
        }
    }
    
    func disableScores(team1Scores: [Int], team2Scores: [Int]) {
                game1UserScore.text = "\(team1Scores[0])"
                game2UserScore.text = "\(team1Scores[1])"
                game3UserScore.text = "\(team1Scores[2])"
                game4UserScore.text = "\(team1Scores[3])"
                game5UserScore.text = "\(team1Scores[4])"
                game1OppScore.text = "\(team2Scores[0])"
                game2OppScore.text = "\(team2Scores[1])"
                game3OppScore.text = "\(team2Scores[2])"
                game4OppScore.text = "\(team2Scores[3])"
                game5OppScore.text = "\(team2Scores[4])"
        game1UserScore.isUserInteractionEnabled = false
        game2UserScore.isUserInteractionEnabled = false
        game3UserScore.isUserInteractionEnabled = false
        game4UserScore.isUserInteractionEnabled = false
        game5UserScore.isUserInteractionEnabled = false
        game1OppScore.isUserInteractionEnabled = false
        game2OppScore.isUserInteractionEnabled = false
        game3OppScore.isUserInteractionEnabled = false
        game4OppScore.isUserInteractionEnabled = false
        game5OppScore.isUserInteractionEnabled = false
    }
    
    func updateExperience() {
        let team1Level = Int((team1_P1_Lev + team1_P2_Lev)/2)
        let team2Level = Int((team2_P1_Lev + team2_P2_Lev)/2)
        let winningTeam = match.winner!
        let levelDifference = abs(team1Level - team2Level)
        let team1ChangeExp = team1Level - team2Level >= 0 ? calculateChangeExperienceHigher(levelDiff: levelDifference, winOrLose: winningTeam == 1 ? true : false) : calculateChangeExperienceLower(levelDiff: levelDifference, winOrLose: winningTeam == 1 ? true : false)
        let team2ChangeExp = team2Level - team1Level >= 0 ? calculateChangeExperienceHigher(levelDiff: levelDifference, winOrLose: winningTeam == 2 ? true : false) : calculateChangeExperienceLower(levelDiff: levelDifference, winOrLose: winningTeam == 2 ? true : false)
        let usersRef = Database.database().reference().child("users")
        let childUpdates = ["/\(match.team_1_player_1!)/\("exp")/": team1_P1_Exp < 150 && team1ChangeExp < 0 ? team1_P1_Exp : team1_P1_Exp + team1ChangeExp, "/\(match.team_1_player_2!)/\("exp")/": team1_P2_Exp < 150 && team1ChangeExp < 0 ? team1_P2_Exp : team1_P2_Exp + team1ChangeExp, "/\(match.team_2_player_1!)/\("exp")/": team2_P1_Exp < 150 && team2ChangeExp < 0 ? team2_P1_Exp : team2_P1_Exp + team2ChangeExp, "/\(match.team_2_player_2!)/\("exp")/": team2_P2_Exp < 150 && team2ChangeExp < 0 ? team2_P2_Exp : team2_P2_Exp + team2ChangeExp] as [String : Any]
        usersRef.updateChildValues(childUpdates, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if error != nil {
                let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(messageSendFailed, animated: true, completion: nil)
                print("Data could not be saved: \(String(describing: error)).")
                return
            }
            
            print("Crazy data 2 saved!")
            
            
        })
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
