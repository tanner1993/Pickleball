//
//  RecentMatchesCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/6/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit

class RecentMatchesCell: MatchCell {
    var team: Match? {
        didSet {
            TeamDuoBetter.text = team?.TeamPairBetter
            TeamDuoWorse.text = team?.TeamPairWorse
        }
    }
    
    let TeamDuoBetter: UILabel = {
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
    let TeamDuoWorse: UILabel = {
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
    let matchScores: UITextView = {
        let ms = UITextView()
        ms.backgroundColor = UIColor.white
        ms.translatesAutoresizingMaskIntoConstraints = false
        ms.layer.cornerRadius = 10
        ms.text = "11/3, 3/11, 4/11, 11/6, 11/9"
        ms.layer.masksToBounds = true
        ms.textAlignment = .center
        return ms
    }()

    
    override func setupViews() {
        addSubview(TeamDuoBetter)
        addSubview(TeamDuoWorse)
        addSubview(matchScores)

        //addConstraint(NSLayoutConstraint(item: TeamRank, attribute: .top, relatedBy: .equal, toItem: topAnchor, attribute: .bottom, multiplier: 1, constant: 4))
        addConstraintsWithFormat(format: "H:|-5-[v0(180)]-5-[v1(180)]-5-|", views: TeamDuoBetter, TeamDuoWorse)
        addConstraintsWithFormat(format: "V:|-4-[v0]-24-|", views: TeamDuoBetter)
        addConstraintsWithFormat(format: "V:|-4-[v0]-24-|", views: TeamDuoWorse)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: matchScores)
        addConstraint(NSLayoutConstraint(item: matchScores, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 24))
        addConstraint(NSLayoutConstraint(item: matchScores, attribute: .top, relatedBy: .equal, toItem: TeamDuoBetter, attribute: .bottom, multiplier: 1, constant: 0))
    }
}
