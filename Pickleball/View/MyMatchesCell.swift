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
    
    var matches = [Match2]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var teams = [Team]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var active = 0 {
        didSet {
            if active >= 2 {
                collectionView.contentInset = UIEdgeInsets(top: 320, left: 0, bottom: 0, right: 0)
                collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 320, left: 0, bottom: 0, right: 0)
            }
        }
    }
    var yetToView = [String]()
    var finals1 = 0
    var finals2 = 0
    var challengerTeamPlayer1Name = [String?]()
    var challengerTeamPlayer2Name = [String?]()
    var challengedTeamPlayer1Name = [String?]()
    var challengedTeamPlayer2Name = [String?]()
    var userTeamId = ""
    
    var myMatches = [Match2]()
    
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
        if match.active == 3 {
            if match.winner == 1 {
                cell.challengerPlaceholder.image = UIImage(named: "winning_team_placeholder")
                cell.challengedPlaceholder.image = UIImage(named: "challenger_team_placeholder")
            } else if match.winner == 2 {
                cell.challengerPlaceholder.image = UIImage(named: "challenger_team_placeholder")
                cell.challengedPlaceholder.image = UIImage(named: "winning_team_placeholder")
            }
        } else {
            if uid == match.team_1_player_1 || uid == match.team_1_player_2 {
                cell.challengerPlaceholder.image = UIImage(named: "user_team_placeholder")
                cell.challengedPlaceholder.image = UIImage(named: "plain_team_placeholder")
            } else if uid == match.team_2_player_1 || uid == match.team_2_player_2 {
                cell.challengerPlaceholder.image = UIImage(named: "plain_team_placeholder")
                cell.challengedPlaceholder.image = UIImage(named: "user_team_placeholder")
            } else {
                cell.challengerPlaceholder.image = UIImage(named: "plain_team_placeholder")
                cell.challengedPlaceholder.image = UIImage(named: "plain_team_placeholder")
            }
        }
        for index in teams {
            if match.team_1_player_1 == index.player1 {
                cell.teamRank1.text = "\(index.rank ?? 0)"
            } else if match.team_2_player_1 == index.player1 {
                cell.teamRank2.text = "\(index.rank ?? 0)"
            }
        }
        let player1ref = Database.database().reference().child("users").child(match.team_1_player_1 ?? "nope")
        player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                cell.challengerTeam1.text = value["username"] as? String
            }
        })
        
        let player2ref = Database.database().reference().child("users").child(match.team_1_player_2 ?? "nope")
        player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                cell.challengerTeam2.text = value["username"] as? String
            }
        })
        
        let player1ref2 = Database.database().reference().child("users").child(match.team_2_player_1 ?? "nope")
        player1ref2.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                cell.challengedTeam1.text = value["username"] as? String
            }
        })
        
        let player2ref2 = Database.database().reference().child("users").child(match.team_2_player_2 ?? "nope")
        player2ref2.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                cell.challengedTeam2.text = value["username"] as? String
            }
        })
        cell.match = match
        cell.teams = teams
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.width / 1.875 + 26)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MatchView()
        for index in teams {
            if matches[indexPath.item].team_1_player_1 == index.player1 {
                vc.team1 = index
            } else if matches[indexPath.item].team_2_player_1 == index.player1 {
                vc.team2 = index
            }
        }
        vc.teams = teams
        vc.matchId = matches[indexPath.item].matchId ?? "none"
        vc.tourneyId = tourneyIdentifier ?? ""
        vc.tourneyActive = active
        vc.finals1 = finals1
        vc.finals2 = finals2
        vc.yetToView = yetToView
        self.delegate?.pushNavigation(vc)
        print(userTeamId)
//        if userTeamId == matches[indexPath.item].challengerTeamId {
//            vc.userIsChallenger = 0
//            for index in teams {
//                if index.teamId == userTeamId {
//                    vc.userTeam = index
//                } else if index.teamId == matches[indexPath.item].challengedTeamId {
//                    vc.oppTeam = index
//                }
//            }
//            self.delegate?.pushNavigation(vc)
//        } else if userTeamId == matches[indexPath.item].challengedTeamId {
//            vc.userIsChallenger = 1
//            for index in teams {
//                if index.teamId == userTeamId {
//                    vc.userTeam = index
//                } else if index.teamId == matches[indexPath.item].challengerTeamId {
//                    vc.oppTeam = index
//                }
//            }
//            vc.teams = teams
//            vc.tourneyStandings = TourneyStandings()
//            self.delegate?.pushNavigation(vc)
//        }
        
    }
    
}
