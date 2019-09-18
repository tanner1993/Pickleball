//
//  SelectTeammate.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/10/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SelectTeammate: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var players = [Player]()
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        setupCollectionView()
        setupNavBar()
        setupNavBarButtons()
        fetchUsers()
    }
    
    func setupCollectionView() {
        collectionView?.register(PlayerCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
    }
    
    func setupNavBar() {
        UINavigationBar.appearance().barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func fetchUsers() {
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "name")
        query.observe(.value) { (snapshot) in
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
    
    func setupNavBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("notifications")
        let selectedplayer = players[indexPath.item].id
        let teamFormationRef = ref.childByAutoId()
        let values = ["player1": uid, "player2": selectedplayer, "active": 0, "tourneyId": "tourney1", "rejection": "0"] as [String : Any]
        teamFormationRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            
            let userNotificationsRef = Database.database().reference().child("user-notifications").child(uid)
            if let notificationId = teamFormationRef.key {
                userNotificationsRef.updateChildValues([notificationId: 1])
                if let recipientInvite = selectedplayer {
                    let recipientNotificationsRef = Database.database().reference().child("user-notifications").child(recipientInvite)
                    recipientNotificationsRef.updateChildValues([notificationId: 1])
                }
            }
            
            self.dismiss(animated: true, completion: nil)
            
            print("Data saved successfully!")
            
            
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return players.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PlayerCell
        cell.player = players[indexPath.item]
        cell.backgroundColor = .blue
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }

}
