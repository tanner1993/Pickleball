//
//  MatchFeed.swift
//  Pickleball
//
//  Created by Tanner Rozier on 3/26/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

private let cellId = "cellId"

class MatchFeed: UITableViewController {
    
    var matches = [Match2]()
    var player = Player()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchMatches()
        setupNavbarTitle()
        tableView?.register(FeedMatchCell.self, forCellReuseIdentifier: cellId)
        tableView?.backgroundColor = .white
        self.tableView.separatorStyle = .none
//        self.collectionView!.register(FeedMatchCell.self, forCellWithReuseIdentifier: cellId)
//        self.collectionView.backgroundColor = .white
    }

    func setupNavbarTitle() {
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        titleLabel.text = "News Feed"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.navigationItem.titleView = titleLabel
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }

//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return matches.count
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FeedMatchCell
        let uid = Auth.auth().currentUser?.uid
        let match = matches[indexPath.item]
        if match.active == 3 {
            if match.winner == 1 {
                cell.challengerPlaceholder.image = UIImage(named: "winning_team_placeholder2")
                cell.challengedPlaceholder.image = UIImage(named: "challenger_team_placeholder")
            } else if match.winner == 2 {
                cell.challengerPlaceholder.image = UIImage(named: "challenger_team_placeholder")
                cell.challengedPlaceholder.image = UIImage(named: "winning_team_placeholder2")
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
        let player1ref = Database.database().reference().child("users").child(match.team_1_player_1 ?? "nope")
        player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                cell.challengerTeam1.setTitle(value["username"] as? String, for: .normal)
                cell.challengerTeam1.tag = indexPath.item
                cell.challengerTeam1.addTarget(self, action: #selector(self.handleViewPlayer), for: .touchUpInside)
                let exp = value["exp"] as? Int ?? 0
                cell.appLevel.text = "\(self.player.haloLevel(exp: exp))"
            }
        })
        
        let player2ref = Database.database().reference().child("users").child(match.team_1_player_2 ?? "nope")
        player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                cell.challengerTeam2.setTitle(value["username"] as? String, for: .normal)
                cell.challengerTeam2.tag = indexPath.item
                cell.challengerTeam2.addTarget(self, action: #selector(self.handleViewPlayer2), for: .touchUpInside)
                let exp = value["exp"] as? Int ?? 0
                cell.appLevel2.text = "\(self.player.haloLevel(exp: exp))"
            }
        })
        
        let player1ref2 = Database.database().reference().child("users").child(match.team_2_player_1 ?? "nope")
        player1ref2.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                cell.challengedTeam1.setTitle(value["username"] as? String, for: .normal)
                cell.challengedTeam1.tag = indexPath.item
                cell.challengedTeam1.addTarget(self, action: #selector(self.handleViewPlayer3), for: .touchUpInside)
                let exp = value["exp"] as? Int ?? 0
                cell.appLevel3.text = "\(self.player.haloLevel(exp: exp))"
            }
        })
        
        let player2ref2 = Database.database().reference().child("users").child(match.team_2_player_2 ?? "nope")
        player2ref2.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                cell.challengedTeam2.setTitle(value["username"] as? String, for: .normal)
                cell.challengedTeam2.tag = indexPath.item
                cell.challengedTeam2.addTarget(self, action: #selector(self.handleViewPlayer4), for: .touchUpInside)
                let exp = value["exp"] as? Int ?? 0
                cell.appLevel4.text = "\(self.player.haloLevel(exp: exp))"
            }
        })
        cell.match = match
        cell.backgroundColor = UIColor.white
        return cell
    }

//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedMatchCell
//        let uid = Auth.auth().currentUser?.uid
//        let match = matches[indexPath.item]
//        if match.active == 3 {
//            if match.winner == 1 {
//                cell.challengerPlaceholder.image = UIImage(named: "winning_team_placeholder")
//                cell.challengedPlaceholder.image = UIImage(named: "challenger_team_placeholder")
//            } else if match.winner == 2 {
//                cell.challengerPlaceholder.image = UIImage(named: "challenger_team_placeholder")
//                cell.challengedPlaceholder.image = UIImage(named: "winning_team_placeholder")
//            }
//        } else {
//            if uid == match.team_1_player_1 || uid == match.team_1_player_2 {
//                cell.challengerPlaceholder.image = UIImage(named: "user_team_placeholder")
//                cell.challengedPlaceholder.image = UIImage(named: "plain_team_placeholder")
//            } else if uid == match.team_2_player_1 || uid == match.team_2_player_2 {
//                cell.challengerPlaceholder.image = UIImage(named: "plain_team_placeholder")
//                cell.challengedPlaceholder.image = UIImage(named: "user_team_placeholder")
//            } else {
//                cell.challengerPlaceholder.image = UIImage(named: "plain_team_placeholder")
//                cell.challengedPlaceholder.image = UIImage(named: "plain_team_placeholder")
//            }
//        }
//        let player1ref = Database.database().reference().child("users").child(match.team_1_player_1 ?? "nope")
//        player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
//            if let value = snapshot.value as? [String: AnyObject] {
//                cell.challengerTeam1.setTitle(value["username"] as? String, for: .normal)
//                cell.challengerTeam1.tag = indexPath.item
//                cell.challengerTeam1.addTarget(self, action: #selector(self.handleViewPlayer), for: .touchUpInside)
//            }
//        })
//        
//        let player2ref = Database.database().reference().child("users").child(match.team_1_player_2 ?? "nope")
//        player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
//            if let value = snapshot.value as? [String: AnyObject] {
//                cell.challengerTeam2.setTitle(value["username"] as? String, for: .normal)
//                cell.challengerTeam2.tag = indexPath.item
//                cell.challengerTeam2.addTarget(self, action: #selector(self.handleViewPlayer2), for: .touchUpInside)
//            }
//        })
//        
//        let player1ref2 = Database.database().reference().child("users").child(match.team_2_player_1 ?? "nope")
//        player1ref2.observeSingleEvent(of: .value, with: {(snapshot) in
//            if let value = snapshot.value as? [String: AnyObject] {
//                cell.challengedTeam1.setTitle(value["username"] as? String, for: .normal)
//                cell.challengedTeam1.tag = indexPath.item
//                cell.challengedTeam1.addTarget(self, action: #selector(self.handleViewPlayer3), for: .touchUpInside)
//            }
//        })
//        
//        let player2ref2 = Database.database().reference().child("users").child(match.team_2_player_2 ?? "nope")
//        player2ref2.observeSingleEvent(of: .value, with: {(snapshot) in
//            if let value = snapshot.value as? [String: AnyObject] {
//                cell.challengedTeam2.setTitle(value["username"] as? String, for: .normal)
//                cell.challengedTeam2.tag = indexPath.item
//                cell.challengedTeam2.addTarget(self, action: #selector(self.handleViewPlayer4), for: .touchUpInside)
//            }
//        })
//        cell.match = match
//        cell.backgroundColor = UIColor.white
//        return cell
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: 226)
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(226)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func handleViewPlayer(sender: UIButton) {
        let whichOne = sender.tag
        let playerProfile = StartupPage()
        playerProfile.hidesBottomBarWhenPushed = true
        playerProfile.playerId = matches[whichOne].team_1_player_1!
        playerProfile.isFriend = 3
        navigationController?.pushViewController(playerProfile, animated: true)
    }
    
    @objc func handleViewPlayer2(sender: UIButton) {
        let whichOne = sender.tag
        let playerProfile = StartupPage()
        playerProfile.hidesBottomBarWhenPushed = true
        playerProfile.playerId = matches[whichOne].team_1_player_2!
        playerProfile.isFriend = 3
        navigationController?.pushViewController(playerProfile, animated: true)
    }
    
    @objc func handleViewPlayer3(sender: UIButton) {
        let whichOne = sender.tag
        let playerProfile = StartupPage()
        playerProfile.hidesBottomBarWhenPushed = true
        playerProfile.playerId = matches[whichOne].team_2_player_1!
        playerProfile.isFriend = 3
        navigationController?.pushViewController(playerProfile, animated: true)
    }
    
    @objc func handleViewPlayer4(sender: UIButton) {
        let whichOne = sender.tag
        let playerProfile = StartupPage()
        playerProfile.hidesBottomBarWhenPushed = true
        playerProfile.playerId = matches[whichOne].team_2_player_2!
        playerProfile.isFriend = 3
        navigationController?.pushViewController(playerProfile, animated: true)
    }
    
    func fetchMatches() {
        let ref = Database.database().reference().child("completed_matches").queryLimited(toLast: 10)
        ref.observe(.childAdded, with: { (snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    let matchT = Match2()
                    let active = value["active"] as? Int ?? 0
                    let submitter = value["submitter"] as? Int ?? 0
                    let winner = value["winner"] as? Int ?? 0
                    let team_1_player_1 = value["team_1_player_1"] as? String ?? "Player not found"
                    let team_1_player_2 = value["team_1_player_2"] as? String ?? "Player not found"
                    let team_2_player_1 = value["team_2_player_1"] as? String ?? "Player not found"
                    let team_2_player_2 = value["team_2_player_2"] as? String ?? "Player not found"
                    let team1_scores = value["team1_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                    let team2_scores = value["team2_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                    let time = value["time"] as? Double ?? Date().timeIntervalSince1970
                    matchT.active = active
                    matchT.winner = winner
                    matchT.submitter = submitter
                    matchT.team_1_player_1 = team_1_player_1
                    matchT.team_1_player_2 = team_1_player_2
                    matchT.team_2_player_1 = team_2_player_1
                    matchT.team_2_player_2 = team_2_player_2
                    matchT.team1_scores = team1_scores
                    matchT.team2_scores = team2_scores
                    matchT.matchId = snapshot.key
                    matchT.time = time
                    self.matches.append(matchT)
                    self.matches = self.matches.sorted { p1, p2 in
                        return (p1.time!) > (p2.time!)
                    }
                    DispatchQueue.main.async { self.tableView.reloadData()}
                }
        }, withCancel: nil)
    }

}
