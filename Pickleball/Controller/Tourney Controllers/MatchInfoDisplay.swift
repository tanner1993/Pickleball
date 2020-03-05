//
//  MatchInfoDisplay.swift
//  Pickleball
//
//  Created by Tanner Rozier on 11/22/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MatchInfoDisplay: UIViewController {

    var tourneyStandings = TourneyStandings()
    var teams = [Team]()
    var userTeam: Team?
    var oppTeam: Team?
    var tourneyId: String = ""
    var match = Match()
    var finalUserScores = [Int]()
    var finalOppScores = [Int]()
    var gameWinners = [Int]()
    var winner = "nobody"
    var userWins = 0
    var oppWins = 0
    var userIsChallenger = 0
    var confirmMatchScoresWidthAnchor: NSLayoutConstraint?
    var confirmMatchScoresCenterXAnchor: NSLayoutConstraint?
    var backgroundImageCenterYAnchor: NSLayoutConstraint?
    var userWinner = -1
    
    let backgroundImage: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.image = UIImage(named: "match_info_display")
        bi.isUserInteractionEnabled = true
        return bi
    }()
    
    let confirmMatchScores: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.alpha = 0.05
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleConfirmScores), for: .touchUpInside)
        return button
    }()
    
    let rejectMatchScores: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.alpha = 0.05
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleEditScores), for: .touchUpInside)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupKeyboardObservers()
    }
    
    func resigningFirstResponders() {
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
        let height =  (keyboardFrame?.height)! - 50
        backgroundImageCenterYAnchor?.constant = -height
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        backgroundImageCenterYAnchor?.constant = 0
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleEditScores() {
        let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1045, w: 532, h: 68, wib: 750, hib: 1150, wia: 375, hia: 575)
        self.match.active = 0
        self.match.winner = "no one"
        self.match.submitter = "no one"
        self.match.challengerScores = [0, 0, 0, 0, 0]
        self.match.challengedScores = [0, 0, 0, 0, 0]
        let newalert = UIAlertController(title: "Okay", message: "well if these scores ain't right then what is?", preferredStyle: UIAlertController.Style.alert)
        newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: resetupviews))
        self.present(newalert, animated: true, completion: nil)
        confirmMatchScoresImage.image = UIImage(named: "confirm_match_scores")
        rejectMatchScores.removeFromSuperview()
        confirmMatchScoresCenterXAnchor?.isActive = false
        confirmMatchScoresCenterXAnchor = confirmMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X))
        confirmMatchScoresCenterXAnchor?.isActive = true
        confirmMatchScoresWidthAnchor?.isActive = false
        confirmMatchScoresWidthAnchor = confirmMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W))
        confirmMatchScoresWidthAnchor?.isActive = true
        
    }
    
    @objc func handleConfirmScores() {
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
        if match.active == 0 {
        finalUserScores.removeAll()
        finalOppScores.removeAll()
        gameWinners.removeAll()
        let scoresValidation = checkScoresValidity()
        
        switch scoresValidation {
        case 0:
            guard let userTeamId = userTeam?.teamId else {
                return
            }
            guard let oppTeamId = oppTeam?.teamId else {
                return
            }
            let values = ["winner": winner, "submitter": userTeamId, "active": 1, "challenger_team": userIsChallenger == 0 ? userTeamId : oppTeamId, "challenged_team": userIsChallenger == 0 ? oppTeamId : userTeamId, "challenger_scores": userIsChallenger == 0 ? finalUserScores : finalOppScores, "challenged_scores": userIsChallenger == 0 ? finalOppScores : finalUserScores] as [String : Any]
            let ref = Database.database().reference().child("tourneys").child(tourneyId).child("matches").child(match.matchId ?? "")
            ref.updateChildValues(values, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if let error = error {
                    print("Data could not be saved: \(error).")
                    return
                }
                
                print("Data saved successfully!")
                self.match.active = 1
                self.match.winner = self.winner
                self.match.submitter = userTeamId
                self.match.challengerScores = self.userIsChallenger == 0 ? self.finalUserScores : self.finalOppScores
                self.match.challengedScores = self.userIsChallenger == 0 ? self.finalOppScores : self.finalUserScores
                
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
        } else if match.active == 1 {
            let values = ["active": 2] as [String : Any]
            let ref = Database.database().reference().child("tourneys").child(tourneyId).child("matches").child(match.matchId ?? "")
            ref.updateChildValues(values, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if let error = error {
                    print("Data could not be saved: \(error).")
                    return
                }
                
                print("Data saved successfully!")
                self.match.active = 2
                self.updateTourneyStandings()
                
                
            })
            let newalert = UIAlertController(title: "Awesome", message: "Match Confirmed", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: resetupviews))
            self.present(newalert, animated: true, completion: nil)
            confirmMatchScoresImage.image = UIImage(named: "winner_confirm")
            let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1045, w: 532, h: 68, wib: 750, hib: 1150, wia: 375, hia: 575)
            view.addSubview(winnerConfirmed)
            winnerConfirmed.text = userTeam?.teamId == match.winner ? "\(userPlayer1.text!) & \(userPlayer2.text!) won!" : "\(oppPlayer1.text!) & \(oppPlayer2.text!) won!"
            winnerConfirmed.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
            winnerConfirmed.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
            winnerConfirmed.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
            winnerConfirmed.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
            
        }
    }
    
    func reorganizeTeams() -> [Int] {
        var newUserTeamRank = -10
        var newOppTeamRank = -10
        var effectedRanks = [Int]()
        var effectedIndices = [Int]()
        guard let userTeamRank = userTeam?.rank else {
            return [-1]
        }
        guard let oppTeamRank = oppTeam?.rank else {
            return [-1]
        }
        let userIsLeading = userTeamRank < oppTeamRank ? 0 : 1
        if match.winner == userTeam?.teamId {
            if userIsLeading == 0 {
                newUserTeamRank = userTeamRank != 1 ? userTeamRank - 1 : 1
                newOppTeamRank = oppTeamRank
                for (index, element) in teams.enumerated() {
                    if element.rank == newUserTeamRank {
                        element.rank = userTeamRank
                        effectedIndices.append(index)
                    } else if element.teamId == userTeam?.teamId {
                        element.rank = newUserTeamRank
                    }
                }
                return effectedIndices
            } else {
                newUserTeamRank = oppTeamRank
                newOppTeamRank = oppTeamRank + 1
                if userTeamRank - oppTeamRank > 1 {
                    for index in oppTeamRank + 1..<userTeamRank {
                        effectedRanks.append(index)
                    }
                }
                for (index, element) in teams.enumerated() {
                    if effectedRanks.contains(element.rank!) {
                        element.rank = element.rank! + 1
                        effectedIndices.append(index)
                    } else if element.teamId == userTeam?.teamId {
                        element.rank = newUserTeamRank
                    } else if element.teamId == oppTeam?.teamId {
                        element.rank = newOppTeamRank
                    }
                }
                return effectedIndices
            }
        } else if match.winner == oppTeam?.teamId {
            if userIsLeading == 1 {
                newOppTeamRank = oppTeamRank != 1 ? oppTeamRank - 1 : 1
                newUserTeamRank = userTeamRank
                for (index, element) in teams.enumerated() {
                    if element.rank == newOppTeamRank {
                        element.rank = oppTeamRank
                        effectedIndices.append(index)
                    } else if element.teamId == oppTeam?.teamId {
                        element.rank = newOppTeamRank
                    }
                }
                return effectedIndices
            } else {
                newOppTeamRank = userTeamRank
                newUserTeamRank = userTeamRank + 1
                if oppTeamRank - userTeamRank > 1 {
                    for index in userTeamRank + 1..<oppTeamRank {
                        effectedRanks.append(index)
                    }
                }
                for (index, element) in teams.enumerated() {
                    if effectedRanks.contains(element.rank!) {
                        element.rank = element.rank! + 1
                        effectedIndices.append(index)
                    } else if element.teamId == oppTeam?.teamId {
                        element.rank = newOppTeamRank
                    } else if element.teamId == userTeam?.teamId {
                        element.rank = newUserTeamRank
                    }
                }
                return effectedIndices
            }
        } else {
            return [-1]
        }
    }
    
    func updateTourneyStandings() {
        var userTeamIndex = -1
        var oppTeamIndex = -1
        for (index, element) in teams.enumerated() {
            if element.teamId == userTeam?.teamId ?? "no user id" {
                userTeamIndex = index
            } else if element.teamId == oppTeam?.teamId {
                oppTeamIndex = index
            }
        }
        let effectedIndices = reorganizeTeams()
        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("teams")
        let valuesUser = ["rank": teams[userTeamIndex].rank, "wins": match.winner == userTeam?.teamId ? userTeam!.wins! + 1 : userTeam?.wins, "losses": match.winner == oppTeam?.teamId ? userTeam!.losses! + 1 : userTeam?.losses, "player1": userTeam?.player1, "player2": userTeam?.player2] as [String : Any]
        let valuesOpp = ["rank": teams[oppTeamIndex].rank, "wins": match.winner == oppTeam?.teamId ? oppTeam!.wins! + 1 : oppTeam?.wins, "losses": match.winner == userTeam?.teamId ? oppTeam!.losses! + 1 : oppTeam?.losses, "player1": oppTeam?.player1, "player2": oppTeam?.player2] as [String : Any]
        var childUpdates = ["/\(userTeam?.teamId ?? "none")/": valuesUser, "/\(oppTeam?.teamId ?? "none")/": valuesOpp]
        if effectedIndices.count == 1 {
            let valuesEffected1 = ["rank": teams[effectedIndices[0]].rank as Any, "wins": teams[effectedIndices[0]].wins as Any, "losses": teams[effectedIndices[0]].losses as Any, "player1": teams[effectedIndices[0]].player1 as Any, "player2": teams[effectedIndices[0]].player2 as Any] as [String : Any]
            childUpdates = ["/\(userTeam?.teamId ?? "none")/": valuesUser, "/\(oppTeam?.teamId ?? "none")/": valuesOpp, "/\(teams[effectedIndices[0]].teamId ?? "none")/": valuesEffected1]
        } else if effectedIndices.count == 2 {
            let valuesEffected1 = ["rank": teams[effectedIndices[0]].rank as Any, "wins": teams[effectedIndices[0]].wins as Any, "losses": teams[effectedIndices[0]].losses as Any, "player1": teams[effectedIndices[0]].player1 as Any, "player2": teams[effectedIndices[0]].player2 as Any] as [String : Any]
            let valuesEffected2 = ["rank": teams[effectedIndices[1]].rank as Any, "wins": teams[effectedIndices[1]].wins as Any, "losses": teams[effectedIndices[1]].losses as Any, "player1": teams[effectedIndices[1]].player1 as Any, "player2": teams[effectedIndices[1]].player2 as Any] as [String : Any]
            childUpdates = ["/\(userTeam?.teamId ?? "none")/": valuesUser, "/\(oppTeam?.teamId ?? "none")/": valuesOpp, "/\(teams[effectedIndices[0]].teamId ?? "none")/": valuesEffected1, "/\(teams[effectedIndices[1]].teamId ?? "none")/": valuesEffected2]
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
    
    @objc func resetupviews(action: UIAlertAction) {
        if match.active != 2 {
            disableScores()
        }
    }
    
    func checkScoresValidity() -> Int {
        userWins = 0
        oppWins = 0
        if game1UserScore.text == "" || game1OppScore.text == "" || game2UserScore.text == "" || game2OppScore.text == "" || game3UserScore.text == "" || game3OppScore.text == "" {
            return 1
        } else {
            finalUserScores.append(Int(game1UserScore.text!)!)
            finalOppScores.append(Int(game1OppScore.text!)!)
            finalUserScores.append(Int(game2UserScore.text!)!)
            finalOppScores.append(Int(game2OppScore.text!)!)
            finalUserScores.append(Int(game3UserScore.text!)!)
            finalOppScores.append(Int(game3OppScore.text!)!)
        }
        
        if (finalUserScores[0] < 11 && finalOppScores[0] < 11) || (finalUserScores[1] < 11 && finalOppScores[1] < 11) || (finalUserScores[2] < 11 && finalOppScores[2] < 11) {
            return 2
        } else if (abs(finalUserScores[0] - finalOppScores[0]) < 2) || (abs(finalUserScores[1] - finalOppScores[1]) < 2) || (abs(finalUserScores[2] - finalOppScores[2]) < 2) {
            return 3
        } else {
            for index in 0...2 {
                gameWinners.append(winChecker(user: finalUserScores[index], opp: finalOppScores[index]))
                if gameWinners[index] == 0 {
                    userWins += 1
                } else {
                    oppWins += 1
                }
            }
            if userWins == 3 {
                winner = userTeam?.teamId ?? "no winner"
                finalUserScores.append(0)
                finalOppScores.append(0)
                finalUserScores.append(0)
                finalOppScores.append(0)
                return 0
            } else if oppWins == 3 {
                winner = oppTeam?.teamId ?? "no winner 2"
                finalUserScores.append(0)
                finalOppScores.append(0)
                finalUserScores.append(0)
                finalOppScores.append(0)
                return 0
            }
        }
        
        if game4UserScore.text == "" || game4OppScore.text == "" {
            return 4
        } else {
            finalUserScores.append(Int(game4UserScore.text!)!)
            finalOppScores.append(Int(game4OppScore.text!)!)
        }
        
        if finalUserScores[3] < 11 && finalOppScores[3] < 11 {
            return 2
        } else if abs(finalUserScores[3] - finalOppScores[3]) < 2 {
            return 3
        } else {
            gameWinners.append(winChecker(user: finalUserScores[3], opp: finalOppScores[3]))
            if gameWinners[3] == 0 {
                userWins += 1
            } else {
                oppWins += 1
            }
            
            if userWins == 3 {
                winner = userTeam?.teamId ?? "no winner"
                finalUserScores.append(0)
                finalOppScores.append(0)
                return 0
            } else if oppWins == 3 {
                winner = oppTeam?.teamId ?? "no winner 2"
                finalUserScores.append(0)
                finalOppScores.append(0)
                return 0
            }
        }
        if game5UserScore.text == "" || game5OppScore.text == "" {
            return 5
        } else {
            finalUserScores.append(Int(game5UserScore.text!)!)
            finalOppScores.append(Int(game5OppScore.text!)!)
        }
        
        if finalUserScores[4] < 11 && finalOppScores[4] < 11 {
            return 2
        } else if abs(finalUserScores[4] - finalOppScores[4]) < 2 {
            return 3
        } else {
            gameWinners.append(winChecker(user: finalUserScores[4], opp: finalOppScores[4]))
            if gameWinners[4] == 0 {
                userWins += 1
            } else {
                oppWins += 1
            }
            
            if userWins == 3 {
                winner = userTeam?.teamId ?? "no winner"
                return 0
            } else if oppWins == 3 {
                winner = oppTeam?.teamId ?? "no winner 2"
                return 0
            } else {
                return -1
            }
        }
    }
    
    func winChecker(user: Int, opp: Int) -> Int {
        if user > opp {
            return 0
        } else {
            return 1
        }
    }
    
    func setupViews() {
        userWinner = userTeam?.teamId == match.winner ? 0 : 1
        view.backgroundColor = .white
        
        disableScores()
        
        view.addSubview(backgroundImage)
        backgroundImageCenterYAnchor = backgroundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        backgroundImageCenterYAnchor?.isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalToConstant: 575).isActive = true
        
        let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1045, w: 532, h: 68, wib: 750, hib: 1150, wia: 375, hia: 575)
        if match.active == 0 {
        
        view.addSubview(confirmMatchScoresImage)
        confirmMatchScoresImage.image = UIImage(named: "confirm_match_scores")
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
            print(confirmMatchScoresLoc.W)
            
        } else if match.active == 1 && match.submitter == userTeam?.teamId {
            confirmMatchScoresImage.image = UIImage(named: "waiting_confirm")
            view.addSubview(confirmMatchScoresImage)
            confirmMatchScoresImage.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
            confirmMatchScoresImage.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
            confirmMatchScoresImage.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
            confirmMatchScoresImage.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
        } else if match.active == 1 && match.submitter == oppTeam?.teamId {
            confirmMatchScoresImage.image = UIImage(named: "reject_confirm")
            view.addSubview(confirmMatchScoresImage)
            confirmMatchScoresImage.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
            confirmMatchScoresImage.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
            confirmMatchScoresImage.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
            confirmMatchScoresImage.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
            
            view.addSubview(confirmMatchScores)
            //confirmMatchScores.backgroundColor = .yellow
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
        }
        
        
        let userPlayer1Loc = calculateButtonPosition(x: 375, y: 75, w: 666, h: 85, wib: 750, hib: 1150, wia: 375, hia: 575)
        let user1NameRef = Database.database().reference().child("users").child(userTeam!.player1!)
        user1NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.userPlayer1.text = value["name"] as? String
                self.winnerConfirmed.text = self.userWinner == 0 ? value["name"] as? String : self.winnerConfirmed.text
            }
        })
        
        view.addSubview(userPlayer1)
        userPlayer1.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(userPlayer1Loc.Y)).isActive = true
        userPlayer1.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(userPlayer1Loc.X)).isActive = true
        userPlayer1.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.H)).isActive = true
        userPlayer1.widthAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.W)).isActive = true
        
        let userPlayer2Loc = calculateButtonPosition(x: 375, y: 165, w: 666, h: 85, wib: 750, hib: 1150, wia: 375, hia: 575)
        let user2NameRef = Database.database().reference().child("users").child(userTeam!.player2!)
        user2NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.userPlayer2.text = value["name"] as? String
                self.winnerConfirmed.text = self.userWinner == 0 ? "\(self.winnerConfirmed.text!) & \(value["name"] as? String ?? "none found") Won!" : self.winnerConfirmed.text
            }
        })
        
        view.addSubview(userPlayer2)
        userPlayer2.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(userPlayer2Loc.Y)).isActive = true
        userPlayer2.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(userPlayer2Loc.X)).isActive = true
        userPlayer2.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer2Loc.H)).isActive = true
        userPlayer2.widthAnchor.constraint(equalToConstant: CGFloat(userPlayer2Loc.W)).isActive = true
        
        let oppPlayer1Loc = calculateButtonPosition(x: 375, y: 381, w: 666, h: 85, wib: 750, hib: 1150, wia: 375, hia: 575)
        let opp1NameRef = Database.database().reference().child("users").child(oppTeam!.player1!)
        opp1NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.oppPlayer1.text = value["name"] as? String
                self.winnerConfirmed.text = self.userWinner == 1 ? value["name"] as? String : self.winnerConfirmed.text
            }
        })
        
        view.addSubview(oppPlayer1)
        oppPlayer1.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(oppPlayer1Loc.Y)).isActive = true
        oppPlayer1.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(oppPlayer1Loc.X)).isActive = true
        oppPlayer1.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.H)).isActive = true
        oppPlayer1.widthAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.W)).isActive = true
        
        let oppPlayer2Loc = calculateButtonPosition(x: 375, y: 471, w: 666, h: 85, wib: 750, hib: 1150, wia: 375, hia: 575)
        let opp2NameRef = Database.database().reference().child("users").child(oppTeam!.player2!)
        opp2NameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.oppPlayer2.text = value["name"] as? String
                self.winnerConfirmed.text = self.userWinner == 1 ? "\(self.winnerConfirmed.text!) & \(value["name"] as? String ?? "none found") Won!" : self.winnerConfirmed.text
            }
        })
        
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
        
        if match.active == 2 {
            confirmMatchScoresImage.image = UIImage(named: "winner_confirm")
            view.addSubview(winnerConfirmed)
            winnerConfirmed.text = userTeam?.teamId == match.winner ? "\(userPlayer1.text ?? "nobody") & \(userPlayer2.text ?? "nobody") won!" : "\(oppPlayer1.text ?? "nobody") & \(oppPlayer2.text ?? "nobody") won!"
            winnerConfirmed.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
            winnerConfirmed.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
            winnerConfirmed.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
            winnerConfirmed.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
        }
    }
    
        func disableScores() {
            if match.active ?? 0 > 0 {
                if userIsChallenger == 0 {
                    game1UserScore.text = "\(match.challengerScores![0])"
                    game2UserScore.text = "\(match.challengerScores![1])"
                    game3UserScore.text = "\(match.challengerScores![2])"
                    game4UserScore.text = "\(match.challengerScores![3])"
                    game5UserScore.text = "\(match.challengerScores![4])"
                    game1OppScore.text = "\(match.challengedScores![0])"
                    game2OppScore.text = "\(match.challengedScores![1])"
                    game3OppScore.text = "\(match.challengedScores![2])"
                    game4OppScore.text = "\(match.challengedScores![3])"
                    game5OppScore.text = "\(match.challengedScores![4])"
                } else if userIsChallenger == 1 {
                    game1UserScore.text = "\(match.challengedScores![0])"
                    game2UserScore.text = "\(match.challengedScores![1])"
                    game3UserScore.text = "\(match.challengedScores![2])"
                    game4UserScore.text = "\(match.challengedScores![3])"
                    game5UserScore.text = "\(match.challengedScores![4])"
                    game1OppScore.text = "\(match.challengerScores![0])"
                    game2OppScore.text = "\(match.challengerScores![1])"
                    game3OppScore.text = "\(match.challengerScores![2])"
                    game4OppScore.text = "\(match.challengerScores![3])"
                    game5OppScore.text = "\(match.challengerScores![4])"
                }
        }
            game1UserScore.isUserInteractionEnabled = match.active == 0 ? true : false
            game2UserScore.isUserInteractionEnabled = match.active == 0 ? true : false
            game3UserScore.isUserInteractionEnabled = match.active == 0 ? true : false
            game4UserScore.isUserInteractionEnabled = match.active == 0 ? true : false
            game5UserScore.isUserInteractionEnabled = match.active == 0 ? true : false
            game1OppScore.isUserInteractionEnabled = match.active == 0 ? true : false
            game2OppScore.isUserInteractionEnabled = match.active == 0 ? true : false
            game3OppScore.isUserInteractionEnabled = match.active == 0 ? true : false
            game4OppScore.isUserInteractionEnabled = match.active == 0 ? true : false
            game5OppScore.isUserInteractionEnabled = match.active == 0 ? true : false
    }
    
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
    }
}
