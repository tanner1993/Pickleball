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
    }
}
