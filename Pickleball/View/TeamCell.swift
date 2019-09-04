//
//  TeamCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/3/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit

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

class TeamCell: BaseCell {
    
    let TeamDuo: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.purple
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 24
        label.layer.masksToBounds = true
        label.text = "Teammate 1 & Teammate 2"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    let TeamRank: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.purple
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 35
        label.layer.masksToBounds = true
        label.text = "1"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textAlignment = .center
        return label
    }()
    let Wins: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.green
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.text = "Wins: 1"
        label.textAlignment = .center
        return label
    }()
    let Losses: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.text = "Losses: 1"
        label.textAlignment = .center
        return label
    }()
    
    override func setupViews() {
        addSubview(TeamDuo)
        addSubview(TeamRank)
        addSubview(Wins)
        addSubview(Losses)
        //addConstraint(NSLayoutConstraint(item: TeamRank, attribute: .top, relatedBy: .equal, toItem: topAnchor, attribute: .bottom, multiplier: 1, constant: 4))
        addConstraintsWithFormat(format: "H:|-4-[v0(70)]-4-[v1]-4-|", views: TeamRank, TeamDuo)
        addConstraintsWithFormat(format: "V:|-4-[v0]-28-|", views: TeamDuo)
        addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: TeamRank)
        addConstraint(NSLayoutConstraint(item: Wins, attribute: .top, relatedBy: .equal, toItem: TeamDuo, attribute: .bottom, multiplier: 1, constant: 4))
        addConstraint(NSLayoutConstraint(item: Wins, attribute: .right, relatedBy: .equal, toItem: TeamDuo, attribute: .centerX, multiplier: 1, constant: -10))
        addConstraint(NSLayoutConstraint(item: Wins, attribute: .left, relatedBy: .equal, toItem: TeamDuo, attribute: .centerX, multiplier: 1, constant: -125))
        addConstraint(NSLayoutConstraint(item: Wins, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))
        addConstraint(NSLayoutConstraint(item: Losses, attribute: .top, relatedBy: .equal, toItem: TeamDuo, attribute: .bottom, multiplier: 1, constant: 4))
        addConstraint(NSLayoutConstraint(item: Losses, attribute: .right, relatedBy: .equal, toItem: TeamDuo, attribute: .centerX, multiplier: 1, constant: 125))
        addConstraint(NSLayoutConstraint(item: Losses, attribute: .left, relatedBy: .equal, toItem: TeamDuo, attribute: .centerX, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: Losses, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))
    }
    
}
