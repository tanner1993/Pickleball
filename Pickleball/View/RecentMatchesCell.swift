//
//  RecentMatchesCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/6/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RecentMatchesCell: BaseCell {
    var teams = [Team]() {
        didSet {
            for index in teams {
                if index.teamId == match?.challengerTeamId {
                    
                    let player1ref = Database.database().reference().child("users").child(index.player1 ?? "nope")
                    player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
                        if let value = snapshot.value as? [String: AnyObject] {
                            self.challengerTeam1.text = value["name"] as? String
                        }
                    })
                    
                    let player2ref = Database.database().reference().child("users").child(index.player2 ?? "nope")
                    player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
                        if let value = snapshot.value as? [String: AnyObject] {
                            self.challengerTeam2.text = value["name"] as? String
                        }
                    })

                }
                if index.teamId == match?.challengedTeamId {
                    let player1ref = Database.database().reference().child("users").child(index.player1 ?? "nope")
                    player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
                        if let value = snapshot.value as? [String: AnyObject] {
                            self.challengedTeam1.text = value["name"] as? String
                        }
                    })
                    
                    let player2ref = Database.database().reference().child("users").child(index.player2 ?? "nope")
                    player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
                        if let value = snapshot.value as? [String: AnyObject] {
                            self.challengedTeam2.text = value["name"] as? String
                        }
                    })
                }
            }

            match1Label.text = "\(match?.challengerGame1 ?? -1)/\(match?.challengedGame1 ?? -1)"
            match2Label.text = "\(match?.challengerGame2 ?? -1)/\(match?.challengedGame2 ?? -1)"
            match3Label.text = "\(match?.challengerGame3 ?? -1)/\(match?.challengedGame3 ?? -1)"
            match4Label.text = "\(match?.challengerGame4 ?? -1)/\(match?.challengedGame4 ?? -1)"
            match5Label.text = "\(match?.challengerGame5 ?? -1)/\(match?.challengedGame5 ?? -1)"
        }
    }
    var match: Match?
    
    let challengerTeam1: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.text = "Teammate 1 & Teammate 2"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    let challengerTeam2: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.text = "Teammate 1 & Teammate 2"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    let challengedTeam1: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.text = "Teammate 1 & Teammate 2"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    let challengedTeam2: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.text = "Teammate 1 & Teammate 2"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    let match1Label: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.text = "0/0"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    let match2Label: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.text = "0/0"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    let match3Label: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.text = "0/0"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    let match4Label: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.text = "0/0"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    let match5Label: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        label.text = "0/0"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    

    
    override func setupViews() {
        addSubview(challengerTeam1)
        addSubview(challengedTeam1)
        addSubview(challengerTeam2)
        addSubview(challengedTeam2)
        addSubview(match1Label)
        addSubview(match2Label)
        addSubview(match3Label)
        addSubview(match4Label)
        addSubview(match5Label)

        challengerTeam1.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        challengerTeam1.leftAnchor.constraint(equalTo: leftAnchor, constant: 3).isActive = true
        challengerTeam1.rightAnchor.constraint(equalTo: centerXAnchor, constant: -3).isActive = true
        challengerTeam1.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        challengedTeam1.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        challengedTeam1.leftAnchor.constraint(equalTo: centerXAnchor, constant: 3).isActive = true
        challengedTeam1.rightAnchor.constraint(equalTo: rightAnchor, constant: -3).isActive = true
        challengedTeam1.heightAnchor.constraint(equalToConstant: 25).isActive = true

        challengerTeam2.topAnchor.constraint(equalTo: challengerTeam1.bottomAnchor, constant: 3).isActive = true
        challengerTeam2.leftAnchor.constraint(equalTo: challengerTeam1.leftAnchor, constant: 0).isActive = true
        challengerTeam2.rightAnchor.constraint(equalTo: challengerTeam1.rightAnchor, constant: 0).isActive = true
        challengerTeam2.heightAnchor.constraint(equalToConstant: 25).isActive = true

        challengedTeam2.topAnchor.constraint(equalTo: challengedTeam1.bottomAnchor, constant: 3).isActive = true
        challengedTeam2.leftAnchor.constraint(equalTo: challengedTeam1.leftAnchor, constant: 0).isActive = true
        challengedTeam2.rightAnchor.constraint(equalTo: challengedTeam1.rightAnchor, constant: 0).isActive = true
        challengedTeam2.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        match1Label.topAnchor.constraint(equalTo: challengedTeam2.bottomAnchor, constant: 3).isActive = true
        match1Label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        match1Label.widthAnchor.constraint(equalToConstant: frame.width / 5).isActive = true
        match1Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        match2Label.topAnchor.constraint(equalTo: challengedTeam2.bottomAnchor, constant: 3).isActive = true
        match2Label.leftAnchor.constraint(equalTo: match1Label.rightAnchor).isActive = true
        match2Label.widthAnchor.constraint(equalToConstant: frame.width / 5).isActive = true
        match2Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        match3Label.topAnchor.constraint(equalTo: challengedTeam2.bottomAnchor, constant: 3).isActive = true
        match3Label.leftAnchor.constraint(equalTo: match2Label.rightAnchor).isActive = true
        match3Label.widthAnchor.constraint(equalToConstant: frame.width / 5).isActive = true
        match3Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        match4Label.topAnchor.constraint(equalTo: challengedTeam2.bottomAnchor, constant: 3).isActive = true
        match4Label.leftAnchor.constraint(equalTo: match3Label.rightAnchor).isActive = true
        match4Label.widthAnchor.constraint(equalToConstant: frame.width / 5).isActive = true
        match4Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        match5Label.topAnchor.constraint(equalTo: challengedTeam2.bottomAnchor, constant: 3).isActive = true
        match5Label.leftAnchor.constraint(equalTo: match4Label.rightAnchor).isActive = true
        match5Label.widthAnchor.constraint(equalToConstant: frame.width / 5).isActive = true
        match5Label.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
}
