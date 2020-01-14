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

class Notifications: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var highestCurrentRank: Int = 0
    var invitations = [Invitation]()
    var matches = [Match]()
    let cellId = "cellId"
    var cellTag = -1
    
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
            let potentialTourneyId = snapshot.value as? String ?? "none"
            
            if potentialTourneyId == "1" {
            let notificationReference = Database.database().reference().child("notifications").child(notificationId)
            notificationReference.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? NSDictionary {
                        let invitation = Invitation()
                        let player1Id = value["player1"] as? String ?? "Player not found"
                        let player2Id = value["player2"] as? String ?? "Player not found"
                        let active = value["active"] as? String ?? "active not found"
                        let tourneyId = value["tourneyId"] as? String ?? "Tourney not found"
                        let rejection = value["rejection"] as? String ?? "rejection not found"
                        invitation.player1 = player1Id
                        invitation.player2 = player2Id
                        invitation.active = active
                        invitation.tourneyid = tourneyId
                        invitation.invitationId = notificationId
                        invitation.rejection = rejection
                        self.invitations.append(invitation)
                        DispatchQueue.main.async { self.collectionView.reloadData() }
                    }

                print(snapshot)
            }, withCancel: nil)
            } else {
                let challengeReference = Database.database().reference().child("tourneys").child(potentialTourneyId).child("matches").child(notificationId)
                challengeReference.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? NSDictionary {
                        let match = Match()
                        let challengerTeamId = value["challenger_team"] as? String ?? "Team not found"
                        let challengedTeamId = value["challenged_team"] as? String ?? "Team not found"
                        match.challengerTeamId = challengerTeamId
                        match.challengedTeamId = challengedTeamId
                        match.matchId = notificationId
                        match.tourneyId = potentialTourneyId
                        self.matches.append(match)
                        DispatchQueue.main.async { self.collectionView.reloadData() }
                    }
                    
                    print(snapshot)
                }, withCancel: nil)
            }

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
        collectionView?.backgroundColor = .white
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return invitations.count + matches.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InvitationCell
        let uid = Auth.auth().currentUser?.uid
        if indexPath.item < invitations.count {
        let invitation = invitations[indexPath.item]
        if invitation.active == "1" {
            if let player2 = invitation.player2 {
                let ref = Database.database().reference().child("users").child(player2)
                ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? [String: AnyObject] {
                        let player2name = value["name"] as? String
                        cell.invitationText.text = "\(player2name ?? "") has confirmed playing with you in \(invitation.tourneyid ?? "")"
                        cell.rejectButton.isHidden = true
                        cell.dismissButton.isHidden = false
                        cell.confirmButton.isHidden = true
                        cell.dismissButton.tag = indexPath.item
                        cell.dismissButton.addTarget(self, action: #selector(self.handleDismiss), for: .touchUpInside)
                    }
                })
            }
        } else if invitation.rejection == "1" {
            if let player2 = invitation.player2 {
                let ref = Database.database().reference().child("users").child(player2)
                ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? [String: AnyObject] {
                        let player2name = value["name"] as? String
                        cell.invitationText.text = "\(player2name ?? "") has rejected playing with you in \(invitation.tourneyid ?? "")"
                        cell.rejectButton.isHidden = true
                        cell.dismissButton.isHidden = false
                        cell.confirmButton.isHidden = true
                        cell.dismissButton.tag = indexPath.item
                        cell.dismissButton.addTarget(self, action: #selector(self.handleDismiss), for: .touchUpInside)
                    }
                })
            }
        } else if uid == invitation.player1 {
            if let player2 = invitation.player2 {
                let ref = Database.database().reference().child("users").child(player2)
                ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? [String: AnyObject] {
                        let player2name = value["name"] as? String
                        cell.invitationText.text = "You have invited \(player2name ?? "") to play with you in \(invitation.tourneyid ?? "")"
                        cell.rejectButton.isHidden = true
                        cell.confirmButton.isHidden = true
                        cell.dismissButton.isHidden = true
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
                        cell.dismissButton.isHidden = true
                        cell.confirmButton.isHidden = false
                        cell.confirmButton.tag = indexPath.item
                        cell.rejectButton.tag = indexPath.item
                        cell.rejectButton.addTarget(self, action: #selector(self.handleInvitationReject), for: .touchUpInside)
                        cell.confirmButton.addTarget(self, action: #selector(self.handleInvitationConfirm), for: .touchUpInside)
                    }
                })
            }
            print("no match")
        } else {
            print("error, the uid doesn't match player 2 or player 1")
        }
            
        } else if indexPath.item >= invitations.count {
            
            let match = matches[indexPath.item - invitations.count]
                if let challengerTeamId = match.challengedTeamId {
                    let ref = Database.database().reference().child("teams").child(challengerTeamId)
                    ref.observeSingleEvent(of: .value, with: {(snapshot) in
                        if let value = snapshot.value as? [String: AnyObject] {
                            let player1name = value["player1Name"] as? String
                            let player2name = value["Player2Name"] as? String
                            cell.invitationText.text = "\(player1name ?? "") and \(player2name ?? "") has challenged you"
                            cell.rejectButton.isHidden = true
                            cell.dismissButton.isHidden = false
                            cell.confirmButton.isHidden = true
                            cell.dismissButton.tag = indexPath.item
                            cell.dismissButton.addTarget(self, action: #selector(self.handleDismiss), for: .touchUpInside)
                        }
                    })
                }
            
        }
        
        
        // Configure the cell
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 150)
    }
    
    @objc func handleInvitationReject(sender: UIButton) {
        cellTag = sender.tag
        let newalert = UIAlertController(title: "Confirm", message: "Are you sure you want to reject?", preferredStyle: UIAlertController.Style.alert)
        newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
        newalert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: handleRejectConfirmed))
        self.present(newalert, animated: true, completion: nil)
    }
    
    @objc func handleInvitationConfirm(sender: UIButton) {
        cellTag = sender.tag
        guard let tourneyId = invitations[cellTag].tourneyid else {
            return
        }
        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("teams")
        let query = ref.queryOrdered(byChild: "rank")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    self.highestCurrentRank = value["rank"] as? Int ?? -1
                }
            }
        }
        let newalert = UIAlertController(title: "Confirm", message: "Are you sure you want to join this tournament?", preferredStyle: UIAlertController.Style.alert)
        newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
        newalert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: handleConfirmConfirmed))
        self.present(newalert, animated: true, completion: nil)
    }
    
    @objc func handleDismiss(sender: UIButton) {
        cellTag = sender.tag
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let invitation = invitations[cellTag]
        guard let invitationId = invitation.invitationId else{
            return
        }
        
        let deleteUserNotIdRef = Database.database().reference().child("user-notifications").child(uid).child(invitationId)
        deleteUserNotIdRef.removeValue()
        let deleteNotificationIdRef = Database.database().reference().child("notifications").child(invitationId)
        deleteNotificationIdRef.removeValue()
        invitations.remove(at: cellTag)
        collectionView.reloadData()
    }
    
    func handleRejectConfirmed(action: UIAlertAction) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let invitation = invitations[cellTag]
        guard let invitationId = invitation.invitationId else{
            return
        }

        let deleteUserNotIdRef = Database.database().reference().child("user-notifications").child(uid).child(invitationId)
        deleteUserNotIdRef.removeValue()
        let changeNotificationIdRef = Database.database().reference().child("notifications").child(invitationId)
        changeNotificationIdRef.updateChildValues(["rejection": "1"])
        invitations.remove(at: cellTag)
        collectionView.reloadData()
    }
    
    func handleConfirmConfirmed(action: UIAlertAction) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let invitation = invitations[cellTag]
        guard let invitationId = invitation.invitationId else{
            return
        }
        guard let inviteeId = invitation.player1 else{
            return
        }
        guard let tourneyId = invitation.tourneyid else {
            return
        }
        
        let deleteUserNotIdRef = Database.database().reference().child("user-notifications").child(uid).child(invitationId)
        deleteUserNotIdRef.removeValue()
        let changeNotificationIdRef = Database.database().reference().child("notifications").child(invitationId)
        changeNotificationIdRef.updateChildValues(["active": "1"])
        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("teams")
        let createTeamInTourneyRef = ref.childByAutoId()
        let values = ["player1": inviteeId, "player2": uid, "wins": 0, "losses": 0, "rank": highestCurrentRank + 1] as [String : Any]
        createTeamInTourneyRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            
            let userNotificationsRef = Database.database().reference().child("user-notifications").child(uid)
            if let teamId = createTeamInTourneyRef.key {
                userNotificationsRef.updateChildValues([teamId: 1])
                let inviteeNotificationsRef = Database.database().reference().child("user-notifications").child(inviteeId)
                inviteeNotificationsRef.updateChildValues([teamId: 1])
            }
            
            self.dismiss(animated: true, completion: nil)
            
            print("Data saved successfully!")
            
            
        })
        invitations.remove(at: cellTag)
        collectionView.reloadData()
    }


}

class InvitationCell: BaseCell {

    let backgroundImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "invitation_cell")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rejectButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = UIColor(r: 56, g: 12, b: 200)
        //button.setTitle("Reject", for: .normal)
        //button.setTitleColor(.white, for: .normal)
        //button.layer.cornerRadius = 5
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
//        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
//        button.backgroundColor = UIColor(r: 56, g: 12, b: 200)
//        button.setTitle("Dismiss", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.layer.cornerRadius = 5
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
//        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = UIColor(r: 56, g: 12, b: 200)
        //button.setTitle("Confirm", for: .normal)
        //button.setTitleColor(.white, for: .normal)
        //button.layer.cornerRadius = 5
        //button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        //button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
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
        
        addSubview(backgroundImage)
        backgroundImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
//        addSubview(separatorView)
//        separatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        separatorView.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor).isActive = true
//        separatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
//        separatorView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        
        addSubview(invitationText)
        addSubview(rejectButton)
        addSubview(dismissButton)
        addSubview(confirmButton)
        
        let invitationTextLoc = calculateButtonPosition(x: 375, y: 72, w: 688, h: 111, wib: 750, hib: 300, wia: 375, hia: 150)
        
        addSubview(invitationText)
        invitationText.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(invitationTextLoc.Y)).isActive = true
        invitationText.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(invitationTextLoc.X)).isActive = true
        invitationText.heightAnchor.constraint(equalToConstant: CGFloat(invitationTextLoc.H)).isActive = true
        invitationText.widthAnchor.constraint(equalToConstant: CGFloat(invitationTextLoc.W)).isActive = true
        
        let confirmLoc = calculateButtonPosition(x: 638.75, y: 206, w: 177.5, h: 146, wib: 750, hib: 300, wia: 375, hia: 150)
        
        addSubview(confirmButton)
        confirmButton.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(confirmLoc.Y)).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(confirmLoc.X)).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: CGFloat(confirmLoc.H)).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: CGFloat(confirmLoc.W)).isActive = true
        
        let rejectLoc = calculateButtonPosition(x: 448.5, y: 206, w: 177.5, h: 146, wib: 750, hib: 300, wia: 375, hia: 150)
        
        addSubview(rejectButton)
        rejectButton.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(rejectLoc.Y)).isActive = true
        rejectButton.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(rejectLoc.X)).isActive = true
        rejectButton.heightAnchor.constraint(equalToConstant: CGFloat(rejectLoc.H)).isActive = true
        rejectButton.widthAnchor.constraint(equalToConstant: CGFloat(rejectLoc.W)).isActive = true

    }
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
    }
}
