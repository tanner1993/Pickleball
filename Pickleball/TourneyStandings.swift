//
//  TourneyLayout.swift
//  Pickleball
//
//  Created by Tanner Rozier on 8/30/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit

class TourneyStandings: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(view.frame.width)
        
        navigationItem.title = "Tournament 1"
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(TeamCell.self, forCellWithReuseIdentifier: "CellID")
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

class TeamCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let TeamDuo: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.purple
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 24
        label.layer.masksToBounds = true
        label.text = "Teammate 1 & Teammate 2"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    let TeamRank: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.purple
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 35
        label.layer.masksToBounds = true
        label.text = "1"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textAlignment = .center
        return label
    }()
    let Wins: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.green
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.text = "Wins: 1"
        label.textAlignment = .center
        return label
    }()
    let Losses: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.text = "Losses: 1"
        label.textAlignment = .center
        return label
    }()
    
    func setupViews() {
        addSubview(TeamDuo)
        addSubview(TeamRank)
        addSubview(Wins)
        addSubview(Losses)
        addConstraintsWithFormat(format: "H:|-4-[v0(70)]-4-[v1]-4-|", views: TeamRank, TeamDuo)
        addConstraintsWithFormat(format: "V:|-4-[v0]-28-|", views: TeamDuo)
        addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: TeamRank)
        addConstraint(NSLayoutConstraint(item: Wins, attribute: .top, relatedBy: .equal, toItem: TeamDuo, attribute: .bottom, multiplier: 1, constant: 4))
        addConstraint(NSLayoutConstraint(item: Wins, attribute: .right, relatedBy: .equal, toItem: TeamDuo, attribute: .centerX, multiplier: 1, constant: -10))
        addConstraint(NSLayoutConstraint(item: Wins, attribute: .left, relatedBy: .equal, toItem: TeamDuo, attribute: .centerX, multiplier: 1, constant: -125))
        addConstraint(NSLayoutConstraint(item: Wins, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))
        addConstraint(NSLayoutConstraint(item: Losses, attribute: .top, relatedBy: .equal, toItem: TeamDuo, attribute: .bottom, multiplier: 1, constant: 4))
        addConstraint(NSLayoutConstraint(item: Losses, attribute: .right, relatedBy: .equal, toItem: TeamDuo, attribute: .centerX, multiplier: 1, constant: 125))
        addConstraint(NSLayoutConstraint(item: Losses, attribute: .left, relatedBy: .equal, toItem: TeamDuo, attribute: .centerX, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: Losses, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
        }

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))

    }
}
