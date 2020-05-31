//
//  PlayerChallengeCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 5/21/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit

class PlayerChallengeCell: BaseCell {
    var player: Player? {
        didSet {
            playerUserName.text = "\(player?.name ?? "none")"
            skillLevel.text = "\(player?.skill_level ?? 0.0)"
            appLevel.text = "\(player?.halo_level ?? 0)"
            playerLocation.text = "\(player?.state ?? "none"), \(player?.county ?? "none")"
            appLevelLabel.text = player?.levelTitle(level: player?.halo_level ?? 1)
            matchesPlayed.text = "\((player?.match_wins ?? 0) + (player?.match_losses ?? 0))"
            let court = player?.court ?? "none"
            courtText.text = court == "none" ? "No Court Selected" : court
            let winRatio2 = Double(player?.match_wins ?? 0) / (Double(player?.match_wins ?? 0) + Double(player?.match_losses ?? 0))
            let winRatioRounded = winRatio2.round(nearest: 0.01)
            winRatio.text = ((player?.match_wins ?? 0) + (player?.match_losses ?? 0)) == 0 ? "\(0)" : "\(winRatioRounded)"
            let friendName = player?.name ?? "none"
            var initials = ""
            var finalChar = 0
            for (index, char) in friendName.enumerated() {
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
            self.playerInitials.text = initials
        }
    }
    
    let playerUserName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "playerName"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "HelveticaNeue", size: 27)
        label.textAlignment = .center
        return label
    }()
        
    let playerLocation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
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
        label.text = ""
        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .right
        return label
    }()
    
    let appLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let appLevelLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let matchesPlayedLabel: UILabel = {
       let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
       label.text = "Matches Played:"
       label.translatesAutoresizingMaskIntoConstraints = false
       label.textColor = .black
       label.font = UIFont(name: "HelveticaNeue-Light", size: 24)
       label.textAlignment = .left
       return label
    }()
   
    let winRatioLabel: UILabel = {
       let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
       label.text = "Match Win Ratio:"
       label.translatesAutoresizingMaskIntoConstraints = false
       label.textColor = .black
       label.font = UIFont(name: "HelveticaNeue-Light", size: 24)
       label.textAlignment = .left
       return label
    }()
    
    let matchesPlayed: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue-Light", size: 24)
        label.textAlignment = .right
        return label
    }()
    
    let winRatio: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue-Light", size: 24)
        label.textAlignment = .right
        return label
    }()
    
    let courtLabel: UILabel = {
        let label = UILabel()
        label.text = "Court:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        label.textAlignment = .center
        return label
    }()
    
    let courtText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var playerUsernameWidthAnchor: NSLayoutConstraint?
    
    override func setupViews() {
        
//        addSubview(playerInitials)
//        playerInitials.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
//        playerInitials.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
//        playerInitials.heightAnchor.constraint(equalToConstant: 70).isActive = true
//        playerInitials.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        addSubview(playerUserName)
        playerUserName.topAnchor.constraint(equalTo: topAnchor).isActive = true
        playerUserName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playerUserName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playerUserName.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        
        addSubview(playerLocation)
        playerLocation.topAnchor.constraint(equalTo: playerUserName.bottomAnchor).isActive = true
        playerLocation.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        playerLocation.heightAnchor.constraint(equalToConstant: 30).isActive = true
        playerLocation.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        
        addSubview(appLevel)
        appLevel.topAnchor.constraint(equalTo: playerLocation.bottomAnchor, constant: 4).isActive = true
        appLevel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        appLevel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        appLevel.widthAnchor.constraint(equalToConstant: frame.width * 1 / 3).isActive = true
        
        addSubview(skillLevel)
        skillLevel.topAnchor.constraint(equalTo: playerUserName.bottomAnchor).isActive = true
        //skillLevel.rightAnchor.constraint(equalTo: centerXAnchor, constant: -50).isActive = true
        skillLevel.centerXAnchor.constraint(equalTo: appLevel.centerXAnchor).isActive = true
        skillLevel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        skillLevel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(appLevelLabel)
        appLevelLabel.topAnchor.constraint(equalTo: appLevel.bottomAnchor, constant: 0).isActive = true
        appLevelLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        appLevelLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        appLevelLabel.widthAnchor.constraint(equalToConstant: frame.width * 1 / 3).isActive = true
        
        addSubview(matchesPlayedLabel)
        matchesPlayedLabel.topAnchor.constraint(equalTo: skillLevel.bottomAnchor, constant: 4).isActive = true
        matchesPlayedLabel.leftAnchor.constraint(equalTo: appLevel.rightAnchor, constant: 12).isActive = true
        matchesPlayedLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        matchesPlayedLabel.widthAnchor.constraint(equalToConstant: frame.width * 1 / 3 + 45).isActive = true
        
        addSubview(winRatioLabel)
        winRatioLabel.topAnchor.constraint(equalTo: appLevel.bottomAnchor, constant: 0).isActive = true
        winRatioLabel.leftAnchor.constraint(equalTo: appLevel.rightAnchor, constant: 12).isActive = true
        winRatioLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        winRatioLabel.widthAnchor.constraint(equalToConstant: frame.width * 1 / 3 + 45).isActive = true
        
        addSubview(matchesPlayed)
        matchesPlayed.topAnchor.constraint(equalTo: skillLevel.bottomAnchor, constant: 4).isActive = true
        matchesPlayed.leftAnchor.constraint(equalTo: matchesPlayedLabel.rightAnchor, constant: 4).isActive = true
        matchesPlayed.heightAnchor.constraint(equalToConstant: 30).isActive = true
        matchesPlayed.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        addSubview(winRatio)
        winRatio.topAnchor.constraint(equalTo: appLevel.bottomAnchor, constant: 0).isActive = true
        winRatio.leftAnchor.constraint(equalTo: matchesPlayedLabel.rightAnchor, constant: 4).isActive = true
        winRatio.heightAnchor.constraint(equalToConstant: 30).isActive = true
        winRatio.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        addSubview(courtLabel)
        courtLabel.topAnchor.constraint(equalTo: winRatio.bottomAnchor, constant: 4).isActive = true
        courtLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        courtLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        courtLabel.widthAnchor.constraint(equalToConstant: 104).isActive = true
        
        addSubview(courtText)
        
        courtText.topAnchor.constraint(equalTo: winRatio.bottomAnchor, constant: 8).isActive = true
        courtText.leftAnchor.constraint(equalTo: courtLabel.rightAnchor, constant: 8).isActive = true
        courtText.heightAnchor.constraint(equalToConstant: 40).isActive = true
        courtText.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        addSubview(separatorView)
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}
