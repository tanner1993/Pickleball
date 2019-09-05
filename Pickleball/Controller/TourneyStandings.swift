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
        Team1.Wins = 5
        Team1.Losses = 0
        
        return [Team1]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Tournament 1"
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Tourney 1 Overall"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        //collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(TeamCell.self, forCellWithReuseIdentifier: "CellID")
        
        collectionView?.contentInset = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
        setupTourneyMenuBar()
    }
    
    let menusBar: TourneyMenuBar = {
        let mb = TourneyMenuBar()
        mb.backgroundColor = UIColor.brown
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
    }()
    
    private func setupTourneyMenuBar() {
        view.addSubview(menusBar)
        view.bringSubviewToFront(menusBar)
        menusBar.tintColor = UIColor.brown
        menusBar.backgroundColor = UIColor.brown
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menusBar)
        view.addConstraintsWithFormat(format: "V:|[v0(35)]", views: menusBar)
    }
    
    

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath)
        cell.backgroundColor = UIColor.blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }

}

