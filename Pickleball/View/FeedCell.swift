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
        let ref = Database.database().reference().child("tourneys").child("tourney1").child("teams")
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
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(TeamCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TeamCell
        cell.team = teams[indexPath.item]
        cell.backgroundColor = UIColor.white
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 80)
    }
    

}
