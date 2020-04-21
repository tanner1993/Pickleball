//
//  TeamStatsCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 3/28/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

class TeamStatsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var team = Team() {
        didSet {
            wins_1.text = "Wins: \(team.wins ?? 0)"
            losses_1.text = "Losses: \(team.losses ?? 0)"
            teamRank.text = "\(team.rank ?? 0)"
            if team.rank == 1 {
                tourneySymbol.isHidden = false
                tourneySymbol2.isHidden = false
                tourneySymbol.image = UIImage(named: "tourney_symbol_go")
                tourneySymbol2.image = UIImage(named: "tourney_symbol_go")
                teamStatPlaceholder.image = UIImage(named: "gold_stat_holder")
                teamRank.text?.append("st")
            } else if team.rank == 2 {
                tourneySymbol.isHidden = false
                tourneySymbol2.isHidden = false
                tourneySymbol.image = UIImage(named: "tourney_symbol_si")
                tourneySymbol2.image = UIImage(named: "tourney_symbol_si")
                teamStatPlaceholder.image = UIImage(named: "silver_stat_holder")
                teamRank.text?.append("nd")
            } else if team.rank == 3 {
                tourneySymbol.isHidden = false
                tourneySymbol2.isHidden = false
                tourneySymbol.image = UIImage(named: "tourney_symbol_br")
                tourneySymbol2.image = UIImage(named: "tourney_symbol_br")
                teamStatPlaceholder.image = UIImage(named: "bronze_stat_holder")
                teamRank.text?.append("rd")
            } else {
                teamStatPlaceholder.image = UIImage(named: "plain_stat_holder")
                tourneySymbol.isHidden = true
                tourneySymbol2.isHidden = true
                teamRank.text?.append("th")
            }
            
            let player1ref = Database.database().reference().child("users").child(team.player1 ?? "nope")
            player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value as? [String: AnyObject] {
                    self.teamName1.text = value["username"] as? String
                }
            })
            
            let player2ref = Database.database().reference().child("users").child(team.player2 ?? "nope")
            player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value as? [String: AnyObject] {
                    self.teamName2.text = value["username"] as? String
                }
            })
        }
        
    }
    
    let teamStatPlaceholder: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "plain_stat_holder")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let teamRank: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 40)
        label.textAlignment = .center
        return label
    }()
    
    let teamName1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 22)
        label.textAlignment = .right
        return label
    }()
    
    let teamName2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 22)
        label.textAlignment = .left
        return label
    }()
    
    let teamNameAnd: UILabel = {
        let label = UILabel()
        label.text = "&"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 24)
        label.textAlignment = .center
        return label
    }()
    
    let tourneySymbol: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.image = UIImage(named: "tourney_symbol")
        bi.isHidden = true
        return bi
    }()
    
    let tourneySymbol2: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.image = UIImage(named: "tourney_symbol")
        bi.isHidden = true
        return bi
    }()
    
    let wins_1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 32, g: 140, b: 21)
        label.font = UIFont(name: "HelveticaNeue-Light", size: 28)
        label.textAlignment = .left
        return label
    }()
    
    let losses_1: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(r: 252, g: 16, b: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 28)
        label.textAlignment = .left
        return label
    }()
    
    let pointsWon: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 32, g: 140, b: 21)
        label.font = UIFont(name: "HelveticaNeue-Light", size: 28)
        label.textAlignment = .left
        return label
    }()
    
    let pointsLost: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(r: 252, g: 16, b: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 28)
        label.textAlignment = .left
        return label
    }()
    
    func setupViews() {
        
        if frame.width < 375 {
            pointsWon.font = UIFont(name: "HelveticaNeue-Light", size: 23)
            pointsLost.font = UIFont(name: "HelveticaNeue-Light", size: 23)
        }
        
        addSubview(teamStatPlaceholder)
        teamStatPlaceholder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        teamStatPlaceholder.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        teamStatPlaceholder.heightAnchor.constraint(equalToConstant: 150).isActive = true
        teamStatPlaceholder.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        teamStatPlaceholder.addSubview(teamRank)
        teamRank.topAnchor.constraint(equalTo: teamStatPlaceholder.topAnchor, constant: 7).isActive = true
        teamRank.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        teamRank.heightAnchor.constraint(equalToConstant: 40).isActive = true
        teamRank.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        teamStatPlaceholder.addSubview(tourneySymbol)
        tourneySymbol.topAnchor.constraint(equalTo: teamRank.topAnchor).isActive = true
        tourneySymbol.rightAnchor.constraint(equalTo: teamRank.leftAnchor, constant: 15).isActive = true
        tourneySymbol.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tourneySymbol.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        teamStatPlaceholder.addSubview(tourneySymbol2)
        tourneySymbol2.topAnchor.constraint(equalTo: teamRank.topAnchor).isActive = true
        tourneySymbol2.leftAnchor.constraint(equalTo: teamRank.rightAnchor, constant: -15).isActive = true
        tourneySymbol2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tourneySymbol2.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        teamStatPlaceholder.addSubview(teamNameAnd)
        teamNameAnd.topAnchor.constraint(equalTo: teamRank.bottomAnchor, constant: 4).isActive = true
        teamNameAnd.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        teamNameAnd.heightAnchor.constraint(equalToConstant: 25).isActive = true
        teamNameAnd.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        teamStatPlaceholder.addSubview(teamName1)
        teamName1.topAnchor.constraint(equalTo: teamRank.bottomAnchor, constant: 4).isActive = true
        teamName1.rightAnchor.constraint(equalTo: teamNameAnd.leftAnchor, constant: -2).isActive = true
        teamName1.heightAnchor.constraint(equalToConstant: 25).isActive = true
        teamName1.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        
        teamStatPlaceholder.addSubview(teamName2)
        teamName2.topAnchor.constraint(equalTo: teamRank.bottomAnchor, constant: 4).isActive = true
        teamName2.leftAnchor.constraint(equalTo: teamNameAnd.rightAnchor, constant: 2).isActive = true
        teamName2.heightAnchor.constraint(equalToConstant: 25).isActive = true
        teamName2.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).isActive = true
        
        teamStatPlaceholder.addSubview(wins_1)
        wins_1.topAnchor.constraint(equalTo: teamName1.bottomAnchor, constant: 4).isActive = true
        wins_1.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
        wins_1.heightAnchor.constraint(equalToConstant: 28).isActive = true
        wins_1.rightAnchor.constraint(equalTo: centerXAnchor, constant: -2).isActive = true
        
        teamStatPlaceholder.addSubview(losses_1)
        losses_1.topAnchor.constraint(equalTo: wins_1.bottomAnchor, constant: 4).isActive = true
        losses_1.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
        losses_1.heightAnchor.constraint(equalToConstant: 28).isActive = true
        losses_1.rightAnchor.constraint(equalTo: centerXAnchor, constant: -2).isActive = true
        
        teamStatPlaceholder.addSubview(pointsWon)
        pointsWon.topAnchor.constraint(equalTo: teamName1.bottomAnchor, constant: 4).isActive = true
        pointsWon.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
        pointsWon.heightAnchor.constraint(equalToConstant: 28).isActive = true
        pointsWon.rightAnchor.constraint(equalTo: centerXAnchor, constant: -2).isActive = true
        
        teamStatPlaceholder.addSubview(pointsLost)
        pointsLost.topAnchor.constraint(equalTo: wins_1.bottomAnchor, constant: 4).isActive = true
        pointsLost.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true
        pointsLost.heightAnchor.constraint(equalToConstant: 28).isActive = true
        pointsLost.rightAnchor.constraint(equalTo: centerXAnchor, constant: -2).isActive = true
    }

}
