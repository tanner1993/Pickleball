//
//  Notifications.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/13/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

private let reuseIdentifier = "Cell"

class Notifications: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var players = [Player]()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        setupCollectionView()
        oberveUserNotifications()
    }
    
    func oberveUserNotifications() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user-notifications").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let notificationId = snapshot.key
            let notificationReference = Database.database().reference().child("tourneys").child("tourney1").child("teams").child(notificationId)
            
            notificationReference.observeSingleEvent(of: .value, with: {(snapshot) in
                print(snapshot)
            }, withCancel: nil)
            
            }, withCancel: nil)
    }
    
    func fetchNotifications() {
        let uid = Auth.auth().currentUser!.uid
        let rootRef = Database.database().reference()
        let notificationRef = rootRef.child("user-notifications").child(uid)
        notificationRef.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let player = Player()
                    let name = value["name"] as? String ?? "Name not found"
                    let email = value["email"] as? String ?? "Email not found"
                    player.name = name
                    player.email = email
                    player.id = child.key
                    self.players.append(player)
                    DispatchQueue.main.async { self.collectionView.reloadData() }
                }
            }
        }
    }
    
    func setupCollectionView() {
        collectionView?.register(PlayerCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }


}
