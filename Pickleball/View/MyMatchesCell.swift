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
        //observeMyTourneyMatches()
        
        collectionView.register(RecentMatchesCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
//    func observeMyTourneyMatches() {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let ref = Database.database().reference().child("user-notifications").child(uid)
//        ref.observe(.childAdded, with: { (snapshot) in
//            let matchId = snapshot.key
//            guard let tourneyId = snapshot.value as? String else {
//                return
//            }
//            if tourneyId == self.tourneyIdentifier {
//                let matchReference = Database.database().reference().child("tourneys").child(tourneyId).child("matches").child(matchId)
//
//                matchReference.observeSingleEvent(of: .value, with: {(snapshot) in
//                    if let value = snapshot.value as? NSDictionary {
//                        let match = Match()
//                        let challengerTeamId = value["challenger_team"] as? String ?? "Team not found"
//                        let challengedTeamId = value["challenged_team"] as? String ?? "Team not found"
//                        let challengerGame1 = value["challenger_game1"] as? Int ?? 0
//                        let challengerGame2 = value["challenger_game2"] as? Int ?? 0
//                        let challengerGame3 = value["challenger_game3"] as? Int ?? 0
//                        let challengerGame4 = value["challenger_game4"] as? Int ?? 0
//                        let challengerGame5 = value["challenger_game5"] as? Int ?? 0
//                        let challengedGame1 = value["challenged_game1"] as? Int ?? 0
//                        let challengedGame2 = value["challenged_game2"] as? Int ?? 0
//                        let challengedGame3 = value["challenged_game3"] as? Int ?? 0
//                        let challengedGame4 = value["challenged_game4"] as? Int ?? 0
//                        let challengedGame5 = value["challenged_game5"] as? Int ?? 0
//                        match.challengerTeamId = challengerTeamId
//                        match.challengedTeamId = challengedTeamId
//                        match.challengerGames?.append(challengerGame1)
//                        match.challengerGames?.append(challengerGame2)
//                        match.challengerGames?.append(challengerGame3)
//                        match.challengerGames?.append(challengerGame4)
//                        match.challengerGames?.append(challengerGame5)
//                        match.challengedGames?.append(challengedGame1)
//                        match.challengedGames?.append(challengedGame2)
//                        match.challengedGames?.append(challengedGame3)
//                        match.challengedGames?.append(challengedGame4)
//                        match.challengedGames?.append(challengedGame5)
//                        match.matchId = matchId
//                        self.matches.append(match)
//                        DispatchQueue.main.async { self.collectionView.reloadData() }
//                    }
//
//                }, withCancel: nil)
//            }
//
//
//        }, withCancel: nil)
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RecentMatchesCell
        cell.match = matches[indexPath.item]
        cell.teams = teams
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}
