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
//            for index in teams {
//                if index.teamId == match?.challengerTeamId {
//
//                    let player1ref = Database.database().reference().child("users").child(index.player1 ?? "nope")
//                    player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
//                        if let value = snapshot.value as? [String: AnyObject] {
//                            self.challengerTeam1.text = value["name"] as? String
//                        }
//                    })
//
//                    let player2ref = Database.database().reference().child("users").child(index.player2 ?? "nope")
//                    player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
//                        if let value = snapshot.value as? [String: AnyObject] {
//                            self.challengerTeam2.text = value["name"] as? String
//                        }
//                    })
//
//                }
//                if index.teamId == match?.challengedTeamId {
//                    let player1ref = Database.database().reference().child("users").child(index.player1 ?? "nope")
//                    player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
//                        if let value = snapshot.value as? [String: AnyObject] {
//                            self.challengedTeam1.text = value["name"] as? String
//                        }
//                    })
//
//                    let player2ref = Database.database().reference().child("users").child(index.player2 ?? "nope")
//                    player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
//                        if let value = snapshot.value as? [String: AnyObject] {
//                            self.challengedTeam2.text = value["name"] as? String
//                        }
//                    })
//                }
//            }

            match1Label.text = "\(match?.challengerScores?[0] ?? -1)/\(match?.challengedScores?[0] ?? -1)"
            match2Label.text = "\(match?.challengerScores?[1] ?? -1)/\(match?.challengedScores?[1] ?? -1)"
            match3Label.text = "\(match?.challengerScores?[2] ?? -1)/\(match?.challengedScores?[2] ?? -1)"
            match4Label.text = "\(match?.challengerScores?[3] ?? -1)/\(match?.challengedScores?[3] ?? -1)"
            match5Label.text = "\(match?.challengerScores?[4] ?? -1)/\(match?.challengedScores?[4] ?? -1)"
        }
    }
    var match: Match?
    
    let challengerPlaceholder: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let challengedPlaceholder: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let teamRank: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 65)
        label.textAlignment = .center
        return label
    }()
    
    let challengerTeam1: UILabel = {
        let label = UILabel()
        //label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.layer.cornerRadius = 16
        //label.layer.masksToBounds = true
        label.text = "Teammate 1 & Teammate 2"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        label.textAlignment = .center
        return label
    }()
    let challengerTeam2: UILabel = {
        let label = UILabel()
        //label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.layer.cornerRadius = 16
        //label.layer.masksToBounds = true
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
        
        addSubview(challengerPlaceholder)
        
        let challengerPlaceholderLoc = calculateButtonPosition(x: 250, y: 92, w: 476, h: 165, wib: 750, hib: 400, wia: 375, hia: 200)

        challengerPlaceholder.centerYAnchor.constraint(equalTo: topAnchor, constant: CGFloat(challengerPlaceholderLoc.Y)).isActive = true
        challengerPlaceholder.centerXAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(challengerPlaceholderLoc.X)).isActive = true
        challengerPlaceholder.heightAnchor.constraint(equalToConstant: CGFloat(challengerPlaceholderLoc.H)).isActive = true
        challengerPlaceholder.widthAnchor.constraint(equalToConstant: CGFloat(challengerPlaceholderLoc.W)).isActive = true
        
        addSubview(challengedPlaceholder)
        
        let challengedPlaceholderLoc = calculateButtonPosition(x: 250, y: 308, w: 476, h: 165, wib: 750, hib: 400, wia: 375, hia: 200)
        
        challengedPlaceholder.centerYAnchor.constraint(equalTo: topAnchor, constant: CGFloat(challengedPlaceholderLoc.Y)).isActive = true
        challengedPlaceholder.centerXAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(challengedPlaceholderLoc.X)).isActive = true
        challengedPlaceholder.heightAnchor.constraint(equalToConstant: CGFloat(challengedPlaceholderLoc.H)).isActive = true
        challengedPlaceholder.widthAnchor.constraint(equalToConstant: CGFloat(challengedPlaceholderLoc.W)).isActive = true
        
        addSubview(challengerTeam1)
        //addSubview(challengedTeam1)
        addSubview(challengerTeam2)
        //addSubview(challengedTeam2)
//        addSubview(match1Label)
//        addSubview(match2Label)
//        addSubview(match3Label)
//        addSubview(match4Label)
//        addSubview(match5Label)
        
        let teamRankLoc = calculateButtonPosition(x: 90, y: 92, w: 100, h: 140, wib: 750, hib: 400, wia: 375, hia: 200)
        
        addSubview(teamRank)
        teamRank.centerYAnchor.constraint(equalTo: topAnchor, constant: CGFloat(teamRankLoc.Y)).isActive = true
        teamRank.centerXAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(teamRankLoc.X)).isActive = true
        teamRank.heightAnchor.constraint(equalToConstant: CGFloat(teamRankLoc.H)).isActive = true
        teamRank.widthAnchor.constraint(equalToConstant: CGFloat(teamRankLoc.W)).isActive = true

        challengerTeam1.topAnchor.constraint(equalTo: challengerPlaceholder.topAnchor, constant: 5).isActive = true
        challengerTeam1.leftAnchor.constraint(equalTo: teamRank.rightAnchor).isActive = true
        challengerTeam1.rightAnchor.constraint(equalTo: challengerPlaceholder.rightAnchor).isActive = true
        challengerTeam1.bottomAnchor.constraint(equalTo: challengerPlaceholder.centerYAnchor).isActive = true
        
        challengerTeam2.topAnchor.constraint(equalTo: challengerPlaceholder.centerYAnchor).isActive = true
        challengerTeam2.leftAnchor.constraint(equalTo: teamRank.rightAnchor).isActive = true
        challengerTeam2.rightAnchor.constraint(equalTo: challengerPlaceholder.rightAnchor).isActive = true
        challengerTeam2.bottomAnchor.constraint(equalTo: challengerPlaceholder.bottomAnchor, constant: -5).isActive = true
        
    }
    
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
    }
}
