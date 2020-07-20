//
//  RoundRobinMatch.swift
//  Pickleball
//
//  Created by Tanner Rozier on 7/12/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FBSDKShareKit

class RoundRobinMatch: UIViewController {
    
    let matchViewOrganizer = MatchViewOrganizer(frame: CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.width)!, height: (UIApplication.shared.keyWindow?.frame.height)!))
    let numberToolbar: UIToolbar = UIToolbar()
    var match = Match2()
    var week = Int()
    var tourney = Tourney()
    var weeklyMatches: WeeklyMatches?
    var whichItem = Int()
    var userIsTeam1 = true
    let player = Player()
    var team1 = Team()
    var team2 = Team()
    
    override func loadView() {
        view = matchViewOrganizer
        matchViewOrganizer.getPlayerNames(match: match)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboard()
        setupNavbarTitle()
        watchMatch()
        setupCorrectBottom()
    }
    
    // MARK: - Match Flow
    
    func watchMatch() {
        tourney.watchRobinMatch(week: "week\(week)", matchId: match.matchId!, completion: { (result) in
            guard let activeResult = result else {
                print("failed to get rresult")
                return
            }
            if activeResult != self.match.active {
                if activeResult == 2 {
                    self.tourney.fetchMatch(week: "week\(self.week)", tourneyId: self.tourney.id!, matchId: self.match.matchId!, completion: { (result) in
                        guard let matchResult = result else {
                            print("failed to get rresult")
                            return
                        }
                        self.match = matchResult
                        self.setupActive2Reload()
                    })
                } else if activeResult == 3 {
                    self.setupActive3Reload()
                }
            }
        })
    }
    
    func setupCorrectBottom() {
        styleAndDoublesSetup()
        let currentTime = Date().timeIntervalSince1970
        setupNavbarTitle()
        let idList = [match.team_1_player_1!, match.team_1_player_2!, match.team_2_player_1!, match.team_2_player_2!]
        guard let uid = Auth.auth().currentUser?.uid, let whichPerson = idList.firstIndex(of: uid) else {
            return
        }
        
        if whichPerson == 0 || whichPerson == 1 {
            userIsTeam1 = true
        } else {
            userIsTeam1 = false
        }
        
        let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1084, w: 712, h: 126, wib: 750, hib: 1164, wia: Float(view.frame.width), hia: Float(view.frame.width) / 0.644)
        
        if match.active == 1 {
            matchViewOrganizer.rejectMatchScores.isHidden = true
            matchViewOrganizer.whiteCover.isHidden = true
            matchViewOrganizer.confirmMatchScores.setTitle("Submit Scores to Opponent for Review", for: .normal)
            matchViewOrganizer.confirmMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
            matchViewOrganizer.confirmMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
            matchViewOrganizer.confirmMatchScores.titleLabel?.numberOfLines = 2
            matchViewOrganizer.confirmMatchScoresWidthAnchor?.isActive = false
            matchViewOrganizer.confirmMatchScoresWidthAnchor?.constant = CGFloat(confirmMatchScoresLoc.W)
            matchViewOrganizer.confirmMatchScoresWidthAnchor?.isActive = true
            matchViewOrganizer.confirmMatchScoresCenterXAnchor?.isActive = false
            matchViewOrganizer.confirmMatchScoresCenterXAnchor?.constant = CGFloat(confirmMatchScoresLoc.X)
            matchViewOrganizer.confirmMatchScoresCenterXAnchor?.isActive = true
        } else if match.active == 2 {
            matchViewOrganizer.whiteCover.isHidden = true
            if match.submitter == 1 {
                matchViewOrganizer.confirmCheck1.isHidden = false
                matchViewOrganizer.confirmCheck2.isHidden = match.doubles! ? false : true
            } else {
                matchViewOrganizer.confirmCheck3.isHidden = false
                matchViewOrganizer.confirmCheck4.isHidden = match.doubles! ? false : true
            }
            
            if userIsTeam1 && match.submitter == 1 || userIsTeam1 == false && match.submitter == 2 {
                matchViewOrganizer.rejectMatchScores.isHidden = true
                if ((match.timeOfScores ?? currentTime) + 86400) < currentTime {
                    matchViewOrganizer.matchStatusLabel.isHidden = true
                    matchViewOrganizer.confirmMatchScores.setTitle("24 hours has passed, confirm scores for opponent", for: .normal)
                    matchViewOrganizer.confirmMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
                    matchViewOrganizer.confirmMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
                    matchViewOrganizer.confirmMatchScores.titleLabel?.numberOfLines = 3
                    matchViewOrganizer.confirmMatchScoresWidthAnchor?.isActive = false
                    matchViewOrganizer.confirmMatchScoresWidthAnchor?.constant = CGFloat(confirmMatchScoresLoc.W)
                    matchViewOrganizer.confirmMatchScoresWidthAnchor?.isActive = true
                    matchViewOrganizer.confirmMatchScoresCenterXAnchor?.isActive = false
                    matchViewOrganizer.confirmMatchScoresCenterXAnchor?.constant = CGFloat(confirmMatchScoresLoc.X)
                    matchViewOrganizer.confirmMatchScoresCenterXAnchor?.isActive = true
                } else {
                    matchViewOrganizer.confirmMatchScores.isHidden = true
                    matchViewOrganizer.matchStatusLabel.text = "Waiting for opponent to accept submitted scores"
                    matchViewOrganizer.matchStatusLabel.numberOfLines = 2
                }
                disableScores()
                matchViewOrganizer.updateGameScores(match: match)
            } else {
                matchViewOrganizer.confirmMatchScores.setTitle("Yes these scores are right, finish the match", for: .normal)
                matchViewOrganizer.confirmMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
                matchViewOrganizer.confirmMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
                matchViewOrganizer.confirmMatchScores.titleLabel?.numberOfLines = 3
                matchViewOrganizer.rejectMatchScores.setTitle("No I want to edit the scores", for: .normal)
                matchViewOrganizer.rejectMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
                matchViewOrganizer.rejectMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
                matchViewOrganizer.rejectMatchScores.titleLabel?.numberOfLines = 3
                disableScores()
                matchViewOrganizer.updateGameScores(match: match)
            }
        } else if match.active == 3 {
            matchViewOrganizer.whiteCover.isHidden = true
            matchViewOrganizer.confirmCheck1.isHidden = false
            matchViewOrganizer.confirmCheck2.isHidden = match.doubles! ? false : true
            matchViewOrganizer.confirmCheck3.isHidden = false
            matchViewOrganizer.confirmCheck4.isHidden = match.doubles! ? false : true
            disableScores()
            matchViewOrganizer.updateGameScores(match: match)
            matchViewOrganizer.winnerConfirmed.isHidden = false
            matchViewOrganizer.matchStyleLabel.isHidden = true
            if AccessToken.isCurrentAccessTokenActive {
                matchViewOrganizer.loadImageButton.isHidden = false
                matchViewOrganizer.shareButton.isHidden = false
            } else {
                matchViewOrganizer.cantLoadImageButton.isHidden = false
            }
            matchViewOrganizer.shareFriendsLabel.isHidden = false
            
        }
    }
    
    func styleAndDoublesSetup() {
        let matchInfoDisplayHeightBefore: Float = 1164
        let matchInfoDisplayHeightAfter: Float = Float(view.frame.width) / 0.644
        matchViewOrganizer.game4UserScore.isHidden = true
        matchViewOrganizer.game4OppScore.isHidden = true
        matchViewOrganizer.game5UserScore.isHidden = true
        matchViewOrganizer.game5OppScore.isHidden = true
        matchViewOrganizer.matchStyleLabel.text = "Best 2 out of 3"
        let whiteCoverLoc2 = calculateButtonPosition(x: 375, y: 935, w: 487, h: 150, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(view.frame.width), hia: matchInfoDisplayHeightAfter)
        
        matchViewOrganizer.whiteCover2HeightAnchor?.isActive = false
        matchViewOrganizer.whiteCover2HeightAnchor?.constant = CGFloat(whiteCoverLoc2.H)
        matchViewOrganizer.whiteCover2HeightAnchor?.isActive = true
        matchViewOrganizer.whiteCover2CenterYAnchor?.isActive = false
        matchViewOrganizer.whiteCover2CenterYAnchor?.constant = CGFloat(whiteCoverLoc2.Y)
        matchViewOrganizer.whiteCover2CenterYAnchor?.isActive = true
    }
    
    // MARK: - Active 1
    
    func performConfirmActive1() {
        resigningFirstResponders()
        matchViewOrganizer.fillInGameScores()
        match.team1_scores = [Int(matchViewOrganizer.game1UserScore.text ?? "0")!, Int(matchViewOrganizer.game2UserScore.text ?? "0")!, Int(matchViewOrganizer.game3UserScore.text ?? "0")!, 0, 0]
        match.team2_scores = [Int(matchViewOrganizer.game1OppScore.text ?? "0")!, Int(matchViewOrganizer.game2OppScore.text ?? "0")!, Int(matchViewOrganizer.game3OppScore.text ?? "0")!, 0, 0]
        let scoresValidation = match.checkRobinMatchScores()
        if !scoresValidation {
            let newalert = UIAlertController(title: "Sorry", message: "A team must score at least 11 points to determine the winner of a game", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
        } else {
            let timeOfScores = Date().timeIntervalSince1970
            self.match.active = 2
            let values = ["winner": match.winner!, "active": 2, "submitter": userIsTeam1 ? 1 : 2, "team1_scores": match.team1_scores!, "team2_scores": match.team2_scores!, "team_1TotalScore": match.team_1TotalScore!, "team_2TotalScore": match.team_2TotalScore!, "timeOfScores": timeOfScores] as [String : Any]
            let ref = Database.database().reference().child("tourneys").child(tourney.id!).child("matches").child("week\(week)").child(match.matchId!)
            ref.updateChildValues(values, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if let error = error {
                    print("Data could not be saved: \(error).")
                    return
                }
                
                print("Data saved successfully!")
                self.weeklyMatches?.matches[self.whichItem].active = 2
                self.setupNavbarTitle()
                //self.match.winner = self.winner
                self.weeklyMatches?.matches[self.whichItem].winner = self.match.winner!
                self.match.submitter = self.userIsTeam1 ? 1 : 2
                self.weeklyMatches?.matches[self.whichItem].submitter = self.userIsTeam1 ? 1 : 2
                //self.match.team1_scores = self.finalTeam1Scores
                //self.match.team2_scores = self.finalTeam2Scores
                self.weeklyMatches?.matches[self.whichItem].team1_scores = self.match.team1_scores!
                self.weeklyMatches?.matches[self.whichItem].team2_scores = self.match.team2_scores!
                self.weeklyMatches?.tableView.reloadData()
                if self.match.submitter == 1 {
                    self.matchViewOrganizer.confirmCheck1.isHidden = false
                    self.matchViewOrganizer.confirmCheck2.isHidden = self.match.doubles! ? false : true
                } else {
                    self.matchViewOrganizer.confirmCheck3.isHidden = false
                    self.matchViewOrganizer.confirmCheck4.isHidden = self.match.doubles! ? false : true
                }
                guard let uid = Auth.auth().currentUser?.uid else {
                    return
                }
                self.match.sendTourneyNotifications(uid: uid, tourneyId: self.tourney.id!, tourneyYetToViewMatch: self.tourney.yetToView!)
                
                self.match.sendMatchPushNotifications(uid: uid, userPlayer1: self.matchViewOrganizer.userPlayer1.titleLabel?.text ?? "none", userPlayer2: self.matchViewOrganizer.userPlayer2.titleLabel?.text ?? "none", oppPlayer1: self.matchViewOrganizer.oppPlayer1.titleLabel?.text ?? "none", oppPlayer2: self.matchViewOrganizer.oppPlayer2.titleLabel?.text ?? "none", message: "submitted the scores for the match, now you need to confirm them", title: "Match Scores Entered")
                
                
            })
            
            let newalert = UIAlertController(title: "Match Scores Confirmed", message: "Now just wait for opponent to confirm", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: resetupviews))
            self.present(newalert, animated: true, completion: nil)
            matchViewOrganizer.confirmMatchScores.isHidden = true
            matchViewOrganizer.matchStatusLabel.text = "Waiting for opponent to accept submitted scores"
            matchViewOrganizer.matchStatusLabel.numberOfLines = 2
            matchViewOrganizer.matchStatusLabel.isHidden = false
        }
    }
    
    // MARK: - Active 2
    
    func performConfirmActive2() {
        self.match.active = 3
        let time = Date().timeIntervalSince1970
        let values = ["active": 3, "time": time] as [String : Any]
        let ref = Database.database().reference().child("tourneys").child(tourney.id!).child("matches").child("week\(week)").child(match.matchId!)
        ref.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            
            print("Data saved successfully!")
            self.weeklyMatches?.matches[self.whichItem].active = 3
            self.weeklyMatches?.tableView.reloadData()
            self.setupNavbarTitle()
            self.matchViewOrganizer.confirmCheck1.isHidden = false
            self.matchViewOrganizer.confirmCheck2.isHidden = self.match.doubles! ? false : true
            self.matchViewOrganizer.confirmCheck3.isHidden = false
            self.matchViewOrganizer.confirmCheck4.isHidden = self.match.doubles! ? false : true
            self.matchViewOrganizer.matchStyleLabel.isHidden = true
            if AccessToken.isCurrentAccessTokenActive {
                self.matchViewOrganizer.loadImageButton.isHidden = false
                self.matchViewOrganizer.shareButton.isHidden = false
            } else {
                self.matchViewOrganizer.cantLoadImageButton.isHidden = false
            }
            self.matchViewOrganizer.shareFriendsLabel.isHidden = false
            self.updatePlayerStats()
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            self.match.sendTourneyNotifications(uid: uid, tourneyId: self.tourney.id!, tourneyYetToViewMatch: self.tourney.yetToView!)
            self.team1.updateTeamRobinWins(tourneyId: self.tourney.id!, winner: self.match.winner == 1 ? true : false, pointsGained: self.match.team_1TotalScore!)
            self.team2.updateTeamRobinWins(tourneyId: self.tourney.id!, winner: self.match.winner == 1 ? false : true, pointsGained: self.match.team_2TotalScore!)
            self.match.sendMatchPushNotifications(uid: uid, userPlayer1: self.matchViewOrganizer.userPlayer1.titleLabel?.text ?? "none", userPlayer2: self.matchViewOrganizer.userPlayer2.titleLabel?.text ?? "none", oppPlayer1: self.matchViewOrganizer.oppPlayer1.titleLabel?.text ?? "none", oppPlayer2: self.matchViewOrganizer.oppPlayer2.titleLabel?.text ?? "none", message: "confirmed the match scores", title: "Match Scores Confirmed")
            
            
        })
        matchViewOrganizer.confirmMatchScores.isHidden = true
        matchViewOrganizer.rejectMatchScores.isHidden = true
        matchViewOrganizer.winnerConfirmed.isHidden = false
        if match.doubles == true {
            let newalert = UIAlertController(title: "Match Complete", message: self.match.winner == 1 ? "\(matchViewOrganizer.userPlayer1.titleLabel?.text ?? "none") and \(matchViewOrganizer.userPlayer2.titleLabel?.text ?? "none") win!" : "\(matchViewOrganizer.oppPlayer1.titleLabel?.text ?? "none") and \(matchViewOrganizer.oppPlayer2.titleLabel?.text ?? "none") win!", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: resetupviews))
            self.present(newalert, animated: true, completion: nil)
            matchViewOrganizer.winnerConfirmed.text = match.winner == 1 ? "\(matchViewOrganizer.userPlayer1.titleLabel?.text ?? "none") & \(matchViewOrganizer.userPlayer2.titleLabel?.text ?? "none") win!" : "\(matchViewOrganizer.oppPlayer1.titleLabel?.text ?? "none") & \(matchViewOrganizer.oppPlayer2.titleLabel?.text ?? "none") win!"
        } else {
            let newalert = UIAlertController(title: "Match Complete", message: self.match.winner == 1 ? "\(matchViewOrganizer.userPlayer1.titleLabel?.text ?? "none") wins!" : "\(matchViewOrganizer.oppPlayer1.titleLabel?.text ?? "none") wins!", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: resetupviews))
            self.present(newalert, animated: true, completion: nil)
            matchViewOrganizer.winnerConfirmed.text = match.winner == 1 ? "\(matchViewOrganizer.userPlayer1.titleLabel?.text ?? "none") wins!" : "\(matchViewOrganizer.oppPlayer1.titleLabel?.text ?? "none") wins!"
        }
        matchViewOrganizer.winnerConfirmed.numberOfLines = 2
    }
    
    func setupActive2Reload() {
        let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1084, w: 712, h: 126, wib: 750, hib: 1164, wia: Float(view.frame.width), hia: Float(view.frame.width) / 0.644)
        self.weeklyMatches?.matches[self.whichItem] = match
        self.setupNavbarTitle()
        self.weeklyMatches?.tableView.reloadData()
        if match.submitter == 1 {
            matchViewOrganizer.confirmCheck1.isHidden = false
            matchViewOrganizer.confirmCheck2.isHidden = match.doubles! ? false : true
            matchViewOrganizer.confirmCheck3.isHidden = true
            matchViewOrganizer.confirmCheck4.isHidden = true
        } else {
            matchViewOrganizer.confirmCheck3.isHidden = false
            matchViewOrganizer.confirmCheck4.isHidden = match.doubles! ? false : true
            matchViewOrganizer.confirmCheck1.isHidden = true
            matchViewOrganizer.confirmCheck2.isHidden = true
        }
        if userIsTeam1 && self.match.submitter! == 1 || userIsTeam1 == false && self.match.submitter! == 2 {
            matchViewOrganizer.confirmMatchScores.isHidden = true
            matchViewOrganizer.rejectMatchScores.isHidden = true
            matchViewOrganizer.matchStatusLabel.isHidden = false
            matchViewOrganizer.matchStatusLabel.text = "Waiting for opponent to accept submitted scores"
            matchViewOrganizer.matchStatusLabel.numberOfLines = 2
        } else {
            matchViewOrganizer.confirmMatchScoresWidthAnchor?.isActive = false
            matchViewOrganizer.confirmMatchScoresWidthAnchor?.constant = CGFloat(confirmMatchScoresLoc.W / 2)
            matchViewOrganizer.confirmMatchScoresWidthAnchor?.isActive = true
            matchViewOrganizer.confirmMatchScoresCenterXAnchor?.isActive = false
            matchViewOrganizer.confirmMatchScoresCenterXAnchor?.constant = CGFloat(confirmMatchScoresLoc.X + (confirmMatchScoresLoc.W / 4))
            matchViewOrganizer.confirmMatchScoresCenterXAnchor?.isActive = true
            matchViewOrganizer.rejectMatchScores.isHidden = false
            matchViewOrganizer.rejectMatchScoresWidthAnchor?.isActive = false
            matchViewOrganizer.rejectMatchScoresWidthAnchor?.constant = CGFloat(confirmMatchScoresLoc.W / 2)
            matchViewOrganizer.rejectMatchScoresWidthAnchor?.isActive = true
            matchViewOrganizer.rejectMatchScoresCenterXAnchor?.isActive = false
            matchViewOrganizer.rejectMatchScoresCenterXAnchor?.constant = CGFloat(confirmMatchScoresLoc.X - (confirmMatchScoresLoc.W / 4))
            matchViewOrganizer.rejectMatchScoresCenterXAnchor?.isActive = true
            matchViewOrganizer.confirmMatchScores.setTitle("Yes these scores are right, finish the match", for: .normal)
            matchViewOrganizer.confirmMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            matchViewOrganizer.confirmMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
            matchViewOrganizer.confirmMatchScores.titleLabel?.numberOfLines = 3
            matchViewOrganizer.rejectMatchScores.setTitle("No I want to edit the scores", for: .normal)
            matchViewOrganizer.rejectMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            matchViewOrganizer.rejectMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
            matchViewOrganizer.rejectMatchScores.titleLabel?.numberOfLines = 3
        }
        matchViewOrganizer.updateGameScores(match: match)
        disableScores()
    }
    
    // MARK: - Active 3
    
    func setupActive3Reload() {
        match.active = 3
        weeklyMatches?.matches[self.whichItem].active = 3
        weeklyMatches?.tableView.reloadData()
        setupNavbarTitle()
        matchViewOrganizer.confirmCheck1.isHidden = false
        matchViewOrganizer.confirmCheck2.isHidden = self.match.doubles! ? false : true
        matchViewOrganizer.confirmCheck3.isHidden = false
        matchViewOrganizer.confirmCheck4.isHidden = self.match.doubles! ? false : true
        matchViewOrganizer.matchStyleLabel.isHidden = true
        if AccessToken.isCurrentAccessTokenActive {
            matchViewOrganizer.loadImageButton.isHidden = false
            matchViewOrganizer.shareButton.isHidden = false
        } else {
            matchViewOrganizer.cantLoadImageButton.isHidden = false
        }
        matchViewOrganizer.shareFriendsLabel.isHidden = false
        matchViewOrganizer.confirmMatchScores.isHidden = true
        matchViewOrganizer.rejectMatchScores.isHidden = true
        matchViewOrganizer.matchStatusLabel.isHidden = true
        matchViewOrganizer.winnerConfirmed.isHidden = false
        matchViewOrganizer.winnerConfirmed.numberOfLines = 2
        if match.doubles == true {
            var userPlayer2Text = String()
            userPlayer2Text = match.team_1_player_2 == "Guest" ? "Guest" : matchViewOrganizer.userPlayer2.titleLabel?.text ?? "none"
            var oppPlayer2Text = String()
            oppPlayer2Text = match.team_2_player_2 == "Guest" ? "Guest" : matchViewOrganizer.oppPlayer2.titleLabel?.text ?? "none"
            matchViewOrganizer.winnerConfirmed.text = match.winner == 1 ? "\(matchViewOrganizer.userPlayer1.titleLabel?.text ?? "none") & \(userPlayer2Text) win!" : "\(matchViewOrganizer.oppPlayer1.titleLabel?.text ?? "none") & \(oppPlayer2Text) win!"
        } else {
            matchViewOrganizer.winnerConfirmed.text = match.winner == 1 ? "\(matchViewOrganizer.userPlayer1.titleLabel?.text ?? "none") wins!" : "\(matchViewOrganizer.oppPlayer1.titleLabel?.text ?? "none") wins!"
        }
    }
    
    // MARK: - Targets
    
    @objc func handleViewPlayer(sender: UIButton) {
        let whichOne = sender.tag
        let playerProfile = StartupPage()
        playerProfile.hidesBottomBarWhenPushed = true
        switch whichOne {
        case 0:
            playerProfile.playerId = match.team_1_player_1!
        case 1:
            playerProfile.playerId = match.team_1_player_2!
        case 2:
            playerProfile.playerId = match.team_2_player_1!
        case 3:
            playerProfile.playerId = match.team_2_player_2!
        default:
            return
        }
        playerProfile.isFriend = 3
        navigationController?.pushViewController(playerProfile, animated: true)
    }
    
    func setupNavbarTitle() {
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        switch match.active {
        case 0:
            titleLabel.text = "Pre-Match Confirmation"
        case 1:
            titleLabel.text = "Enter Scores"
        case 2:
            titleLabel.text = "Confirm Scores"
        case 3:
            titleLabel.text = "Match Complete"
        default:
            print("failed title")
        }
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.navigationItem.titleView = titleLabel
    }
    
    override func willMove(toParent parent: UIViewController?) {
        print("Moving")
        if parent == nil {
            let matchReference = Database.database().reference().child("tourneys").child(tourney.id!).child("matches").child("week\(week)").child(match.matchId!).child("active")
            matchReference.removeAllObservers()
        }
    }
    
    @objc func handleConfirm(sender: UIButton) {
        resigningFirstResponders()
        if match.active == 1 {
            print("confirming scores")
            performConfirmActive1()
        } else if match.active == 2 {
            performConfirmActive2()
        }
    }
    
    @objc func handleReject(sender: UIButton) {
        resigningFirstResponders()
        matchViewOrganizer.rejectMatchScores.isHidden = true
        self.match.active = 1
        weeklyMatches?.matches[whichItem].active = 1
        setupNavbarTitle()
        matchViewOrganizer.confirmCheck1.isHidden = true
        matchViewOrganizer.confirmCheck2.isHidden = true
        matchViewOrganizer.confirmCheck3.isHidden = true
        matchViewOrganizer.confirmCheck4.isHidden = true
        let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1084, w: 712, h: 126, wib: 750, hib: 1164, wia: Float(view.frame.width), hia: Float(view.frame.width) / 0.644)
        matchViewOrganizer.confirmMatchScores.setTitle("Submit Scores to Opponent for Review", for: .normal)
        matchViewOrganizer.confirmMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        matchViewOrganizer.confirmMatchScores.titleLabel?.numberOfLines = 2
        matchViewOrganizer.confirmMatchScoresWidthAnchor?.isActive = false
        matchViewOrganizer.confirmMatchScoresWidthAnchor?.constant = CGFloat(confirmMatchScoresLoc.W)
        matchViewOrganizer.confirmMatchScoresWidthAnchor?.isActive = true
        matchViewOrganizer.confirmMatchScoresCenterXAnchor?.isActive = false
        matchViewOrganizer.confirmMatchScoresCenterXAnchor?.constant = CGFloat(confirmMatchScoresLoc.X)
        matchViewOrganizer.confirmMatchScoresCenterXAnchor?.isActive = true
        clearAndActivateScores()
    }
    
    func clearAndActivateScores() {
        matchViewOrganizer.game1UserScore.isUserInteractionEnabled = true
        matchViewOrganizer.game2UserScore.isUserInteractionEnabled = true
        matchViewOrganizer.game3UserScore.isUserInteractionEnabled = true
        matchViewOrganizer.game4UserScore.isUserInteractionEnabled = true
        matchViewOrganizer.game5UserScore.isUserInteractionEnabled = true
        matchViewOrganizer.game1OppScore.isUserInteractionEnabled = true
        matchViewOrganizer.game2OppScore.isUserInteractionEnabled = true
        matchViewOrganizer.game3OppScore.isUserInteractionEnabled = true
        matchViewOrganizer.game4OppScore.isUserInteractionEnabled = true
        matchViewOrganizer.game5OppScore.isUserInteractionEnabled = true
        
        matchViewOrganizer.game1UserScore.text = ""
        matchViewOrganizer.game2UserScore.text = ""
        matchViewOrganizer.game3UserScore.text = ""
        matchViewOrganizer.game4UserScore.text = ""
        matchViewOrganizer.game5UserScore.text = ""
        matchViewOrganizer.game1OppScore.text = ""
        matchViewOrganizer.game2OppScore.text = ""
        matchViewOrganizer.game3OppScore.text = ""
        matchViewOrganizer.game4OppScore.text = ""
        matchViewOrganizer.game5OppScore.text = ""
    }
    
    @objc func resetupviews(action: UIAlertAction) {
        if match.active != 3 {
            disableScores()
        }
    }
    
    func disableScores() {
        matchViewOrganizer.game1UserScore.isUserInteractionEnabled = false
        matchViewOrganizer.game2UserScore.isUserInteractionEnabled = false
        matchViewOrganizer.game3UserScore.isUserInteractionEnabled = false
        matchViewOrganizer.game4UserScore.isUserInteractionEnabled = false
        matchViewOrganizer.game5UserScore.isUserInteractionEnabled = false
        matchViewOrganizer.game1OppScore.isUserInteractionEnabled = false
        matchViewOrganizer.game2OppScore.isUserInteractionEnabled = false
        matchViewOrganizer.game3OppScore.isUserInteractionEnabled = false
        matchViewOrganizer.game4OppScore.isUserInteractionEnabled = false
        matchViewOrganizer.game5OppScore.isUserInteractionEnabled = false
    }

    // MARK: - Match Finish Functions
    
    func updatePlayerStats() {
        let results = match.updateExperience(playerExps: [matchViewOrganizer.team1_P1_Exp, matchViewOrganizer.team1_P2_Exp, matchViewOrganizer.team2_P1_Exp, matchViewOrganizer.team2_P2_Exp], playerLevs: [matchViewOrganizer.team1_P1_Lev, matchViewOrganizer.team1_P2_Lev, matchViewOrganizer.team2_P1_Lev, matchViewOrganizer.team2_P2_Lev])
        levelUpDisplay(previousLev: [matchViewOrganizer.team1_P1_Lev, matchViewOrganizer.team1_P2_Lev, matchViewOrganizer.team2_P1_Lev, matchViewOrganizer.team2_P2_Lev], newExp: results, players: [match.team_1_player_1!, match.team_1_player_2!, match.team_2_player_1!, match.team_2_player_2!])
        player.updatePlayerStats(playerId: match.team_1_player_2!, winner: match.winner!, userIsTeam1: true)
        player.updatePlayerStats(playerId: match.team_2_player_2!, winner: match.winner!, userIsTeam1: false)
        player.updatePlayerStats(playerId: match.team_1_player_1!, winner: match.winner!, userIsTeam1: true)
        player.updatePlayerStats(playerId: match.team_2_player_1!, winner: match.winner!, userIsTeam1: false)
    }
    
    func levelUpDisplay(previousLev: [Int], newExp: [Int], players: [String]) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        for (index, element) in players.enumerated() {
            let newLevel = player.haloLevel(exp: newExp[index])
            
            if (newLevel - previousLev[index]) > 0 {
                uid == element ? matchViewOrganizer.openMenu(newExp: newExp[index], newLevel: newLevel, oldLevel: previousLev[index]) : uploadLevelUp(oldLevel: previousLev[index], player: element)
            }
        }
    }
    
    
    func uploadLevelUp(oldLevel: Int, player: String) {
        Database.database().reference().child("users").child(player).child("oldLevel").setValue(oldLevel)
    }
    
    func checkUser(player1: String, player2: String, player3: String, player4: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        if uid == player1 || uid == player2 {
            matchViewOrganizer.backgroundImage.image = UIImage(named: "match_info_display2.01")
        } else if uid == player3 || uid == player4 {
            matchViewOrganizer.backgroundImage.image = UIImage(named: "match_info_display2.02")
        } else {
            matchViewOrganizer.backgroundImage.image = UIImage(named: "match_info_display2.0")
        }
    }
    
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
    }
    
}

// MARK: - Keyboard
extension RoundRobinMatch {
    func setupKeyboard() {
        setupKeyboardObservers()
        numberToolbar.items=[
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(MatchView.hoopla)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Apply", style: UIBarButtonItem.Style.plain, target: self, action: #selector(MatchView.boopla))
        ]
        numberToolbar.sizeToFit()
        matchViewOrganizer.game1UserScore.inputAccessoryView = numberToolbar
        matchViewOrganizer.game2UserScore.inputAccessoryView = numberToolbar
        matchViewOrganizer.game3UserScore.inputAccessoryView = numberToolbar
        matchViewOrganizer.game4UserScore.inputAccessoryView = numberToolbar
        matchViewOrganizer.game5UserScore.inputAccessoryView = numberToolbar
        matchViewOrganizer.game1OppScore.inputAccessoryView = numberToolbar
        matchViewOrganizer.game2OppScore.inputAccessoryView = numberToolbar
        matchViewOrganizer.game3OppScore.inputAccessoryView = numberToolbar
        matchViewOrganizer.game4OppScore.inputAccessoryView = numberToolbar
        matchViewOrganizer.game5OppScore.inputAccessoryView = numberToolbar
        matchViewOrganizer.userPlayer1.addTarget(self, action: #selector(handleViewPlayer), for: .touchUpInside)
        matchViewOrganizer.userPlayer2.addTarget(self, action: #selector(handleViewPlayer), for: .touchUpInside)
        matchViewOrganizer.oppPlayer1.addTarget(self, action: #selector(handleViewPlayer), for: .touchUpInside)
        matchViewOrganizer.oppPlayer2.addTarget(self, action: #selector(handleViewPlayer), for: .touchUpInside)
        matchViewOrganizer.confirmMatchScores.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        matchViewOrganizer.rejectMatchScores.addTarget(self, action: #selector(handleReject), for: .touchUpInside)
    }
    
    @objc func boopla () {
        resigningFirstResponders()
    }
    
    @objc func hoopla () {
        matchViewOrganizer.game1UserScore.text = ""
        matchViewOrganizer.game2UserScore.text = ""
        matchViewOrganizer.game3UserScore.text = ""
        matchViewOrganizer.game4UserScore.text = ""
        matchViewOrganizer.game5UserScore.text = ""
        matchViewOrganizer.game1OppScore.text = ""
        matchViewOrganizer.game2OppScore.text = ""
        matchViewOrganizer.game3OppScore.text = ""
        matchViewOrganizer.game4OppScore.text = ""
        matchViewOrganizer.game5OppScore.text = ""
        resigningFirstResponders()
    }
    
    func resigningFirstResponders() {
        matchViewOrganizer.game1UserScore.resignFirstResponder()
        matchViewOrganizer.game2UserScore.resignFirstResponder()
        matchViewOrganizer.game3UserScore.resignFirstResponder()
        matchViewOrganizer.game4UserScore.resignFirstResponder()
        matchViewOrganizer.game5UserScore.resignFirstResponder()
        matchViewOrganizer.game1OppScore.resignFirstResponder()
        matchViewOrganizer.game2OppScore.resignFirstResponder()
        matchViewOrganizer.game3OppScore.resignFirstResponder()
        matchViewOrganizer.game4OppScore.resignFirstResponder()
        matchViewOrganizer.game5OppScore.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resigningFirstResponders()
        self.view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        let height =  (keyboardFrame?.height)! - 30
        matchViewOrganizer.backgroundImageCenterYAnchor?.constant = -height
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        matchViewOrganizer.backgroundImageCenterYAnchor?.constant = 0
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
}
