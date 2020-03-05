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
            playerName.text = "\(player?.username ?? "none") | \(player?.state ?? "none"), \(player?.county ?? "none")"
            skills.text = "Skill Level: \(player?.skill_level ?? 0.0)"
        }
    }
    
    let playerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "playerName"
        //label.font = UIFont.boldSystemFont(ofSize: 20)
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
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let skills: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "playerName"
        //label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    let viewProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 56, g: 12, b: 200)
        button.setTitle("View Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 56, g: 12, b: 200)
        button.setTitle("Message", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.masksToBounds = true
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
        playerName.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        addSubview(skills)
        skills.topAnchor.constraint(equalTo: playerName.bottomAnchor).isActive = true
        skills.leftAnchor.constraint(equalTo: playerName.leftAnchor).isActive = true
        skills.heightAnchor.constraint(equalToConstant: frame.height / 2).isActive = true
        skills.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        addSubview(messageButton)
        messageButton.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        messageButton.leftAnchor.constraint(equalTo: playerName.rightAnchor, constant: 4).isActive = true
        messageButton.heightAnchor.constraint(equalToConstant: frame.height - 8).isActive = true
        messageButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        
        addSubview(separatorView)
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}
