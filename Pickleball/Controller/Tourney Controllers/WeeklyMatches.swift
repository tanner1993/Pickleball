//
//  WeeklyMatches.swift
//  Pickleball
//
//  Created by Tanner Rozier on 7/12/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

class WeeklyMatches: UITableViewController {
    
    let cellId = "cellId"
    var matches = [Match2]()
    var tourney = Tourney()
    var week = Int()
    var nameTracker = [String: String]()
    var levelTracker = [String: String]()
    let player = Player()
    var teams = [Team]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.register(FeedMatchCell.self, forCellReuseIdentifier: cellId)
        fetchMatches()
        setupTitle()
    }
    
    private func setupTitle() {
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        titleLabel.text = "Week \(week) Matches"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        navigationItem.titleView = titleLabel
    }
    
    func fetchMatches() {
        tourney.fetchMatches(week: week, completion:{ (result) in
            guard let matchResults = result else {
                print("failed to get rresult")
                return
            }
            self.matches = matchResults
            self.tableView.reloadData()
        })
    }
    
    func findTeamIndices(team1Player1: String, team2Player1: String) -> [Team] {
        var team1 = Team()
        var team2 = Team()
        for team in teams {
            if team.player1 == team1Player1 {
                team1 = team
            } else if team.player1 == team2Player1 {
                team2 = team
            }
        }
        return [team1, team2]
    }
    
    func showAlert() {
        let newalert = UIAlertController(title: "Sorry", message: "You are not a part of this match, please select one of your matches", preferredStyle: UIAlertController.Style.alert)
        newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
        self.present(newalert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width / 1.875 + 66
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let match = matches[indexPath.row]
        if ![match.team_1_player_1!, match.team_1_player_2!, match.team_2_player_1!, match.team_2_player_2!].contains(uid) {
            showAlert()
        } else {
            let roundRobinMatch = RoundRobinMatch()
            roundRobinMatch.tourney = tourney
            roundRobinMatch.week = week
            roundRobinMatch.weeklyMatches = self
            roundRobinMatch.whichItem = indexPath.row
            roundRobinMatch.match = match
            let matchTeams = findTeamIndices(team1Player1: match.team_1_player_1!, team2Player1: match.team_2_player_1!)
            roundRobinMatch.team1 = matchTeams[0]
            roundRobinMatch.team2 = matchTeams[1]
            navigationController?.pushViewController(roundRobinMatch, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FeedMatchCell
        let match = matches[indexPath.row]
        cell.likesLabel.isHidden = true
        cell.likeImage.isHidden = true
        cell.likedButton.isHidden = true
        cell.openLikesButton.isHidden = true
        cell.challengerTeam1.isUserInteractionEnabled = false
        cell.challengerTeam1.setTitleColor(.black, for: .normal)
        cell.challengerTeam2.isUserInteractionEnabled = false
        cell.challengerTeam2.setTitleColor(.black, for: .normal)
        cell.challengedTeam1.isUserInteractionEnabled = false
        cell.challengedTeam1.setTitleColor(.black, for: .normal)
        cell.challengedTeam2.isUserInteractionEnabled = false
        cell.challengedTeam2.setTitleColor(.black, for: .normal)
        cell.whiteBoxTopAnchor?.isActive = false
        cell.whiteBoxTopAnchor = cell.whiteBox.topAnchor.constraint(equalTo: cell.headerLabel.bottomAnchor)
        cell.whiteBoxTopAnchor?.isActive = true
        cell.courtLabel.isHidden = true
        cell.headerLabel.isHidden = false
        cell.selectCourtButton.isHidden = true
        cell.headerLabelRightAnchor?.isActive = false
        cell.headerLabelRightAnchor = cell.headerLabel.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -4)
        cell.headerLabelRightAnchor?.isActive = true
        if nameTracker[match.team_1_player_1 ?? "nope"] == nil {
            let player1ref = Database.database().reference().child("users").child(match.team_1_player_1 ?? "nope")
            player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value as? [String: AnyObject] {
                    cell.challengerTeam1.setTitle((value["name"] as? String ?? "none").getFirstAndLastInitial, for: .normal)
                    self.nameTracker[match.team_1_player_1 ?? "nope"] = (value["name"] as? String ?? "none").getFirstAndLastInitial
                    let exp = value["exp"] as? Int ?? 0
                    cell.appLevel.text = "\(self.player.haloLevel(exp: exp))"
                    self.levelTracker[match.team_1_player_1 ?? "nope"] = "\(self.player.haloLevel(exp: exp))"
                }
            })
        } else {
            cell.challengerTeam1.setTitle(nameTracker[match.team_1_player_1 ?? "nope"], for: .normal)
            cell.appLevel.text = levelTracker[match.team_1_player_1 ?? "nope"]
        }
        cell.challengerTeam2.isUserInteractionEnabled = false
        cell.challengerTeam2.setTitleColor(.black, for: .normal)
        if nameTracker[match.team_1_player_2 ?? "nope"] == nil {
            let player2ref = Database.database().reference().child("users").child(match.team_1_player_2 ?? "nope")
            player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value as? [String: AnyObject] {
                    cell.challengerTeam2.setTitle((value["name"] as? String ?? "none").getFirstAndLastInitial, for: .normal)
                    self.nameTracker[match.team_1_player_2 ?? "nope"] = (value["name"] as? String ?? "none").getFirstAndLastInitial
                    let exp = value["exp"] as? Int ?? 0
                    cell.appLevel2.text = "\(self.player.haloLevel(exp: exp))"
                    self.levelTracker[match.team_1_player_2 ?? "nope"] = "\(self.player.haloLevel(exp: exp))"
                }
            })
        } else {
            cell.challengerTeam2.setTitle(nameTracker[match.team_1_player_2 ?? "nope"], for: .normal)
            cell.appLevel2.text = levelTracker[match.team_1_player_2 ?? "nope"]
        }
    cell.challengerTeam2.isHidden = false
    cell.appLevel2.isHidden = false
        
        if nameTracker[match.team_2_player_1 ?? "nope"] == nil {
            let player1ref2 = Database.database().reference().child("users").child(match.team_2_player_1 ?? "nope")
            player1ref2.observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value as? [String: AnyObject] {
                    cell.challengedTeam1.setTitle((value["name"] as? String ?? "none").getFirstAndLastInitial, for: .normal)
                    self.nameTracker[match.team_2_player_1 ?? "nope"] = (value["name"] as? String ?? "none").getFirstAndLastInitial
                    let exp = value["exp"] as? Int ?? 0
                    cell.appLevel3.text = "\(self.player.haloLevel(exp: exp))"
                    self.levelTracker[match.team_2_player_1 ?? "nope"] = "\(self.player.haloLevel(exp: exp))"
                }
            })
        } else {
            cell.challengedTeam1.setTitle(nameTracker[match.team_2_player_1 ?? "nope"], for: .normal)
            cell.appLevel3.text = levelTracker[match.team_2_player_1 ?? "nope"]
        }
        cell.challengedTeam2.isUserInteractionEnabled = false
        cell.challengedTeam2.setTitleColor(.black, for: .normal)
        if nameTracker[match.team_2_player_2 ?? "nope"] == nil {
            let player2ref2 = Database.database().reference().child("users").child(match.team_2_player_2 ?? "nope")
            player2ref2.observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value as? [String: AnyObject] {
                    cell.challengedTeam2.setTitle((value["name"] as? String ?? "none").getFirstAndLastInitial, for: .normal)
                    self.nameTracker[match.team_2_player_2 ?? "nope"] = (value["name"] as? String ?? "none").getFirstAndLastInitial
                    let exp = value["exp"] as? Int ?? 0
                    cell.appLevel4.text = "\(self.player.haloLevel(exp: exp))"
                    self.levelTracker[match.team_2_player_2 ?? "nope"] = "\(self.player.haloLevel(exp: exp))"
                }
            })
        } else {
            cell.challengedTeam2.setTitle(nameTracker[match.team_2_player_2 ?? "nope"], for: .normal)
            cell.appLevel4.text = levelTracker[match.team_2_player_2 ?? "nope"]
        }
        cell.challengedTeam2.isHidden = false
        cell.appLevel4.isHidden = false
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
        cell.match = match
        cell.editButton.isHidden = true
        cell.backgroundColor = UIColor.white
        return cell
    }
}
