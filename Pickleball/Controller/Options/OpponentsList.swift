//
//  CollectionViewController.swift
//  Pickleball
//
//  Created by Tanner Rozier on 5/21/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class OpponentsList: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let player = Player()
    var opponents = [Player]()
    let blackView = UIView()
    var matchFeed: MatchFeed?
    var createdMatch = Match2()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupFilterCollectionView()
        setupCountySelectionView()
        getLocalPlayers(loadUp: true, countySelected: "none")
    }
    
    func setupCollectionView() {
        self.collectionView!.register(PlayerChallengeCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsets(top: 115, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 115, left: 0, bottom: 0, right: 0)
    }
    
    func setupCountySelectionView() {
        
        view.addSubview(whiteBox)
        whiteBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        whiteBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        whiteBox.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        whiteBox.heightAnchor.constraint(equalToConstant: 115).isActive = true
        
        whiteBox.addSubview(countyChallengersLabel)
        countyChallengersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        countyChallengersLabel.topAnchor.constraint(equalTo: whiteBox.topAnchor).isActive = true
        countyChallengersLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        countyChallengersLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        whiteBox.addSubview(selectCountyButton)
        selectCountyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectCountyButton.topAnchor.constraint(equalTo: countyChallengersLabel.bottomAnchor, constant: 4).isActive = true
        selectCountyButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        selectCountyButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        whiteBox.addSubview(separatorView)
        separatorView.bottomAnchor.constraint(equalTo: whiteBox.bottomAnchor).isActive = true
        separatorView.centerXAnchor.constraint(equalTo: whiteBox.centerXAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.widthAnchor.constraint(equalTo: whiteBox.widthAnchor).isActive = true
    }
    
    func getLocalPlayers(loadUp: Bool, countySelected: String) {
        if loadUp {
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            Database.database().reference().child("users").child(uid).child("county").observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value {
                    let county = value as? String ?? "none"
                    self.selectCountyButton.setTitle(county, for: .normal)
                    self.player.findLocalPlayers(county: county, completion:{ (result) in
                        guard let playerResults = result else {
                            print("failed to get rresult")
                            return
                        }
                        self.opponents = playerResults
                        self.collectionView.reloadData()
                    })
                }
            })
        } else {
            opponents.removeAll()
            self.selectCountyButton.setTitle(countySelected, for: .normal)
            self.player.findLocalPlayers(county: countySelected, completion:{ (result) in
                guard let playerResults = result else {
                    print("failed to get rresult")
                    return
                }
                self.opponents = playerResults
                self.collectionView.reloadData()
            })
        }
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return opponents.count
        } else {
            return counties.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PlayerChallengeCell
            cell.player = opponents[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! ProfileMenuCell
            cell.menuItem.text = counties[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: view.frame.width, height: 193)
        } else {
            return CGSize(width: view.frame.width, height: 50)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if collectionView == self.collectionView {
                handleViewPlayer(whichOne: indexPath.item)
            } else {
                getLocalPlayers(loadUp: false, countySelected: counties[indexPath.item])
                dismissMenu()
            }
    }
    
    @objc func handleViewPlayer(whichOne: Int) {
        let playerProfile = StartupPage()
        playerProfile.playerId = opponents[whichOne].id ?? "none"
        playerProfile.isFriend = 3
        playerProfile.opponentsList = self
        navigationController?.pushViewController(playerProfile, animated: true)
    }
    
    func popOpponents() {
        matchFeed?.matches.insert(createdMatch, at: 0)
        matchFeed?.tableView.reloadData()
        navigationController?.popViewController(animated: false)
    }
    
    let filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    let cellId2 = "cellId2"
    
    func setupFilterCollectionView() {
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.register(ProfileMenuCell.self, forCellWithReuseIdentifier: cellId2)
    }
    
    @objc func handleDropDownFinish() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu)))
            window.addSubview(blackView)
            window.addSubview(filterCollectionView)
            filterCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 350)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.filterCollectionView.frame = CGRect(x: 0, y: window.frame.height - 350, width: window.frame.width, height: 350)
            }, completion: nil)
        }
    }
    
    @objc func dismissMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.filterCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 350)
            }
        })
    }

    let countyChallengersLabel: UILabel = {
        let label = UILabel()
        label.text = "Currently showing players looking for a challenge in the below county:"
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let selectCountyButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25)
        button.addTarget(self, action: #selector(handleDropDownFinish), for: .touchUpInside)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.black, for: .normal)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(r: 120, g: 207, b: 138)
        return button
    }()
    
    let whiteBox: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let counties = ["Beaver", "Box Elder", "Cache", "Carbon", "Daggett", "Davis", "Duchesne", "Emery", "Garfield", "Grand", "Iron", "Juab", "Kane", "Millard", "Morgan", "Piute", "Rich", "Salt Lake", "San Juan", "Sanpete", "Sevier", "Summit", "Tooele", "Uintah", "Utah", "Wasatch", "Washington", "Wayne", "Weber"]

}