//
//  MyMatchesCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/24/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MyMatchesCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var delegate: FeedCellProtocol?
    var userIsChallenger = 0
    
    var matches = [Match]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var teams = [Team]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var challengerTeamPlayer1Name = [String?]()
    var challengerTeamPlayer2Name = [String?]()
    var challengedTeamPlayer1Name = [String?]()
    var challengedTeamPlayer2Name = [String?]()
    var userTeam = Team()
    var oppTeam = Team()
    
    var myMatches = [Match]()
    
    var tourneyIdentifier: String?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .black
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(RecentMatchesCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RecentMatchesCell
        let uid = Auth.auth().currentUser?.uid
        let match = matches[indexPath.item]
        for index in teams {
            if index.teamId == match.challengerTeamId {
                if index.player1 == uid || index.player2 == uid {
                    userIsChallenger = 0
                    cell.challengerPlaceholder.image = UIImage(named: "user_team_placeholder")
                    cell.challengedPlaceholder.image = UIImage(named: "plain_team_placeholder")
                }
                let player1ref = Database.database().reference().child("users").child(index.player1 ?? "nope")
                player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? [String: AnyObject] {
                        cell.challengerTeam1.text = value["name"] as? String
                    }
                })
                
                let player2ref = Database.database().reference().child("users").child(index.player2 ?? "nope")
                player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? [String: AnyObject] {
                        cell.challengerTeam2.text = value["name"] as? String
                    }
                })
                
            }
            if index.teamId == match.challengedTeamId {
                if index.player1 == uid || index.player2 == uid {
                    userIsChallenger = 1
                    cell.challengedPlaceholder.image = UIImage(named: "user_team_placeholder")
                    cell.challengerPlaceholder.image = UIImage(named: "challenger_team_placeholder")
                }
                let player1ref = Database.database().reference().child("users").child(index.player1 ?? "nope")
                player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? [String: AnyObject] {
                        cell.challengedTeam1.text = value["name"] as? String
                    }
                })
                
                let player2ref = Database.database().reference().child("users").child(index.player2 ?? "nope")
                player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? [String: AnyObject] {
                        cell.challengedTeam2.text = value["name"] as? String
                    }
                })
            }
        }
        cell.match = match
        cell.teams = teams
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MatchInfoDisplay()
        vc.match = matches[indexPath.item]
        vc.tourneyId = tourneyIdentifier ?? ""
        print(challengedTeamPlayer1Name)
        print(challengerTeamPlayer1Name)
        if userIsChallenger == 0 {
            
            for index in teams {
                if index.teamId == matches[indexPath.item].challengerTeamId {
                    vc.userTeam = index
                } else if index.teamId == matches[indexPath.item].challengedTeamId {
                    vc.oppTeam = index
                }
            }
            vc.userIsChallenger = 0
            self.delegate?.pushNavigation(vc)
        } else {
            for index in teams {
                if index.teamId == matches[indexPath.item].challengedTeamId {
                    vc.userTeam = index
                } else if index.teamId == matches[indexPath.item].challengerTeamId {
                    vc.oppTeam = index
                }
            }
            vc.userIsChallenger = 1
            self.delegate?.pushNavigation(vc)
        }
    }
    
}
