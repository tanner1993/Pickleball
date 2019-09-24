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

    var teams = [Team]()
    var cellTag = -1
    var myTeamId: Int?
    
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
    
    func observeTourneyTeams() {
        let ref = Database.database().reference().child("tourneys").child("tourney1").child("teams").queryOrdered(byChild: "rank")
        ref.observe(.childAdded, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let team = Team()
                let player1Id = value["player1"] as? String ?? "Player not found"
                let player2Id = value["player2"] as? String ?? "Player not found"
                let rank = value["rank"] as? Int ?? 100
                let wins = value["wins"] as? Int ?? -1
                let losses = value["losses"] as? Int ?? -1
                
                
                team.player2 = player2Id
                team.player1 = player1Id
                team.rank = rank
                team.wins = wins
                team.losses = losses
                team.teamId = snapshot.key
                self.teams.append(team)
                DispatchQueue.main.async { self.collectionView.reloadData() }
            }
            
        }, withCancel: nil)
    }
    
    
    override func setupViews() {
        super.setupViews()
        observeTourneyTeams()
        backgroundColor = .black
        
        addSubview(collectionView)
        collectionView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        
        collectionView.register(TeamCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TeamCell
        let uid = Auth.auth().currentUser?.uid
        cell.team = teams[indexPath.item]
        if cell.team?.player1 == uid || cell.team?.player2 == uid {
            cell.backgroundColor = .gray
            cell.challengeButton.isHidden = true
            cell.challengeConfirmButton.isHidden = true
            myTeamId = indexPath.item
        } else {
            cell.backgroundColor = UIColor.white
            print(cellTag)
            print(indexPath.item)
            if cellTag == indexPath.item {
                cell.challengeConfirmButton.isHidden = false
                cell.challengeConfirmButton.tag = indexPath.item
                cell.challengeConfirmButton.addTarget(self, action: #selector(handleChallengeConfirmed), for: .touchUpInside)
                cell.challengeButton.isHidden = true
            } else {
                cell.challengeConfirmButton.isHidden = true
                cell.challengeButton.isHidden = false
                cell.challengeButton.tag = indexPath.item
                cell.challengeButton.addTarget(self, action: #selector(handleChallengeInvitation), for: .touchUpInside)
            }
        }
        return cell
    }
    
    @objc func handleChallengeConfirmed() {
        print("challenge confirmed")
        guard let myTeamIndex = myTeamId else {
            return
        }
        let ref = Database.database().reference().child("matches")
        let createMatchInTourneyRef = ref.childByAutoId()
        let values = ["challenger_team": teams[myTeamIndex].teamId as Any, "challenged_team": teams[cellTag].teamId as Any, "challenger_game1": 0, "challenger_game2": 0, "challenger_game3": 0, "challenger_game4": 0, "challenger_game5": 0, "challenged_game1": 0, "challenged_game2": 0, "challenged_game3": 0, "challenged_game4": 0, "challenged_game5": 0] as [String : Any]
        createMatchInTourneyRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            guard let challengerPlayer1Id = self.teams[myTeamIndex].player1 else {
                return
            }
            guard let challengerPlayer2Id = self.teams[myTeamIndex].player2 else {
                return
            }
            guard let challengedPlayer1Id = self.teams[self.cellTag].player1 else {
                return
            }
            guard let challengedPlayer2Id = self.teams[self.cellTag].player2 else {
                return
            }
            guard let matchId = createMatchInTourneyRef.key else {
                return
            }
                let matchRef = Database.database().reference().child("tourneys").child("tourney1").child("matches")
                matchRef.updateChildValues([matchId: 1])

            let notifiedPlayers = [challengerPlayer1Id, challengerPlayer2Id, challengedPlayer1Id, challengedPlayer2Id]
            for index in notifiedPlayers {
                let userNotificationsRef = Database.database().reference().child("user-notifications").child(index)
                userNotificationsRef.updateChildValues([matchId: 1])
            }
            
            print("Data saved successfully!")
            
            
        })
    }
    
    @objc func handleChallengeInvitation(sender: UIButton) {
        cellTag = sender.tag
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 80)
    }
    

}
