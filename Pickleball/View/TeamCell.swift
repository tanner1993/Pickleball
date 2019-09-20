//
//  TeamCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/3/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TeamCell: FeedCell {
    
    var team: Team? {
        didSet {
            let player1ref = Database.database().reference().child("users").child(team?.player1 ?? "nope")
            player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value as? [String: AnyObject] {
                    self.player1.text = value["name"] as? String
                }
            })
            
            let player2ref = Database.database().reference().child("users").child(team?.player2 ?? "nope")
            player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value as? [String: AnyObject] {
                    self.player2.text = value["name"] as? String
                }
            })
            //player1.text = team?.player1
            //player2.text = team?.player2
            wins.text = "Wins: \(team?.wins ?? -1)"
            losses.text = "Losses: \(team?.losses ?? -1)"
            teamRank.text = "\(team?.rank ?? -1)"
        }
    }
    
    let player1: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 24
        label.layer.masksToBounds = true
        label.text = "Teammate 1"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    let player2: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 24
        label.layer.masksToBounds = true
        label.text = "Teammate 2"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    let teamRank: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 35
        label.layer.masksToBounds = true
        label.text = "1"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textAlignment = .center
        return label
    }()
    
    let wins: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 0/255, green: 250/255, blue: 154/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.text = "Wins: 1"
        label.textAlignment = .center
        return label
    }()
    
    let losses: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 240/255, green: 128/255, blue: 128/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.text = "Losses: 1"
        label.textAlignment = .center
        return label
    }()
    
    let challengeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 150, g: 0, b: 0)
        button.setTitle("Challenge", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func setupViews() {
        addSubview(teamRank)
        teamRank.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        teamRank.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        teamRank.widthAnchor.constraint(equalToConstant: 70).isActive = true
        teamRank.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        addSubview(player1)
        player1.leftAnchor.constraint(equalTo: teamRank.rightAnchor, constant: 4).isActive = true
        player1.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        player1.widthAnchor.constraint(equalToConstant: ((frame.width - 74) / 2) - 6).isActive = true
        player1.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        addSubview(player2)
        player2.leftAnchor.constraint(equalTo: player1.rightAnchor, constant: 4).isActive = true
        player2.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        player2.widthAnchor.constraint(equalToConstant: ((frame.width - 74) / 2) - 6).isActive = true
        player2.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        addSubview(wins)
        wins.rightAnchor.constraint(equalTo: player1.centerXAnchor, constant: -2).isActive = true
        wins.topAnchor.constraint(equalTo: player1.bottomAnchor, constant: 4).isActive = true
        wins.leftAnchor.constraint(equalTo: player1.leftAnchor, constant: 0).isActive = true
        wins.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(losses)
        losses.rightAnchor.constraint(equalTo: player1.rightAnchor, constant: 0).isActive = true
        losses.topAnchor.constraint(equalTo: player2.bottomAnchor, constant: 4).isActive = true
        losses.leftAnchor.constraint(equalTo: player1.centerXAnchor, constant: 2).isActive = true
        losses.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(challengeButton)
        challengeButton.rightAnchor.constraint(equalTo: player2.rightAnchor, constant: 0).isActive = true
        challengeButton.topAnchor.constraint(equalTo: player2.bottomAnchor, constant: 4).isActive = true
        challengeButton.leftAnchor.constraint(equalTo: player2.leftAnchor, constant: 2).isActive = true
        challengeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    
}
