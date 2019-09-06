//
//  RecentMatchesCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/6/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit

class RecentMatchesCell: MatchCell {
    var team: Team? {
        didSet {
            TeamDuo.text = team?.TeamPair
        }
    }
    
    let TeamDuo: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 26
        label.layer.masksToBounds = true
        label.text = "Teammate 1 & Teammate 2"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()

    
    override func setupViews() {
        addSubview(TeamDuo)

        //addConstraint(NSLayoutConstraint(item: TeamRank, attribute: .top, relatedBy: .equal, toItem: topAnchor, attribute: .bottom, multiplier: 1, constant: 4))
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: TeamDuo)
        addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: TeamDuo)
    }
}
