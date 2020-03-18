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
    
    let challengeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 150, g: 0, b: 0)
        button.setTitle("Challenge", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleChallengeConfirmed), for: .touchUpInside)
        return button
    }()
    
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
        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        return label
    }()
    
    let appLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "12"
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        return label
    }()
    
    let playerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "playerName"
        label.font = UIFont(name: "HelveticaNeue", size: 19)
        label.textAlignment = .left
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        
        setupNavbar()
        setupViews()
    }
    
    func setupNavbar() {
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        titleLabel.text = "Team Info"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.navigationItem.titleView = titleLabel
    }
    
    func setupViews() {
        
        view.addSubview(player1Label)
        player1Label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        player1Label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        player1Label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        player1Label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        view.addSubview(whiteBox)
        whiteBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        whiteBox.topAnchor.constraint(equalTo: player1Label.bottomAnchor, constant: 20).isActive = true
        whiteBox.heightAnchor.constraint(equalToConstant: 104).isActive = true
        whiteBox.widthAnchor.constraint(equalToConstant: view.frame.width - 24).isActive = true
        
        whiteBox.addSubview(playerInitials)
        playerInitials.topAnchor.constraint(equalTo: whiteBox.topAnchor, constant: 4).isActive = true
        playerInitials.leftAnchor.constraint(equalTo: whiteBox.leftAnchor, constant: 4).isActive = true
        playerInitials.heightAnchor.constraint(equalToConstant: 70).isActive = true
        playerInitials.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        whiteBox.addSubview(playerName)
        playerName.topAnchor.constraint(equalTo: whiteBox.topAnchor).isActive = true
        playerName.leftAnchor.constraint(equalTo: playerInitials.rightAnchor, constant: 4).isActive = true
        playerName.heightAnchor.constraint(equalToConstant: 52).isActive = true
        playerName.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        whiteBox.addSubview(skillLevel)
        skillLevel.topAnchor.constraint(equalTo: playerName.bottomAnchor).isActive = true
        skillLevel.leftAnchor.constraint(equalTo: playerName.leftAnchor).isActive = true
        skillLevel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        skillLevel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        whiteBox.addSubview(appLevel)
        appLevel.topAnchor.constraint(equalTo: playerName.bottomAnchor).isActive = true
        appLevel.leftAnchor.constraint(equalTo: skillLevel.rightAnchor, constant: 15).isActive = true
        appLevel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        appLevel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
//        view.addSubview(challengeButton)
//        challengeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        challengeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
//        challengeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        challengeButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    @objc func handleChallengeConfirmed() {
        print("challenge confirmed")
        let timeOfChallenge = Date().timeIntervalSince1970
        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("matches")
        let createMatchInTourneyRef = ref.childByAutoId()
        let values = ["active": 0, "challenger_team": usersTeamId.teamId as Any, "challenged_team": teamIdSelected.teamId as Any, "challenger_scores": [0, 0, 0, 0, 0], "challenged_scores": [0, 0, 0, 0, 0], "time": timeOfChallenge] as [String : Any]
        createMatchInTourneyRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            guard let challengerPlayer1Id = self.usersTeamId.player1 else {
                return
            }
            guard let challengerPlayer2Id = self.usersTeamId.player2 else {
                return
            }
            guard let challengedPlayer1Id = self.teamIdSelected.player1 else {
                return
            }
            guard let challengedPlayer2Id = self.teamIdSelected.player2 else {
                return
            }
            guard let matchId = createMatchInTourneyRef.key else {
                return
            }
            
            let notifiedPlayers = [challengerPlayer1Id, challengerPlayer2Id, challengedPlayer1Id, challengedPlayer2Id]
            for index in notifiedPlayers {
                let userNotificationsRef = Database.database().reference().child("user-notifications").child(index)
                userNotificationsRef.updateChildValues([matchId: self.tourneyId])
            }
            
            print("Data saved successfully!")
            
            
        })
    }

}
