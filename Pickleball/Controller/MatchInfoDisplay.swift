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

    var userTeamId: String = ""
    var userTeamPlayer1Name: String?
    var userTeamPlayer2Name: String?
    var oppTeamId: String = ""
    var oppTeamPlayer1Name: String?
    var oppTeamPlayer2Name: String?
    var tourneyId: String = ""
    var match = Match()
    var finalUserScores = [Int]()
    var finalOppScores = [Int]()
    var gameWinners = [Int]()
    var winner = "nobody"
    var userWins = 0
    var oppWins = 0
    var userIsChallenger = 0
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    @objc func handleConfirmScores() {
        confirmMatchScores.flash()
        finalUserScores.removeAll()
        finalOppScores.removeAll()
        gameWinners.removeAll()
        let scoresValidation = checkScoresValidity()
        
        switch scoresValidation {
        case 0:
            let ref = Database.database().reference().child("tourneys").child(tourneyId).child("matches").child(match.matchId ?? "")
            ref.updateChildValues(["challenger_scores": userIsChallenger == 0 ? finalUserScores : finalOppScores], withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if let error = error {
                    print("Data could not be saved: \(error).")
                    return
                }
                
                print("Data saved successfully!")
                
                
            })
            ref.updateChildValues(["challenged_scores": userIsChallenger == 0 ? finalOppScores : finalUserScores], withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if let error = error {
                    print("Data could not be saved: \(error).")
                    return
                }
                
                print("Data saved successfully!")
                
                
            })
            let newalert = UIAlertController(title: "Awesome", message: "\(winner)", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
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
                winner = "You won!"
                finalUserScores.append(0)
                finalOppScores.append(0)
                finalUserScores.append(0)
                finalOppScores.append(0)
                return 0
            } else if oppWins == 3 {
                winner = "You Lost!"
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
                winner = "You won!"
                finalUserScores.append(0)
                finalOppScores.append(0)
                return 0
            } else if oppWins == 3 {
                winner = "You Lost!"
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
                winner = "You won!"
                return 0
            } else if oppWins == 3 {
                winner = "You Lost!"
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
        view.backgroundColor = .white
        
        view.addSubview(backgroundImage)
        backgroundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalToConstant: 575).isActive = true
        
        let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1045, w: 532, h: 68, wib: 750, hib: 1150, wia: 375, hia: 575)
        
        view.addSubview(confirmMatchScores)
        confirmMatchScores.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
        confirmMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
        confirmMatchScores.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
        confirmMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
        
        let userPlayer1Loc = calculateButtonPosition(x: 375, y: 75, w: 666, h: 85, wib: 750, hib: 1150, wia: 375, hia: 575)
        userPlayer1.text = userTeamPlayer1Name!
        
        view.addSubview(userPlayer1)
        userPlayer1.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(userPlayer1Loc.Y)).isActive = true
        userPlayer1.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(userPlayer1Loc.X)).isActive = true
        userPlayer1.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.H)).isActive = true
        userPlayer1.widthAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.W)).isActive = true
        
        let userPlayer2Loc = calculateButtonPosition(x: 375, y: 165, w: 666, h: 85, wib: 750, hib: 1150, wia: 375, hia: 575)
        userPlayer2.text = userTeamPlayer2Name!
        
        view.addSubview(userPlayer2)
        userPlayer2.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(userPlayer2Loc.Y)).isActive = true
        userPlayer2.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(userPlayer2Loc.X)).isActive = true
        userPlayer2.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer2Loc.H)).isActive = true
        userPlayer2.widthAnchor.constraint(equalToConstant: CGFloat(userPlayer2Loc.W)).isActive = true
        
        let oppPlayer1Loc = calculateButtonPosition(x: 375, y: 381, w: 666, h: 85, wib: 750, hib: 1150, wia: 375, hia: 575)
        oppPlayer1.text = oppTeamPlayer1Name!
        
        view.addSubview(oppPlayer1)
        oppPlayer1.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(oppPlayer1Loc.Y)).isActive = true
        oppPlayer1.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(oppPlayer1Loc.X)).isActive = true
        oppPlayer1.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.H)).isActive = true
        oppPlayer1.widthAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.W)).isActive = true
        
        let oppPlayer2Loc = calculateButtonPosition(x: 375, y: 471, w: 666, h: 85, wib: 750, hib: 1150, wia: 375, hia: 575)
        oppPlayer2.text = oppTeamPlayer2Name!
        
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

    
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
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
}
