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

    var tourneyIdentification: String?
    var invitations = [Invitation]()
    var teams = [Team]()
    var alreadyInvitedPlayers = [String]()
    var alreadyInvitedYouPlayers = [String]()
    var players = [Player]()
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        oberveUserNotifications()
        observeTourneyTeams()
        setupCollectionView()
        setupNavBar()
        //setupNavBarButtons()
        fetchUsers()
    }
    
    func findAlreadyInvitedUsers(selectedPlayer: String) -> Int{
        guard let tourneyId = tourneyIdentification else {
            return 4
        }
        let uid = Auth.auth().currentUser?.uid
        var match = 0
        print(invitations)
        for index in invitations {
            if index.tourneyid == tourneyId {
                switch uid {
                case index.player1:
                    if let player2 = index.player2 {
                        alreadyInvitedPlayers.append(player2)
                    }
                
                case index.player2:
                    if let player1 = index.player1 {
                        alreadyInvitedYouPlayers.append(player1)
                    }
                    
                default:
                    print("nobody")
                }
                
                
            }
        }
        print(alreadyInvitedPlayers)
        for index in alreadyInvitedPlayers {
            if index == selectedPlayer {
                match = 1
                break
            }
        }
        
        for index in alreadyInvitedYouPlayers {
            if index == selectedPlayer {
                match = 2
                break
            }
        }
        
        for index in teams {
            if index.player1 == selectedPlayer || index.player2 == selectedPlayer {
                match = 3
                break
            }
        }
        
        return match
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
                    let rejection = value["rejection"] as? String ?? "rejection not found"
                    invitation.player1 = player1Id
                    invitation.player2 = player2Id
                    invitation.active = active
                    invitation.tourneyid = tourneyId
                    invitation.invitationId = notificationId
                    invitation.rejection = rejection
                    self.invitations.append(invitation)
                }
                
                print(snapshot)
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    func observeTourneyTeams() {
        guard let tourneyId = tourneyIdentification else {
            return
        }
        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("teams")
        ref.observe(.childAdded, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let team = Team()
                let player1Id = value["player1"] as? String ?? "Player not found"
                let player2Id = value["player2"] as? String ?? "Player not found"
                let rank = value["rank"] as? Int ?? 100
                let wins = value["wins"] as? Int ?? -1
                let losses = value["losses"] as? Int ?? -1
                
                
                team.player2 = player2Id
                team.player1 = player1Id
                team.rank = rank
                team.wins = wins
                team.losses = losses
                team.teamId = snapshot.key
                self.teams.append(team)
            }
            
        }, withCancel: nil)
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
                    if player.id != Auth.auth().currentUser?.uid {
                        self.players.append(player)
                    }
                    DispatchQueue.main.async { self.collectionView.reloadData() }
                }
            }
        }
    }
    
//    func setupNavBarButtons() {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
//    }
//
//    @objc func handleCancel() {
//        dismiss(animated: true, completion: nil)
//    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPlayer = players[indexPath.item].id
        let match = findAlreadyInvitedUsers(selectedPlayer: selectedPlayer!)
        print(match)
        switch match {
        case 0:
            guard let tourneyId = tourneyIdentification else {
                return
            }
            let uid = Auth.auth().currentUser!.uid
            let ref = Database.database().reference().child("notifications")
            let teamFormationRef = ref.childByAutoId()
            let values = ["player1": uid, "player2": selectedPlayer as Any, "active": 0, "tourneyId": tourneyId, "rejection": "0"] as [String : Any]
            teamFormationRef.updateChildValues(values, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if let error = error {
                    print("Data could not be saved: \(error).")
                    return
                }
                
                let userNotificationsRef = Database.database().reference().child("user-notifications").child(uid)
                if let notificationId = teamFormationRef.key {
                    userNotificationsRef.updateChildValues([notificationId: "1"])
                    if let recipientInvite = selectedPlayer {
                        let recipientNotificationsRef = Database.database().reference().child("user-notifications").child(recipientInvite)
                        recipientNotificationsRef.updateChildValues([notificationId: "1"])
                    }
                }
                let newalert = UIAlertController(title: "Sweet", message: "Invite has been sent", preferredStyle: UIAlertController.Style.alert)
                newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: self.handleInviteSent))
                self.present(newalert, animated: true, completion: nil)
                
                print("Data saved successfully!")
                
                
            })
        case 1:
            let newalert = UIAlertController(title: "Sorry", message: "You have already invited this player to play with you in this tournament", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
        case 2:
            let newalert = UIAlertController(title: "Sorry", message: "This player has already invited you to play with them in this tournament", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
        case 3:
            let newalert = UIAlertController(title: "Sorry", message: "This player is already enrolled in this tournament", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
        default:
            print("failed to match at all!!!")
        }
        
    }
    
    @objc func handleInviteSent(action: UIAlertAction) {
        self.dismiss(animated: true, completion: nil)
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
