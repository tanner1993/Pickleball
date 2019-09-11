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
            playerName.text = player?.name
        }
    }
    
    let playerName: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 24
        label.layer.masksToBounds = true
        label.text = "playerName"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    override func setupViews() {
        addSubview(playerName)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: playerName)
        addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: playerName)
    }
}
