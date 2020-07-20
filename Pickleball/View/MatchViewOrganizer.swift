//
//  MatchViewOrganizer.swift
//  Pickleball
//
//  Created by Tanner Rozier on 5/7/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import FBSDKShareKit
import Charts
import Firebase

class MatchViewOrganizer: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    var backgroundImageCenterYAnchor: NSLayoutConstraint?
    var confirmMatchScoresWidthAnchor: NSLayoutConstraint?
    var confirmMatchScoresCenterXAnchor: NSLayoutConstraint?
    var rejectMatchScoresWidthAnchor: NSLayoutConstraint?
    var rejectMatchScoresCenterXAnchor: NSLayoutConstraint?
    var whiteCover2HeightAnchor: NSLayoutConstraint?
    var whiteCover2CenterYAnchor: NSLayoutConstraint?
    
    var confirmCheck1CenterYAnchor: NSLayoutConstraint?
    var confirmCheck3CenterYAnchor: NSLayoutConstraint?
    var userPlayer1CenterYAnchor: NSLayoutConstraint?
    var oppPlayer1CenterYAnchor: NSLayoutConstraint?
    var team1_P1_Exp = 0
    var team1_P1_Lev = 0
    var team1_P2_Exp = 0
    var team1_P2_Lev = 0
    var team2_P1_Exp = 0
    var team2_P1_Lev = 0
    var team2_P2_Exp = 0
    var team2_P2_Lev = 0
    
    
    let backgroundImage: UIImageView = {
            let bi = UIImageView()
            bi.translatesAutoresizingMaskIntoConstraints = false
            bi.contentMode = .scaleAspectFit
            bi.image = UIImage(named: "match_info_display2.0")
            bi.isUserInteractionEnabled = true
            return bi
        }()

        let userPlayer1: UIButton = {
            let button = UIButton(type: .system)
            button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
            button.setTitleColor(.white, for: .highlighted)
            button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = 0
            //button.textAlignment = .center
            return button
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
        
        let userPlayer2: UIButton = {
            let button = UIButton(type: .system)
            button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
            button.setTitleColor(.white, for: .highlighted)
            button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = 1
            //button.textAlignment = .center
            return button
        }()
    
    let guestTeammateButton: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.setTitle("Switch from guest?", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.tag = 11
        return button
    }()
    
    let guestOpponentButton: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.setTitle("Switch from guest?", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.tag = 12
        return button
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
        
        let oppPlayer1: UIButton = {
            let button = UIButton(type: .system)
            button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
            button.setTitleColor(.white, for: .highlighted)
            button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = 2
            //button.textAlignment = .center
            return button
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
        
        let oppPlayer2: UIButton = {
            let button = UIButton(type: .system)
            button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
            button.setTitleColor(.white, for: .highlighted)
            button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = 3
            //button.textAlignment = .center
            return button
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
            textField.keyboardType = .numberPad
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = "#"
            textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            textField.textAlignment = .center
            return textField
        }()
        
        let game2UserScore: UITextField = {
            let textField = UITextField()
            textField.keyboardType = .numberPad
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = "#"
            textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            textField.textAlignment = .center
            return textField
        }()
        
        let game3UserScore: UITextField = {
            let textField = UITextField()
            textField.keyboardType = .numberPad
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = "#"
            textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            textField.textAlignment = .center
            return textField
        }()
        
        let game4UserScore: UITextField = {
            let textField = UITextField()
            textField.keyboardType = .numberPad
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = "#"
            textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            textField.textAlignment = .center
            return textField
        }()
        
        let game5UserScore: UITextField = {
            let textField = UITextField()
            textField.keyboardType = .numberPad
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = "#"
            textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            textField.textAlignment = .center
            return textField
        }()
        
        let game1OppScore: UITextField = {
            let textField = UITextField()
            textField.keyboardType = .numberPad
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = "#"
            textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            textField.textAlignment = .center
            return textField
        }()
        
        let game2OppScore: UITextField = {
            let textField = UITextField()
            textField.keyboardType = .numberPad
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = "#"
            textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            textField.textAlignment = .center
            return textField
        }()
        
        let game3OppScore: UITextField = {
            let textField = UITextField()
            textField.keyboardType = .numberPad
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = "#"
            textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            textField.textAlignment = .center
            return textField
        }()
        
        let game4OppScore: UITextField = {
            let textField = UITextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.keyboardType = .numberPad
            textField.placeholder = "#"
            textField.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            textField.textAlignment = .center
            return textField
        }()
        
        let game5OppScore: UITextField = {
            let textField = UITextField()
            textField.keyboardType = .numberPad
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
            //button.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
            return button
        }()
        
        let rejectMatchScores: UIButton = {
            let button = UIButton(type: .system)
            button.setTitleColor(.red, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.translatesAutoresizingMaskIntoConstraints = false
            //button.addTarget(self, action: #selector(handleReject), for: .touchUpInside)
            return button
        }()
        
        let winnerConfirmed: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = " won!"
            label.numberOfLines = 2
            label.font = UIFont(name: "HelveticaNeue", size: 25)
            label.textAlignment = .center
            label.isHidden = true
            return label
        }()
        
        let forfeitLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "The challenged team forfeited!"
            label.isHidden = true
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
        
        let whiteCover2: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let matchStyleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "HelveticaNeue", size: 25)
            label.textAlignment = .center
            return label
        }()
    
    func fillInGameScores() {
        for index in [game1UserScore, game1OppScore, game2UserScore, game2OppScore, game3UserScore, game3OppScore, game4UserScore, game4OppScore, game5UserScore, game5OppScore] {
            if index.text == "" {
                index.text = "0"
            }
        }
    }
    
    func updateGameScores(match: Match2) {
        let scores = [match.team1_scores![0], match.team2_scores![0], match.team1_scores![1], match.team2_scores![1], match.team1_scores![2], match.team2_scores![2]]
        for (index, element) in [game1UserScore, game1OppScore, game2UserScore, game2OppScore, game3UserScore, game3OppScore].enumerated() {
            element.text = "\(scores[index])"
        }
    }
    
    func checkUser(idList: [String]) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        if uid == idList[0] || uid == idList[1] {
            backgroundImage.image = UIImage(named: "match_info_display2.01")
        } else if uid == idList[2] || uid == idList[3] {
            backgroundImage.image = UIImage(named: "match_info_display2.02")
        } else {
            backgroundImage.image = UIImage(named: "match_info_display2.0")
        }
    }
    
    func getPlayerNames(match: Match2) {
        let idList = [match.team_1_player_1!, match.team_1_player_2!, match.team_2_player_1!, match.team_2_player_2!]
        checkUser(idList: idList)
        player.getPlayerNameAndSkill(playerId: idList[0], completion: { (result) in
            guard let playerResult = result else {
                print("failed to get result")
                return
            }
            self.userPlayer1.setTitle(playerResult.name!, for: .normal)
            self.userPlayer1Skill.text = "\(playerResult.skill_level!)"
            self.userPlayer1Level.text = "\(playerResult.halo_level!)"
            self.team1_P1_Exp = playerResult.exp!
            self.team1_P1_Lev = playerResult.halo_level!
            if match.active == 3 && match.winner == 1 {
                if self.winnerConfirmed.text!.count > 5 {
                    self.winnerConfirmed.text = playerResult.name! + " and " + self.winnerConfirmed.text!
                } else {
                    self.winnerConfirmed.text = playerResult.name! + self.winnerConfirmed.text!
                }
            }
        })
        
        player.getPlayerNameAndSkill(playerId: idList[2], completion: { (result) in
            guard let playerResult = result else {
                print("failed to get result")
                return
            }
            self.oppPlayer1.setTitle(playerResult.name!, for: .normal)
            self.oppPlayer1Skill.text = "\(playerResult.skill_level!)"
            self.oppPlayer1Level.text = "\(playerResult.halo_level!)"
            self.team2_P1_Exp = playerResult.exp!
            self.team2_P1_Lev = playerResult.halo_level!
            if match.active == 3 && match.winner == 2 {
                if self.winnerConfirmed.text!.count > 5 {
                    self.winnerConfirmed.text = playerResult.name! + " and " + self.winnerConfirmed.text!
                } else {
                    self.winnerConfirmed.text = playerResult.name! + self.winnerConfirmed.text!
                }
            }
        })
            
        self.userPlayer2.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        self.userPlayer2.isUserInteractionEnabled = true
        player.getPlayerNameAndSkill(playerId: idList[1], completion: { (result) in
            guard let playerResult = result else {
                print("failed to get result")
                return
            }
            self.userPlayer2.setTitle(playerResult.name!, for: .normal)
            self.userPlayer2Skill.text = "\(playerResult.skill_level!)"
            self.userPlayer2Level.text = "\(playerResult.halo_level!)"
            self.team1_P2_Exp = playerResult.exp!
            self.team1_P2_Lev = playerResult.halo_level!
            if match.active == 3 && match.winner == 1 {
                if self.winnerConfirmed.text!.count > 5 {
                    self.winnerConfirmed.text = playerResult.name! + " and " + self.winnerConfirmed.text!
                } else {
                    self.winnerConfirmed.text = playerResult.name! + self.winnerConfirmed.text!
                }
            }
        })
        self.oppPlayer2.setTitle("Guest Player", for: .normal)
        self.oppPlayer2.setTitleColor(.black, for: .normal)
        self.oppPlayer2.isUserInteractionEnabled = false
        self.oppPlayer2.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        self.oppPlayer2.isUserInteractionEnabled = true
        player.getPlayerNameAndSkill(playerId: idList[3], completion: { (result) in
            guard let playerResult = result else {
                print("failed to get result")
                return
            }
            self.oppPlayer2.setTitle(playerResult.name!, for: .normal)
            self.oppPlayer2Skill.text = "\(playerResult.skill_level!)"
            self.oppPlayer2Level.text = "\(playerResult.halo_level!)"
            self.team2_P2_Exp = playerResult.exp!
            self.team2_P2_Lev = playerResult.halo_level!
            if match.active == 3 && match.winner == 2 {
                if self.winnerConfirmed.text!.count > 5 {
                    self.winnerConfirmed.text = playerResult.name! + " and " + self.winnerConfirmed.text!
                } else {
                    self.winnerConfirmed.text = playerResult.name! + self.winnerConfirmed.text!
                }
            }
        })
    }
    
    func setupViews() {
        backgroundColor = .white
        if frame.width < 375 {
            matchStatusLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        }
        
        let matchInfoDisplayHeightBefore: Float = 1164
        let matchInfoDisplayHeightAfter: Float = Float(frame.width) / 0.644
        addSubview(backgroundImage)
        backgroundImageCenterYAnchor = backgroundImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        backgroundImageCenterYAnchor?.isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalToConstant: frame.width / 0.652).isActive = true
        confirmCheck1.isHidden = true
        confirmCheck2.isHidden = true
        confirmCheck3.isHidden = true
        confirmCheck4.isHidden = true
        
        let matchStyleLabelLoc = calculateButtonPosition(x: 375, y: 592, w: 430, h: 84, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
        addSubview(matchStyleLabel)
        matchStyleLabel.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(matchStyleLabelLoc.Y)).isActive = true
        matchStyleLabel.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(matchStyleLabelLoc.X)).isActive = true
        matchStyleLabel.heightAnchor.constraint(equalToConstant: CGFloat(matchStyleLabelLoc.H)).isActive = true
        matchStyleLabel.widthAnchor.constraint(equalToConstant: CGFloat(matchStyleLabelLoc.W)).isActive = true
//        if match.style == 0 {
//            matchStyleLabel.text = "Single Match"
//        } else if match.style == 1 {
//            matchStyleLabel.text = "Best 2 out of 3"
//        } else {
//            matchStyleLabel.text = "Best 3 out of 5"
//        }
        
        let whiteCoverLoc = calculateButtonPosition(x: 479.5, y: 832, w: 275, h: 331, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
        addSubview(whiteCover)
        whiteCover.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(whiteCoverLoc.Y)).isActive = true
        whiteCover.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(whiteCoverLoc.X)).isActive = true
        whiteCover.heightAnchor.constraint(equalToConstant: CGFloat(whiteCoverLoc.H)).isActive = true
        whiteCover.widthAnchor.constraint(equalToConstant: CGFloat(whiteCoverLoc.W)).isActive = true
        
        let whiteCoverLoc2 = calculateButtonPosition(x: 375, y: 865, w: 487, h: 275, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
        addSubview(whiteCover2)
        whiteCover2CenterYAnchor = whiteCover2.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(whiteCoverLoc2.Y))
        whiteCover2CenterYAnchor?.isActive = true
        whiteCover2.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(whiteCoverLoc2.X)).isActive = true
        whiteCover2HeightAnchor = whiteCover2.heightAnchor.constraint(equalToConstant: CGFloat(whiteCoverLoc2.H))
        whiteCover2HeightAnchor?.isActive = true
        whiteCover2.widthAnchor.constraint(equalToConstant: CGFloat(whiteCoverLoc2.W)).isActive = true
            
        let userPlayer1Loc = calculateButtonPosition(x: 211.5, y: 75, w: 327, h: 85, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
        addSubview(userPlayer1)
        userPlayer1CenterYAnchor = userPlayer1.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(userPlayer1Loc.Y))
        userPlayer1CenterYAnchor?.isActive = true
        userPlayer1.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(userPlayer1Loc.X)).isActive = true
        userPlayer1.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.H)).isActive = true
        userPlayer1.widthAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.W)).isActive = true
        
        addSubview(userPlayer1Skill)
        userPlayer1Skill.centerYAnchor.constraint(equalTo: userPlayer1.centerYAnchor).isActive = true
        userPlayer1Skill.leftAnchor.constraint(equalTo: backgroundImage.centerXAnchor, constant: 4).isActive = true
        userPlayer1Skill.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.H)).isActive = true
        userPlayer1Skill.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        
        addSubview(userPlayer1Level)
        userPlayer1Level.centerYAnchor.constraint(equalTo: userPlayer1.centerYAnchor).isActive = true
        userPlayer1Level.leftAnchor.constraint(equalTo: userPlayer1Skill.rightAnchor, constant: 40).isActive = true
        userPlayer1Level.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.H)).isActive = true
        userPlayer1Level.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        
        let oppPlayer1Loc = calculateButtonPosition(x: 211.5, y: 381, w: 327, h: 85, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
        
        addSubview(oppPlayer1)
        oppPlayer1CenterYAnchor = oppPlayer1.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(oppPlayer1Loc.Y))
        oppPlayer1CenterYAnchor?.isActive = true
        oppPlayer1.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(oppPlayer1Loc.X)).isActive = true
        oppPlayer1.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.H)).isActive = true
        oppPlayer1.widthAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.W)).isActive = true
        
        addSubview(oppPlayer1Skill)
        oppPlayer1Skill.centerYAnchor.constraint(equalTo: oppPlayer1.centerYAnchor).isActive = true
        oppPlayer1Skill.leftAnchor.constraint(equalTo: backgroundImage.centerXAnchor, constant: 4).isActive = true
        oppPlayer1Skill.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.H)).isActive = true
        oppPlayer1Skill.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        
        addSubview(oppPlayer1Level)
        oppPlayer1Level.centerYAnchor.constraint(equalTo: oppPlayer1.centerYAnchor).isActive = true
        oppPlayer1Level.leftAnchor.constraint(equalTo: oppPlayer1Skill.rightAnchor, constant: 40).isActive = true
        oppPlayer1Level.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.H)).isActive = true
        oppPlayer1Level.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        
        let confirmCheck1Loc = calculateButtonPosition(x: 666, y: 77, w: 74, h: 74, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
        addSubview(confirmCheck1)
        confirmCheck1CenterYAnchor = confirmCheck1.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmCheck1Loc.Y))
        confirmCheck1CenterYAnchor?.isActive = true
        confirmCheck1.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmCheck1Loc.X)).isActive = true
        confirmCheck1.heightAnchor.constraint(equalToConstant: CGFloat(confirmCheck1Loc.H)).isActive = true
        confirmCheck1.widthAnchor.constraint(equalToConstant: CGFloat(confirmCheck1Loc.W)).isActive = true
        
        let confirmCheck2Loc = calculateButtonPosition(x: 666, y: 163, w: 74, h: 74, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
        addSubview(confirmCheck2)
        confirmCheck2.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmCheck2Loc.Y)).isActive = true
        confirmCheck2.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmCheck2Loc.X)).isActive = true
        confirmCheck2.heightAnchor.constraint(equalToConstant: CGFloat(confirmCheck2Loc.H)).isActive = true
        confirmCheck2.widthAnchor.constraint(equalToConstant: CGFloat(confirmCheck2Loc.W)).isActive = true
        
        let confirmCheck3Loc = calculateButtonPosition(x: 666, y: 383, w: 74, h: 74, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
        addSubview(confirmCheck3)
        confirmCheck3CenterYAnchor = confirmCheck3.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmCheck3Loc.Y))
        confirmCheck3CenterYAnchor?.isActive = true
        confirmCheck3.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmCheck3Loc.X)).isActive = true
        confirmCheck3.heightAnchor.constraint(equalToConstant: CGFloat(confirmCheck3Loc.H)).isActive = true
        confirmCheck3.widthAnchor.constraint(equalToConstant: CGFloat(confirmCheck3Loc.W)).isActive = true
        
        let confirmCheck4Loc = calculateButtonPosition(x: 666, y: 469, w: 74, h: 74, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
        addSubview(confirmCheck4)
        confirmCheck4.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmCheck4Loc.Y)).isActive = true
        confirmCheck4.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmCheck4Loc.X)).isActive = true
        confirmCheck4.heightAnchor.constraint(equalToConstant: CGFloat(confirmCheck4Loc.H)).isActive = true
        confirmCheck4.widthAnchor.constraint(equalToConstant: CGFloat(confirmCheck4Loc.W)).isActive = true
        
        let userPlayer2Loc = calculateButtonPosition(x: 211.5, y: 165, w: 327, h: 85, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
        
        addSubview(userPlayer2)
        userPlayer2.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(userPlayer2Loc.Y)).isActive = true
        userPlayer2.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(userPlayer2Loc.X)).isActive = true
        userPlayer2.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer2Loc.H)).isActive = true
        userPlayer2.widthAnchor.constraint(equalToConstant: CGFloat(userPlayer2Loc.W)).isActive = true
        
        addSubview(guestTeammateButton)
        guestTeammateButton.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(userPlayer2Loc.Y)).isActive = true
        guestTeammateButton.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(userPlayer2Loc.X) + 30).isActive = true
        guestTeammateButton.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer2Loc.H)).isActive = true
        guestTeammateButton.widthAnchor.constraint(equalToConstant: CGFloat(userPlayer2Loc.W) + 60).isActive = true
        
        addSubview(userPlayer2Skill)
        userPlayer2Skill.centerYAnchor.constraint(equalTo: userPlayer2.centerYAnchor).isActive = true
        userPlayer2Skill.leftAnchor.constraint(equalTo: backgroundImage.centerXAnchor, constant: 4).isActive = true
        userPlayer2Skill.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer2Loc.H)).isActive = true
        userPlayer2Skill.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        
        addSubview(userPlayer2Level)
        userPlayer2Level.centerYAnchor.constraint(equalTo: userPlayer2.centerYAnchor).isActive = true
        userPlayer2Level.leftAnchor.constraint(equalTo: userPlayer2Skill.rightAnchor, constant: 40).isActive = true
        userPlayer2Level.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer2Loc.H)).isActive = true
        userPlayer2Level.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        
        let oppPlayer2Loc = calculateButtonPosition(x: 211.5, y: 471, w: 327, h: 85, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
        
        addSubview(oppPlayer2)
        oppPlayer2.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(oppPlayer2Loc.Y)).isActive = true
        oppPlayer2.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(oppPlayer2Loc.X)).isActive = true
        oppPlayer2.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer2Loc.H)).isActive = true
        oppPlayer2.widthAnchor.constraint(equalToConstant: CGFloat(oppPlayer2Loc.W)).isActive = true
        
        addSubview(guestOpponentButton)
        guestOpponentButton.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(oppPlayer2Loc.Y)).isActive = true
        guestOpponentButton.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(oppPlayer2Loc.X) + 30).isActive = true
        guestOpponentButton.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer2Loc.H)).isActive = true
        guestOpponentButton.widthAnchor.constraint(equalToConstant: CGFloat(oppPlayer2Loc.W) + 60).isActive = true
        
        addSubview(oppPlayer2Skill)
        oppPlayer2Skill.centerYAnchor.constraint(equalTo: oppPlayer2.centerYAnchor).isActive = true
        oppPlayer2Skill.leftAnchor.constraint(equalTo: backgroundImage.centerXAnchor, constant: 4).isActive = true
        oppPlayer2Skill.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer2Loc.H)).isActive = true
        oppPlayer2Skill.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        
        addSubview(oppPlayer2Level)
        oppPlayer2Level.centerYAnchor.constraint(equalTo: oppPlayer2.centerYAnchor).isActive = true
        oppPlayer2Level.leftAnchor.constraint(equalTo: oppPlayer2Skill.rightAnchor, constant: 40).isActive = true
        oppPlayer2Level.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer2Loc.H)).isActive = true
        oppPlayer2Level.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
            
//            userPlayer1.font = UIFont(name: "HelveticaNeue-Light", size: 30)
//            oppPlayer1.font = UIFont(name: "HelveticaNeue-Light", size: 30)
//            userPlayer1Skill.font = UIFont(name: "HelveticaNeue", size: 30)
//            oppPlayer1Skill.font = UIFont(name: "HelveticaNeue", size: 30)
//            userPlayer1Level.font = UIFont(name: "HelveticaNeue", size: 30)
//            oppPlayer1Level.font = UIFont(name: "HelveticaNeue", size: 30)
//
//            let confirmCheck1Loc = calculateButtonPosition(x: 666, y: 122, w: 90, h: 90, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
//            addSubview(confirmCheck1)
//            confirmCheck1.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmCheck1Loc.Y)).isActive = true
//            confirmCheck1.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmCheck1Loc.X)).isActive = true
//            confirmCheck1.heightAnchor.constraint(equalToConstant: CGFloat(confirmCheck1Loc.H)).isActive = true
//            confirmCheck1.widthAnchor.constraint(equalToConstant: CGFloat(confirmCheck1Loc.W)).isActive = true
//
//            let confirmCheck3Loc = calculateButtonPosition(x: 666, y: 428, w: 90, h: 90, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
//            addSubview(confirmCheck3)
//            confirmCheck3.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmCheck3Loc.Y)).isActive = true
//            confirmCheck3.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmCheck3Loc.X)).isActive = true
//            confirmCheck3.heightAnchor.constraint(equalToConstant: CGFloat(confirmCheck3Loc.H)).isActive = true
//            confirmCheck3.widthAnchor.constraint(equalToConstant: CGFloat(confirmCheck3Loc.W)).isActive = true
//
//            let userPlayer1Loc = calculateButtonPosition(x: 211.5, y: 120, w: 327, h: 160, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
//            addSubview(userPlayer1)
//            userPlayer1.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(userPlayer1Loc.Y)).isActive = true
//            userPlayer1.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(userPlayer1Loc.X)).isActive = true
//            userPlayer1.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.H)).isActive = true
//            userPlayer1.widthAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.W)).isActive = true
//
//            addSubview(userPlayer1Skill)
//            userPlayer1Skill.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(userPlayer1Loc.Y)).isActive = true
//            userPlayer1Skill.leftAnchor.constraint(equalTo: backgroundImage.centerXAnchor, constant: 4).isActive = true
//            userPlayer1Skill.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.H)).isActive = true
//            userPlayer1Skill.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
//
//            addSubview(userPlayer1Level)
//            userPlayer1Level.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(userPlayer1Loc.Y)).isActive = true
//            userPlayer1Level.leftAnchor.constraint(equalTo: userPlayer1Skill.rightAnchor, constant: 40).isActive = true
//            userPlayer1Level.heightAnchor.constraint(equalToConstant: CGFloat(userPlayer1Loc.H)).isActive = true
//            userPlayer1Level.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
//
//            let oppPlayer1Loc = calculateButtonPosition(x: 211.5, y: 426, w: 327, h: 160, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
//
//            addSubview(oppPlayer1)
//            oppPlayer1.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(oppPlayer1Loc.Y)).isActive = true
//            oppPlayer1.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(oppPlayer1Loc.X)).isActive = true
//            oppPlayer1.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.H)).isActive = true
//            oppPlayer1.widthAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.W)).isActive = true
//
//            addSubview(oppPlayer1Skill)
//            oppPlayer1Skill.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(oppPlayer1Loc.Y)).isActive = true
//            oppPlayer1Skill.leftAnchor.constraint(equalTo: backgroundImage.centerXAnchor, constant: 4).isActive = true
//            oppPlayer1Skill.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.H)).isActive = true
//            oppPlayer1Skill.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
//
//            addSubview(oppPlayer1Level)
//            oppPlayer1Level.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(oppPlayer1Loc.Y)).isActive = true
//            oppPlayer1Level.leftAnchor.constraint(equalTo: oppPlayer1Skill.rightAnchor, constant: 40).isActive = true
//            oppPlayer1Level.heightAnchor.constraint(equalToConstant: CGFloat(oppPlayer1Loc.H)).isActive = true
//            oppPlayer1Level.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
//        }
        
        
        let game1UserScoreLoc = calculateButtonPosition(x: 407.52, y: 698, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
        
        addSubview(game1UserScore)
        game1UserScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game1UserScoreLoc.Y)).isActive = true
        game1UserScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game1UserScoreLoc.X)).isActive = true
        game1UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game1UserScoreLoc.H)).isActive = true
        game1UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game1UserScoreLoc.W)).isActive = true
        
        let game1OppScoreLoc = calculateButtonPosition(x: 549.02, y: 698, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
        
        addSubview(game1OppScore)
        game1OppScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game1OppScoreLoc.Y)).isActive = true
        game1OppScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game1OppScoreLoc.X)).isActive = true
        game1OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game1OppScoreLoc.H)).isActive = true
        game1OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game1OppScoreLoc.W)).isActive = true
        
      //  if match.style! >= 1 {
            let game2UserScoreLoc = calculateButtonPosition(x: 407.52, y: 763, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
            
            addSubview(game2UserScore)
            game2UserScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game2UserScoreLoc.Y)).isActive = true
            game2UserScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game2UserScoreLoc.X)).isActive = true
            game2UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game2UserScoreLoc.H)).isActive = true
            game2UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game2UserScoreLoc.W)).isActive = true
            
            let game2OppScoreLoc = calculateButtonPosition(x: 549.02, y: 763, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
            
            addSubview(game2OppScore)
            game2OppScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game2OppScoreLoc.Y)).isActive = true
            game2OppScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game2OppScoreLoc.X)).isActive = true
            game2OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game2OppScoreLoc.H)).isActive = true
            game2OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game2OppScoreLoc.W)).isActive = true
            
            let game3UserScoreLoc = calculateButtonPosition(x: 407.52, y: 828, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
            
            addSubview(game3UserScore)
            game3UserScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game3UserScoreLoc.Y)).isActive = true
            game3UserScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game3UserScoreLoc.X)).isActive = true
            game3UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game3UserScoreLoc.H)).isActive = true
            game3UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game3UserScoreLoc.W)).isActive = true
            
            let game3OppScoreLoc = calculateButtonPosition(x: 549.02, y: 828, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
            
            addSubview(game3OppScore)
            game3OppScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game3OppScoreLoc.Y)).isActive = true
            game3OppScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game3OppScoreLoc.X)).isActive = true
            game3OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game3OppScoreLoc.H)).isActive = true
            game3OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game3OppScoreLoc.W)).isActive = true
      //  }
      //  if match.style! >= 2 {
            let game4UserScoreLoc = calculateButtonPosition(x: 407.52, y: 893, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
            
            addSubview(game4UserScore)
            game4UserScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game4UserScoreLoc.Y)).isActive = true
            game4UserScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game4UserScoreLoc.X)).isActive = true
            game4UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game4UserScoreLoc.H)).isActive = true
            game4UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game4UserScoreLoc.W)).isActive = true
            
            let game4OppScoreLoc = calculateButtonPosition(x: 549.02, y: 893, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
            
            addSubview(game4OppScore)
            game4OppScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game4OppScoreLoc.Y)).isActive = true
            game4OppScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game4OppScoreLoc.X)).isActive = true
            game4OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game4OppScoreLoc.H)).isActive = true
            game4OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game4OppScoreLoc.W)).isActive = true
            
            let game5UserScoreLoc = calculateButtonPosition(x: 407.52, y: 958, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
            
            addSubview(game5UserScore)
            game5UserScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game5UserScoreLoc.Y)).isActive = true
            game5UserScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game5UserScoreLoc.X)).isActive = true
            game5UserScore.heightAnchor.constraint(equalToConstant: CGFloat(game5UserScoreLoc.H)).isActive = true
            game5UserScore.widthAnchor.constraint(equalToConstant: CGFloat(game5UserScoreLoc.W)).isActive = true
            
            let game5OppScoreLoc = calculateButtonPosition(x: 549.02, y: 958, w: 115, h: 55, wib: 750, hib: matchInfoDisplayHeightBefore, wia: Float(frame.width), hia: matchInfoDisplayHeightAfter)
            
            addSubview(game5OppScore)
            game5OppScore.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(game5OppScoreLoc.Y)).isActive = true
            game5OppScore.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(game5OppScoreLoc.X)).isActive = true
            game5OppScore.heightAnchor.constraint(equalToConstant: CGFloat(game5OppScoreLoc.H)).isActive = true
            game5OppScore.widthAnchor.constraint(equalToConstant: CGFloat(game5OppScoreLoc.W)).isActive = true
        //}
        let confirmMatchScoresLoc = calculateButtonPosition(x: 375, y: 1084, w: 712, h: 126, wib: 750, hib: 1164, wia: Float(frame.width), hia: Float(frame.width) / 0.644)
        addSubview(winnerConfirmed)
        winnerConfirmed.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
        winnerConfirmed.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
        winnerConfirmed.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
        winnerConfirmed.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
        
        addSubview(confirmMatchScores)
        confirmMatchScores.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
        confirmMatchScoresCenterXAnchor = confirmMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X + (confirmMatchScoresLoc.W / 4)))
        confirmMatchScoresCenterXAnchor?.isActive = true
        confirmMatchScores.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
        confirmMatchScoresWidthAnchor = confirmMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W / 2))
        confirmMatchScoresWidthAnchor?.isActive = true
        
        addSubview(rejectMatchScores)
        rejectMatchScores.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
        rejectMatchScoresCenterXAnchor = rejectMatchScores.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X - (confirmMatchScoresLoc.W / 4)))
        rejectMatchScoresCenterXAnchor?.isActive = true
        rejectMatchScores.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
        rejectMatchScoresWidthAnchor = rejectMatchScores.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W / 2))
        rejectMatchScoresWidthAnchor?.isActive = true
        
        addSubview(matchStatusLabel)
        matchStatusLabel.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
        matchStatusLabel.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
        matchStatusLabel.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
        matchStatusLabel.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
        
        addSubview(forfeitLabel)
        forfeitLabel.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmMatchScoresLoc.Y)).isActive = true
        forfeitLabel.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmMatchScoresLoc.X)).isActive = true
        forfeitLabel.heightAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.H)).isActive = true
        forfeitLabel.widthAnchor.constraint(equalToConstant: CGFloat(confirmMatchScoresLoc.W)).isActive = true
        
        addSubview(shareFriendsLabel)
        shareFriendsLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        shareFriendsLabel.centerYAnchor.constraint(equalTo: matchStyleLabel.centerYAnchor).isActive = true
        shareFriendsLabel.rightAnchor.constraint(equalTo: matchStyleLabel.centerXAnchor, constant: 8).isActive = true
        shareFriendsLabel.heightAnchor.constraint(equalTo: matchStyleLabel.heightAnchor).isActive = true
        addSubview(loadImageButton)
        loadImageButton.leftAnchor.constraint(equalTo: shareFriendsLabel.rightAnchor, constant: 6).isActive = true
        loadImageButton.centerYAnchor.constraint(equalTo: matchStyleLabel.centerYAnchor).isActive = true
        loadImageButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        loadImageButton.heightAnchor.constraint(equalTo: matchStyleLabel.heightAnchor, constant: -12).isActive = true
        addSubview(cantLoadImageButton)
        cantLoadImageButton.leftAnchor.constraint(equalTo: shareFriendsLabel.rightAnchor, constant: 6).isActive = true
        cantLoadImageButton.centerYAnchor.constraint(equalTo: matchStyleLabel.centerYAnchor).isActive = true
        cantLoadImageButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        cantLoadImageButton.heightAnchor.constraint(equalTo: matchStyleLabel.heightAnchor, constant: -12).isActive = true
        addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.leftAnchor.constraint(equalTo: loadImageButton.rightAnchor, constant: 4).isActive = true
        shareButton.centerYAnchor.constraint(equalTo: matchStyleLabel.centerYAnchor).isActive = true
        shareButton.isHidden = true
    }
    
    let shareButton = FBShareButton()
    
    let shareFriendsLabel: UILabel = {
        let label = UILabel()
        label.text = "Share this match on Facebook:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()
    
    let loadImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Load", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 15)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loadImage), for: .touchUpInside)
        button.isHidden = true
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        return button
    }()
    
    let cantLoadImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Cant Share to FB", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 15)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        return button
    }()
    
    @objc func loadImage() {
            matchStyleLabel.isHidden = false
            shareFriendsLabel.isHidden = true
            loadImageButton.isHidden = true
            shareButton.isHidden = true
            let shareContent = SharePhoto()
            shareContent.image = takeScreenshot()
            shareContent.isUserGenerated = true
            let sharePhotoContent = SharePhotoContent()
            sharePhotoContent.photos = [shareContent]
            shareButton.shareContent = sharePhotoContent
            matchStyleLabel.isHidden = true
            shareFriendsLabel.isHidden = false
            loadImageButton.isHidden = true
            shareButton.isHidden = false
    }
    
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
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
    
    let player = Player()
    let blackView = UIView()
    
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
            
//            let whichPlayerAmI = match.whichPlayerAmI()
//            switch whichPlayerAmI {
//            case 0:
//                matchViewOrganizer.userPlayer1Level.text = "\(newLevel)"
//            case 1:
//                matchViewOrganizer.userPlayer2Level.text = "\(newLevel)"
//            case 2:
//                matchViewOrganizer.oppPlayer1Level.text = "\(newLevel)"
//            case 3:
//                matchViewOrganizer.oppPlayer2Level.text = "\(newLevel)"
//            default:
//                print("none")
//            }
            
            haloLevel.text = "\(newLevel)"
            pieBackground.addSubview(haloLevel)
            haloLevel.heightAnchor.constraint(equalToConstant: 150).isActive = true
            haloLevel.centerXAnchor.constraint(equalTo: pieBackground.centerXAnchor).isActive = true
            haloLevel.widthAnchor.constraint(equalToConstant: 150).isActive = true
            haloLevel.centerYAnchor.constraint(equalTo: pieBackground.centerYAnchor).isActive = true
            
            pieBackground.addSubview(haloLevelTitle)
            haloLevelTitle.heightAnchor.constraint(equalToConstant: 60).isActive = true
            haloLevelTitle.centerXAnchor.constraint(equalTo: pieBackground.centerXAnchor).isActive = true
            haloLevelTitle.widthAnchor.constraint(equalToConstant: frame.width - 64).isActive = true
            haloLevelTitle.bottomAnchor.constraint(equalTo: pieChart.topAnchor, constant: 15).isActive = true
            
            pieBackground.addSubview(levelUpLabel)
            levelUpLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
            levelUpLabel.centerXAnchor.constraint(equalTo: pieBackground.centerXAnchor).isActive = true
            levelUpLabel.widthAnchor.constraint(equalToConstant: frame.width - 64).isActive = true
            levelUpLabel.bottomAnchor.constraint(equalTo: haloLevelTitle.topAnchor, constant: 0).isActive = true
            
            pieBackground.addSubview(haloLevelTitle3)
            haloLevelTitle3.heightAnchor.constraint(equalToConstant: 80).isActive = true
            haloLevelTitle3.centerXAnchor.constraint(equalTo: pieBackground.centerXAnchor).isActive = true
            haloLevelTitle3.widthAnchor.constraint(equalToConstant: frame.width - 64).isActive = true
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
