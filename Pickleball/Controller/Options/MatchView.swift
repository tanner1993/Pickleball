//
//  MatchView.swift
//  Pickleball
//
//  Created by Tanner Rozier on 3/4/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import Charts

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
    let numberToolbar: UIToolbar = UIToolbar()
    var whichItem = Int()
    var matchFeed: MatchFeed?
    var tourneyName = String()
    let tourneyFun = Tourney()
    let blackView = UIView()
    let matchViewOrganizer = MatchViewOrganizer(frame: CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.width)!, height: (UIApplication.shared.keyWindow?.frame.height)!))
    
    override func loadView() {
        view = matchViewOrganizer
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if tourneyId != "none" {
            fetchMatch()
        } else {
            furtherSetup()
        }
        setupKeyboardObservers()
        numberToolbar.items=[
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(MatchView.hoopla)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Apply", style: UIBarButtonItem.Style.plain, target: self, action: #selector(MatchView.boopla))
        ]
        //numberToolbar.barStyle = .black
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
        matchViewOrganizer.confirmMatchScores.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        matchViewOrganizer.rejectMatchScores.addTarget(self, action: #selector(handleReject), for: .touchUpInside)
        styleAndDoublesSetup()
    }
    
    func furtherSetup() {
        let idList = [match.team_1_player_1!, match.team_1_player_2!, match.team_2_player_1!, match.team_2_player_2!]
        self.checkUser(player1: match.team_1_player_1!, player2: match.team_1_player_2!, player3: match.team_2_player_1!, player4: match.team_2_player_2!)
        self.getPlayerNames(idList: idList)
        self.setupCorrectBottom(active: match.active!, submitter: match.submitter!, confirmers: match.team1_scores!, team2: match.team2_scores!, idList: idList, startTime: match.time!, forfeit: match.forfeit!)
    }
    
    func styleAndDoublesSetup() {
        let matchInfoDisplayHeightBefore: Float = 1164
        let matchInfoDisplayHeightAfter: Float = Float(view.frame.width) / 0.644
        if match.style == 0 {
            matchViewOrganizer.matchStyleLabel.text = "Single Match"
            matchViewOrganizer.game2UserScore.isHidden = true
            matchViewOrganizer.game2OppScore.isHidden = true
            matchViewOrganizer.game3UserScore.isHidden = true
            matchViewOrganizer.game3OppScore.isHidden = true
            matchViewOrganizer.game4UserScore.isHidden = true
            matchViewOrganizer.game4OppScore.isHidden = true
            matchViewOrganizer.game5UserScore.isHidden = true
            matchViewOrganizer.game5OppScore.isHidden = true
        } else if match.style == 1 {
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
        } else {
            matchViewOrganizer.matchStyleLabel.text = "Best 3 out of 5"
            matchViewOrganizer.whiteCover2.isHidden = true
        }
        
        if match.doubles! {
            
        } else {
            matchViewOrganizer.userPlayer2.isHidden = true
            matchViewOrganizer.userPlayer2Level.isHidden = true
            matchViewOrganizer.userPlayer2Skill.isHidden = true
            matchViewOrganizer.confirmCheck2.isHidden = true
            matchViewOrganizer.oppPlayer2.isHidden = true
            matchViewOrganizer.oppPlayer2Level.isHidden = true
            matchViewOrganizer.oppPlayer2Skill.isHidden = true
            matchViewOrganizer.confirmCheck4.isHidden = true
            let userPlayer1Loc = calculateButtonPosition(x: 211.5, y: 120, w: 327, h: 160, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(view.frame.width), hia: matchInfoDisplayHeightAfter)
            let oppPlayer1Loc = calculateButtonPosition(x: 211.5, y: 426, w: 327, h: 160, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(view.frame.width), hia: matchInfoDisplayHeightAfter)
            matchViewOrganizer.userPlayer1CenterYAnchor?.isActive = false
            matchViewOrganizer.userPlayer1CenterYAnchor?.constant = CGFloat(userPlayer1Loc.Y)
            matchViewOrganizer.userPlayer1CenterYAnchor?.isActive = true
            matchViewOrganizer.oppPlayer1CenterYAnchor?.isActive = false
            matchViewOrganizer.oppPlayer1CenterYAnchor?.constant = CGFloat(oppPlayer1Loc.Y)
            matchViewOrganizer.oppPlayer1CenterYAnchor?.isActive = true
            matchViewOrganizer.confirmCheck1CenterYAnchor?.isActive = false
            matchViewOrganizer.confirmCheck1CenterYAnchor?.constant = CGFloat(userPlayer1Loc.Y)
            matchViewOrganizer.confirmCheck1CenterYAnchor?.isActive = true
            matchViewOrganizer.confirmCheck3CenterYAnchor?.isActive = false
            matchViewOrganizer.confirmCheck3CenterYAnchor?.constant = CGFloat(oppPlayer1Loc.Y)
            matchViewOrganizer.confirmCheck3CenterYAnchor?.isActive = true
        }
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
    
    func setupNavbarTitle(status: Int) {
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        switch status {
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
    
    func fetchMatch() {
        tourneyFun.fetchMatch(tourneyId: tourneyId, matchId: matchId, completion: { (result) in
            guard let matchResult = result else {
                print("failed to get rresult")
                return
            }
            self.match = matchResult
            let idList = [matchResult.team_1_player_1!, matchResult.team_1_player_2!, matchResult.team_2_player_1!, matchResult.team_2_player_2!]
            self.checkUser(player1: matchResult.team_1_player_1!, player2: matchResult.team_1_player_2!, player3: matchResult.team_2_player_1!, player4: matchResult.team_2_player_2!)
            self.getPlayerNames(idList: idList)
            self.setupCorrectBottom(active: matchResult.active!, submitter: matchResult.submitter!, confirmers: matchResult.team1_scores!, team2: matchResult.team2_scores!, idList: idList, startTime: matchResult.time!, forfeit: matchResult.forfeit!)
        })
    }
    
    @objc func handleTimeExpired(action: UIAlertAction) {
        Database.database().reference().child("tourneys").child(tourneyId).child("matches").child(matchId).removeValue()
        removeCantChallenge()
    }
    
    @objc func handleConfirm(sender: UIButton) {
        resigningFirstResponders()
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
        } else {
            performRejectActive0Tourney()
        }
    }
    
    @objc func handleReject(sender: UIButton) {
        resigningFirstResponders()
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
            matchViewOrganizer.rejectMatchScores.isHidden = true
            self.match.active = 1
            matchFeed?.matches[whichItem].active = 1
            setupNavbarTitle(status: 1)
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
        
        let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1084, w: 712, h: 126, wib: 750, hib: 1164, wia: Float(view.frame.width), hia: Float(view.frame.width) / 0.644)
        
        if active == 0 {
            view.bringSubviewToFront(matchViewOrganizer.whiteCover)
            matchViewOrganizer.confirmCheck1.isHidden = false
            if confirmers[1] == 1 {
                matchViewOrganizer.confirmCheck2.isHidden = false
            }
            if confirmers[2] == 1 {
                self.matchViewOrganizer.confirmCheck3.isHidden = false
            }
            if confirmers[3] == 1 {
                self.matchViewOrganizer.confirmCheck4.isHidden = false
            }
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
        let currentTime = Date().timeIntervalSince1970
        if active == 0 && confirmers[whichPerson] == 1 && tourneyId != "none" && (startTime + 86400) < currentTime {
            matchViewOrganizer.confirmMatchScores.isHidden = true
            matchViewOrganizer.rejectMatchScores.tag = whichPerson
            matchViewOrganizer.rejectMatchScores.setTitle("Submit a forfeit for the opposing team as it's been over 24 hours", for: .normal)
            matchViewOrganizer.rejectMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
            matchViewOrganizer.rejectMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
            matchViewOrganizer.rejectMatchScores.titleLabel?.numberOfLines = 2
            matchViewOrganizer.rejectMatchScoresWidthAnchor?.isActive = false
            matchViewOrganizer.rejectMatchScoresWidthAnchor?.constant = CGFloat(confirmMatchScoresLoc.W)
            matchViewOrganizer.rejectMatchScoresWidthAnchor?.isActive = true
            matchViewOrganizer.rejectMatchScoresCenterXAnchor?.isActive = false
            matchViewOrganizer.rejectMatchScoresCenterXAnchor?.constant = CGFloat(confirmMatchScoresLoc.X)
            matchViewOrganizer.rejectMatchScoresCenterXAnchor?.isActive = true
        } else if active == 0 && confirmers[whichPerson] == 0 {
            matchViewOrganizer.confirmMatchScores.tag = whichPerson
            matchViewOrganizer.confirmMatchScores.setTitle("Yes I want to play in this match", for: .normal)
            matchViewOrganizer.confirmMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            matchViewOrganizer.confirmMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
            matchViewOrganizer.confirmMatchScores.titleLabel?.numberOfLines = 2
            matchViewOrganizer.rejectMatchScores.tag = whichPerson
            matchViewOrganizer.rejectMatchScores.setTitle("No I don't want to play", for: .normal)
            matchViewOrganizer.rejectMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            matchViewOrganizer.rejectMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
            matchViewOrganizer.rejectMatchScores.titleLabel?.numberOfLines = 2
        } else if active == 0 && confirmers[whichPerson] == 1 {
            matchViewOrganizer.confirmMatchScores.isHidden = true
            matchViewOrganizer.rejectMatchScores.isHidden = true
            matchViewOrganizer.matchStatusLabel.isHidden = false
            matchViewOrganizer.matchStatusLabel.text = "Waiting for opponents to confirm match"
            matchViewOrganizer.matchStatusLabel.numberOfLines = 2
        } else if active == 1 && (startTime + (86400 * 3)) < currentTime && tourneyId != "none" {
            let matchdeleted = UIAlertController(title: "Sorry", message: "It's been 3 days and you failed to play in the time limit, the match will be deleted and you will be free to challenge someone else", preferredStyle: .alert)
            matchdeleted.addAction(UIAlertAction(title: "Ok", style: .default, handler: self.handleTimeExpired))
            self.present(matchdeleted, animated: true, completion: nil)
        } else if active == 1 {
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
        } else if active == 2 {
            matchViewOrganizer.whiteCover.isHidden = true
            if submitter == 1 {
                matchViewOrganizer.confirmCheck1.isHidden = false
                matchViewOrganizer.confirmCheck2.isHidden = match.doubles! ? false : true
            } else {
                matchViewOrganizer.confirmCheck3.isHidden = false
                matchViewOrganizer.confirmCheck4.isHidden = match.doubles! ? false : true
            }
            
            if userIsTeam1 && submitter == 1 || userIsTeam1 == false && submitter == 2 {
                matchViewOrganizer.confirmMatchScores.isHidden = true
                matchViewOrganizer.rejectMatchScores.isHidden = true
                matchViewOrganizer.matchStatusLabel.text = "Waiting for opponent to accept submitted scores"
                matchViewOrganizer.matchStatusLabel.numberOfLines = 2
                disableScores(team1Scores: confirmers, team2Scores: team2)
            } else {
                matchViewOrganizer.confirmMatchScores.setTitle("Yes these scores are right, finish the match", for: .normal)
                matchViewOrganizer.confirmMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
                matchViewOrganizer.confirmMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
                matchViewOrganizer.confirmMatchScores.titleLabel?.numberOfLines = 3
                matchViewOrganizer.rejectMatchScores.setTitle("No I want to edit the scores", for: .normal)
                matchViewOrganizer.rejectMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
                matchViewOrganizer.rejectMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
                matchViewOrganizer.rejectMatchScores.titleLabel?.numberOfLines = 3
                disableScores(team1Scores: confirmers, team2Scores: team2)
            }
        } else if active == 3 {
            if forfeit == 1 {
                matchViewOrganizer.whiteCover.isHidden = false
                disableScores(team1Scores: confirmers, team2Scores: team2)
                matchViewOrganizer.confirmCheck1.isHidden = false
                matchViewOrganizer.confirmCheck2.isHidden = match.doubles! ? false : true
                matchViewOrganizer.confirmCheck3.isHidden = false
                matchViewOrganizer.confirmCheck4.isHidden = match.doubles! ? false : true
                matchViewOrganizer.forfeitLabel.isHidden = false
            } else {
                matchViewOrganizer.whiteCover.isHidden = true
                matchViewOrganizer.confirmCheck1.isHidden = false
                matchViewOrganizer.confirmCheck2.isHidden = match.doubles! ? false : true
                matchViewOrganizer.confirmCheck3.isHidden = false
                matchViewOrganizer.confirmCheck4.isHidden = match.doubles! ? false : true
                disableScores(team1Scores: confirmers, team2Scores: team2)
                matchViewOrganizer.winnerConfirmed.isHidden = false
            }
        }
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
    
    func getPlayerNames(idList: [String]) {
        
        player.getPlayerNameAndSkill(playerId: idList[0], completion: { (result) in
            guard let playerResult = result else {
                print("failed to get result")
                return
            }
            self.matchViewOrganizer.userPlayer1.text = playerResult.name!
            self.matchViewOrganizer.userPlayer1Skill.text = "\(playerResult.skill_level!)"
            self.matchViewOrganizer.userPlayer1Level.text = "\(playerResult.halo_level!)"
            self.team1_P1_Exp = playerResult.exp!
            self.team1_P1_Lev = playerResult.halo_level!
            if self.match.active == 3 && self.match.winner == 1 {
                if self.matchViewOrganizer.winnerConfirmed.text!.count > 5 {
                    self.matchViewOrganizer.winnerConfirmed.text = playerResult.name! + " and " + self.matchViewOrganizer.winnerConfirmed.text!
                } else {
                    self.matchViewOrganizer.winnerConfirmed.text = playerResult.name! + self.matchViewOrganizer.winnerConfirmed.text!
                }
            }
        })
        
        player.getPlayerNameAndSkill(playerId: idList[2], completion: { (result) in
            guard let playerResult = result else {
                print("failed to get result")
                return
            }
            self.matchViewOrganizer.oppPlayer1.text = playerResult.name!
            self.matchViewOrganizer.oppPlayer1Skill.text = "\(playerResult.skill_level!)"
            self.matchViewOrganizer.oppPlayer1Level.text = "\(playerResult.halo_level!)"
            self.team2_P1_Exp = playerResult.exp!
            self.team2_P1_Lev = playerResult.halo_level!
            if self.match.active == 3 && self.match.winner == 2 {
                if self.matchViewOrganizer.winnerConfirmed.text!.count > 5 {
                    self.matchViewOrganizer.winnerConfirmed.text = playerResult.name! + " and " + self.matchViewOrganizer.winnerConfirmed.text!
                } else {
                    self.matchViewOrganizer.winnerConfirmed.text = playerResult.name! + self.matchViewOrganizer.winnerConfirmed.text!
                }
            }
        })
        
        if match.doubles! {
            player.getPlayerNameAndSkill(playerId: idList[1], completion: { (result) in
                guard let playerResult = result else {
                    print("failed to get result")
                    return
                }
                self.matchViewOrganizer.userPlayer2.text = playerResult.name!
                self.matchViewOrganizer.userPlayer2Skill.text = "\(playerResult.skill_level!)"
                self.matchViewOrganizer.userPlayer2Level.text = "\(playerResult.halo_level!)"
                self.team1_P2_Exp = playerResult.exp!
                self.team1_P2_Lev = playerResult.halo_level!
                if self.match.active == 3 && self.match.winner == 1 {
                    if self.matchViewOrganizer.winnerConfirmed.text!.count > 5 {
                        self.matchViewOrganizer.winnerConfirmed.text = playerResult.name! + " and " + self.matchViewOrganizer.winnerConfirmed.text!
                    } else {
                        self.matchViewOrganizer.winnerConfirmed.text = playerResult.name! + self.matchViewOrganizer.winnerConfirmed.text!
                    }
                }
            })
            
            player.getPlayerNameAndSkill(playerId: idList[3], completion: { (result) in
                guard let playerResult = result else {
                    print("failed to get result")
                    return
                }
                self.matchViewOrganizer.oppPlayer2.text = playerResult.name!
                self.matchViewOrganizer.oppPlayer2Skill.text = "\(playerResult.skill_level!)"
                self.matchViewOrganizer.oppPlayer2Level.text = "\(playerResult.halo_level!)"
                self.team2_P2_Exp = playerResult.exp!
                self.team2_P2_Lev = playerResult.halo_level!
                if self.match.active == 3 && self.match.winner == 2 {
                    if self.matchViewOrganizer.winnerConfirmed.text!.count > 5 {
                        self.matchViewOrganizer.winnerConfirmed.text = playerResult.name! + " and " + self.matchViewOrganizer.winnerConfirmed.text!
                    } else {
                        self.matchViewOrganizer.winnerConfirmed.text = playerResult.name! + self.matchViewOrganizer.winnerConfirmed.text!
                    }
                }
            })
        }
        
    }
    

    
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
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
    
    func performRejectActive0Tourney() {
        match.winner = 1
        winner = 1
        match.team1_scores = [0, 0, 0, 0, 0]
        match.forfeit = 1
        let childUpdates = ["/\("team1_scores")/": match.team1_scores ?? [0,0,0,0,0], "/\("active")/": 3, "/\("forfeit")/": 1, "/\("winner")/": 1] as [String : Any]
        let ref = tourneyId == "none" ? Database.database().reference().child("matches").child(matchId) : Database.database().reference().child("tourneys").child(tourneyId).child("matches").child(matchId)
        ref.updateChildValues(childUpdates, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            
            print("Data saved successfully!")
            self.match.active = 3
            //self.matchFeed?.matches[self.whichItem].active = 3
            self.setupNavbarTitle(status: 3)
            self.matchViewOrganizer.confirmCheck1.isHidden = false
            self.matchViewOrganizer.confirmCheck2.isHidden = false
            self.matchViewOrganizer.confirmCheck3.isHidden = false
            self.matchViewOrganizer.confirmCheck4.isHidden = false
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            self.match.sendTourneyNotifications(uid: uid, tourneyId: self.tourneyId, tourneyYetToViewMatch: self.yetToView)

            self.updateTourneyStandings()
            self.removeCantChallenge()
            
            
            
        })
        matchViewOrganizer.rejectMatchScores.isHidden = true
        matchViewOrganizer.confirmMatchScores.isHidden = true
        matchViewOrganizer.forfeitLabel.isHidden = false
    }
    
    let whiteCover3: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let matchDeleted: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Match has been erased"
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    func performRejectActive0(whichOne: Int) {
        view.addSubview(whiteCover3)
        whiteCover3.topAnchor.constraint(equalTo: matchViewOrganizer.topAnchor).isActive = true
        whiteCover3.bottomAnchor.constraint(equalTo: matchViewOrganizer.bottomAnchor).isActive = true
        whiteCover3.leftAnchor.constraint(equalTo: matchViewOrganizer.leftAnchor).isActive = true
        whiteCover3.widthAnchor.constraint(equalTo: matchViewOrganizer.widthAnchor).isActive = true
        
        view.addSubview(matchDeleted)
        matchDeleted.topAnchor.constraint(equalTo: matchViewOrganizer.topAnchor).isActive = true
        matchDeleted.bottomAnchor.constraint(equalTo: matchViewOrganizer.bottomAnchor).isActive = true
        matchDeleted.leftAnchor.constraint(equalTo: matchViewOrganizer.leftAnchor).isActive = true
        matchDeleted.rightAnchor.constraint(equalTo: matchViewOrganizer.rightAnchor).isActive = true
        
        matchFeed?.matches.remove(at: whichItem)
        matchFeed?.tableView.reloadData()
        Database.database().reference().child("matches").child(matchId).removeValue()
        if match.doubles == true {
            Database.database().reference().child("user_matches").child(match.team_1_player_2!).child(matchId).removeValue()
            Database.database().reference().child("user_matches").child(match.team_2_player_2!).child(matchId).removeValue()
        }
        Database.database().reference().child("user_matches").child(match.team_1_player_1!).child(matchId).removeValue()
        Database.database().reference().child("user_matches").child(match.team_2_player_1!).child(matchId).removeValue()
        
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
                var nameOnInvite = String()
                switch uid {
                case self.match.team_1_player_1:
                    nameOnInvite = self.matchViewOrganizer.userPlayer1.text!
                case self.match.team_1_player_2:
                    nameOnInvite = self.matchViewOrganizer.userPlayer2.text!
                case self.match.team_2_player_1:
                    nameOnInvite = self.matchViewOrganizer.oppPlayer1.text!
                case self.match.team_2_player_2:
                    nameOnInvite = self.matchViewOrganizer.oppPlayer2.text!
                default:
                    print("failedUser")
                }
                Database.database().reference().child("users").child(toId).child("deviceId").observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value {
                        let deviceId = value as? String ?? "none"
                        let pusher = PushNotificationHandler()
                        pusher.setupPushNotification(deviceId: deviceId, message: "\(nameOnInvite) rejected a match you invited them to", title: "Match Canceled")
                        //self.setupPushNotification(deviceId: self.playersDeviceId, nameOnInvite: nameOnInvite)
                    }
                })
                
                
            })
            
            print("Crazy data saved!")
            
            
        })
    }
    
    func performConfirmActive0(whichOne: Int) {
        let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1084, w: 712, h: 126, wib: 750, hib: 1164, wia: Float(view.frame.width), hia: Float(view.frame.width) / 0.644)
        var matchReady = -1
        if match.doubles == true {
            if tourneyId == "none" {
                let ref = Database.database().reference().child("matches").child(matchId).child("team1_scores")
                match.team1_scores![whichOne] = 1
                matchFeed?.matches[whichItem].team1_scores![whichOne] = 1
                matchFeed?.tableView.reloadData()
                switch whichOne {
                case 1:
                    matchViewOrganizer.confirmCheck2.isHidden = false
                case 2:
                    matchViewOrganizer.confirmCheck3.isHidden = false
                case 3:
                    matchViewOrganizer.confirmCheck4.isHidden = false
                default:
                    print("failed to confirm")
                }
                ref.setValue(match.team1_scores)
                matchReady = checkIfMatchReady()
            } else {
                matchViewOrganizer.confirmCheck3.isHidden = false
                matchViewOrganizer.confirmCheck4.isHidden = false
                matchReady = 1
            }
        } else {
            matchReady = 1
            matchViewOrganizer.confirmCheck3.isHidden = false
        }
        if matchReady == 0 {
            matchViewOrganizer.confirmMatchScores.isHidden = true
            matchViewOrganizer.rejectMatchScores.isHidden = true
            matchViewOrganizer.matchStatusLabel.text = "Waiting for opponents to confirm match"
            matchViewOrganizer.matchStatusLabel.numberOfLines = 2
            matchViewOrganizer.matchStatusLabel.isHidden = false
        } else {
            matchViewOrganizer.whiteCover.isHidden = true
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            let matchActiveRef = tourneyId == "none" ? Database.database().reference().child("matches").child(matchId) : Database.database().reference().child("tourneys").child(tourneyId).child("matches").child(matchId)
            match.team1_scores = [0, 0, 0, 0, 0]
            let timeOfChallenge = Date().timeIntervalSince1970
            let childUpdates = ["/\("team1_scores")/": match.team1_scores ?? [0,0,0,0,0], "/\("active")/": 1, "/\("time")/": timeOfChallenge] as [String : Any]
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
                self.matchFeed?.matches[self.whichItem].active = 1
                self.matchFeed?.tableView.reloadData()
                self.setupNavbarTitle(status: 1)
                
                print("Crazy data 2 saved!")
                if self.tourneyId == "none" {
                    if self.match.doubles == true {
                        uid != self.match.team_1_player_2 ? Database.database().reference().child("user_matches").child(self.match.team_1_player_2!).child(self.matchId).setValue(1) : print("nope")
                        uid != self.match.team_2_player_2 ? Database.database().reference().child("user_matches").child(self.match.team_2_player_2!).child(self.matchId).setValue(1) : print("nope")
                    }
                    uid != self.match.team_1_player_1 ? Database.database().reference().child("user_matches").child(self.match.team_1_player_1!).child(self.matchId).setValue(1) : print("nope")
                    uid != self.match.team_2_player_1 ? Database.database().reference().child("user_matches").child(self.match.team_2_player_1!).child(self.matchId).setValue(1) : print("nope")
                } else {
                    self.match.sendTourneyNotifications(uid: uid, tourneyId: self.tourneyId, tourneyYetToViewMatch: self.yetToView)
                }
                self.match.sendMatchPushNotifications(uid: uid, userPlayer1: self.matchViewOrganizer.userPlayer1.text ?? "none", userPlayer2: self.matchViewOrganizer.userPlayer2.text ?? "none", oppPlayer1: self.matchViewOrganizer.oppPlayer1.text ?? "none", oppPlayer2: self.matchViewOrganizer.oppPlayer2.text ?? "none", message: "fully confirmed the match, now you can log the scores whenever you're finished playing", title: "Match Confirmed")
                
            })
            
            matchViewOrganizer.rejectMatchScores.isHidden = true
            matchViewOrganizer.confirmMatchScores.setTitle("Submit Scores to Opponent for Review", for: .normal)
            matchViewOrganizer.confirmMatchScores.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
            matchViewOrganizer.confirmMatchScores.titleLabel?.lineBreakMode = .byWordWrapping
            matchViewOrganizer.confirmMatchScores.titleLabel?.numberOfLines = 2
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
            
            
            matchViewOrganizer.confirmMatchScoresWidthAnchor?.isActive = false
            matchViewOrganizer.confirmMatchScoresWidthAnchor?.constant = CGFloat(confirmMatchScoresLoc.W)
            matchViewOrganizer.confirmMatchScoresWidthAnchor?.isActive = true
            matchViewOrganizer.confirmMatchScoresCenterXAnchor?.isActive = false
            matchViewOrganizer.confirmMatchScoresCenterXAnchor?.constant = CGFloat(confirmMatchScoresLoc.X)
            matchViewOrganizer.confirmMatchScoresCenterXAnchor?.isActive = true
        }
    }
    
    func performConfirmActive1() {
        let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1084, w: 712, h: 126, wib: 750, hib: 1164, wia: Float(view.frame.width), hia: Float(view.frame.width) / 0.644)
        resigningFirstResponders()
        finalTeam1Scores.removeAll()
        finalTeam2Scores.removeAll()
        gameWinners.removeAll()
        var scoresValidation = Int()
        if match.style == 0 {
            scoresValidation = match.checkScoresValiditySingle(game1UserScore: matchViewOrganizer.game1UserScore.text!, game1OppScore: matchViewOrganizer.game1OppScore.text!)
        } else if match.style == 1 {
            scoresValidation = match.checkScoresValidityThree(game1UserScore: matchViewOrganizer.game1UserScore.text!, game1OppScore: matchViewOrganizer.game1OppScore.text!, game2UserScore: matchViewOrganizer.game2UserScore.text!, game2OppScore: matchViewOrganizer.game2OppScore.text!, game3UserScore: matchViewOrganizer.game3UserScore.text!, game3OppScore: matchViewOrganizer.game3OppScore.text!)
        } else {
            scoresValidation = match.checkScoresValidityFive(game1UserScore: matchViewOrganizer.game1UserScore.text!, game1OppScore: matchViewOrganizer.game1OppScore.text!, game2UserScore: matchViewOrganizer.game2UserScore.text!, game2OppScore: matchViewOrganizer.game2OppScore.text!, game3UserScore: matchViewOrganizer.game3UserScore.text!, game3OppScore: matchViewOrganizer.game3OppScore.text!, game4UserScore: matchViewOrganizer.game4UserScore.text!, game4OppScore: matchViewOrganizer.game4OppScore.text!, game5UserScore: matchViewOrganizer.game5UserScore.text!, game5OppScore: matchViewOrganizer.game5OppScore.text!)
        }
        
        switch scoresValidation {
        case 0:
            let values = ["winner": match.winner!, "active": 2, "submitter": userIsTeam1 ? 1 : 2, "team_1_player_1": match.team_1_player_1!, "team_1_player_2": match.team_1_player_2!, "team_2_player_1": match.team_2_player_1!, "team_2_player_2": match.team_2_player_2!, "team1_scores": match.team1_scores!, "team2_scores": match.team2_scores!, "style": match.style!] as [String : Any]
            let ref = tourneyId == "none" ? Database.database().reference().child("matches").child(matchId) : Database.database().reference().child("tourneys").child(tourneyId).child("matches").child(matchId)
            ref.updateChildValues(values, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if let error = error {
                    print("Data could not be saved: \(error).")
                    return
                }
                
                print("Data saved successfully!")
                self.match.active = 2
                self.matchFeed?.matches[self.whichItem].active = 2
                self.setupNavbarTitle(status: 2)
                //self.match.winner = self.winner
                self.matchFeed?.matches[self.whichItem].winner = self.match.winner!
                self.match.submitter = self.userIsTeam1 ? 1 : 2
                self.matchFeed?.matches[self.whichItem].submitter = self.userIsTeam1 ? 1 : 2
                //self.match.team1_scores = self.finalTeam1Scores
                //self.match.team2_scores = self.finalTeam2Scores
                self.matchFeed?.matches[self.whichItem].team1_scores = self.match.team1_scores!
                self.matchFeed?.matches[self.whichItem].team2_scores = self.match.team2_scores!
                self.matchFeed?.tableView.reloadData()
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
                
                if self.tourneyId == "none" {
                    if self.match.doubles == true {
                        uid != self.match.team_1_player_2 ? Database.database().reference().child("user_matches").child(self.match.team_1_player_2!).child(self.matchId).setValue(1) : print("nope")
                        uid != self.match.team_2_player_2 ? Database.database().reference().child("user_matches").child(self.match.team_2_player_2!).child(self.matchId).setValue(1) : print("nope")
                    }
                    uid != self.match.team_1_player_1 ? Database.database().reference().child("user_matches").child(self.match.team_1_player_1!).child(self.matchId).setValue(1) : print("nope")
                    uid != self.match.team_2_player_1 ? Database.database().reference().child("user_matches").child(self.match.team_2_player_1!).child(self.matchId).setValue(1) : print("nope")
                } else {
                    self.match.sendTourneyNotifications(uid: uid, tourneyId: self.tourneyId, tourneyYetToViewMatch: self.yetToView)
                }
                self.match.sendMatchPushNotifications(uid: uid, userPlayer1: self.matchViewOrganizer.userPlayer1.text ?? "none", userPlayer2: self.matchViewOrganizer.userPlayer2.text ?? "none", oppPlayer1: self.matchViewOrganizer.oppPlayer1.text ?? "none", oppPlayer2: self.matchViewOrganizer.oppPlayer2.text ?? "none", message: "submitted the scores for the match, now you need to confirm them", title: "Match Scores Entered")
                
                
            })
            
            let newalert = UIAlertController(title: "Match Scores Confirmed", message: "Now just wait for opponent to confirm", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: resetupviews))
            self.present(newalert, animated: true, completion: nil)
            matchViewOrganizer.confirmMatchScores.isHidden = true
            matchViewOrganizer.matchStatusLabel.text = "Waiting for opponent to accept submitted scores"
            matchViewOrganizer.matchStatusLabel.numberOfLines = 2
            matchViewOrganizer.matchStatusLabel.isHidden = false
            
        case 1:
            let newalert = UIAlertController(title: "Sorry", message: "Not enough games were completed to determine the winner of the match", preferredStyle: UIAlertController.Style.alert)
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
        case 6:
            let newalert = UIAlertController(title: "Sorry", message: "A team needs to win at least 2 games before a winner of the match can be determined and game 3 has no scores", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
        default:
            let newalert = UIAlertController(title: "Sorry", message: "Cannot determine winner", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            
        }
    }
    
    func performConfirmActive2() {
        let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1084, w: 712, h: 126, wib: 750, hib: 1164, wia: Float(view.frame.width), hia: Float(view.frame.width) / 0.644)
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
            let values2 = ["active": 3, "winner": self.match.winner ?? 1, "forfeit": self.match.forfeit ?? -1, "team_1_player_1": self.match.team_1_player_1 ?? "none", "team_1_player_2": self.match.team_1_player_2 ?? "none", "team_2_player_1": self.match.team_2_player_1 ?? "none", "team_2_player_2": self.match.team_2_player_2 ?? "none", "team1_scores": self.match.team1_scores ?? [0,0,0,0,0], "team2_scores": self.match.team2_scores ?? [0,0,0,0,0], "time": time, "style": self.match.style!] as [String : Any]
            ref2.updateChildValues(values2, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if let error = error {
                    print("Data could not be saved: \(error).")
                    return
                }
                })
            self.match.active = 3
            self.matchFeed?.matches[self.whichItem].active = 3
            self.matchFeed?.tableView.reloadData()
            self.setupNavbarTitle(status: 3)
            self.matchViewOrganizer.confirmCheck1.isHidden = false
            self.matchViewOrganizer.confirmCheck2.isHidden = self.match.doubles! ? false : true
            self.matchViewOrganizer.confirmCheck3.isHidden = false
            self.matchViewOrganizer.confirmCheck4.isHidden = self.match.doubles! ? false : true
            self.updatePlayerStats()
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            self.tourneyId != "none" ? self.match.sendTourneyNotifications(uid: uid, tourneyId: self.tourneyId, tourneyYetToViewMatch: self.yetToView) : print("turd")
            if self.tourneyActive >= 2 {
                self.adjustTourneyFinals()
                self.team1.updateTeamWins(tourneyId: self.tourneyId, winner: self.match.winner!)
                self.team2.updateTeamWins(tourneyId: self.tourneyId, winner: self.match.winner!)
            } else {
                self.tourneyId != "none" ? self.updateTourneyStandings() : print("nope")
                self.tourneyId != "none" ? self.removeCantChallenge() : print("nope")
            }
            if self.tourneyId == "none" {
                if self.match.doubles == true {
                    uid != self.match.team_1_player_2 ? Database.database().reference().child("user_matches").child(self.match.team_1_player_2!).child(self.matchId).setValue(1) : print("nope")
                    uid != self.match.team_2_player_2 ? Database.database().reference().child("user_matches").child(self.match.team_2_player_2!).child(self.matchId).setValue(1) : print("nope")
                }
                uid != self.match.team_1_player_1 ? Database.database().reference().child("user_matches").child(self.match.team_1_player_1!).child(self.matchId).setValue(1) : print("nope")
                uid != self.match.team_2_player_1 ? Database.database().reference().child("user_matches").child(self.match.team_2_player_1!).child(self.matchId).setValue(1) : print("nope")
            }
            self.match.sendMatchPushNotifications(uid: uid, userPlayer1: self.matchViewOrganizer.userPlayer1.text ?? "none", userPlayer2: self.matchViewOrganizer.userPlayer2.text ?? "none", oppPlayer1: self.matchViewOrganizer.oppPlayer1.text ?? "none", oppPlayer2: self.matchViewOrganizer.oppPlayer2.text ?? "none", message: "confirmed the match scores", title: "Match Scores Confirmed")
            
            
        })
        matchViewOrganizer.confirmMatchScores.isHidden = true
        matchViewOrganizer.rejectMatchScores.isHidden = true
        matchViewOrganizer.winnerConfirmed.isHidden = false
        if match.doubles == true {
            let newalert = UIAlertController(title: "Match Complete", message: self.match.winner == 1 ? "\(matchViewOrganizer.userPlayer1.text!) and \(matchViewOrganizer.userPlayer2.text!) win!" : "\(matchViewOrganizer.oppPlayer1.text!) and \(matchViewOrganizer.oppPlayer2.text!) win!", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: resetupviews))
            self.present(newalert, animated: true, completion: nil)
            matchViewOrganizer.winnerConfirmed.text = match.winner == 1 ? "\(matchViewOrganizer.userPlayer1.text!) & \(matchViewOrganizer.userPlayer2.text!) win!" : "\(matchViewOrganizer.oppPlayer1.text!) & \(matchViewOrganizer.oppPlayer2.text!) win!"
        } else {
            let newalert = UIAlertController(title: "Match Complete", message: self.match.winner == 1 ? "\(matchViewOrganizer.userPlayer1.text!) wins!" : "\(matchViewOrganizer.oppPlayer1.text!) wins!", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: resetupviews))
            self.present(newalert, animated: true, completion: nil)
            matchViewOrganizer.winnerConfirmed.text = match.winner == 1 ? "\(matchViewOrganizer.userPlayer1.text!) wins!" : "\(matchViewOrganizer.oppPlayer1.text!) wins!"
        }
        matchViewOrganizer.winnerConfirmed.numberOfLines = 2
    }
    
    func removeCantChallenge() {
        let tourneyFunctions = Tourney()
        tourneyFunctions.removeCantChallenge(team_1_player_1: match.team_1_player_1!, team_1_player_2: match.team_1_player_2!, team_2_player_1: match.team_2_player_1!, team_2_player_2: match.team_2_player_2!, tourneyId: tourneyId)
    }
    
    func updatePlayerStats() {
        updateExperience()
        if match.doubles == true {
            player.updatePlayerStats(playerId: match.team_1_player_2!, winner: match.winner!)
            player.updatePlayerStats(playerId: match.team_2_player_2!, winner: match.winner!)
        }
        player.updatePlayerStats(playerId: match.team_1_player_1!, winner: match.winner!)
        player.updatePlayerStats(playerId: match.team_2_player_1!, winner: match.winner!)
    }
    
    @objc func resetupviews(action: UIAlertAction) {
        if match.active != 3 {
            disableScores(team1Scores: match.team1_scores!, team2Scores: match.team2_scores!)
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
        let valuesTeam1 = ["rank": teams[team1Index].rank!, "wins": match.winner == 1 ? team1.wins! + 1 : team1.wins!, "losses": match.winner == 2 ? team1.losses! + 1 : team1.losses!, "player1": team1.player1!, "player2": team1.player2!] as [String : Any]
        let valuesTeam2 = ["rank": teams[team2Index].rank!, "wins": match.winner == 2 ? team2.wins! + 1 : team2.wins!, "losses": match.winner == 1 ? team2.losses! + 1 : team2.losses!, "player1": team2.player1!, "player2": team2.player2!] as [String : Any]
        var childUpdates = ["/\(team1.teamId ?? "none")/": valuesTeam1, "/\(team2.teamId ?? "none")/": valuesTeam2]
        if effectedIndices.count == 1 {
            let valuesEffected1 = ["rank": teams[effectedIndices[0]].rank as Any, "wins": teams[effectedIndices[0]].wins as Any, "losses": teams[effectedIndices[0]].losses as Any, "player1": teams[effectedIndices[0]].player1 as Any, "player2": teams[effectedIndices[0]].player2 as Any] as [String : Any]
            childUpdates = ["/\(team1.teamId ?? "none")/": valuesTeam1, "/\(team2.teamId ?? "none")/": valuesTeam2, "/\(teams[effectedIndices[0]].teamId ?? "none")/": valuesEffected1]
        } else if effectedIndices.count == 2 {
            let valuesEffected1 = ["rank": teams[effectedIndices[0]].rank as Any, "wins": teams[effectedIndices[0]].wins as Any, "losses": teams[effectedIndices[0]].losses as Any, "player1": teams[effectedIndices[0]].player1 as Any, "player2": teams[effectedIndices[0]].player2 as Any] as [String : Any]
            let valuesEffected2 = ["rank": teams[effectedIndices[1]].rank as Any, "wins": teams[effectedIndices[1]].wins as Any, "losses": teams[effectedIndices[1]].losses as Any, "player1": teams[effectedIndices[1]].player1 as Any, "player2": teams[effectedIndices[1]].player2 as Any] as [String : Any]
            childUpdates = ["/\(team1.teamId ?? "none")/": valuesTeam1, "/\(team2.teamId ?? "none")/": valuesTeam2, "/\(teams[effectedIndices[0]].teamId ?? "none")/": valuesEffected1, "/\(teams[effectedIndices[1]].teamId ?? "none")/": valuesEffected2]
        } else if effectedIndices.count == 3 {
            let valuesEffected1 = ["rank": teams[effectedIndices[0]].rank as Any, "wins": teams[effectedIndices[0]].wins as Any, "losses": teams[effectedIndices[0]].losses as Any, "player1": teams[effectedIndices[0]].player1 as Any, "player2": teams[effectedIndices[0]].player2 as Any] as [String : Any]
            let valuesEffected2 = ["rank": teams[effectedIndices[1]].rank as Any, "wins": teams[effectedIndices[1]].wins as Any, "losses": teams[effectedIndices[1]].losses as Any, "player1": teams[effectedIndices[1]].player1 as Any, "player2": teams[effectedIndices[1]].player2 as Any] as [String : Any]
            let valuesEffected3 = ["rank": teams[effectedIndices[2]].rank as Any, "wins": teams[effectedIndices[2]].wins as Any, "losses": teams[effectedIndices[2]].losses as Any, "player1": teams[effectedIndices[2]].player1 as Any, "player2": teams[effectedIndices[2]].player2 as Any] as [String : Any]
            childUpdates = ["/\(team1.teamId ?? "none")/": valuesTeam1, "/\(team2.teamId ?? "none")/": valuesTeam2, "/\(teams[effectedIndices[0]].teamId ?? "none")/": valuesEffected1, "/\(teams[effectedIndices[1]].teamId ?? "none")/": valuesEffected2, "/\(teams[effectedIndices[2]].teamId ?? "none")/": valuesEffected3]
        } else if effectedIndices.count == 4 {
            let valuesEffected1 = ["rank": teams[effectedIndices[0]].rank as Any, "wins": teams[effectedIndices[0]].wins as Any, "losses": teams[effectedIndices[0]].losses as Any, "player1": teams[effectedIndices[0]].player1 as Any, "player2": teams[effectedIndices[0]].player2 as Any] as [String : Any]
            let valuesEffected2 = ["rank": teams[effectedIndices[1]].rank as Any, "wins": teams[effectedIndices[1]].wins as Any, "losses": teams[effectedIndices[1]].losses as Any, "player1": teams[effectedIndices[1]].player1 as Any, "player2": teams[effectedIndices[1]].player2 as Any] as [String : Any]
            let valuesEffected3 = ["rank": teams[effectedIndices[2]].rank as Any, "wins": teams[effectedIndices[2]].wins as Any, "losses": teams[effectedIndices[2]].losses as Any, "player1": teams[effectedIndices[2]].player1 as Any, "player2": teams[effectedIndices[2]].player2 as Any] as [String : Any]
            let valuesEffected4 = ["rank": teams[effectedIndices[3]].rank as Any, "wins": teams[effectedIndices[3]].wins as Any, "losses": teams[effectedIndices[3]].losses as Any, "player1": teams[effectedIndices[3]].player1 as Any, "player2": teams[effectedIndices[3]].player2 as Any] as [String : Any]
            childUpdates = ["/\(team1.teamId ?? "none")/": valuesTeam1, "/\(team2.teamId ?? "none")/": valuesTeam2, "/\(teams[effectedIndices[0]].teamId ?? "none")/": valuesEffected1, "/\(teams[effectedIndices[1]].teamId ?? "none")/": valuesEffected2, "/\(teams[effectedIndices[2]].teamId ?? "none")/": valuesEffected3, "/\(teams[effectedIndices[3]].teamId ?? "none")/": valuesEffected4]
        } else if effectedIndices.count == 5 {
            let valuesEffected1 = ["rank": teams[effectedIndices[0]].rank as Any, "wins": teams[effectedIndices[0]].wins as Any, "losses": teams[effectedIndices[0]].losses as Any, "player1": teams[effectedIndices[0]].player1 as Any, "player2": teams[effectedIndices[0]].player2 as Any] as [String : Any]
            let valuesEffected2 = ["rank": teams[effectedIndices[1]].rank as Any, "wins": teams[effectedIndices[1]].wins as Any, "losses": teams[effectedIndices[1]].losses as Any, "player1": teams[effectedIndices[1]].player1 as Any, "player2": teams[effectedIndices[1]].player2 as Any] as [String : Any]
            let valuesEffected3 = ["rank": teams[effectedIndices[2]].rank as Any, "wins": teams[effectedIndices[2]].wins as Any, "losses": teams[effectedIndices[2]].losses as Any, "player1": teams[effectedIndices[2]].player1 as Any, "player2": teams[effectedIndices[2]].player2 as Any] as [String : Any]
            let valuesEffected4 = ["rank": teams[effectedIndices[3]].rank as Any, "wins": teams[effectedIndices[3]].wins as Any, "losses": teams[effectedIndices[3]].losses as Any, "player1": teams[effectedIndices[3]].player1 as Any, "player2": teams[effectedIndices[3]].player2 as Any] as [String : Any]
            let valuesEffected5 = ["rank": teams[effectedIndices[4]].rank as Any, "wins": teams[effectedIndices[4]].wins as Any, "losses": teams[effectedIndices[4]].losses as Any, "player1": teams[effectedIndices[4]].player1 as Any, "player2": teams[effectedIndices[4]].player2 as Any] as [String : Any]
            childUpdates = ["/\(team1.teamId ?? "none")/": valuesTeam1, "/\(team2.teamId ?? "none")/": valuesTeam2, "/\(teams[effectedIndices[0]].teamId ?? "none")/": valuesEffected1, "/\(teams[effectedIndices[1]].teamId ?? "none")/": valuesEffected2, "/\(teams[effectedIndices[2]].teamId ?? "none")/": valuesEffected3, "/\(teams[effectedIndices[3]].teamId ?? "none")/": valuesEffected4, "/\(teams[effectedIndices[4]].teamId ?? "none")/": valuesEffected5]
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
        let values = ["style": match.style!, "active": 1, "team_1_player_1": team1st.player1!, "team_1_player_2": team1st.player2!, "team_2_player_1": team2nd.player1!, "team_2_player_2": team2nd.player2!, "team1_scores": [0, 0, 0, 0, 0], "team2_scores": [0, 0, 0, 0, 0], "time": timeOfChallenge] as [String : Any]
        createMatchRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            let userIds = [team1st.player1!, team1st.player2!, team2nd.player1!, team2nd.player2!]
            for index in userIds {
                if self.yetToView.contains(index) == false {
                    self.yetToView.append(index)
                }
            }
            
            let notificationsRef = Database.database().reference()
            let childUpdates = ["/\("user_tourneys")/\(team1st.player1!)/\(self.tourneyId)/": team1st.player1 == uid ? 0 : 1, "/\("user_tourneys")/\(team1st.player2!)/\(self.tourneyId)/": team1st.player2 == uid ? 0 : 1, "/\("user_tourneys")/\(team2nd.player1!)/\(self.tourneyId)/": team2nd.player1 == uid ? 0 : 1, "/\("user_tourneys")/\(team2nd.player2!)/\(self.tourneyId)/": team2nd.player2 == uid ? 0 : 1, "/\("tourneys")/\(self.tourneyId)/\("yet_to_view")/": self.yetToView] as [String : Any]
            notificationsRef.updateChildValues(childUpdates, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in

                if error != nil {
                    let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(messageSendFailed, animated: true, completion: nil)
                    print("Data could not be saved: \(String(describing: error)).")
                    return
                }
                
                let newMessage = "You have made it to finals!"
                let title = self.tourneyName
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
    
    func disableScores(team1Scores: [Int], team2Scores: [Int]) {
        matchViewOrganizer.game1UserScore.text = "\(team1Scores[0])"
        matchViewOrganizer.game2UserScore.text = "\(team1Scores[1])"
        matchViewOrganizer.game3UserScore.text = "\(team1Scores[2])"
        matchViewOrganizer.game4UserScore.text = "\(team1Scores[3])"
        matchViewOrganizer.game5UserScore.text = "\(team1Scores[4])"
        matchViewOrganizer.game1OppScore.text = "\(team2Scores[0])"
        matchViewOrganizer.game2OppScore.text = "\(team2Scores[1])"
        matchViewOrganizer.game3OppScore.text = "\(team2Scores[2])"
        matchViewOrganizer.game4OppScore.text = "\(team2Scores[3])"
        matchViewOrganizer.game5OppScore.text = "\(team2Scores[4])"
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
    
    func updateExperience() {
        let team1Level = match.doubles == true ? Int((team1_P1_Lev + team1_P2_Lev)/2) : team1_P1_Lev
        let team2Level = match.doubles == true ? Int((team2_P1_Lev + team2_P2_Lev)/2) : team2_P1_Lev
        let winningTeam = match.winner!
        let levelDifference = abs(team1Level - team2Level)
        let team1ChangeExpFlat = team1Level - team2Level >= 0 ? player.calculateChangeExperienceHigher(levelDiff: levelDifference, winOrLose: winningTeam == 1 ? true : false) : player.calculateChangeExperienceLower(levelDiff: levelDifference, winOrLose: winningTeam == 1 ? true : false)
        let team2ChangeExpFlat = team2Level - team1Level >= 0 ? player.calculateChangeExperienceHigher(levelDiff: levelDifference, winOrLose: winningTeam == 2 ? true : false) : player.calculateChangeExperienceLower(levelDiff: levelDifference, winOrLose: winningTeam == 2 ? true : false)
        var team1ChangeExp = Int()
        var team2ChangeExp = Int()
        if match.style == 0 {
            team1ChangeExp = team1ChangeExpFlat * 1/2
            team2ChangeExp = team2ChangeExpFlat * 1/2
        } else if match.style == 1 {
            team1ChangeExp = team1ChangeExpFlat
            team2ChangeExp = team2ChangeExpFlat
        } else {
            team1ChangeExp = team1ChangeExpFlat * 3/2
            team2ChangeExp = team2ChangeExpFlat * 3/2
        }
        if match.doubles == true {
            levelUpDisplay(previousLev: [team1_P1_Lev, team1_P2_Lev, team2_P1_Lev, team2_P2_Lev], newExp: [team1_P1_Exp + team1ChangeExp, team1_P2_Exp + team1ChangeExp, team2_P1_Exp + team2ChangeExp, team2_P2_Exp + team2ChangeExp], players: [match.team_1_player_1!, match.team_1_player_2!, match.team_2_player_1!, match.team_2_player_2!])
        } else {
            levelUpDisplay(previousLev: [team1_P1_Lev, team2_P1_Lev], newExp: [team1_P1_Exp + team1ChangeExp, team2_P1_Exp + team2ChangeExp], players: [match.team_1_player_1!, match.team_2_player_1!])
        }
        let usersRef = Database.database().reference().child("users")
        let childUpdates = match.doubles == true ? ["/\(match.team_1_player_1!)/\("exp")/": team1_P1_Exp < 150 && team1ChangeExp < 0 ? team1_P1_Exp : team1_P1_Exp + team1ChangeExp, "/\(match.team_1_player_2!)/\("exp")/": team1_P2_Exp < 150 && team1ChangeExp < 0 ? team1_P2_Exp : team1_P2_Exp + team1ChangeExp, "/\(match.team_2_player_1!)/\("exp")/": team2_P1_Exp < 150 && team2ChangeExp < 0 ? team2_P1_Exp : team2_P1_Exp + team2ChangeExp, "/\(match.team_2_player_2!)/\("exp")/": team2_P2_Exp < 150 && team2ChangeExp < 0 ? team2_P2_Exp : team2_P2_Exp + team2ChangeExp] as [String : Any] : ["/\(match.team_1_player_1!)/\("exp")/": team1_P1_Exp < 150 && team1ChangeExp < 0 ? team1_P1_Exp : team1_P1_Exp + team1ChangeExp, "/\(match.team_2_player_1!)/\("exp")/": team2_P1_Exp < 150 && team2ChangeExp < 0 ? team2_P1_Exp : team2_P1_Exp + team2ChangeExp] as [String : Any]
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
    
    func levelUpDisplay(previousLev: [Int], newExp: [Int], players: [String]) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        for (index, element) in players.enumerated() {
            let newLevel = player.haloLevel(exp: newExp[index])
            
            if (newLevel - previousLev[index]) > 0 {
                uid == element ? openMenu(newExp: newExp[index], newLevel: newLevel, oldLevel: previousLev[index]) : uploadLevelUp(oldLevel: previousLev[index], player: element)
            }
        }
    }
    
    
    func uploadLevelUp(oldLevel: Int, player: String) {
        Database.database().reference().child("users").child(player).child("oldLevel").setValue(oldLevel)
    }
    
    let pieBackground: UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
        cv.layer.cornerRadius = 10
        cv.layer.masksToBounds = true
        return cv
    }()
    
    let haloLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 100)
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.textAlignment = .center
        return label
    }()
    
    let haloLevelTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.text = "You leveled up!"
        label.textAlignment = .center
        return label
    }()
    
    let levelUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Level Up!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 50)
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.textAlignment = .center
        return label
    }()
    
    let haloLevelTitle3: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.textAlignment = .center
        return label
    }()
    
    let pieBackroundHeight = 440
    
    let pieChart: PieChartView = {
        let bi = PieChartView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.isUserInteractionEnabled = true
        return bi
    }()
    
    func openMenu(newExp: Int, newLevel: Int, oldLevel: Int) {
        self.haloLevelTitle.text = "You moved up from level \(oldLevel) to level \(newLevel)!"
        if self.player.levelTitle(level: oldLevel) != self.player.levelTitle(level: newLevel) {
            self.haloLevelTitle3.text = "You graduated from '\(self.player.levelTitle(level: oldLevel))' to '\(self.player.levelTitle(level: newLevel))'"
        } else {
            self.haloLevelTitle3.text = "You're currently '\(self.player.levelTitle(level: newLevel))'"
        }
        let bounds = self.player.findExpBounds(exp: newExp)
        let startExp = bounds[0]
        let endExp = bounds[1]
        
        let currentExp = PieChartDataEntry(value: Double(newExp - startExp), label: nil)
        let goalExp = PieChartDataEntry(value: Double(endExp - newExp), label: nil)
        let chartDataSet = PieChartDataSet(entries: [currentExp, goalExp], label: nil)
        chartDataSet.drawValuesEnabled = false
        
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [UIColor.init(r: 120, g: 207, b: 138), UIColor.white]
        chartDataSet.colors = colors
        
        pieChart.data = chartData
        pieChart.legend.enabled = false
        pieChart.holeRadiusPercent = 0.93
        pieChart.transparentCircleColor = UIColor.init(r: 120, g: 207, b: 138)
        pieChart.transparentCircleRadiusPercent = 0.94
           if let window = UIApplication.shared.keyWindow {
               blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
               blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu)))
               window.addSubview(blackView)
               window.addSubview(pieBackground)
               pieBackground.frame = CGRect(x: 24, y: window.frame.height, width: window.frame.width - 48, height: CGFloat(pieBackroundHeight))
               blackView.frame = window.frame
               blackView.alpha = 0
               
               UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                   self.blackView.alpha = 1
                self.pieBackground.frame = CGRect(x: 24, y: window.frame.height - CGFloat(self.pieBackroundHeight + 140), width: window.frame.width - 48, height: CGFloat(self.pieBackroundHeight))
               }, completion: nil)
            
            pieBackground.addSubview(pieChart)
            pieChart.heightAnchor.constraint(equalToConstant: 230).isActive = true
            pieChart.centerXAnchor.constraint(equalTo: pieBackground.centerXAnchor).isActive = true
            pieChart.widthAnchor.constraint(equalToConstant: 230).isActive = true
            pieChart.centerYAnchor.constraint(equalTo: pieBackground.centerYAnchor).isActive = true
            
            let whichPlayerAmI = match.whichPlayerAmI()
            switch whichPlayerAmI {
            case 0:
                matchViewOrganizer.userPlayer1Level.text = "\(newLevel)"
            case 1:
                matchViewOrganizer.userPlayer2Level.text = "\(newLevel)"
            case 2:
                matchViewOrganizer.oppPlayer1Level.text = "\(newLevel)"
            case 3:
                matchViewOrganizer.oppPlayer2Level.text = "\(newLevel)"
            default:
                print("none")
            }
            
            haloLevel.text = "\(newLevel)"
            pieBackground.addSubview(haloLevel)
            haloLevel.heightAnchor.constraint(equalToConstant: 150).isActive = true
            haloLevel.centerXAnchor.constraint(equalTo: pieBackground.centerXAnchor).isActive = true
            haloLevel.widthAnchor.constraint(equalToConstant: 150).isActive = true
            haloLevel.centerYAnchor.constraint(equalTo: pieBackground.centerYAnchor).isActive = true
            
            pieBackground.addSubview(haloLevelTitle)
            haloLevelTitle.heightAnchor.constraint(equalToConstant: 60).isActive = true
            haloLevelTitle.centerXAnchor.constraint(equalTo: pieBackground.centerXAnchor).isActive = true
            haloLevelTitle.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
            haloLevelTitle.bottomAnchor.constraint(equalTo: pieChart.topAnchor, constant: 15).isActive = true
            
            pieBackground.addSubview(levelUpLabel)
            levelUpLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
            levelUpLabel.centerXAnchor.constraint(equalTo: pieBackground.centerXAnchor).isActive = true
            levelUpLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
            levelUpLabel.bottomAnchor.constraint(equalTo: haloLevelTitle.topAnchor, constant: 0).isActive = true
            
            pieBackground.addSubview(haloLevelTitle3)
            haloLevelTitle3.heightAnchor.constraint(equalToConstant: 80).isActive = true
            haloLevelTitle3.centerXAnchor.constraint(equalTo: pieBackground.centerXAnchor).isActive = true
            haloLevelTitle3.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
            haloLevelTitle3.topAnchor.constraint(equalTo: pieChart.bottomAnchor, constant: -15).isActive = true
           }
       }
       
       @objc func dismissMenu() {
           UIView.animate(withDuration: 0.5, animations: {
               self.blackView.alpha = 0
               if let window = UIApplication.shared.keyWindow {
                self.pieBackground.frame = CGRect(x: 24, y: window.frame.height, width: window.frame.width - 48, height: CGFloat(self.pieBackroundHeight))
               }
           })
       }
    
}
