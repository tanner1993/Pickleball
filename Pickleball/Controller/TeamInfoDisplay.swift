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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(challengeButton)
        challengeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        challengeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        challengeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        challengeButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
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
