//
//  FeedCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/6/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FeedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var delegate: FeedCellProtocol?
    var tourneyName = String()
    var style = Int()
    var nameTracker = [String: String]()
    var type = "Ladder"
    var collectionViewCell = UICollectionViewCell()
    var activityIndicatorView: UIActivityIndicatorView!
    
    var teams = [Team]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var cellTag = -1
    var myTeamId: Int?
    var tourneyIdentifier: String?
    var active = 0 {
        didSet {
            if active >= 2 && type == "Ladder" {
                collectionView.contentInset = UIEdgeInsets(top: 320, left: 0, bottom: 0, right: 0)
                collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 320, left: 0, bottom: 0, right: 0)
            }
        }
    }
    var tourneyStandings = TourneyStandings()
    
    
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
    let cellId2 = "cellId2"
    let cellIdNone = "cellIdNone"
    var noNotifications = 0
    
    
    override func setupViews() {
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.fillInRow()
        }
        super.setupViews()
        backgroundColor = .white
        
        //observeTourneyTeams()
        addSubview(collectionView)
        collectionView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        collectionView.register(TeamCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(TeamRoundCell.self, forCellWithReuseIdentifier: cellId2)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: cellIdNone)
    }
    
    func fillInRow() {
        if teams.count == 0 {
            noNotifications = 1
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count == 0 ? 1 : teams.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if teams.count == 0 {
            if noNotifications == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdNone, for: indexPath) as! EmptyCell
                cell.backgroundView = activityIndicatorView
                activityIndicatorView.startAnimating()
                return cell
            } else {
                activityIndicatorView.stopAnimating()
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdNone, for: indexPath) as! EmptyCell
                cell.emptyLabel.text = "No Teams Registered"
                cell.emptyLabel.textAlignment = .center
                return cell
            }
        } else if type == "Ladder" {
            activityIndicatorView.stopAnimating()
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TeamCell
            let uid = Auth.auth().currentUser?.uid
            cell.team = teams[indexPath.item]
            if cell.team?.player1 == uid || cell.team?.player2 == uid {
                //cell.backgroundColor = .gray
                cell.backgroundImage.image = UIImage(named: "team_cell_bg2_ladder_you")
                myTeamId = indexPath.item
            } else {
                //cell.backgroundColor = UIColor.white
                cell.backgroundImage.image = UIImage(named: "team_cell_bg2_ladder")
            }

            if nameTracker[cell.team?.player1 ?? "nope"] == nil {
                let player1ref = Database.database().reference().child("users").child(cell.team?.player1 ?? "nope").child("name")
                player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value {
                        let playerName = value as? String ?? "noName"
                        cell.player1.text = self.getFirstAndLastInitial(name: playerName)
                        self.nameTracker[cell.team?.player1 ?? "nope"] = self.getFirstAndLastInitial(name: playerName)
                    }
                })
            } else {
                cell.player1.text = nameTracker[cell.team?.player1 ?? "nope"]
            }

            if nameTracker[cell.team?.player1 ?? "nope"] == nil {
                let player2ref = Database.database().reference().child("users").child(cell.team?.player2 ?? "nope").child("name")
                player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value {
                        let playerName = value as? String ?? "noName"
                        cell.player2.text = self.getFirstAndLastInitial(name: playerName)
                        self.nameTracker[cell.team?.player2 ?? "nope"] = self.getFirstAndLastInitial(name: playerName)
                    }
                })
            } else {
                cell.player2.text = nameTracker[cell.team?.player2 ?? "nope"]
            }

            return cell
        } else {
            activityIndicatorView.stopAnimating()
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! TeamRoundCell
            let uid = Auth.auth().currentUser?.uid
            cell.team = teams[indexPath.item]
            cell.teamRank.text = "\(indexPath.item + 1)"
            if cell.team?.player1 == uid || cell.team?.player2 == uid {
                //cell.backgroundColor = .gray
                cell.backgroundImage.image = UIImage(named: "team_cell_bg2_you")
                myTeamId = indexPath.item
            } else {
                //cell.backgroundColor = UIColor.white
                cell.backgroundImage.image = UIImage(named: "team_cell_bg2")
            }

            if nameTracker[cell.team?.player1 ?? "nope"] == nil {
                let player1ref = Database.database().reference().child("users").child(cell.team?.player1 ?? "nope").child("name")
                player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value {
                        let playerName = value as? String ?? "noName"
                        cell.player1.text = self.getFirstAndLastInitial(name: playerName)
                        self.nameTracker[cell.team?.player1 ?? "nope"] = self.getFirstAndLastInitial(name: playerName)
                    }
                })
            } else {
                cell.player1.text = nameTracker[cell.team?.player1 ?? "nope"]
            }

            if nameTracker[cell.team?.player1 ?? "nope"] == nil {
                let player2ref = Database.database().reference().child("users").child(cell.team?.player2 ?? "nope").child("name")
                player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value {
                        let playerName = value as? String ?? "noName"
                        cell.player2.text = self.getFirstAndLastInitial(name: playerName)
                        self.nameTracker[cell.team?.player2 ?? "nope"] = self.getFirstAndLastInitial(name: playerName)
                    }
                })
            } else {
                cell.player2.text = nameTracker[cell.team?.player2 ?? "nope"]
            }

            return cell
        }
    }
    
    func getFirstAndLastInitial(name: String) -> String {
        var initials = ""
        var finalChar = 0
        for char in name {
            if finalChar == 0 {
                initials.append(char)
            }
            if finalChar == 1 {
                initials.append(char)
                initials.append(".")
                break
            }
            
            if char == " " {
                finalChar = 1
            }
        }
        return initials
    }
    
    @objc func handleChallengeInvitation(sender: UIButton) {
        cellTag = sender.tag
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.width / 3.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.init(displayP3Red: 88/255, green: 148/255, blue: 200/255, alpha: 0.3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = nil
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if teams.count == 0 {
            
        } else {
            guard let myTeamIndex = myTeamId else {
                return
            }
            guard let tourneyId = self.tourneyIdentifier else {
                return
            }
            let vc = TeamInfoDisplay()
            vc.teamIdSelected = teams[indexPath.item]
            vc.usersTeamId = teams[myTeamIndex]
            vc.tourneyId = tourneyId
            vc.active = active
            vc.style = style
            vc.tourneyName = tourneyName
            self.delegate?.pushNavigation(vc)
            
        }
    }
    

}
