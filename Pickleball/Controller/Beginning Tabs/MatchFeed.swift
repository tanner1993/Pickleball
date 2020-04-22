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
    var noNotifications = 0
    let cellIdNone = "loading"
    var sender = 0
    var nameTracker = [String: String]()
    var levelTracker = [String: String]()
    var matchIds = [String]()
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    override func loadView() {
        super.loadView()
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.fillInRow()
        }
        view.backgroundColor = .white
        if sender == 0 {
            fetchMatches()
        } else {
            fetchMyMatches()
        }
        setupNavbarTitle()
        tableView?.register(FeedMatchCell.self, forCellReuseIdentifier: cellId)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellIdNone)
        tableView?.backgroundColor = .white
        self.tableView.separatorStyle = .none
//        self.collectionView!.register(FeedMatchCell.self, forCellWithReuseIdentifier: cellId)
//        self.collectionView.backgroundColor = .white
    }
    
    func fillInRow() {
        if matches.count == 0 {
            noNotifications = 1
            tableView.reloadData()
        }
    }

    func setupNavbarTitle() {
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        if sender == 0 {
            titleLabel.text = "News Feed"
        } else {
            titleLabel.text = "My Matches"
            let plusImage = UIImage(named: "plus")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            let createNewButton = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(handleCreateNewMatch))
            self.navigationItem.rightBarButtonItem = createNewButton
        }
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.navigationItem.titleView = titleLabel
    }
    
    @objc func handleSort() {
        self.matches = self.matches.sorted { p1, p2 in
            return (p1.time!) > (p2.time!)
        }
        self.tableView.reloadData()
    }
    
    @objc func handleCreateNewMatch() {
        let createNewMatch = CreateMatch()
        createNewMatch.hidesBottomBarWhenPushed = true
        navigationController?.present(createNewMatch, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count == 0 ? 1 : matches.count
    }

//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return matches.count
//    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if matches.count == 0 {
            if noNotifications == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdNone, for: indexPath)
                cell.backgroundView = activityIndicatorView
                activityIndicatorView.startAnimating()
                return cell
            } else {
                activityIndicatorView.stopAnimating()
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdNone, for: indexPath)
                cell.textLabel?.text = "No News"
                cell.textLabel?.textAlignment = .center
                return cell
            }
        } else {
            activityIndicatorView.stopAnimating()
            
            let match = matches[indexPath.item]
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FeedMatchCell
            if nameTracker[match.team_1_player_1 ?? "nope"] == nil {
                let player1ref = Database.database().reference().child("users").child(match.team_1_player_1 ?? "nope")
                player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? [String: AnyObject] {
                        cell.challengerTeam1.setTitle(value["username"] as? String, for: .normal)
                        self.nameTracker[match.team_1_player_1 ?? "nope"] = value["username"] as? String
                        let exp = value["exp"] as? Int ?? 0
                        cell.appLevel.text = "\(self.player.haloLevel(exp: exp))"
                        self.levelTracker[match.team_1_player_1 ?? "nope"] = "\(self.player.haloLevel(exp: exp))"
                    }
                })
            } else {
                cell.challengerTeam1.setTitle(nameTracker[match.team_1_player_1 ?? "nope"], for: .normal)
                cell.appLevel.text = levelTracker[match.team_1_player_1 ?? "nope"]
            }
            
            if nameTracker[match.team_1_player_2 ?? "nope"] == nil {
                let player2ref = Database.database().reference().child("users").child(match.team_1_player_2 ?? "nope")
                player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? [String: AnyObject] {
                        cell.challengerTeam2.setTitle(value["username"] as? String, for: .normal)
                        self.nameTracker[match.team_1_player_2 ?? "nope"] = value["username"] as? String
                        let exp = value["exp"] as? Int ?? 0
                        cell.appLevel2.text = "\(self.player.haloLevel(exp: exp))"
                        self.levelTracker[match.team_1_player_2 ?? "nope"] = "\(self.player.haloLevel(exp: exp))"
                    }
                })
            } else {
                cell.challengerTeam2.setTitle(nameTracker[match.team_1_player_2 ?? "nope"], for: .normal)
                cell.appLevel2.text = levelTracker[match.team_1_player_2 ?? "nope"]
            }
            
            if nameTracker[match.team_2_player_1 ?? "nope"] == nil {
                let player1ref2 = Database.database().reference().child("users").child(match.team_2_player_1 ?? "nope")
                player1ref2.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? [String: AnyObject] {
                        cell.challengedTeam1.setTitle(value["username"] as? String, for: .normal)
                        self.nameTracker[match.team_2_player_1 ?? "nope"] = value["username"] as? String
                        let exp = value["exp"] as? Int ?? 0
                        cell.appLevel3.text = "\(self.player.haloLevel(exp: exp))"
                        self.levelTracker[match.team_2_player_1 ?? "nope"] = "\(self.player.haloLevel(exp: exp))"
                    }
                })
            } else {
                cell.challengedTeam1.setTitle(nameTracker[match.team_2_player_1 ?? "nope"], for: .normal)
                cell.appLevel3.text = levelTracker[match.team_2_player_1 ?? "nope"]
            }
            
            if nameTracker[match.team_2_player_2 ?? "nope"] == nil {
                let player2ref2 = Database.database().reference().child("users").child(match.team_2_player_2 ?? "nope")
                player2ref2.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? [String: AnyObject] {
                        cell.challengedTeam2.setTitle(value["username"] as? String, for: .normal)
                        self.nameTracker[match.team_2_player_2 ?? "nope"] = value["username"] as? String
                        let exp = value["exp"] as? Int ?? 0
                        cell.appLevel4.text = "\(self.player.haloLevel(exp: exp))"
                        self.levelTracker[match.team_2_player_2 ?? "nope"] = "\(self.player.haloLevel(exp: exp))"
                    }
                })
            } else {
                cell.challengedTeam2.setTitle(nameTracker[match.team_2_player_2 ?? "nope"], for: .normal)
                cell.appLevel4.text = levelTracker[match.team_2_player_2 ?? "nope"]
            }
            let uid = Auth.auth().currentUser?.uid
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
            
            cell.challengerTeam1.tag = indexPath.item
            cell.challengerTeam1.addTarget(self, action: #selector(self.handleViewPlayer), for: .touchUpInside)
            cell.challengerTeam2.tag = indexPath.item
            cell.challengerTeam2.addTarget(self, action: #selector(self.handleViewPlayer2), for: .touchUpInside)
            cell.challengedTeam1.tag = indexPath.item
            cell.challengedTeam1.addTarget(self, action: #selector(self.handleViewPlayer3), for: .touchUpInside)
            cell.challengedTeam2.tag = indexPath.item
            cell.challengedTeam2.addTarget(self, action: #selector(self.handleViewPlayer4), for: .touchUpInside)
                    
            cell.match = match
            cell.backgroundColor = UIColor.white
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if matches.count > 0 {
            if sender == 1 {
                let matchDisplay = MatchView()
                matchDisplay.matchId = matches[indexPath.item].matchId ?? "none"
                matchDisplay.match = matches[indexPath.item]
                matchDisplay.whichItem = indexPath.item
                matchDisplay.matchFeed = self
                navigationController?.pushViewController(matchDisplay, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sender == 0 {
            return view.frame.width / 1.875 + 26
        } else {
            return view.frame.width / 1.875 + 66
        }
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
    
//    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if sender == 0 {
//            return nil
//        }
//    }
    
//    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
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
    
    func fetchMyMatches() {
        for index in matchIds {
            let rootRef = Database.database().reference()
            let query = rootRef.child("matches").child(index)
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
                if let value = snapshot.value as? NSDictionary {
                    let matchT = Match2()
                    let active = value["active"] as? Int ?? 0
                    let submitter = value["submitter"] as? Int ?? 0
                    let winner = value["winner"] as? Int ?? 0
                    let style = value["style"] as? Int ?? 0
                    let team_1_player_1 = value["team_1_player_1"] as? String ?? "Player not found"
                    let team_1_player_2 = value["team_1_player_2"] as? String ?? "Player not found"
                    let team_2_player_1 = value["team_2_player_1"] as? String ?? "Player not found"
                    let team_2_player_2 = value["team_2_player_2"] as? String ?? "Player not found"
                    let team1_scores = value["team1_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                    let team2_scores = value["team2_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                    let time = value["time"] as? Double ?? Date().timeIntervalSince1970
                    let forfeit = value["forfeit"] as? Int ?? 0
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
                    matchT.forfeit = forfeit
                    matchT.style = style
                    matchT.doubles = team_1_player_2 == "Player not found" ? false : true
                    self.matches.append(matchT)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }, withCancel: nil)
        }
    }

}
