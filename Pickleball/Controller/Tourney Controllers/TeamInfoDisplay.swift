//
//  TeamInfoDisplay.swift
//  Pickleball
//
//  Created by Tanner Rozier on 11/19/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class TeamInfoDisplay: UIViewController {

    var teamIdSelected = Team()
    var usersTeamId = Team()
    var tourneyId: String = ""
    var player = Player()
    var active = -1
    var tourneyCantChallenge = [String]()
    var tourneyYetToViewMatch = [String]()
    
    let challengeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitle("Challenge Team", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 30)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleChallengeConfirmed), for: .touchUpInside)
        return button
    }()
    
    let player1Button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePlayer1), for: .touchUpInside)
        return button
    }()
    
    let player2Button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePlayer2), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlayer1() {
        let playerProfile = StartupPage()
        playerProfile.playerId = teamIdSelected.player1 ?? "none"
        playerProfile.isFriend = 3
        navigationController?.pushViewController(playerProfile, animated: true)
    }
    
    @objc func handlePlayer2() {
        let playerProfile = StartupPage()
        playerProfile.playerId = teamIdSelected.player2 ?? "none"
        playerProfile.isFriend = 3
        navigationController?.pushViewController(playerProfile, animated: true)
    }
    
    let player1Label: UILabel = {
        let label = UILabel()
        label.text = "Player 1"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let whiteBox: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let playerInitials: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        label.textColor = .white
        label.layer.cornerRadius = 35
        label.layer.masksToBounds = true
        label.font = UIFont(name: "HelveticaNeue", size: 36)
        label.textAlignment = .center
        return label
    }()
    
    let skillLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4.0"
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue", size: 22)
        label.textAlignment = .left
        return label
    }()
    
    let appLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "12"
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue", size: 22)
        label.textAlignment = .left
        return label
    }()
    
    let playerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "playerName"
        label.font = UIFont(name: "HelveticaNeue", size: 22)
        label.textAlignment = .left
        return label
    }()
    
    let player2Label: UILabel = {
        let label = UILabel()
        label.text = "Player 2"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let whiteBox2: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let playerInitials2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        label.textColor = .white
        label.layer.cornerRadius = 35
        label.layer.masksToBounds = true
        label.font = UIFont(name: "HelveticaNeue", size: 36)
        label.textAlignment = .center
        return label
    }()
    
    let skillLevel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4.0"
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue", size: 22)
        label.textAlignment = .left
        return label
    }()
    
    let appLevel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "12"
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue", size: 22)
        label.textAlignment = .left
        return label
    }()
    
    let playerName2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "playerName"
        label.font = UIFont(name: "HelveticaNeue", size: 22)
        label.textAlignment = .left
        return label
    }()
    
    let matchesWon: UILabel = {
        let label = UILabel()
        label.text = "W: 5"
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .right
        return label
    }()
    
    let matchesLost: UILabel = {
        let label = UILabel()
        label.text = "W: 5"
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .right
        return label
    }()
    
    let matchesWon2: UILabel = {
        let label = UILabel()
        label.text = "W: 5"
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .right
        return label
    }()
    
    let matchesLost2: UILabel = {
        let label = UILabel()
        label.text = "W: 5"
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .right
        return label
    }()
    
    let teamWins: UILabel = {
        let label = UILabel()
        label.text = "Team Wins:"
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 40)
        label.textAlignment = .left
        return label
    }()
    
    let teamLosses: UILabel = {
        let label = UILabel()
        label.text = "Team Losses:"
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 40)
        label.textAlignment = .left
        return label
    }()
    
    let currentRank: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.text = "Current Rank:"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 40)
        label.textAlignment = .left
        return label
    }()
    
    let teamWinsAct: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 45)
        label.textAlignment = .right
        return label
    }()
    
    let teamLossesAct: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 45)
        label.textAlignment = .right
        return label
    }()
    
    let currentRankAct: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 45)
        label.textAlignment = .right
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        if teamIdSelected != usersTeamId {
            observeTourneyInfo()
        }
        setupNavbar()
        setupViews()
        fetchPlayer1()
        fetchPlayer2()
    }
    
    func setupForCorrectStage(active1: Int, cantChallenge: [String]) {
        tourneyCantChallenge = cantChallenge
        active = active1
        scrollView.addSubview(challengeButton)
        challengeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        challengeButton.topAnchor.constraint(equalTo: currentRankAct.bottomAnchor, constant: 50).isActive = true
        challengeButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        challengeButton.widthAnchor.constraint(equalToConstant: 290).isActive = true
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        if active == 0 {
            
            challengeButton.alpha = 0.2
            
        } else if active == 1 && (cantChallenge.contains(uid) == true || cantChallenge.contains(teamIdSelected.player1 ?? "none") == true) {
            challengeButton.alpha = 0.2
        } else if active == 2 || active == 3 || active == 4 || active == 5 {
            challengeButton.alpha = 0.2
        } else if active == 6 {
            challengeButton.isHidden = true
        }
    }
    
    func observeTourneyInfo() {
        let ref = Database.database().reference().child("tourneys").child(tourneyId)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let tourneyActive = value["active"] as? Int ?? -1
                let cantChallenge = value["cant_challenge"] as? [String] ?? [String]()
                self.setupForCorrectStage(active1: tourneyActive, cantChallenge: cantChallenge)
            }
        }, withCancel: nil)
    }
    
    func fetchPlayer1() {
        let player1Id = teamIdSelected.player1 ?? "none"
        let ref = Database.database().reference().child("users").child(player1Id)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? NSDictionary {
                
                let normalSkill = "Rating: "
                let boldSkill = "\(value["skill_level"] as? Float ?? 0)"
                let attributedSkill = NSMutableAttributedString(string: normalSkill)
                let attrb = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 23), NSAttributedString.Key.foregroundColor : UIColor.init(r: 88, g: 148, b: 200)]
                let boldSkillString = NSAttributedString(string: boldSkill, attributes: attrb as [NSAttributedString.Key : Any])
                attributedSkill.append(boldSkillString)
                self.skillLevel.attributedText = attributedSkill
                let exp = value["exp"] as? Int ?? 0
                
                let normalApp = "PR: "
                let boldApp = "\(self.player.haloLevel(exp: exp))"
                let attributedApp = NSMutableAttributedString(string: normalApp)
                let attrb2 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 23), NSAttributedString.Key.foregroundColor : UIColor.init(r: 120, g: 207, b: 138)]
                let boldAppString = NSAttributedString(string: boldApp, attributes: attrb2 as [NSAttributedString.Key : Any])
                attributedApp.append(boldAppString)
                self.appLevel.attributedText = attributedApp
                self.playerName.text = value["username"] as? String ?? "no name"
                self.matchesWon.text = "W: \(value["match_wins"] as? Int ?? 0)"
                self.matchesLost.text = "L: \(value["match_losses"] as? Int ?? 0)"
                self.playerInitials.text = self.getInitials(name: self.playerName.text ?? "none")
            }
        }, withCancel: nil)
    }
    
    func getInitials(name: String) -> String {
        var initials = ""
        var finalChar = 0
        for (index, char) in name.enumerated() {
            if index == 0 {
                initials.append(char)
            }
            if finalChar == 1 {
                initials.append(char)
                break
            }
            
            if char == " " {
                finalChar = 1
            }
        }
        return initials
    }
    
    func fetchPlayer2() {
        let player2Id = teamIdSelected.player2 ?? "none"
        let ref = Database.database().reference().child("users").child(player2Id)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let normalSkill = "Rating: "
                let boldSkill = "\(value["skill_level"] as? Float ?? 0)"
                let attributedSkill = NSMutableAttributedString(string: normalSkill)
                let attrb = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 23), NSAttributedString.Key.foregroundColor : UIColor.init(r: 88, g: 148, b: 200)]
                let boldSkillString = NSAttributedString(string: boldSkill, attributes: attrb as [NSAttributedString.Key : Any])
                attributedSkill.append(boldSkillString)
                self.skillLevel2.attributedText = attributedSkill
                let exp = value["exp"] as? Int ?? 0
                
                let normalApp = "PR: "
                let boldApp = "\(self.player.haloLevel(exp: exp))"
                let attributedApp = NSMutableAttributedString(string: normalApp)
                let attrb2 = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 23), NSAttributedString.Key.foregroundColor : UIColor.init(r: 120, g: 207, b: 138)]
                let boldAppString = NSAttributedString(string: boldApp, attributes: attrb2 as [NSAttributedString.Key : Any])
                attributedApp.append(boldAppString)
                self.appLevel2.attributedText = attributedApp
                self.playerName2.text = value["username"] as? String ?? "no name"
                self.matchesWon2.text = "W: \(value["match_wins"] as? Int ?? 0)"
                self.matchesLost2.text = "L: \(value["match_losses"] as? Int ?? 0)"
                self.playerInitials2.text = self.getInitials(name: self.playerName2.text ?? "none")
            }
        }, withCancel: nil)
    }
    
    func setupNavbar() {
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        titleLabel.text = "Team Info"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        self.navigationItem.titleView = titleLabel
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isScrollEnabled = true
        sv.backgroundColor = .white
        sv.minimumZoomScale = 1.0
        //sv.maximumZoomScale = 2.5
        return sv
    }()
    
    func setupViews() {
        scrollView.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        let Width = Float(view.frame.width)
        scrollView.contentSize = CGSize(width: Double(Width), height: Double(600))
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Player 1", attributes: underlineAttribute)
        let underlineAttributedString2 = NSAttributedString(string: "Player 2", attributes: underlineAttribute)
        player1Label.attributedText = underlineAttributedString
        player2Label.attributedText = underlineAttributedString2
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        scrollView.addSubview(player1Label)
        player1Label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        player1Label.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        player1Label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        player1Label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        scrollView.addSubview(whiteBox)
        whiteBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        whiteBox.topAnchor.constraint(equalTo: player1Label.bottomAnchor, constant: 5).isActive = true
        whiteBox.heightAnchor.constraint(equalToConstant: 80).isActive = true
        whiteBox.widthAnchor.constraint(equalToConstant: view.frame.width - 24).isActive = true
        
        whiteBox.addSubview(playerInitials)
        playerInitials.topAnchor.constraint(equalTo: whiteBox.topAnchor, constant: 5).isActive = true
        playerInitials.leftAnchor.constraint(equalTo: whiteBox.leftAnchor, constant: 4).isActive = true
        playerInitials.heightAnchor.constraint(equalToConstant: 70).isActive = true
        playerInitials.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        whiteBox.addSubview(playerName)
        playerName.topAnchor.constraint(equalTo: whiteBox.topAnchor).isActive = true
        playerName.leftAnchor.constraint(equalTo: playerInitials.rightAnchor, constant: 4).isActive = true
        playerName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playerName.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        whiteBox.addSubview(skillLevel)
        skillLevel.topAnchor.constraint(equalTo: playerName.bottomAnchor).isActive = true
        skillLevel.leftAnchor.constraint(equalTo: playerName.leftAnchor).isActive = true
        skillLevel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        if view.frame.width < 375 {
            skillLevel.font = UIFont(name: "HelveticaNeue", size: 17)
            skillLevel2.font = UIFont(name: "HelveticaNeue", size: 17)
            appLevel.font = UIFont(name: "HelveticaNeue", size: 17)
            appLevel2.font = UIFont(name: "HelveticaNeue", size: 17)
            skillLevel.widthAnchor.constraint(equalToConstant: 91).isActive = true
        } else {
            skillLevel.widthAnchor.constraint(equalToConstant: 110).isActive = true
        }
        
        whiteBox.addSubview(matchesWon)
        matchesWon.topAnchor.constraint(equalTo: whiteBox.topAnchor).isActive = true
        matchesWon.widthAnchor.constraint(equalToConstant: 68).isActive = true
        matchesWon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        matchesWon.rightAnchor.constraint(equalTo: whiteBox.rightAnchor, constant: -8).isActive = true
        
        whiteBox.addSubview(matchesLost)
        matchesLost.topAnchor.constraint(equalTo: matchesWon.bottomAnchor).isActive = true
        matchesLost.widthAnchor.constraint(equalToConstant: 68).isActive = true
        matchesLost.heightAnchor.constraint(equalToConstant: 30).isActive = true
        matchesLost.rightAnchor.constraint(equalTo: whiteBox.rightAnchor, constant: -8).isActive = true
        
        whiteBox.addSubview(appLevel)
        appLevel.topAnchor.constraint(equalTo: playerName.bottomAnchor).isActive = true
        appLevel.leftAnchor.constraint(equalTo: skillLevel.rightAnchor, constant: 5).isActive = true
        appLevel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        appLevel.rightAnchor.constraint(equalTo: matchesLost.leftAnchor).isActive = true
        
        scrollView.addSubview(player2Label)
        player2Label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        player2Label.topAnchor.constraint(equalTo: whiteBox.bottomAnchor, constant: 28).isActive = true
        player2Label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        player2Label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        scrollView.addSubview(whiteBox2)
        whiteBox2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        whiteBox2.topAnchor.constraint(equalTo: player2Label.bottomAnchor, constant: 5).isActive = true
        whiteBox2.heightAnchor.constraint(equalToConstant: 80).isActive = true
        whiteBox2.widthAnchor.constraint(equalToConstant: view.frame.width - 24).isActive = true
        
        whiteBox2.addSubview(playerInitials2)
        playerInitials2.topAnchor.constraint(equalTo: whiteBox2.topAnchor, constant: 5).isActive = true
        playerInitials2.leftAnchor.constraint(equalTo: whiteBox2.leftAnchor, constant: 4).isActive = true
        playerInitials2.heightAnchor.constraint(equalToConstant: 70).isActive = true
        playerInitials2.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        whiteBox2.addSubview(playerName2)
        playerName2.topAnchor.constraint(equalTo: whiteBox2.topAnchor).isActive = true
        playerName2.leftAnchor.constraint(equalTo: playerInitials2.rightAnchor, constant: 4).isActive = true
        playerName2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playerName2.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        whiteBox2.addSubview(skillLevel2)
        skillLevel2.topAnchor.constraint(equalTo: playerName2.bottomAnchor).isActive = true
        skillLevel2.leftAnchor.constraint(equalTo: playerName2.leftAnchor).isActive = true
        skillLevel2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        skillLevel2.widthAnchor.constraint(equalToConstant: 110).isActive = true
        if view.frame.width < 375 {
            skillLevel2.widthAnchor.constraint(equalToConstant: 91).isActive = true
        } else {
            skillLevel2.widthAnchor.constraint(equalToConstant: 110).isActive = true
        }
        
        whiteBox2.addSubview(appLevel2)
        appLevel2.topAnchor.constraint(equalTo: playerName2.bottomAnchor).isActive = true
        appLevel2.leftAnchor.constraint(equalTo: skillLevel2.rightAnchor, constant: 5).isActive = true
        appLevel2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        appLevel2.rightAnchor.constraint(equalTo: matchesLost.leftAnchor).isActive = true
        
        whiteBox2.addSubview(matchesWon2)
        matchesWon2.topAnchor.constraint(equalTo: whiteBox2.topAnchor).isActive = true
        matchesWon2.widthAnchor.constraint(equalToConstant: 68).isActive = true
        matchesWon2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        matchesWon2.rightAnchor.constraint(equalTo: whiteBox2.rightAnchor, constant: -8).isActive = true
        
        whiteBox2.addSubview(matchesLost2)
        matchesLost2.topAnchor.constraint(equalTo: matchesWon2.bottomAnchor).isActive = true
        matchesLost2.widthAnchor.constraint(equalToConstant: 68).isActive = true
        matchesLost2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        matchesLost2.rightAnchor.constraint(equalTo: whiteBox2.rightAnchor, constant: -8).isActive = true
        
        scrollView.addSubview(teamWins)
        teamWins.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        teamWins.topAnchor.constraint(equalTo: whiteBox2.bottomAnchor, constant: 30).isActive = true
        teamWins.heightAnchor.constraint(equalToConstant: 45).isActive = true
        teamWins.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3 + 20).isActive = true
        
        scrollView.addSubview(teamLosses)
        teamLosses.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        teamLosses.topAnchor.constraint(equalTo: teamWins.bottomAnchor, constant: 15).isActive = true
        teamLosses.heightAnchor.constraint(equalToConstant: 45).isActive = true
        teamLosses.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3 + 20).isActive = true
        
        scrollView.addSubview(currentRank)
        currentRank.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        currentRank.topAnchor.constraint(equalTo: teamLosses.bottomAnchor, constant: 15).isActive = true
        currentRank.heightAnchor.constraint(equalToConstant: 45).isActive = true
        currentRank.widthAnchor.constraint(equalToConstant: view.frame.width * 2 / 3 + 20).isActive = true
        
        teamWinsAct.text = "\(teamIdSelected.wins ?? 0)"
        teamLossesAct.text = "\(teamIdSelected.losses ?? 0)"
        currentRankAct.text = "\(teamIdSelected.rank ?? 0)"
        
        scrollView.addSubview(teamWinsAct)
        teamWinsAct.leftAnchor.constraint(equalTo: teamWins.rightAnchor).isActive = true
        teamWinsAct.topAnchor.constraint(equalTo: whiteBox2.bottomAnchor, constant: 30).isActive = true
        teamWinsAct.heightAnchor.constraint(equalToConstant: 45).isActive = true
        teamWinsAct.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        scrollView.addSubview(teamLossesAct)
        teamLossesAct.leftAnchor.constraint(equalTo: teamWins.rightAnchor).isActive = true
        teamLossesAct.topAnchor.constraint(equalTo: teamWins.bottomAnchor, constant: 15).isActive = true
        teamLossesAct.heightAnchor.constraint(equalToConstant: 45).isActive = true
        teamLossesAct.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        scrollView.addSubview(currentRankAct)
        currentRankAct.leftAnchor.constraint(equalTo: teamWins.rightAnchor).isActive = true
        currentRankAct.topAnchor.constraint(equalTo: teamLosses.bottomAnchor, constant: 15).isActive = true
        currentRankAct.heightAnchor.constraint(equalToConstant: 45).isActive = true
        currentRankAct.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        scrollView.addSubview(player1Button)
        player1Button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        player1Button.topAnchor.constraint(equalTo: player1Label.bottomAnchor, constant: 5).isActive = true
        player1Button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        player1Button.widthAnchor.constraint(equalToConstant: view.frame.width - 24).isActive = true
        
        scrollView.addSubview(player2Button)
        player2Button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        player2Button.topAnchor.constraint(equalTo: player2Label.bottomAnchor, constant: 5).isActive = true
        player2Button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        player2Button.widthAnchor.constraint(equalToConstant: view.frame.width - 24).isActive = true
    }
    
    @objc func handleChallengeConfirmed() {
        if active == 5 {
            let newalert = UIAlertController(title: "No can do", message: "The ladder is over, now it's finals!", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        } else if active >= 2 {
            let newalert = UIAlertController(title: "No can do", message: "The ladder is over, now it's semifinals!", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        } else if active == 0 {
            let newalert = UIAlertController(title: "No can do", message: "The Tourney has not begun yet! Once it begins, challenge away.", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        if tourneyCantChallenge.contains(uid) == true {
            let newalert = UIAlertController(title: "Impossible", message: "You already have an open match in this tourney, complete that then challenge them!", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        if tourneyCantChallenge.contains(teamIdSelected.player1 ?? "none") == true {
            let newalert = UIAlertController(title: "Impossible", message: "This team still has an open match, once they finish that, then you can challenge them", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        
        if abs(teamIdSelected.rank! - usersTeamId.rank!) > 3 {
            let newalert = UIAlertController(title: "Not gonna happen", message: "You can only challenge teams that are within a rank of 3 from you", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        
        guard let team_1_player_1 = self.usersTeamId.player1 else {
            return
        }
        guard let team_1_player_2 = self.usersTeamId.player2 else {
            return
        }
        guard let team_2_player_1 = self.teamIdSelected.player1 else {
            return
        }
        guard let team_2_player_2 = self.teamIdSelected.player2 else {
            return
        }
        tourneyCantChallenge.append(team_1_player_1)
        tourneyCantChallenge.append(team_1_player_2)
        tourneyCantChallenge.append(team_2_player_1)
        tourneyCantChallenge.append(team_2_player_2)
        team_1_player_1 != uid ? tourneyYetToViewMatch.append(team_1_player_1) : print("yep")
        team_1_player_2 != uid ? tourneyYetToViewMatch.append(team_1_player_2) : print("yep")
        team_2_player_1 != uid ? tourneyYetToViewMatch.append(team_2_player_1) : print("yep")
        team_2_player_2 != uid ? tourneyYetToViewMatch.append(team_2_player_2) : print("yep")
        
        let timeOfChallenge = Date().timeIntervalSince1970
        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("matches")
        let createMatchRef = ref.childByAutoId()
        let values = ["active": 0, "team_1_player_1": team_1_player_1, "team_1_player_2": team_1_player_2, "team_2_player_1": team_2_player_1, "team_2_player_2": team_2_player_2, "team1_scores": [1, 1, 0, 0, 0], "team2_scores": [0, 0, 0, 0, 0], "time": timeOfChallenge] as [String : Any]
        createMatchRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            
            
                
                let notificationsRef = Database.database().reference()
            let childUpdates = ["/\("tourney_notifications")/\(team_1_player_1)/\(self.tourneyId)/": team_1_player_1 == uid ? 0 : 1, "/\("tourney_notifications")/\(team_1_player_2)/\(self.tourneyId)/": team_1_player_2 == uid ? 0 : 1, "/\("tourney_notifications")/\(team_2_player_1)/\(self.tourneyId)/": team_2_player_1 == uid ? 0 : 1, "/\("tourney_notifications")/\(team_2_player_2)/\(self.tourneyId)/": team_2_player_2 == uid ? 0 : 1, "/\("tourneys")/\(self.tourneyId)/\("cant_challenge")/": self.tourneyCantChallenge, "/\("tourneys")/\(self.tourneyId)/\("yet_to_view")/": self.tourneyYetToViewMatch] as [String : Any]
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
                    self.challengeButton.alpha = 0.2
                    let newalert = UIAlertController(title: "Challenge Made", message: "Check 'My Matches' to view the challenge you made and enter the scores", preferredStyle: UIAlertController.Style.alert)
                    newalert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(newalert, animated: true, completion: nil)
                    
                    
                })
            
        })
    }

}
