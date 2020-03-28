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
    var team1 = Team()
    var team2 = Team()
    var teams = [Team]()
    var yetToView = [String]()
    var tourneyId = "none"
    var matchId = "none"
    var tourneyActive = 0
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
    var rejectIndex = -1
    var finals1 = 0
    var finals2 = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        fetchMatch()
        
    }
    
    func setupNavbarTitle(status: Int) {
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        switch status {
        case 0:
            titleLabel.text = "Prematch"
        case 1:
            titleLabel.text = "Mid-match"
        case 2:
            titleLabel.text = "Match Confirmation"
        case 3:
            titleLabel.text = "Match Complete"
        default:
            print("failed title")
        }
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.navigationItem.titleView = titleLabel
    }
    
    func fetchMatch() {
        let matchReference = tourneyId == "none" ? Database.database().reference().child("matches").child(matchId) : Database.database().reference().child("tourneys").child(tourneyId).child("matches").child(matchId)
        
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
                let time = value["time"] as? Double ?? Date().timeIntervalSince1970
                let forfeit = value["forfeit"] as? Int ?? 0
                self.setupCorrectBottom(active: active, submitter: submitter, confirmers: team1_scores, team2: team2_scores, idList: idList, startTime: time, forfeit: forfeit)
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
                matchT.forfeit = forfeit
                self.match = matchT
            }
            
        }, withCancel: nil)
    }
    
    @objc func handleTimeExpired(action: UIAlertAction) {
        Database.database().reference().child("tourneys").child(tourneyId).child("matches").child(matchId).removeValue()
        removeCantChallenge()
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
    
    func handleRejectConfirmed(action: UIAlertAction) {
        if tourneyId == "none" {
            performRejectActive0(whichOne: rejectIndex)
            dismiss(animated: true, completion: nil)
        } else {
            performRejectActive0Tourney()
        }
    }
    
    @objc func handleReject(sender: UIButton) {
        if match.active == 0 {
            rejectIndex = sender.tag
            if tourneyId == "none" {
                let createMatchConfirmed = UIAlertController(title: "Are you sure?", message: "Rejecting this match invite will notify whoever invited you that you don't want to play.", preferredStyle: .alert)
                createMatchConfirmed.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                createMatchConfirmed.addAction(UIAlertAction(title: "Reject", style: .default, handler: self.handleRejectConfirmed))
                self.present(createMatchConfirmed, animated: true, completion: nil)
            } else {
                guard let uid = Auth.auth().currentUser?.uid else {
                    return
                }
                if uid == match.team_1_player_1 || uid == match.team_1_player_2 {
                    let forfeitMatch = UIAlertController(title: "Ok", message: "Rejecting this match will count as a forfeit for the opponent which is a loss", preferredStyle: .alert)
                    forfeitMatch.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    forfeitMatch.addAction(UIAlertAction(title: "Opponent Forfeit", style: .default, handler: self.handleRejectConfirmed))
                    self.present(forfeitMatch, animated: true, completion: nil)
                } else {
                    let forfeitMatch = UIAlertController(title: "Are you sure?", message: "Rejecting this match will count as a forfeit resulting in the same effect as a loss", preferredStyle: .alert)
                    forfeitMatch.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    forfeitMatch.addAction(UIAlertAction(title: "Forfeit", style: .default, handler: self.handleRejectConfirmed))
                    self.present(forfeitMatch, animated: true, completion: nil)
                }
            }
        } else if match.active == 2 {
            confirmMatchScores.isHidden = true
            self.match.active = 1
            setupNavbarTitle(status: 1)
            confirmCheck1.isHidden = true
            confirmCheck2.isHidden = true
            confirmCheck3.isHidden = true
            confirmCheck4.isHidden = true
            let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1084, w: 712, h: 126, wib: 750, hib: 1164, wia: 375, hia: 582)
            confirmMatchScores.setTitle("Submit Scores to Opponent for Review", for: .normal)
            confirmMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
            confirmMatchScores.titleLabel?.numberOfLines = 2
            confirmMatchScoresCenterXAnchor?.constant = CGFloat(confirmMatchScoresLoc.X)
            confirmMatchScoresWidthAnchor?.constant = CGFloat(confirmMatchScoresLoc.W)
            confirmMatchScores.isHidden = false
            rejectMatchScores.isEnabled = false
            rejectMatchScores.isHidden = true
            game1UserScore.isUserInteractionEnabled = true
            game2UserScore.isUserInteractionEnabled = true
            game3UserScore.isUserInteractionEnabled = true
            game4UserScore.isUserInteractionEnabled = true
            game5UserScore.isUserInteractionEnabled = true
            game1OppScore.isUserInteractionEnabled = true
            game2OppScore.isUserInteractionEnabled = true
            game3OppScore.isUserInteractionEnabled = true
            game4OppScore.isUserInteractionEnabled = true
            game5OppScore.isUserInteractionEnabled = true
            
            game1UserScore.text = ""
            game2UserScore.text = ""
            game3UserScore.text = ""
            game4UserScore.text = ""
            game5UserScore.text = ""
            game1OppScore.text = ""
            game2OppScore.text = ""
            game3OppScore.text = ""
            game4OppScore.text = ""
            game5OppScore.text = ""
            
        }
    }
    
    func setupCorrectBottom(active: Int, submitter: Int, confirmers: [Int], team2: [Int], idList: [String], startTime: Double, forfeit: Int) {
        setupNavbarTitle(status: active)
        guard let uid = Auth.auth().currentUser?.uid, let whichPerson = idList.firstIndex(of: uid) else {
            return
        }
        
        if whichPerson == 0 || whichPerson == 1 {
            userIsTeam1 = true
        } else {
            userIsTeam1 = false
        }
        
        let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1084, w: 712, h: 126, wib: 750, hib: 1164, wia: 375, hia: 582)
        
        if active == 0 {
            view.bringSubviewToFront(whiteCover)
            confirmCheck1.isHidden = false
            if confirmers[1] == 1 {
                confirmCheck2.isHidden = false
            }
            if confirmers[2] == 1 {
                confirmCheck3.isHidden = false
            }
            if confirmers[3] == 1 {
                confirmCheck4.isHidden = false
            }
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
        let currentTime = Date().timeIntervalSince1970
        if active == 0 && confirmers[whichPerson] == 1 && tourneyId != "none" && (startTime + 86400) < currentTime {
            view.addSubview(rejectMatchScores)
            rejectMatchScores.tag = whichPerson
            rejectMatchScores.setTitle("Submit a forfeit for the opposing team as it's been over 24 hours", for: .normal)
            rejectMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
            rejectMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
            rejectMatchScores.titleLabel?.numberOfLines = 2
            rejectMatchScores.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
            rejectMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
            rejectMatchScores.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
            rejectMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
        } else if active == 0 && confirmers[whichPerson] == 0 {
            confirmMatchScores.tag = whichPerson
            
            view.addSubview(confirmMatchScores)
            confirmMatchScores.setTitle("Yes I want to play in this match", for: .normal)
            confirmMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            confirmMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
            confirmMatchScores.titleLabel?.numberOfLines = 2
            confirmMatchScores.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
            confirmMatchScoresCenterXAnchor = confirmMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X + (confirmMatchScoresLoc.W / 4)))
            confirmMatchScoresCenterXAnchor?.isActive = true
            confirmMatchScores.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
            confirmMatchScoresWidthAnchor = confirmMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W / 2))
            confirmMatchScoresWidthAnchor?.isActive = true
            
            view.addSubview(rejectMatchScores)
            //rejectMatchScores.backgroundColor = .red
            rejectMatchScores.tag = whichPerson
            rejectMatchScores.setTitle("No I don't want to play", for: .normal)
            rejectMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            rejectMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
            rejectMatchScores.titleLabel?.numberOfLines = 2
            rejectMatchScores.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
            rejectMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X - (confirmMatchScoresLoc.W / 4))).isActive = true
            rejectMatchScores.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
            rejectMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W / 2)).isActive = true
        } else if active == 0 && confirmers[whichPerson] == 1 {
            view.addSubview(matchStatusLabel)
            matchStatusLabel.text = "Waiting for opponents to confirm match"
            matchStatusLabel.numberOfLines = 2
            matchStatusLabel.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
            matchStatusLabel.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
            matchStatusLabel.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
            matchStatusLabel.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
        } else if active == 1 && (startTime + (86400 * 3)) < currentTime {
            let matchdeleted = UIAlertController(title: "Sorry", message: "It's been 3 days and you failed to play in the time limit, the match will be deleted and you will be free to challenge someone else", preferredStyle: .alert)
            matchdeleted.addAction(UIAlertAction(title: "Ok", style: .default, handler: self.handleTimeExpired))
            self.present(matchdeleted, animated: true, completion: nil)
        } else if active == 1 {
            whiteCover.isHidden = true
            view.addSubview(confirmMatchScores)
            confirmMatchScores.setTitle("Submit Scores to Opponent for Review", for: .normal)
            confirmMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
            confirmMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
            confirmMatchScores.titleLabel?.numberOfLines = 2
            confirmMatchScores.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
            confirmMatchScoresCenterXAnchor = confirmMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X))
            confirmMatchScoresCenterXAnchor?.isActive = true
            confirmMatchScores.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
            confirmMatchScoresWidthAnchor = confirmMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W))
            confirmMatchScoresWidthAnchor?.isActive = true
        } else if active == 2 {
            whiteCover.isHidden = true
            if submitter == 1 {
                confirmCheck1.isHidden = false
                confirmCheck2.isHidden = false
            } else {
                confirmCheck3.isHidden = false
                confirmCheck4.isHidden = false
            }
            
            if userIsTeam1 && submitter == 1 || userIsTeam1 == false && submitter == 2 {
                confirmMatchScores.isEnabled = false
                view.addSubview(matchStatusLabel)
                matchStatusLabel.text = "Waiting for opponent to accept submitted scores"
                matchStatusLabel.numberOfLines = 2
                matchStatusLabel.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
                matchStatusLabel.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
                matchStatusLabel.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
                matchStatusLabel.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
                disableScores(team1Scores: confirmers, team2Scores: team2)
            } else {
                confirmMatchScores.isEnabled = true
                rejectMatchScores.isEnabled = true
                
                view.addSubview(confirmMatchScores)
                confirmMatchScores.setTitle("Yes these scores are right, finish the match", for: .normal)
                confirmMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
                confirmMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
                confirmMatchScores.titleLabel?.numberOfLines = 3
                confirmMatchScores.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
                confirmMatchScoresCenterXAnchor = confirmMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X + (confirmMatchScoresLoc.W / 4)))
                confirmMatchScoresCenterXAnchor?.isActive = true
                confirmMatchScores.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
                confirmMatchScoresWidthAnchor = confirmMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W / 2))
                confirmMatchScoresWidthAnchor?.isActive = true
                
                view.addSubview(rejectMatchScores)
                rejectMatchScores.setTitle("No I want to edit the scores", for: .normal)
                rejectMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
                rejectMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
                rejectMatchScores.titleLabel?.numberOfLines = 3
                rejectMatchScores.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
                rejectMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X - (confirmMatchScoresLoc.W / 4))).isActive = true
                rejectMatchScores.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
                rejectMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W / 2)).isActive = true
                disableScores(team1Scores: confirmers, team2Scores: team2)
            }
        } else if active == 3 {
            if forfeit == 1 {
                whiteCover.isHidden = false
                disableScores(team1Scores: confirmers, team2Scores: team2)
                confirmCheck1.isHidden = false
                confirmCheck2.isHidden = false
                confirmCheck3.isHidden = false
                confirmCheck4.isHidden = false
                view.addSubview(forfeitLabel)
                forfeitLabel.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
                forfeitLabel.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
                forfeitLabel.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
                forfeitLabel.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
            } else {
                whiteCover.isHidden = true
                confirmCheck1.isHidden = false
                confirmCheck2.isHidden = false
                confirmCheck3.isHidden = false
                confirmCheck4.isHidden = false
                disableScores(team1Scores: confirmers, team2Scores: team2)
                view.addSubview(winnerConfirmed)
                winnerConfirmed.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
                winnerConfirmed.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
                winnerConfirmed.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
                winnerConfirmed.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
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
                let exp = value["exp"] as? Int
                let playerLevel = self.player.haloLevel(exp: exp!)
                self.userPlayer1.text = "\(value["username"] as? String ?? "none")"
                self.userPlayer1Skill.text = "\(value["skill_level"] as? Float ?? 0)"
                self.userPlayer1Level.text = "\(playerLevel)"
                let playerExp = value["exp"] as? Int
                self.team1_P1_Exp = playerExp!
                self.team1_P1_Lev = self.player.haloLevel(exp: playerExp!)
                if self.match.active == 3 && self.match.winner == 1 {
                    if self.winnerConfirmed.text!.count > 5 {
                        self.winnerConfirmed.text = (value["username"] as? String)! + " and " + self.winnerConfirmed.text!
                    } else {
                        self.winnerConfirmed.text = (value["username"] as? String)! + self.winnerConfirmed.text!
                    }
                }
            }
        })
        
        let user2NameRef = Database.database().reference().child("users").child(idList[1])
        user2NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                let exp = value["exp"] as? Int
                let playerLevel = self.player.haloLevel(exp: exp!)
                self.userPlayer2.text = "\(value["username"] as? String ?? "none")"
                self.userPlayer2Skill.text = "\(value["skill_level"] as? Float ?? 0)"
                self.userPlayer2Level.text = "\(playerLevel)"
                let playerExp = value["exp"] as? Int
                self.team1_P2_Exp = playerExp!
                self.team1_P2_Lev = self.player.haloLevel(exp: playerExp!)
                if self.match.active == 3 && self.match.winner == 1 {
                    if self.winnerConfirmed.text!.count > 5 {
                        self.winnerConfirmed.text = (value["username"] as? String)! + " and " + self.winnerConfirmed.text!
                    } else {
                        self.winnerConfirmed.text = (value["username"] as? String)! + self.winnerConfirmed.text!
                    }
                }
            }
        })
        
        let opp1NameRef = Database.database().reference().child("users").child(idList[2])
        opp1NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                let exp = value["exp"] as? Int
                let playerLevel = self.player.haloLevel(exp: exp!)
                self.oppPlayer1.text = "\(value["username"] as? String ?? "none")"
                self.oppPlayer1Skill.text = "\(value["skill_level"] as? Float ?? 0)"
                self.oppPlayer1Level.text = "\(playerLevel)"
                let playerExp = value["exp"] as? Int
                self.team2_P1_Exp = playerExp!
                self.team2_P1_Lev = self.player.haloLevel(exp: playerExp!)
                if self.match.active == 3 && self.match.winner == 2 {
                    if self.winnerConfirmed.text!.count > 5 {
                        self.winnerConfirmed.text = (value["username"] as? String)! + " and " + self.winnerConfirmed.text!
                    } else {
                        self.winnerConfirmed.text = (value["username"] as? String)! + self.winnerConfirmed.text!
                    }
                }
            }
        })
        
        let opp2NameRef = Database.database().reference().child("users").child(idList[3])
        opp2NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                let exp = value["exp"] as? Int
                let playerLevel = self.player.haloLevel(exp: exp!)
                self.oppPlayer2.text = "\(value["username"] as? String ?? "none")"
                self.oppPlayer2Skill.text = "\(value["skill_level"] as? Float ?? 0)"
                self.oppPlayer2Level.text = "\(playerLevel)"
                let playerExp = value["exp"] as? Int
                self.team2_P2_Exp = playerExp!
                self.team2_P2_Lev = self.player.haloLevel(exp: playerExp!)
                if self.match.active == 3 && self.match.winner == 2 {
                    if self.winnerConfirmed.text!.count > 5 {
                        self.winnerConfirmed.text = (value["username"] as? String)! + " and " + self.winnerConfirmed.text!
                    } else {
                        self.winnerConfirmed.text = (value["username"] as? String)! + self.winnerConfirmed.text!
                    }
                }
            }
        })
    }
    
    let backgroundImage: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.image = UIImage(named: "match_info_display2.0")
        bi.isUserInteractionEnabled = true
        return bi
    }()

    let userPlayer1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Teammate 1"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let userPlayer1Skill: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .right
        return label
    }()
    
    let userPlayer1Level: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        return label
    }()
    
    let userPlayer2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Teammate 1"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let userPlayer2Skill: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .right
        return label
    }()
    
    let userPlayer2Level: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        return label
    }()
    
    let oppPlayer1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Teammate 1"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let oppPlayer1Skill: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .right
        return label
    }()
    
    let oppPlayer1Level: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        return label
    }()
    
    let oppPlayer2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Teammate 1"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let oppPlayer2Skill: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .right
        return label
    }()
    
    let oppPlayer2Level: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        return label
    }()
    
    let game1UserScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let game2UserScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let game3UserScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let game4UserScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let game5UserScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let game1OppScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let game2OppScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let game3OppScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let game4OppScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let game5OppScore: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "#"
        textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        textField.textAlignment = .center
        return textField
    }()
    
    let matchStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let confirmMatchScores: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        return button
    }()
    
    let rejectMatchScores: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleReject), for: .touchUpInside)
        return button
    }()
    
//    let confirmMatchScoresImage: UIImageView = {
//        let image = UIImageView()
//        image.translatesAutoresizingMaskIntoConstraints = false
//        return image
//    }()
    
    let winnerConfirmed: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = " win!"
        label.numberOfLines = 2
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let forfeitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The challenged team forfeited!"
        label.numberOfLines = 2
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let confirmCheck1: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "confirmed_check")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let confirmCheck2: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "confirmed_check")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let confirmCheck3: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "confirmed_check")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let confirmCheck4: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "confirmed_check")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let whiteCover: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
    }
    
    func setupViews() {
        
        let matchInfoDisplayHeightBefore: Float = 1164
        let matchInfoDisplayHeightAfter: Float = 582
        
        view.addSubview(backgroundImage)
        backgroundImageCenterYAnchor = backgroundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        backgroundImageCenterYAnchor?.isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalToConstant: 575).isActive = true
        confirmCheck1.isHidden = true
        confirmCheck2.isHidden = true
        confirmCheck3.isHidden = true
        confirmCheck4.isHidden = true
        
        let whiteCoverLoc = calculateButtonPosition(x: 479.5, y: 832, w: 275, h: 331, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        view.addSubview(whiteCover)
        whiteCover.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(whiteCoverLoc.Y)).isActive = true
        whiteCover.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(whiteCoverLoc.X)).isActive = true
        whiteCover.heightAnchor.constraint(equalToConstant: CGFloat(whiteCoverLoc.H)).isActive = true
        whiteCover.widthAnchor.constraint(equalToConstant: CGFloat(whiteCoverLoc.W)).isActive = true
        
        let confirmCheck1Loc = calculateButtonPosition(x: 666, y: 77, w: 74, h: 74, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        view.addSubview(confirmCheck1)
        confirmCheck1.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmCheck1Loc.Y)).isActive = true
        confirmCheck1.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmCheck1Loc.X)).isActive = true
        confirmCheck1.heightAnchor.constraint(equalToConstant: CGFloat(confirmCheck1Loc.H)).isActive = true
        confirmCheck1.widthAnchor.constraint(equalToConstant: CGFloat(confirmCheck1Loc.W)).isActive = true
        
        let confirmCheck2Loc = calculateButtonPosition(x: 666, y: 163, w: 74, h: 74, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        view.addSubview(confirmCheck2)
        confirmCheck2.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmCheck2Loc.Y)).isActive = true
        confirmCheck2.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmCheck2Loc.X)).isActive = true
        confirmCheck2.heightAnchor.constraint(equalToConstant: CGFloat(confirmCheck2Loc.H)).isActive = true
        confirmCheck2.widthAnchor.constraint(equalToConstant: CGFloat(confirmCheck2Loc.W)).isActive = true
        
        let confirmCheck3Loc = calculateButtonPosition(x: 666, y: 383, w: 74, h: 74, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        view.addSubview(confirmCheck3)
        confirmCheck3.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmCheck3Loc.Y)).isActive = true
        confirmCheck3.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmCheck3Loc.X)).isActive = true
        confirmCheck3.heightAnchor.constraint(equalToConstant: CGFloat(confirmCheck3Loc.H)).isActive = true
        confirmCheck3.widthAnchor.constraint(equalToConstant: CGFloat(confirmCheck3Loc.W)).isActive = true
        
        let confirmCheck4Loc = calculateButtonPosition(x: 666, y: 469, w: 74, h: 74, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        view.addSubview(confirmCheck4)
        confirmCheck4.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmCheck4Loc.Y)).isActive = true
        confirmCheck4.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmCheck4Loc.X)).isActive = true
        confirmCheck4.heightAnchor.constraint(equalToConstant: CGFloat(confirmCheck4Loc.H)).isActive = true
        confirmCheck4.widthAnchor.constraint(equalToConstant: CGFloat(confirmCheck4Loc.W)).isActive = true
        
        let userPlayer1Loc = calculateButtonPosition(x: 211.5, y: 75, w: 327, h: 85, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        view.addSubview(userPlayer1)
        userPlayer1.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(userPlayer1Loc.Y)).isActive = true
        userPlayer1.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(userPlayer1Loc.X)).isActive = true
        userPlayer1.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.H)).isActive = true
        userPlayer1.widthAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.W)).isActive = true
        
        view.addSubview(userPlayer1Skill)
        userPlayer1Skill.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(userPlayer1Loc.Y)).isActive = true
        userPlayer1Skill.leftAnchor.constraint(equalTo: backgroundImage.centerXAnchor, constant: 4).isActive = true
        userPlayer1Skill.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.H)).isActive = true
        userPlayer1Skill.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        
        view.addSubview(userPlayer1Level)
        userPlayer1Level.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(userPlayer1Loc.Y)).isActive = true
        userPlayer1Level.leftAnchor.constraint(equalTo: userPlayer1Skill.rightAnchor, constant: 40).isActive = true
        userPlayer1Level.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.H)).isActive = true
        userPlayer1Level.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        
        let userPlayer2Loc = calculateButtonPosition(x: 211.5, y: 165, w: 327, h: 85, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        
        view.addSubview(userPlayer2)
        userPlayer2.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(userPlayer2Loc.Y)).isActive = true
        userPlayer2.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(userPlayer2Loc.X)).isActive = true
        userPlayer2.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer2Loc.H)).isActive = true
        userPlayer2.widthAnchor.constraint(equalToConstant: CGFloat(userPlayer2Loc.W)).isActive = true
        
        view.addSubview(userPlayer2Skill)
        userPlayer2Skill.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(userPlayer2Loc.Y)).isActive = true
        userPlayer2Skill.leftAnchor.constraint(equalTo: backgroundImage.centerXAnchor, constant: 4).isActive = true
        userPlayer2Skill.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer2Loc.H)).isActive = true
        userPlayer2Skill.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        
        view.addSubview(userPlayer2Level)
        userPlayer2Level.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(userPlayer2Loc.Y)).isActive = true
        userPlayer2Level.leftAnchor.constraint(equalTo: userPlayer2Skill.rightAnchor, constant: 40).isActive = true
        userPlayer2Level.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer2Loc.H)).isActive = true
        userPlayer2Level.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        
        let oppPlayer1Loc = calculateButtonPosition(x: 211.5, y: 381, w: 327, h: 85, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        
        view.addSubview(oppPlayer1)
        oppPlayer1.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(oppPlayer1Loc.Y)).isActive = true
        oppPlayer1.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(oppPlayer1Loc.X)).isActive = true
        oppPlayer1.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.H)).isActive = true
        oppPlayer1.widthAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.W)).isActive = true
        
        view.addSubview(oppPlayer1Skill)
        oppPlayer1Skill.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(oppPlayer1Loc.Y)).isActive = true
        oppPlayer1Skill.leftAnchor.constraint(equalTo: backgroundImage.centerXAnchor, constant: 4).isActive = true
        oppPlayer1Skill.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.H)).isActive = true
        oppPlayer1Skill.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        
        view.addSubview(oppPlayer1Level)
        oppPlayer1Level.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(oppPlayer1Loc.Y)).isActive = true
        oppPlayer1Level.leftAnchor.constraint(equalTo: oppPlayer1Skill.rightAnchor, constant: 40).isActive = true
        oppPlayer1Level.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.H)).isActive = true
        oppPlayer1Level.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        
        let oppPlayer2Loc = calculateButtonPosition(x: 211.5, y: 471, w: 327, h: 85, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        
        view.addSubview(oppPlayer2)
        oppPlayer2.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(oppPlayer2Loc.Y)).isActive = true
        oppPlayer2.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(oppPlayer2Loc.X)).isActive = true
        oppPlayer2.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer2Loc.H)).isActive = true
        oppPlayer2.widthAnchor.constraint(equalToConstant: CGFloat(oppPlayer2Loc.W)).isActive = true
        
        view.addSubview(oppPlayer2Skill)
        oppPlayer2Skill.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(oppPlayer2Loc.Y)).isActive = true
        oppPlayer2Skill.leftAnchor.constraint(equalTo: backgroundImage.centerXAnchor, constant: 4).isActive = true
        oppPlayer2Skill.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer2Loc.H)).isActive = true
        oppPlayer2Skill.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        
        view.addSubview(oppPlayer2Level)
        oppPlayer2Level.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(oppPlayer2Loc.Y)).isActive = true
        oppPlayer2Level.leftAnchor.constraint(equalTo: oppPlayer2Skill.rightAnchor, constant: 40).isActive = true
        oppPlayer2Level.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer2Loc.H)).isActive = true
        oppPlayer2Level.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        
        let game1UserScoreLoc = calculateButtonPosition(x: 407.52, y: 698, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        
        view.addSubview(game1UserScore)
        game1UserScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game1UserScoreLoc.Y)).isActive = true
        game1UserScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game1UserScoreLoc.X)).isActive = true
        game1UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game1UserScoreLoc.H)).isActive = true
        game1UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game1UserScoreLoc.W)).isActive = true
        
        let game1OppScoreLoc = calculateButtonPosition(x: 549.02, y: 698, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        
        view.addSubview(game1OppScore)
        game1OppScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game1OppScoreLoc.Y)).isActive = true
        game1OppScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game1OppScoreLoc.X)).isActive = true
        game1OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game1OppScoreLoc.H)).isActive = true
        game1OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game1OppScoreLoc.W)).isActive = true
        
        let game2UserScoreLoc = calculateButtonPosition(x: 407.52, y: 763, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        
        view.addSubview(game2UserScore)
        game2UserScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game2UserScoreLoc.Y)).isActive = true
        game2UserScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game2UserScoreLoc.X)).isActive = true
        game2UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game2UserScoreLoc.H)).isActive = true
        game2UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game2UserScoreLoc.W)).isActive = true
        
        let game2OppScoreLoc = calculateButtonPosition(x: 549.02, y: 763, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        
        view.addSubview(game2OppScore)
        game2OppScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game2OppScoreLoc.Y)).isActive = true
        game2OppScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game2OppScoreLoc.X)).isActive = true
        game2OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game2OppScoreLoc.H)).isActive = true
        game2OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game2OppScoreLoc.W)).isActive = true
        
        let game3UserScoreLoc = calculateButtonPosition(x: 407.52, y: 828, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        
        view.addSubview(game3UserScore)
        game3UserScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game3UserScoreLoc.Y)).isActive = true
        game3UserScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game3UserScoreLoc.X)).isActive = true
        game3UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game3UserScoreLoc.H)).isActive = true
        game3UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game3UserScoreLoc.W)).isActive = true
        
        let game3OppScoreLoc = calculateButtonPosition(x: 549.02, y: 828, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        
        view.addSubview(game3OppScore)
        game3OppScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game3OppScoreLoc.Y)).isActive = true
        game3OppScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game3OppScoreLoc.X)).isActive = true
        game3OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game3OppScoreLoc.H)).isActive = true
        game3OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game3OppScoreLoc.W)).isActive = true
        
        let game4UserScoreLoc = calculateButtonPosition(x: 407.52, y: 893, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        
        view.addSubview(game4UserScore)
        game4UserScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game4UserScoreLoc.Y)).isActive = true
        game4UserScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game4UserScoreLoc.X)).isActive = true
        game4UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game4UserScoreLoc.H)).isActive = true
        game4UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game4UserScoreLoc.W)).isActive = true
        
        let game4OppScoreLoc = calculateButtonPosition(x: 549.02, y: 893, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        
        view.addSubview(game4OppScore)
        game4OppScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game4OppScoreLoc.Y)).isActive = true
        game4OppScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game4OppScoreLoc.X)).isActive = true
        game4OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game4OppScoreLoc.H)).isActive = true
        game4OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game4OppScoreLoc.W)).isActive = true
        
        let game5UserScoreLoc = calculateButtonPosition(x: 407.52, y: 958, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        
        view.addSubview(game5UserScore)
        game5UserScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game5UserScoreLoc.Y)).isActive = true
        game5UserScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game5UserScoreLoc.X)).isActive = true
        game5UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game5UserScoreLoc.H)).isActive = true
        game5UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game5UserScoreLoc.W)).isActive = true
        
        let game5OppScoreLoc = calculateButtonPosition(x: 549.02, y: 958, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: 375, hia: matchInfoDisplayHeightAfter)
        
        view.addSubview(game5OppScore)
        game5OppScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game5OppScoreLoc.Y)).isActive = true
        game5OppScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game5OppScoreLoc.X)).isActive = true
        game5OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game5OppScoreLoc.H)).isActive = true
        game5OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game5OppScoreLoc.W)).isActive = true
    }
    
    func performRejectActive0Tourney() {
        match.winner = 1
        winner = 1
        //let values = ["active": 3] as [String : Any]
        match.team1_scores = [0, 0, 0, 0, 0]
        match.forfeit = 1
        let childUpdates = ["/\("team1_scores")/": match.team1_scores, "/\("active")/": 3, "/\("forfeit")/": 1, "/\("winner")/": 1] as [String : Any]
        let ref = tourneyId == "none" ? Database.database().reference().child("matches").child(matchId) : Database.database().reference().child("tourneys").child(tourneyId).child("matches").child(matchId)
        ref.updateChildValues(childUpdates, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            
            print("Data saved successfully!")
            self.match.active = 3
            self.setupNavbarTitle(status: 3)
            self.confirmCheck1.isHidden = false
            self.confirmCheck2.isHidden = false
            self.confirmCheck3.isHidden = false
            self.confirmCheck4.isHidden = false
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            self.match.sendTourneyNotifications(uid: uid, tourneyId: self.tourneyId, tourneyYetToViewMatch: self.yetToView)

            self.updateTourneyStandings()
            self.removeCantChallenge()
            
            
            
        })
        rejectMatchScores.isHidden = true
        confirmMatchScores.isHidden = true
        let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1084, w: 712, h: 126, wib: 750, hib: 1164, wia: 375, hia: 582)
        view.addSubview(forfeitLabel)
        forfeitLabel.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
        forfeitLabel.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
        forfeitLabel.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
        forfeitLabel.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
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
        let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1084, w: 712, h: 126, wib: 750, hib: 1164, wia: 375, hia: 582)
        var matchReady = -1
        if tourneyId == "none" {
            let ref = Database.database().reference().child("matches").child(matchId).child("team1_scores")
            match.team1_scores![whichOne] = 1
            switch whichOne {
            case 1:
                confirmCheck2.isHidden = false
            case 2:
                confirmCheck3.isHidden = false
            case 3:
                confirmCheck4.isHidden = false
            default:
                print("failed to confirm")
            }
            ref.setValue(match.team1_scores)
            matchReady = checkIfMatchReady()
        } else {
            confirmCheck3.isHidden = false
            confirmCheck4.isHidden = false
            matchReady = 1
        }
        if matchReady == 0 {
            confirmMatchScores.isHidden = true
            rejectMatchScores.isHidden = true
            view.addSubview(matchStatusLabel)
            matchStatusLabel.text = "Waiting for opponents to confirm match"
            matchStatusLabel.numberOfLines = 2
            matchStatusLabel.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
            matchStatusLabel.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
            matchStatusLabel.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
            matchStatusLabel.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
        } else {
            whiteCover.isHidden = true
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            let matchActiveRef = tourneyId == "none" ? Database.database().reference().child("matches").child(matchId) : Database.database().reference().child("tourneys").child(tourneyId).child("matches").child(matchId)
            match.team1_scores = [0, 0, 0, 0, 0]
            let timeOfChallenge = Date().timeIntervalSince1970
            let childUpdates = ["/\("team1_scores")/": match.team1_scores, "/\("active")/": 1, "/\("time")/": timeOfChallenge] as [String : Any]
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
                self.setupNavbarTitle(status: 1)
                
                print("Crazy data 2 saved!")
                uid != self.match.team_1_player_1 ? Database.database().reference().child("user_notifications").child(self.match.team_1_player_1!).child(self.matchId).setValue(1) : print("nope")
                uid != self.match.team_1_player_2 ? Database.database().reference().child("user_notifications").child(self.match.team_1_player_2!).child(self.matchId).setValue(1) : print("nope")
                uid != self.match.team_2_player_1 ? Database.database().reference().child("user_notifications").child(self.match.team_2_player_1!).child(self.matchId).setValue(1) : print("nope")
                uid != self.match.team_2_player_2 ? Database.database().reference().child("user_notifications").child(self.match.team_2_player_2!).child(self.matchId).setValue(1) : print("nope")
                
                
            })
            
            rejectMatchScores.isHidden = true
            confirmMatchScores.setTitle("Submit Scores to Opponent for Review", for: .normal)
            confirmMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
            confirmMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
            confirmMatchScores.titleLabel?.numberOfLines = 2
            game1UserScore.isUserInteractionEnabled = true
            game2UserScore.isUserInteractionEnabled = true
            game3UserScore.isUserInteractionEnabled = true
            game4UserScore.isUserInteractionEnabled = true
            game5UserScore.isUserInteractionEnabled = true
            game1OppScore.isUserInteractionEnabled = true
            game2OppScore.isUserInteractionEnabled = true
            game3OppScore.isUserInteractionEnabled = true
            game4OppScore.isUserInteractionEnabled = true
            game5OppScore.isUserInteractionEnabled = true
            
            
            confirmMatchScoresCenterXAnchor?.constant = CGFloat(confirmMatchScoresLoc.X)
            confirmMatchScoresWidthAnchor?.constant = CGFloat(confirmMatchScoresLoc.W)
        }
    }
    
    func performConfirmActive1() {
        let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1084, w: 712, h: 126, wib: 750, hib: 1164, wia: 375, hia: 582)
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
            let ref = tourneyId == "none" ? Database.database().reference().child("matches").child(matchId) : Database.database().reference().child("tourneys").child(tourneyId).child("matches").child(matchId)
            ref.updateChildValues(values, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if let error = error {
                    print("Data could not be saved: \(error).")
                    return
                }
                
                print("Data saved successfully!")
                self.match.active = 2
                self.setupNavbarTitle(status: 2)
                self.match.winner = self.winner
                self.match.submitter = self.userIsTeam1 ? 1 : 2
                self.match.team1_scores = self.finalTeam1Scores
                self.match.team2_scores = self.finalTeam2Scores
                if self.match.submitter == 1 {
                    self.confirmCheck1.isHidden = false
                    self.confirmCheck2.isHidden = false
                } else {
                    self.confirmCheck3.isHidden = false
                    self.confirmCheck4.isHidden = false
                }
                guard let uid = Auth.auth().currentUser?.uid else {
                    return
                }
                
                if self.tourneyId == "none" {
                    uid != self.match.team_1_player_1 ? Database.database().reference().child("user_notifications").child(self.match.team_1_player_1!).child(self.matchId).setValue(1) : print("nope")
                    uid != self.match.team_1_player_2 ? Database.database().reference().child("user_notifications").child(self.match.team_1_player_2!).child(self.matchId).setValue(1) : print("nope")
                    uid != self.match.team_2_player_1 ? Database.database().reference().child("user_notifications").child(self.match.team_2_player_1!).child(self.matchId).setValue(1) : print("nope")
                    uid != self.match.team_2_player_2 ? Database.database().reference().child("user_notifications").child(self.match.team_2_player_2!).child(self.matchId).setValue(1) : print("nope")
                } else {
                    self.match.sendTourneyNotifications(uid: uid, tourneyId: self.tourneyId, tourneyYetToViewMatch: self.yetToView)
                }
                
                
            })
            
            let newalert = UIAlertController(title: "Match Scores Confirmed", message: "Now just wait for opponent to confirm", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: resetupviews))
            self.present(newalert, animated: true, completion: nil)
            confirmMatchScores.isHidden = true
            view.addSubview(matchStatusLabel)
            matchStatusLabel.text = "Waiting for opponent to accept submitted scores"
            matchStatusLabel.numberOfLines = 2
            matchStatusLabel.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
            matchStatusLabel.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
            matchStatusLabel.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
            matchStatusLabel.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
            
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
        let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1084, w: 712, h: 126, wib: 750, hib: 1164, wia: 375, hia: 582)
        let time = Date().timeIntervalSince1970
        let values = ["active": 3, "time": time] as [String : Any]
        let ref = tourneyId == "none" ? Database.database().reference().child("matches").child(matchId) : Database.database().reference().child("tourneys").child(tourneyId).child("matches").child(matchId)
        ref.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            
            print("Data saved successfully!")
            let ref2 = Database.database().reference().child("completed_matches").child(self.matchId)
            let values2 = ["active": 3, "winner": self.match.winner, "forfeit": self.match.forfeit, "team_1_player_1": self.match.team_1_player_1, "team_1_player_2": self.match.team_1_player_2, "team_2_player_1": self.match.team_2_player_1, "team_2_player_2": self.match.team_2_player_2, "team1_scores": self.match.team1_scores, "team2_scores": self.match.team2_scores, "time": time] as [String : Any]
            ref2.updateChildValues(values2, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if let error = error {
                    print("Data could not be saved: \(error).")
                    return
                }
                })
            self.match.active = 3
            self.setupNavbarTitle(status: 3)
            self.confirmCheck1.isHidden = false
            self.confirmCheck2.isHidden = false
            self.confirmCheck3.isHidden = false
            self.confirmCheck4.isHidden = false
            self.updatePlayerStats()
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            self.match.sendTourneyNotifications(uid: uid, tourneyId: self.tourneyId, tourneyYetToViewMatch: self.yetToView)
            if self.tourneyActive >= 2 {
                self.adjustTourneyFinals()
                self.updateTeamWins()
            } else {
                self.tourneyId != "none" ? self.updateTourneyStandings() : print("nope")
                self.tourneyId != "none" ? self.removeCantChallenge() : print("nope")
            }
            
            
        })
        let newalert = UIAlertController(title: "Match Complete", message: self.match.winner == 1 ? "\(userPlayer1.text!) and \(userPlayer2.text!) win!" : "\(oppPlayer1.text!) and \(oppPlayer2.text!) win!", preferredStyle: UIAlertController.Style.alert)
        newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: resetupviews))
        self.present(newalert, animated: true, completion: nil)
        confirmMatchScores.isHidden = true
        rejectMatchScores.isHidden = true
        view.addSubview(winnerConfirmed)
        winnerConfirmed.text = match.winner == 1 ? "\(userPlayer1.text!) & \(userPlayer2.text!) win!" : "\(oppPlayer1.text!) & \(oppPlayer2.text!) win!"
        winnerConfirmed.numberOfLines = 2
        winnerConfirmed.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
        winnerConfirmed.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
        winnerConfirmed.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
        winnerConfirmed.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
    }
    
    func updateTeamWins() {
        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("teams")
        let valuesTeam1 = ["rank": team1.rank, "wins": match.winner == 1 ? team1.wins! + 1 : team1.wins!, "losses": match.winner == 2 ? team1.losses! + 1 : team1.losses!, "player1": team1.player1, "player2": team1.player2] as [String : Any]
        let valuesTeam2 = ["rank": team2.rank, "wins": match.winner == 2 ? team2.wins! + 1 : team2.wins!, "losses": match.winner == 1 ? team2.losses! + 1 : team2.losses!, "player1": team2.player1, "player2": team2.player2] as [String : Any]
        var childUpdates = ["/\(team1.teamId ?? "none")/": valuesTeam1, "/\(team2.teamId ?? "none")/": valuesTeam2]
        ref.updateChildValues(childUpdates, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            
            print("Crazy data saved!")
            
            
        })
    }
    
    func removeCantChallenge() {
        let ref = Database.database().reference().child("tourneys").child(tourneyId)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? NSDictionary {
                if let cantChallenge = value["cant_challenge"] as? [String] {
                    var tourneyCantChallenge = cantChallenge
                    tourneyCantChallenge.remove(at: tourneyCantChallenge.firstIndex(of: self.match.team_1_player_1!)!)
                    tourneyCantChallenge.remove(at: tourneyCantChallenge.firstIndex(of: self.match.team_1_player_2!)!)
                    tourneyCantChallenge.remove(at: tourneyCantChallenge.firstIndex(of: self.match.team_2_player_1!)!)
                    tourneyCantChallenge.remove(at: tourneyCantChallenge.firstIndex(of: self.match.team_2_player_2!)!)
                    Database.database().reference().child("tourneys").child(self.tourneyId).child("cant_challenge").setValue(tourneyCantChallenge)
                }
            }
        }, withCancel: nil)
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
    
    func reorganizeTeams() -> [Int] {
        var newTeam1Rank = -10
        var newTeam2Rank = -10
        var effectedRanks = [Int]()
        var effectedIndices = [Int]()
        guard let team1Rank = team1.rank else {
            return [-1]
        }
        guard let team2Rank = team2.rank else {
            return [-1]
        }
        let team1IsLeading = team1Rank < team2Rank ? 0 : 1
        if match.winner == 1 {
            if team1IsLeading == 0 {
                newTeam1Rank = team1Rank != 1 ? team1Rank - 1 : 1
                newTeam2Rank = team2Rank
                for (index, element) in teams.enumerated() {
                    if element.rank == newTeam1Rank {
                        if team1Rank != 1 {
                            element.rank = team1Rank
                            effectedIndices.append(index)
                        }
                    } else if element.teamId == team1.teamId {
                        element.rank = newTeam1Rank
                    }
                }
                return effectedIndices
            } else {
                newTeam1Rank = team2Rank
                newTeam2Rank = team2Rank + 1
                if team1Rank - team2Rank > 1 {
                    for index in team2Rank + 1..<team1Rank {
                        effectedRanks.append(index)
                    }
                }
                for (index, element) in teams.enumerated() {
                    if effectedRanks.contains(element.rank!) {
                        element.rank = element.rank! + 1
                        effectedIndices.append(index)
                    } else if element.teamId == team1.teamId {
                        element.rank = newTeam1Rank
                    } else if element.teamId == team2.teamId {
                        element.rank = newTeam2Rank
                    }
                }
                return effectedIndices
            }
        } else if match.winner == 2 {
            if team1IsLeading == 1 {
                newTeam2Rank = team2Rank != 1 ? team2Rank - 1 : 1
                newTeam1Rank = team1Rank
                for (index, element) in teams.enumerated() {
                    if element.rank == newTeam2Rank {
                        if team2Rank != 1 {
                            element.rank = team2Rank
                            effectedIndices.append(index)
                        }
                    } else if element.teamId == team2.teamId {
                        element.rank = newTeam2Rank
                    }
                }
                return effectedIndices
            } else {
                newTeam2Rank = team1Rank
                newTeam1Rank = team1Rank + 1
                if team2Rank - team1Rank > 1 {
                    for index in team1Rank + 1..<team2Rank {
                        effectedRanks.append(index)
                    }
                }
                for (index, element) in teams.enumerated() {
                    if effectedRanks.contains(element.rank!) {
                        element.rank = element.rank! + 1
                        effectedIndices.append(index)
                    } else if element.teamId == team2.teamId {
                        element.rank = newTeam2Rank
                    } else if element.teamId == team1.teamId {
                        element.rank = newTeam1Rank
                    }
                }
                return effectedIndices
            }
        } else {
            return [-1]
        }
    }
    
    func updateTourneyStandings() {
        var team1Index = -1
        var team2Index = -1
        for (index, element) in teams.enumerated() {
            if element.teamId == team1.teamId ?? "no user id" {
                team1Index = index
            } else if element.teamId == team2.teamId {
                team2Index = index
            }
        }
        let effectedIndices = reorganizeTeams()
        
        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("teams")
        let valuesTeam1 = ["rank": teams[team1Index].rank, "wins": match.winner == 1 ? team1.wins! + 1 : team1.wins!, "losses": match.winner == 2 ? team1.losses! + 1 : team1.losses!, "player1": team1.player1, "player2": team1.player2] as [String : Any]
        let valuesTeam2 = ["rank": teams[team2Index].rank, "wins": match.winner == 2 ? team2.wins! + 1 : team2.wins!, "losses": match.winner == 1 ? team2.losses! + 1 : team2.losses!, "player1": team2.player1, "player2": team2.player2] as [String : Any]
        var childUpdates = ["/\(team1.teamId ?? "none")/": valuesTeam1, "/\(team2.teamId ?? "none")/": valuesTeam2]
        if effectedIndices.count == 1 {
            let valuesEffected1 = ["rank": teams[effectedIndices[0]].rank as Any, "wins": teams[effectedIndices[0]].wins as Any, "losses": teams[effectedIndices[0]].losses as Any, "player1": teams[effectedIndices[0]].player1 as Any, "player2": teams[effectedIndices[0]].player2 as Any] as [String : Any]
            childUpdates = ["/\(team1.teamId ?? "none")/": valuesTeam1, "/\(team2.teamId ?? "none")/": valuesTeam2, "/\(teams[effectedIndices[0]].teamId ?? "none")/": valuesEffected1]
        } else if effectedIndices.count == 2 {
            let valuesEffected1 = ["rank": teams[effectedIndices[0]].rank as Any, "wins": teams[effectedIndices[0]].wins as Any, "losses": teams[effectedIndices[0]].losses as Any, "player1": teams[effectedIndices[0]].player1 as Any, "player2": teams[effectedIndices[0]].player2 as Any] as [String : Any]
            let valuesEffected2 = ["rank": teams[effectedIndices[1]].rank as Any, "wins": teams[effectedIndices[1]].wins as Any, "losses": teams[effectedIndices[1]].losses as Any, "player1": teams[effectedIndices[1]].player1 as Any, "player2": teams[effectedIndices[1]].player2 as Any] as [String : Any]
            childUpdates = ["/\(team1.teamId ?? "none")/": valuesTeam1, "/\(team2.teamId ?? "none")/": valuesTeam2, "/\(teams[effectedIndices[0]].teamId ?? "none")/": valuesEffected1, "/\(teams[effectedIndices[1]].teamId ?? "none")/": valuesEffected2]
        }
        ref.updateChildValues(childUpdates, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            
            print("Crazy data saved!")
            
            
        })
        
    }
    
    func adjustTourneyFinals() {
        if tourneyActive == 2 {
            if team1.rank == 1 {
                Database.database().reference().child("tourneys").child(tourneyId).child("active").setValue(3)
                let finalsTeam = self.match.winner == 1 ? 1 : 4
                Database.database().reference().child("tourneys").child(tourneyId).child("finals1").setValue(finalsTeam)
            } else if team1.rank == 2 {
                Database.database().reference().child("tourneys").child(tourneyId).child("active").setValue(4)
                let finalsTeam = self.match.winner == 1 ? 2 : 3
                Database.database().reference().child("tourneys").child(tourneyId).child("finals2").setValue(finalsTeam)
            }
        } else if tourneyActive == 3 {
            Database.database().reference().child("tourneys").child(tourneyId).child("active").setValue(5)
            let finalsTeam = self.match.winner == 1 ? 2 : 3
            Database.database().reference().child("tourneys").child(tourneyId).child("finals2").setValue(finalsTeam)
            finals2 = self.match.winner == 1 ? 2 : 3
            setupFinalMatch()
        } else if tourneyActive == 4 {
            Database.database().reference().child("tourneys").child(tourneyId).child("active").setValue(5)
            let finalsTeam = self.match.winner == 1 ? 1 : 4
            finals1 = self.match.winner == 1 ? 1 : 4
            Database.database().reference().child("tourneys").child(tourneyId).child("finals1").setValue(finalsTeam)
            setupFinalMatch()
        } else if tourneyActive == 5 {
            Database.database().reference().child("tourneys").child(tourneyId).child("active").setValue(6)
            let finalsTeam = self.match.winner == 1 ? team1.rank : team2.rank
            Database.database().reference().child("tourneys").child(tourneyId).child("winner").setValue(finalsTeam)
        }
    }
    
    func setupFinalMatch() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        var team1stIndex = 0
        var team2ndIndex = 0
        for (index, element) in teams.enumerated() {
            if element.rank == finals1 {
                team1stIndex = index
            } else if element.rank == finals2 {
                team2ndIndex = index
            }
        }
        let team1st = teams[team1stIndex]
        let team2nd = teams[team2ndIndex]
        let timeOfChallenge = Date().timeIntervalSince1970
        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("matches")
        let createMatchRef = ref.childByAutoId()
        let values = ["active": 1, "team_1_player_1": team1st.player1, "team_1_player_2": team1st.player2, "team_2_player_1": team2nd.player1, "team_2_player_2": team2nd.player2, "team1_scores": [0, 0, 0, 0, 0], "team2_scores": [0, 0, 0, 0, 0], "time": timeOfChallenge] as [String : Any]
        createMatchRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            guard let matchId = createMatchRef.key else {
                return
            }
            
            let notificationsRef = Database.database().reference()
            let childUpdates = ["/\("tourney_notifications")/\(team1st.player1)/\(self.tourneyId)/": team1st.player1 == uid ? 0 : 1, "/\("tourney_notifications")/\(team1st.player2)/\(self.tourneyId)/": team1st.player2 == uid ? 0 : 1, "/\("tourney_notifications")/\(team2nd.player1)/\(self.tourneyId)/": team2nd.player1 == uid ? 0 : 1, "/\("tourney_notifications")/\(team2nd.player2)/\(self.tourneyId)/": team2nd.player2 == uid ? 0 : 1] as [String : Any]
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
            
        })
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
