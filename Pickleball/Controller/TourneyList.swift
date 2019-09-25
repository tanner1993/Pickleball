//
//  TourneyList.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/24/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class TourneyList: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var tourneys = [Tourney]()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTourneys()
        setupCollectionView()

    }

    func fetchTourneys() {
        let rootRef = Database.database().reference()
        let query = rootRef.child("tourneys")
        query.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
                if let value = snapshot.value as? [String: AnyObject] {
                    let tourney = Tourney()
                    let name = value["name"] as? String ?? "Name not found"
                    let type = value["type"] as? String ?? "Email not found"
                    let level = value["level"] as? Int ?? 0
                    tourney.name = name
                    tourney.type = type
                    tourney.level = level
                    tourney.id = snapshot.key
                    self.tourneys.append(tourney)
                    
                    DispatchQueue.main.async { self.collectionView.reloadData() }
                }
        })
    }
    
    func setupCollectionView() {
        collectionView?.register(TourneyCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tourneys.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TourneyCell
        cell.tourney = tourneys[indexPath.item]
        cell.backgroundColor = .blue
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let tourneyStandingsPage = TourneyStandings(collectionViewLayout: layout)
        tourneyStandingsPage.tourneyIdentifier = tourneys[indexPath.item].id
        navigationController?.pushViewController(tourneyStandingsPage, animated: true)
    }



}

class TourneyCell: BaseCell {
    var tourney: Tourney? {
        didSet {
            playerName.text = tourney?.name
        }
    }
    
    let playerName: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 24
        label.layer.masksToBounds = true
        label.text = "playerName"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    override func setupViews() {
        addSubview(playerName)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: playerName)
        addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: playerName)
    }
}