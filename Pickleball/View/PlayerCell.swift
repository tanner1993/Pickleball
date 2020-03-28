//
//  PlayerCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/10/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit

class PlayerCell: BaseCell {
    
    var player: Player? {
        didSet {
            playerName.text = "\(player?.username ?? "none") | \(player?.state ?? "none"), \(player?.county ?? "none")"
            skills.text = "Skill Level: \(player?.skill_level ?? 0.0)"
        }
    }
    
    let playerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "playerName"
        //label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    let skills: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "playerName"
        //label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        addSubview(playerName)
        playerName.topAnchor.constraint(equalTo: topAnchor).isActive = true
        playerName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playerName.heightAnchor.constraint(equalToConstant: frame.height / 2).isActive = true
        playerName.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        addSubview(skills)
        skills.topAnchor.constraint(equalTo: playerName.bottomAnchor).isActive = true
        skills.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        skills.heightAnchor.constraint(equalToConstant: frame.height / 2).isActive = true
        skills.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        addSubview(separatorView)
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}

class FriendListCell: BaseCell {
    var player: Player? {
        didSet {
            playerName.text = "\(player?.username ?? "none")"
            skillLevel.text = "\(player?.skill_level ?? 0.0)"
            appLevel.text = "\(player?.halo_level ?? 0)"
            playerLocation.text = "\(player?.state ?? "none"), \(player?.county ?? "none")"
            if player?.friend == 2 {
                friendImage.isHidden = false
            } else {
                friendImage.isHidden = true
            }
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
    
    let friendImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "friend_signal")
        image.contentMode = .scaleAspectFit
        image.isHidden = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let playerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "playerName"
        label.font = UIFont(name: "HelveticaNeue", size: 19)
        label.textAlignment = .left
        return label
    }()
    
    let playerLocation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.text = ""
        label.font = UIFont(name: "HelveticaNeue", size: 19)
        label.textAlignment = .center
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
        label.textAlignment = .left
        return label
    }()
    
    let appLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        return label
    }()
    
    let messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Message", for: .normal)
        button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        
        addSubview(playerInitials)
        playerInitials.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        playerInitials.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        playerInitials.heightAnchor.constraint(equalToConstant: 70).isActive = true
        playerInitials.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        addSubview(playerName)
        playerName.topAnchor.constraint(equalTo: topAnchor).isActive = true
        playerName.leftAnchor.constraint(equalTo: playerInitials.rightAnchor, constant: 4).isActive = true
        playerName.heightAnchor.constraint(equalToConstant: frame.height / 2).isActive = true
        playerName.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        addSubview(skillLevel)
        skillLevel.topAnchor.constraint(equalTo: playerName.bottomAnchor).isActive = true
        skillLevel.leftAnchor.constraint(equalTo: playerName.leftAnchor).isActive = true
        skillLevel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        skillLevel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(appLevel)
        appLevel.topAnchor.constraint(equalTo: playerName.bottomAnchor).isActive = true
        appLevel.leftAnchor.constraint(equalTo: skillLevel.rightAnchor, constant: 15).isActive = true
        appLevel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        appLevel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(messageButton)
        messageButton.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        messageButton.leftAnchor.constraint(equalTo: playerName.rightAnchor, constant: 4).isActive = true
        messageButton.heightAnchor.constraint(equalToConstant: frame.height - 8).isActive = true
        messageButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        
        addSubview(friendImage)
        friendImage.topAnchor.constraint(equalTo: playerName.topAnchor, constant: 10).isActive = true
        friendImage.leftAnchor.constraint(equalTo: playerName.rightAnchor, constant: 2).isActive = true
        friendImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        friendImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        
        addSubview(playerLocation)
        playerLocation.topAnchor.constraint(equalTo: appLevel.topAnchor).isActive = true
        playerLocation.leftAnchor.constraint(equalTo: playerName.rightAnchor, constant: 2).isActive = true
        playerLocation.heightAnchor.constraint(equalToConstant: 30).isActive = true
        playerLocation.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        
        addSubview(separatorView)
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}
