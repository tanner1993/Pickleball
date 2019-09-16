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

    var invitations = [Invitation]()
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        oberveUserNotifications()
        setupCollectionView()
    }
    
    func oberveUserNotifications() {
        invitations.removeAll()
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user-notifications").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let notificationId = snapshot.key
            let notificationReference = Database.database().reference().child("notifications").child(notificationId)
            
            notificationReference.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? NSDictionary {
                        let invitation = Invitation()
                        let player1Id = value["player1"] as? String ?? "Player not found"
                        let player2Id = value["player2"] as? String ?? "Player not found"
                        let active = value["active"] as? String ?? "active not found"
                        let tourneyId = value["tourneyId"] as? String ?? "Tourney not found"
                        invitation.player1 = player1Id
                        invitation.player2 = player2Id
                        invitation.active = active
                        invitation.tourneyid = tourneyId
                        self.invitations.append(invitation)
                        DispatchQueue.main.async { self.collectionView.reloadData() }
                    }
                
                print(snapshot)
            }, withCancel: nil)
            
            }, withCancel: nil)
    }
    
//    func fetchNotifications() {
//        let uid = Auth.auth().currentUser!.uid
//        let rootRef = Database.database().reference()
//        let notificationRef = rootRef.child("user-notifications").child(uid)
//        notificationRef.observe(.value) { (snapshot) in
//            for child in snapshot.children.allObjects as! [DataSnapshot] {
//                if let value = child.value as? NSDictionary {
//                    let player = Player()
//                    let name = value["name"] as? String ?? "Name not found"
//                    let email = value["email"] as? String ?? "Email not found"
//                    player.name = name
//                    player.email = email
//                    player.id = child.key
//                    self.players.append(player)
//                    DispatchQueue.main.async { self.collectionView.reloadData() }
//                }
//            }
//        }
//    }
    
    func setupCollectionView() {
        collectionView?.register(InvitationCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return invitations.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InvitationCell
        let invitation = invitations[indexPath.item]
        let uid = Auth.auth().currentUser?.uid
        if uid == invitation.player1 {
            if let player2 = invitation.player2 {
                let ref = Database.database().reference().child("users").child(player2)
                ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? [String: AnyObject] {
                        let player2name = value["name"] as? String
                        cell.invitationText.text = "You have invited \(player2name ?? "") to play with you in \(invitation.tourneyid ?? "")"
                        cell.rejectButton.isHidden = true
                    }
                })
            }
            print("match")
        } else if uid == invitation.player2 {
            if let player1 = invitation.player1 {
                let ref = Database.database().reference().child("users").child(player1)
                ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? [String: AnyObject] {
                        let player1name = value["name"] as? String
                        cell.invitationText.text = "\(player1name ?? "") has invited you to play with them in \(invitation.tourneyid ?? "")"
                        cell.rejectButton.isHidden = false
                    }
                })
            }
            print("no match")
        } else {
            print("error, the uid doesn't match player 2 or player 1")
        }
        
        
        // Configure the cell
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    


}

class InvitationCell: BaseCell {
//    var player2Name: String?
//    var invitation: Invitation? {
//        didSet {
//            guard let player2nam = invitation?.player2 else{
//                return
//            }
//            guard let tourneyIdText = invitation?.tourneyid else{
//                return
//            }
//            invitationText.text = "\(player2nam) has invited you to join them in playing in \(tourneyIdText)"
//        }
//    }
    
    let rejectButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 56, g: 12, b: 200)
        button.setTitle("Reject", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.addTarget(self, action: #selector(handleLoginOrRegister), for: .touchUpInside)
        return button
    }()
    
    let invitationText: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 24
        label.layer.masksToBounds = true
        label.text = "Player 1 has invited you to join tourney1 to play with them"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    
    
    override func setupViews() {
        addSubview(invitationText)
        addSubview(rejectButton)
        invitationText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        invitationText.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        invitationText.widthAnchor.constraint(equalTo: widthAnchor, constant: -8).isActive = true
        invitationText.heightAnchor.constraint(equalToConstant: 90).isActive = true
        rejectButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -75).isActive = true
        rejectButton.topAnchor.constraint(equalTo: invitationText.bottomAnchor, constant: 4).isActive = true
        rejectButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        rejectButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: invitationText)
        //addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: invitationText)
    }
}