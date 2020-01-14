//
//  Connect.swift
//  Pickleball
//
//  Created by Tanner Rozier on 12/31/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

private let reuseIdentifier = "Cell"

class Connect: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var players = [Player]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(RecentMessagesCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        collectionView.backgroundColor = .white
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        titleLabel.text = "Connect"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.navigationItem.titleView = titleLabel
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(handleNewMessage))
    }
    
    @objc func handleNewMessage(){
        let layout = UICollectionViewFlowLayout()
        let friendList = FriendList(collectionViewLayout: layout)
        let friendNavController = UINavigationController(rootViewController: friendList)
        //friendList.hidesBottomBarWhenPushed = true
        friendNavController.navigationBar.barTintColor = UIColor.init(r: 88, g: 148, b: 200)
        friendNavController.navigationBar.tintColor = .white
        friendNavController.navigationBar.isTranslucent = false
        navigationController?.present(friendNavController, animated: true, completion: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecentMessagesCell
        //cell.player = players[indexPath.item]
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let chatLogs = ChatLogs(collectionViewLayout: layout)
        chatLogs.hidesBottomBarWhenPushed = true
        chatLogs.recipientName = "tanner_46"
        navigationController?.pushViewController(chatLogs, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    
    func fetchUsers() {
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "name")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let player = Player()
                    let name = value["name"] as? String ?? "No Name"
                    let username = value["username"] as? String ?? "No Username"
                    let skillLevel = value["skill_level"] as? Float ?? 0.0
                    let exp = value["exp"] as? Int ?? 0
                    let haloLevel = player.haloLevel(exp: exp)
                    player.name = name
                    player.username = username
                    player.id = child.key
                    player.skill_level = skillLevel
                    player.halo_level = haloLevel
                    
                    if player.id != Auth.auth().currentUser?.uid {
                        self.players.append(player)
                    }
                    DispatchQueue.main.async { self.collectionView.reloadData() }
                }
            }
        }
    }

}

class RecentMessagesCell: BaseCell {
    
    var player: Player? {
        didSet {
            //playerName.text = player?.name
        }
    }
    
    let playerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "tanner_46"
        //label.textColor = UIColor.init(r: 220, g: 220, b: 220)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textAlignment = .left
        return label
    }()
    
    let playerHaloLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "11"
        //label.textColor = UIColor.init(r: 220, g: 220, b: 220)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let recentMessage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "How is it going?"
        label.textColor = UIColor.init(r: 170, g: 170, b: 170)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textAlignment = .left
        return label
    }()
    
    override func setupViews() {
        addSubview(playerHaloLevel)
        playerHaloLevel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        playerHaloLevel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        playerHaloLevel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        playerHaloLevel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(playerName)
        playerName.topAnchor.constraint(equalTo: topAnchor).isActive = true
        playerName.leftAnchor.constraint(equalTo: playerHaloLevel.rightAnchor, constant: 4).isActive = true
        playerName.heightAnchor.constraint(equalToConstant: frame.height / 2).isActive = true
        playerName.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        addSubview(recentMessage)
        recentMessage.topAnchor.constraint(equalTo: playerName.bottomAnchor).isActive = true
        recentMessage.leftAnchor.constraint(equalTo: playerHaloLevel.rightAnchor, constant: 4).isActive = true
        recentMessage.heightAnchor.constraint(equalToConstant: frame.height / 2).isActive = true
        recentMessage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
