//
//  ListOfPotentialTeammates.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/10/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

//class ListOfPotentialTeammates: UICollectionViewController {
//
//    var players = [Player]()
//    let cellId = "cellId"
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//        collectionView?.register(PlayerCell.self, forCellWithReuseIdentifier: cellId)
//        setupNavBarButtons()
//        fetchUsers()
//    }
//
//    func fetchUsers() {
//        let rootRef = Database.database().reference()
//        let query = rootRef.child("users").queryOrdered(byChild: "name")
//        query.observe(.value) { (snapshot) in
//            for child in snapshot.children.allObjects as! [DataSnapshot] {
//                if let value = child.value as? NSDictionary {
//                    let player = Player()
//                    let name = value["name"] as? String ?? "Name not found"
//                    let email = value["email"] as? String ?? "Email not found"
//                    player.name = name
//                    player.email = email
//                    self.players.append(player)
//                    DispatchQueue.main.async { self.collectionView.reloadData() }
//                }
//            }
//        }
//    }
//
//    func setupNavBarButtons() {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
//    }
//
//    @objc func handleCancel() {
//        dismiss(animated: true, completion: nil)
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return players.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PlayerCell
//        cell.player = players[indexPath.item]
//        return cell
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: 80)
//    }
//
//
//}

class PlayerCell: BaseCell {
    
    var player: Player? {
        didSet {
            playerName.text = player?.name
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
