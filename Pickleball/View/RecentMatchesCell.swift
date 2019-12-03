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
    
    let timePlaceholder: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "match_time_placeholder")
        return image
    }()
    
    let match1Placeholder: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "plain_score_placeholder")
        return image
    }()
    
    let match2Placeholder: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "plain_score_placeholder")
        return image
    }()
    
    let match3Placeholder: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "plain_score_placeholder")
        return image
    }()
    
    let match4Placeholder: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "plain_score_placeholder")
        return image
    }()
    
    let match5Placeholder: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "plain_score_placeholder")
        return image
    }()
    
    let challenged: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Challenged:"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 21)
        label.textAlignment = .center
        return label
    }()
    
    let teamRank1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 65)
        label.textAlignment = .center
        return label
    }()
    
    let teamRank2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 65)
        label.textAlignment = .center
        return label
    }()
    
    let challengerTeam1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Teammate 1 & Teammate 2"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let challengerTeam2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Teammate 1 & Teammate 2"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let challengedTeam1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Teammate 1 & Teammate 2"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let challengedTeam2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Teammate 1 & Teammate 2"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let match1Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/0"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        label.textAlignment = .center
        return label
    }()
    let match2Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/0"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        label.textAlignment = .center
        return label
    }()
    let match3Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/0"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        label.textAlignment = .center
        return label
    }()
    let match4Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/0"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        label.textAlignment = .center
        return label
    }()
    let match5Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0/0"
        label.font = UIFont(name: "ArialRoundedMTBold", size: 20)
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
        
        addSubview(timePlaceholder)
        
        let timePlaceholderLoc = calculateButtonPosition(x: 690, y: 200, w: 105, h: 140, wib: 750, hib: 400, wia: 375, hia: 200)
        
        timePlaceholder.centerYAnchor.constraint(equalTo: topAnchor, constant: CGFloat(timePlaceholderLoc.Y)).isActive = true
        timePlaceholder.centerXAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(timePlaceholderLoc.X)).isActive = true
        timePlaceholder.heightAnchor.constraint(equalToConstant: CGFloat(timePlaceholderLoc.H)).isActive = true
        timePlaceholder.widthAnchor.constraint(equalToConstant: CGFloat(timePlaceholderLoc.W)).isActive = true
        
        addSubview(challenged)
        
        let challengedLoc = calculateButtonPosition(x: 250, y: 198, w: 350, h: 50, wib: 750, hib: 400, wia: 375, hia: 200)
        
        challenged.centerYAnchor.constraint(equalTo: topAnchor, constant: CGFloat(challengedLoc.Y)).isActive = true
        challenged.centerXAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(challengedLoc.X)).isActive = true
        challenged.heightAnchor.constraint(equalToConstant: CGFloat(challengedLoc.H)).isActive = true
        challenged.widthAnchor.constraint(equalToConstant: CGFloat(challengedLoc.W)).isActive = true
        
        addSubview(challengerTeam1)
        addSubview(challengedTeam1)
        addSubview(challengerTeam2)
        addSubview(challengedTeam2)
        addSubview(match1Label)
        addSubview(match2Label)
        addSubview(match3Label)
        addSubview(match4Label)
        addSubview(match5Label)
        
        let teamRankLoc = calculateButtonPosition(x: 90, y: 92, w: 100, h: 140, wib: 750, hib: 400, wia: 375, hia: 200)
        
        addSubview(teamRank1)
        teamRank1.centerYAnchor.constraint(equalTo: topAnchor, constant: CGFloat(teamRankLoc.Y)).isActive = true
        teamRank1.centerXAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(teamRankLoc.X)).isActive = true
        teamRank1.heightAnchor.constraint(equalToConstant: CGFloat(teamRankLoc.H)).isActive = true
        teamRank1.widthAnchor.constraint(equalToConstant: CGFloat(teamRankLoc.W)).isActive = true
        
        let teamRankLoc2 = calculateButtonPosition(x: 90, y: 308, w: 100, h: 140, wib: 750, hib: 400, wia: 375, hia: 200)
        
        addSubview(teamRank2)
        teamRank2.centerYAnchor.constraint(equalTo: topAnchor, constant: CGFloat(teamRankLoc2.Y)).isActive = true
        teamRank2.centerXAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(teamRankLoc2.X)).isActive = true
        teamRank2.heightAnchor.constraint(equalToConstant: CGFloat(teamRankLoc2.H)).isActive = true
        teamRank2.widthAnchor.constraint(equalToConstant: CGFloat(teamRankLoc2.W)).isActive = true

        challengerTeam1.topAnchor.constraint(equalTo: challengerPlaceholder.topAnchor, constant: 5).isActive = true
        challengerTeam1.leftAnchor.constraint(equalTo: teamRank1.rightAnchor).isActive = true
        challengerTeam1.rightAnchor.constraint(equalTo: challengerPlaceholder.rightAnchor).isActive = true
        challengerTeam1.bottomAnchor.constraint(equalTo: challengerPlaceholder.centerYAnchor).isActive = true
        
        challengerTeam2.topAnchor.constraint(equalTo: challengerPlaceholder.centerYAnchor).isActive = true
        challengerTeam2.leftAnchor.constraint(equalTo: teamRank1.rightAnchor).isActive = true
        challengerTeam2.rightAnchor.constraint(equalTo: challengerPlaceholder.rightAnchor).isActive = true
        challengerTeam2.bottomAnchor.constraint(equalTo: challengerPlaceholder.bottomAnchor, constant: -5).isActive = true
        
        challengedTeam1.topAnchor.constraint(equalTo: challengedPlaceholder.topAnchor, constant: 5).isActive = true
        challengedTeam1.leftAnchor.constraint(equalTo: teamRank2.rightAnchor).isActive = true
        challengedTeam1.rightAnchor.constraint(equalTo: challengedPlaceholder.rightAnchor).isActive = true
        challengedTeam1.bottomAnchor.constraint(equalTo: challengedPlaceholder.centerYAnchor).isActive = true
        
        challengedTeam2.topAnchor.constraint(equalTo: challengedPlaceholder.centerYAnchor).isActive = true
        challengedTeam2.leftAnchor.constraint(equalTo: teamRank2.rightAnchor).isActive = true
        challengedTeam2.rightAnchor.constraint(equalTo: challengedPlaceholder.rightAnchor).isActive = true
        challengedTeam2.bottomAnchor.constraint(equalTo: challengedPlaceholder.bottomAnchor, constant: -5).isActive = true
        
        addSubview(match1Placeholder)
        let match1PlaceholderLoc = calculateButtonPosition(x: 566.5, y: 42, w: 120, h: 62, wib: 750, hib: 400, wia: 375, hia: 200)
        match1Placeholder.centerYAnchor.constraint(equalTo: topAnchor, constant: CGFloat(match1PlaceholderLoc.Y)).isActive = true
        match1Placeholder.centerXAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(match1PlaceholderLoc.X)).isActive = true
        match1Placeholder.heightAnchor.constraint(equalToConstant: CGFloat(match1PlaceholderLoc.H)).isActive = true
        match1Placeholder.widthAnchor.constraint(equalToConstant: CGFloat(match1PlaceholderLoc.W)).isActive = true
        
        addSubview(match2Placeholder)
        let match2PlaceholderLoc = calculateButtonPosition(x: 566.5, y: 120, w: 120, h: 62, wib: 750, hib: 400, wia: 375, hia: 200)
        match2Placeholder.centerYAnchor.constraint(equalTo: topAnchor, constant: CGFloat(match2PlaceholderLoc.Y)).isActive = true
        match2Placeholder.centerXAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(match2PlaceholderLoc.X)).isActive = true
        match2Placeholder.heightAnchor.constraint(equalToConstant: CGFloat(match2PlaceholderLoc.H)).isActive = true
        match2Placeholder.widthAnchor.constraint(equalToConstant: CGFloat(match2PlaceholderLoc.W)).isActive = true
        
        addSubview(match3Placeholder)
        let match3PlaceholderLoc = calculateButtonPosition(x: 566.5, y: 198, w: 120, h: 62, wib: 750, hib: 400, wia: 375, hia: 200)
        match3Placeholder.centerYAnchor.constraint(equalTo: topAnchor, constant: CGFloat(match3PlaceholderLoc.Y)).isActive = true
        match3Placeholder.centerXAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(match3PlaceholderLoc.X)).isActive = true
        match3Placeholder.heightAnchor.constraint(equalToConstant: CGFloat(match3PlaceholderLoc.H)).isActive = true
        match3Placeholder.widthAnchor.constraint(equalToConstant: CGFloat(match3PlaceholderLoc.W)).isActive = true
        
        addSubview(match4Placeholder)
        let match4PlaceholderLoc = calculateButtonPosition(x: 566.5, y: 276, w: 120, h: 62, wib: 750, hib: 400, wia: 375, hia: 200)
        match4Placeholder.centerYAnchor.constraint(equalTo: topAnchor, constant: CGFloat(match4PlaceholderLoc.Y)).isActive = true
        match4Placeholder.centerXAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(match4PlaceholderLoc.X)).isActive = true
        match4Placeholder.heightAnchor.constraint(equalToConstant: CGFloat(match4PlaceholderLoc.H)).isActive = true
        match4Placeholder.widthAnchor.constraint(equalToConstant: CGFloat(match4PlaceholderLoc.W)).isActive = true
        
        addSubview(match5Placeholder)
        let match5PlaceholderLoc = calculateButtonPosition(x: 566.5, y: 354, w: 120, h: 62, wib: 750, hib: 400, wia: 375, hia: 200)
        match5Placeholder.centerYAnchor.constraint(equalTo: topAnchor, constant: CGFloat(match5PlaceholderLoc.Y)).isActive = true
        match5Placeholder.centerXAnchor.constraint(equalTo: leftAnchor, constant: CGFloat(match5PlaceholderLoc.X)).isActive = true
        match5Placeholder.heightAnchor.constraint(equalToConstant: CGFloat(match5PlaceholderLoc.H)).isActive = true
        match5Placeholder.widthAnchor.constraint(equalToConstant: CGFloat(match5PlaceholderLoc.W)).isActive = true
        
        match1Label.topAnchor.constraint(equalTo: match1Placeholder.topAnchor).isActive = true
        match1Label.leftAnchor.constraint(equalTo: match1Placeholder.leftAnchor).isActive = true
        match1Label.rightAnchor.constraint(equalTo: match1Placeholder.rightAnchor).isActive = true
        match1Label.bottomAnchor.constraint(equalTo: match1Placeholder.bottomAnchor).isActive = true
        
        match2Label.topAnchor.constraint(equalTo: match2Placeholder.topAnchor).isActive = true
        match2Label.leftAnchor.constraint(equalTo: match2Placeholder.leftAnchor).isActive = true
        match2Label.rightAnchor.constraint(equalTo: match2Placeholder.rightAnchor).isActive = true
        match2Label.bottomAnchor.constraint(equalTo: match2Placeholder.bottomAnchor).isActive = true
        
        match3Label.topAnchor.constraint(equalTo: match3Placeholder.topAnchor).isActive = true
        match3Label.leftAnchor.constraint(equalTo: match3Placeholder.leftAnchor).isActive = true
        match3Label.rightAnchor.constraint(equalTo: match3Placeholder.rightAnchor).isActive = true
        match3Label.bottomAnchor.constraint(equalTo: match3Placeholder.bottomAnchor).isActive = true
        
        match4Label.topAnchor.constraint(equalTo: match4Placeholder.topAnchor).isActive = true
        match4Label.leftAnchor.constraint(equalTo: match4Placeholder.leftAnchor).isActive = true
        match4Label.rightAnchor.constraint(equalTo: match4Placeholder.rightAnchor).isActive = true
        match4Label.bottomAnchor.constraint(equalTo: match4Placeholder.bottomAnchor).isActive = true
        
        match5Label.topAnchor.constraint(equalTo: match5Placeholder.topAnchor).isActive = true
        match5Label.leftAnchor.constraint(equalTo: match5Placeholder.leftAnchor).isActive = true
        match5Label.rightAnchor.constraint(equalTo: match5Placeholder.rightAnchor).isActive = true
        match5Label.bottomAnchor.constraint(equalTo: match5Placeholder.bottomAnchor).isActive = true
    }
    
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
    }
}
