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
        if match.active != 3 && yetToView.contains(uid!) {
            cell.notifBadge.isHidden = false
        } else {
            cell.notifBadge.isHidden = true
        }
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
        cell.editButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        cell.editButton.tag = indexPath.item
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    @objc func handleDelete(sender: UIButton) {
        let matchToDelete = matches[sender.tag]
        Database.database().reference().child("tourneys").child(tourneyIdentifier!).child("matches").child(matchToDelete.matchId!).removeValue()
        matches.remove(at: sender.tag)
        collectionView.reloadData()
    }
    
//    func handleDeleteConfirmed(action: UIAlertAction) {
//        let matchToDelete = matches[matchDeletionIndex]
//        var referencesNeedDeletion = [String]()
//        if matchToDelete.doubles == true {
//            referencesNeedDeletion.append(matchToDelete.team_1_player_2!)
//            referencesNeedDeletion.append(matchToDelete.team_2_player_2!)
//        }
//        referencesNeedDeletion.append(matchToDelete.team_1_player_1!)
//        referencesNeedDeletion.append(matchToDelete.team_2_player_1!)
//        for index in referencesNeedDeletion {
//            Database.database().reference().child("user_matches").child(index).child(matchToDelete.matchId!).removeValue()
//        }
//        Database.database().reference().child("matches").child(matchToDelete.matchId!).removeValue()
//        matches.remove(at: matchDeletionIndex)
//        tableView.reloadData()
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.width / 1.875 + 66)
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
        vc.match.style = matches[indexPath.item].style ?? 0
        vc.match.doubles = true
        self.delegate?.pushNavigation(vc)
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        if yetToView.contains(uid) {
            yetToView.remove(at: yetToView.firstIndex(of: uid)!)
            collectionView.reloadData()
        }
    }
    
}
