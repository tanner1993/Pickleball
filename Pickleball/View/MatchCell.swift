//
//  RecentMatchesCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/6/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit

class MatchCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {


    var matches: [Match] = {
    var match1 = Match()
    match1.challengerTeamId = "Tanner and Scott"
    match1.challengedTeamId = "Keili and Kim"
        match1.challengerGames?.append(3)
        match1.challengerGames?.append(2)
        match1.challengerGames?.append(11)
        match1.challengerGames?.append(11)
        match1.challengerGames?.append(11)
        match1.challengedGames?.append(11)
        match1.challengedGames?.append(11)
        match1.challengedGames?.append(1)
        match1.challengedGames?.append(2)
        match1.challengedGames?.append(3)

    return [match1]
}()

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
    
    collectionView.register(RecentMatchesCell.self, forCellWithReuseIdentifier: cellId)
    
}

    
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return matches.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RecentMatchesCell
    cell.match = matches[indexPath.item]
    cell.backgroundColor = UIColor.white
    return cell
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: frame.width, height: 60)
}

}
