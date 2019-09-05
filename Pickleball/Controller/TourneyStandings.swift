//
//  TourneyLayout.swift
//  Pickleball
//
//  Created by Tanner Rozier on 8/30/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit

class TourneyStandings: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var teams: [Team] = {
        var Team1 = Team()
        Team1.TeamPair = "Tanner and Scott"
        Team1.Wins = "Wins: 5"
        Team1.Losses = "Losses: 0"
        Team1.Rank = "1"
        
        var Team2 = Team()
        Team2.TeamPair = "Keili and Kim"
        Team2.Wins = "Wins: 0"
        Team2.Losses = "Losses: 5"
        Team2.Rank = "2"
        
        return [Team1, Team2]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Tournament 1"
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Tourney 1 Overall"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        collectionView?.register(TeamCell.self, forCellWithReuseIdentifier: "CellID")
        
        collectionView?.contentInset = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
        setupTourneyMenuBar()
    }
    
    let menusBar: TourneyMenuBar = {
        let mb = TourneyMenuBar()
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
    }()
    
    private func setupTourneyMenuBar() {
        view.addSubview(menusBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menusBar)
        view.addConstraintsWithFormat(format: "V:|[v0(35)]", views: menusBar)
    }
    
    

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! TeamCell
        cell.team = teams[indexPath.item]
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }

}

