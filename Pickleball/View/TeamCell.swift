//
//  TeamCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/3/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

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

class TeamCell: FeedCell {
    
    var team: Team? {
        didSet {
            wins.text = "W: \(team?.wins ?? -1)"
            losses.text = "L: \(team?.losses ?? -1)"
            teamRank.text = "\(team?.rank ?? -1)"
        }
    }
    
    let player1: UILabel = {
        let label = UILabel()
        //label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.layer.cornerRadius = 24
        //label.layer.masksToBounds = true
        label.text = "Teammate 1"
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let player2: UILabel = {
        let label = UILabel()
        //label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.layer.cornerRadius = 24
        //label.layer.masksToBounds = true
        label.text = "Teammate 2"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        return label
    }()
    
    let teamRank: UILabel = {
        let label = UILabel()
        //label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.layer.cornerRadius = 35
        //label.layer.masksToBounds = true
        label.adjustsFontSizeToFitWidth = true
        label.text = "1"
        label.font = UIFont(name: "HelveticaNeue", size: 65)
        label.textAlignment = .center
        return label
    }()
    
    let wins: UILabel = {
        let label = UILabel()
        //label.backgroundColor = UIColor.init(displayP3Red: 0/255, green: 250/255, blue: 154/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.layer.cornerRadius = 10
        //label.layer.masksToBounds = true
        label.font = UIFont(name: "HelveticaNeue", size: 22)
        label.text = "Wins: 1"
        label.textAlignment = .center
        return label
    }()
    
    let losses: UILabel = {
        let label = UILabel()
        //label.backgroundColor = UIColor.init(displayP3Red: 240/255, green: 128/255, blue: 128/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.layer.cornerRadius = 10
        //label.layer.masksToBounds = true
        label.font = UIFont(name: "HelveticaNeue", size: 22)
        label.text = "Losses: 1"
        label.textAlignment = .center
        return label
    }()
    
    let challengeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 150, g: 0, b: 0)
        button.setTitle("Challenge", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let challengeConfirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 0, g: 150, b: 0)
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backgroundImage: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.image = UIImage(named: "team_cell_bg2")
        bi.isUserInteractionEnabled = true
        return bi
    }()
    
    override func setupViews() {
        
        addSubview(backgroundImage)
        backgroundImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        backgroundImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        backgroundImage.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        
        let teamRankLoc = calculateButtonPosition(x: 150, y: 165.5, w: 167, h: 270, wib: 1242, hib: 332, wia: Float(frame.width), hia: Float(frame.height))
        
        addSubview(teamRank)
        teamRank.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(teamRankLoc.Y)).isActive = true
        teamRank.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(teamRankLoc.X)).isActive = true
        teamRank.heightAnchor.constraint(equalToConstant: CGFloat(teamRankLoc.H)).isActive = true
        teamRank.widthAnchor.constraint(equalToConstant: CGFloat(teamRankLoc.W)).isActive = true
        
        let player1Loc = calculateButtonPosition(x: 540, y: 95.5, w: 625, h: 130, wib: 1242, hib: 332, wia: Float(frame.width), hia: Float(frame.height))
        
        addSubview(player1)
        player1.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(player1Loc.Y)).isActive = true
        player1.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(player1Loc.X)).isActive = true
        player1.heightAnchor.constraint(equalToConstant: CGFloat(player1Loc.H)).isActive = true
        player1.widthAnchor.constraint(equalToConstant: CGFloat(player1Loc.W)).isActive = true
        
        let player2Loc = calculateButtonPosition(x: 540, y: 235.5, w: 625, h: 130, wib: 1242, hib: 332, wia: Float(frame.width), hia: Float(frame.height))
        
        addSubview(player2)
        player2.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(player2Loc.Y)).isActive = true
        player2.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(player2Loc.X)).isActive = true
        player2.heightAnchor.constraint(equalToConstant: CGFloat(player2Loc.H)).isActive = true
        player2.widthAnchor.constraint(equalToConstant: CGFloat(player2Loc.W)).isActive = true
        
        let winsLoc = calculateButtonPosition(x: 1000, y: 95.5, w: 266, h: 130, wib: 1242, hib: 332, wia: Float(frame.width), hia: Float(frame.height))
        
        addSubview(wins)
        wins.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(winsLoc.Y)).isActive = true
        wins.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(winsLoc.X)).isActive = true
        wins.heightAnchor.constraint(equalToConstant: CGFloat(winsLoc.H)).isActive = true
        wins.widthAnchor.constraint(equalToConstant: CGFloat(winsLoc.W)).isActive = true
        
        let lossesLoc = calculateButtonPosition(x: 1000, y: 235.5, w: 266, h: 130, wib: 1242, hib: 332, wia: Float(frame.width), hia: Float(frame.height))
        
        addSubview(losses)
        losses.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(lossesLoc.Y)).isActive = true
        losses.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(lossesLoc.X)).isActive = true
        losses.heightAnchor.constraint(equalToConstant: CGFloat(lossesLoc.H)).isActive = true
        losses.widthAnchor.constraint(equalToConstant: CGFloat(lossesLoc.W)).isActive = true
        
//        addSubview(challengeButton)
//        challengeButton.rightAnchor.constraint(equalTo: player2.rightAnchor, constant: 0).isActive = true
//        challengeButton.topAnchor.constraint(equalTo: player2.bottomAnchor, constant: 4).isActive = true
//        challengeButton.leftAnchor.constraint(equalTo: player2.leftAnchor, constant: 2).isActive = true
//        challengeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        addSubview(challengeConfirmButton)
//        challengeConfirmButton.rightAnchor.constraint(equalTo: player2.rightAnchor, constant: 0).isActive = true
//        challengeConfirmButton.topAnchor.constraint(equalTo: player2.bottomAnchor, constant: 4).isActive = true
//        challengeConfirmButton.leftAnchor.constraint(equalTo: player2.leftAnchor, constant: 2).isActive = true
//        challengeConfirmButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
    }
    
    
}

class TeamRoundCell: FeedCell {
    
    var team: Team? {
        didSet {
            wins.text = "W: \(team?.wins ?? -1)"
            losses.text = "L: \(team?.losses ?? -1)"
            teamRank.text = "\(team?.rank ?? -1)"
        }
    }
    
    let player1: UILabel = {
        let label = UILabel()
        //label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.layer.cornerRadius = 24
        //label.layer.masksToBounds = true
        label.text = "Teammate 1"
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let player2: UILabel = {
        let label = UILabel()
        //label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.layer.cornerRadius = 24
        //label.layer.masksToBounds = true
        label.text = "Teammate 2"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        return label
    }()
    
    let teamRank: UILabel = {
        let label = UILabel()
        //label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.layer.cornerRadius = 35
        //label.layer.masksToBounds = true
        label.adjustsFontSizeToFitWidth = true
        label.text = "1"
        label.font = UIFont(name: "HelveticaNeue", size: 65)
        label.textAlignment = .center
        return label
    }()
    
    let wins: UILabel = {
        let label = UILabel()
        //label.backgroundColor = UIColor.init(displayP3Red: 0/255, green: 250/255, blue: 154/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.layer.cornerRadius = 10
        //label.layer.masksToBounds = true
        label.font = UIFont(name: "HelveticaNeue", size: 22)
        label.text = "Wins: 1"
        label.textAlignment = .center
        return label
    }()
    
    let losses: UILabel = {
        let label = UILabel()
        //label.backgroundColor = UIColor.init(displayP3Red: 240/255, green: 128/255, blue: 128/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.layer.cornerRadius = 10
        //label.layer.masksToBounds = true
        label.font = UIFont(name: "HelveticaNeue", size: 22)
        label.text = "Losses: 1"
        label.textAlignment = .center
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
    
    let backgroundImage: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.image = UIImage(named: "team_cell_bg2")
        bi.isUserInteractionEnabled = true
        return bi
    }()
    
    override func setupViews() {
        
        addSubview(backgroundImage)
        backgroundImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        backgroundImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        backgroundImage.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        
        let teamRankLoc = calculateButtonPosition(x: 150, y: 165.5, w: 167, h: 270, wib: 1242, hib: 332, wia: Float(frame.width), hia: Float(frame.height))
        
        addSubview(teamRank)
        teamRank.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(teamRankLoc.Y)).isActive = true
        teamRank.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(teamRankLoc.X)).isActive = true
        teamRank.heightAnchor.constraint(equalToConstant: CGFloat(teamRankLoc.H)).isActive = true
        teamRank.widthAnchor.constraint(equalToConstant: CGFloat(teamRankLoc.W)).isActive = true
        
        let player1Loc = calculateButtonPosition(x: 540, y: 95.5, w: 625, h: 130, wib: 1242, hib: 332, wia: Float(frame.width), hia: Float(frame.height))
        
        addSubview(player1)
        player1.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(player1Loc.Y)).isActive = true
        player1.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(player1Loc.X)).isActive = true
        player1.heightAnchor.constraint(equalToConstant: CGFloat(player1Loc.H)).isActive = true
        player1.widthAnchor.constraint(equalToConstant: CGFloat(player1Loc.W)).isActive = true
        
        let player2Loc = calculateButtonPosition(x: 540, y: 235.5, w: 625, h: 130, wib: 1242, hib: 332, wia: Float(frame.width), hia: Float(frame.height))
        
        addSubview(player2)
        player2.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(player2Loc.Y)).isActive = true
        player2.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(player2Loc.X)).isActive = true
        player2.heightAnchor.constraint(equalToConstant: CGFloat(player2Loc.H)).isActive = true
        player2.widthAnchor.constraint(equalToConstant: CGFloat(player2Loc.W)).isActive = true
        
        let winsLoc = calculateButtonPosition(x: 1000, y: 95.5, w: 266, h: 130, wib: 1242, hib: 332, wia: Float(frame.width), hia: Float(frame.height))
        
        addSubview(wins)
        wins.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(winsLoc.Y)).isActive = true
        wins.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(winsLoc.X)).isActive = true
        wins.heightAnchor.constraint(equalToConstant: CGFloat(winsLoc.H)).isActive = true
        wins.widthAnchor.constraint(equalToConstant: CGFloat(winsLoc.W)).isActive = true
        
        let lossesLoc = calculateButtonPosition(x: 1000, y: 235.5, w: 266, h: 130, wib: 1242, hib: 332, wia: Float(frame.width), hia: Float(frame.height))
        
        addSubview(losses)
        losses.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(lossesLoc.Y)).isActive = true
        losses.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(lossesLoc.X)).isActive = true
        losses.heightAnchor.constraint(equalToConstant: CGFloat(lossesLoc.H)).isActive = true
        losses.widthAnchor.constraint(equalToConstant: CGFloat(lossesLoc.W)).isActive = true
        
        let pointsLoc = calculateButtonPosition(x: 900, y: 235.5, w: 466, h: 130, wib: 1242, hib: 332, wia: Float(frame.width), hia: Float(frame.height))
        
        addSubview(pointsWon)
        pointsWon.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(pointsLoc.Y)).isActive = true
        pointsWon.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(pointsLoc.X)).isActive = true
        pointsWon.heightAnchor.constraint(equalToConstant: CGFloat(pointsLoc.H)).isActive = true
        pointsWon.widthAnchor.constraint(equalToConstant: CGFloat(pointsLoc.W)).isActive = true
    }
    
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
    }
    
    
}
