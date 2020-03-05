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

class Notifications: UITableViewController {

    var highestCurrentRank: Int = 0
    //var invitations = [Invitation]()
    var notifications = [Message]()
    let cellId = "cellId"
    let cellId2 = "cellId2"
    var cellTag = -1
    var currentUser2 = "nothing"
    
    func setupNavbarAndTitle() {
        let plusImage = UIImage(named: "plus")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let createNewMatchButton = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(handleCreateNewMatch))
        self.navigationItem.rightBarButtonItem = createNewMatchButton
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        titleLabel.text = "Notifications"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.navigationItem.titleView = titleLabel
    }
    
    @objc func handleCreateNewMatch() {
        let createNewMatch = CreateMatch()
        createNewMatch.hidesBottomBarWhenPushed = true
        navigationController?.present(createNewMatch, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("notifications didload")
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        currentUser2 = uid
        setupNavbarAndTitle()
        setupCollectionView()
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkUser()
        print("notifications willload")
        print(currentUser2)
    }
    
    
    func checkUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        if currentUser2 != uid {
            notifications.removeAll()
            tableView.reloadData()
            fetchNotifications()
            currentUser2 = uid
        }
    }
    
    func fetchNotifications() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user_notifications").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let notificationId = snapshot.key
            let notificationSeen = snapshot.value! as! Int
            if notificationSeen == 1 {
                Database.database().reference().child("user_notifications").child(uid).child(notificationId).setValue(0, andPriority: .none)
            }
            let notificationsReference = Database.database().reference().child("notifications").child(notificationId)
            notificationsReference.observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    let notification = Message()
                    let messageText = value["type"] as? String ?? "No text"
                    let timeStamp = value["timestamp"] as? Double ?? Double(Date().timeIntervalSince1970)
                    let toId = value["toId"] as? String ?? "No toId"
                    let fromId = value["fromId"] as? String ?? "No fromId"
                    notification.message = messageText
                    notification.timeStamp = timeStamp
                    notification.toId = toId
                    notification.fromId = fromId
                    notification.id = notificationId
                    self.notifications.append(notification)
                    DispatchQueue.main.async { self.tableView.reloadData()}
                }
            }, withCancel: nil)
        }, withCancel: nil)
        if let tabItems = self.tabBarController?.tabBar.items {
            let tabItem = tabItems[3]
            tabItem.badgeValue = .none
        }
    }
    
//    func oberveUserNotifications() {
//        invitations.removeAll()
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let ref = Database.database().reference().child("user-notifications").child(uid)
//        ref.observe(.childAdded, with: { (snapshot) in
//            let notificationId = snapshot.key
//            let potentialTourneyId = snapshot.value as? String ?? "none"
//
//            if potentialTourneyId == "1" {
//            let notificationReference = Database.database().reference().child("notifications").child(notificationId)
//            notificationReference.observeSingleEvent(of: .value, with: {(snapshot) in
//                    if let value = snapshot.value as? NSDictionary {
//                        let invitation = Invitation()
//                        let player1Id = value["player1"] as? String ?? "Player not found"
//                        let player2Id = value["player2"] as? String ?? "Player not found"
//                        let active = value["active"] as? String ?? "active not found"
//                        let tourneyId = value["tourneyId"] as? String ?? "Tourney not found"
//                        let rejection = value["rejection"] as? String ?? "rejection not found"
//                        invitation.player1 = player1Id
//                        invitation.player2 = player2Id
//                        invitation.active = active
//                        invitation.tourneyid = tourneyId
//                        invitation.invitationId = notificationId
//                        invitation.rejection = rejection
//                        self.invitations.append(invitation)
//                        DispatchQueue.main.async { self.collectionView.reloadData() }
//                    }
//
//                print(snapshot)
//            }, withCancel: nil)
//            } else {
//                let challengeReference = Database.database().reference().child("tourneys").child(potentialTourneyId).child("matches").child(notificationId)
//                challengeReference.observeSingleEvent(of: .value, with: {(snapshot) in
//                    if let value = snapshot.value as? NSDictionary {
//                        let match = Match()
//                        let challengerTeamId = value["challenger_team"] as? String ?? "Team not found"
//                        let challengedTeamId = value["challenged_team"] as? String ?? "Team not found"
//                        match.challengerTeamId = challengerTeamId
//                        match.challengedTeamId = challengedTeamId
//                        match.matchId = notificationId
//                        match.tourneyId = potentialTourneyId
//                        self.matches.append(match)
//                        DispatchQueue.main.async { self.collectionView.reloadData() }
//                    }
//
//                    print(snapshot)
//                }, withCancel: nil)
//            }
//
//            }, withCancel: nil)
//    }
    
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
        tableView?.register(FriendInviteCell.self, forCellReuseIdentifier: cellId)
        tableView?.register(MatchNotificationCell.self, forCellReuseIdentifier: cellId2)
        tableView?.backgroundColor = .white
        self.tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if notifications[indexPath.row].message == "friend" {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FriendInviteCell
            cell.friendInvite = notifications[indexPath.row]
            cell.confirmButton.tag = indexPath.row
            cell.confirmButton.addTarget(self, action: #selector(confirmFriend), for: .touchUpInside)
            cell.rejectButton.tag = indexPath.row
            cell.rejectButton.addTarget(self, action: #selector(rejectFriend), for: .touchUpInside)
            cell.viewButton.tag = indexPath.row
            cell.viewButton.addTarget(self, action: #selector(viewProfile), for: .touchUpInside)
            return cell
        } else if notifications[indexPath.row].message == "match" {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! MatchNotificationCell
            cell.matchInvite = notifications[indexPath.row]
            cell.viewButton.tag = indexPath.row
            cell.viewButton.addTarget(self, action: #selector(viewMatch), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(88)
    }
    
    @objc func confirmFriend(sender: UIButton) {
        let whichNotif = sender.tag
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        guard let playerId = notifications[whichNotif].fromId else {
            return
        }
        
        let friendsRef = Database.database().reference()
        guard let notificationId = notifications[whichNotif].id else {
            return
        }
        let childUpdates = ["/\("friends")/\(uid)/\(playerId)/": true, "/\("friends")/\(playerId)/\(uid)/": true] as [String : Any]
        friendsRef.updateChildValues(childUpdates, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if error != nil {
                let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(messageSendFailed, animated: true, completion: nil)
                print("Data could not be saved: \(String(describing: error)).")
                return
            }
            
            Database.database().reference().child("notifications").child(notificationId).removeValue()
            Database.database().reference().child("user_notifications").child(uid).child(notificationId).removeValue()
            self.notifications.remove(at: whichNotif)
            self.tableView.reloadData()
            
            print("Crazy data 2 saved!")
            
            
        })
    }
    
    @objc func rejectFriend(sender: UIButton) {
        let whichNotif = sender.tag
        
        guard let uid = Auth.auth().currentUser?.uid, let playerId = notifications[whichNotif].fromId, let notificationId = notifications[whichNotif].id else {
            return
        }
            
        Database.database().reference().child("notifications").child(notificationId).removeValue()
        Database.database().reference().child("user_notifications").child(uid).child(notificationId).removeValue()
        Database.database().reference().child("friends").child(playerId).child(uid).removeValue()
        
        self.notifications.remove(at: whichNotif)
        self.tableView.reloadData()
    }
    
    @objc func viewProfile(sender: UIButton) {
        let whichNotif = sender.tag
        
        let playerProfile = StartupPage()
        playerProfile.playerId = notifications[whichNotif].fromId ?? "none"
        playerProfile.isFriend = 3
        playerProfile.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(playerProfile, animated: true)
    }
    
    @objc func viewMatch(sender: UIButton) {
        let whichNotif = sender.tag
        let matchDisplay = MatchView()
        matchDisplay.matchId = notifications[whichNotif].id ?? "none"
        matchDisplay.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(matchDisplay, animated: true)
    }
    
    @objc func handleInvitationReject(sender: UIButton) {
        cellTag = sender.tag
        let newalert = UIAlertController(title: "Confirm", message: "Are you sure you want to reject?", preferredStyle: UIAlertController.Style.alert)
        newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
        newalert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: handleRejectConfirmed))
        self.present(newalert, animated: true, completion: nil)
    }
    
    @objc func handleInvitationConfirm(sender: UIButton) {
//        cellTag = sender.tag
//        guard let tourneyId = invitations[cellTag].tourneyid else {
//            return
//        }
//        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("teams")
//        let query = ref.queryOrdered(byChild: "rank")
//        query.observe(.value) { (snapshot) in
//            for child in snapshot.children.allObjects as! [DataSnapshot] {
//                if let value = child.value as? NSDictionary {
//                    self.highestCurrentRank = value["rank"] as? Int ?? -1
//                }
//            }
//        }
//        let newalert = UIAlertController(title: "Confirm", message: "Are you sure you want to join this tournament?", preferredStyle: UIAlertController.Style.alert)
//        newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
//        newalert.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: handleConfirmConfirmed))
//        self.present(newalert, animated: true, completion: nil)
    }
    
    @objc func handleDismiss(sender: UIButton) {
//        cellTag = sender.tag
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let invitation = invitations[cellTag]
//        guard let invitationId = invitation.invitationId else{
//            return
//        }
//
//        let deleteUserNotIdRef = Database.database().reference().child("user-notifications").child(uid).child(invitationId)
//        deleteUserNotIdRef.removeValue()
//        let deleteNotificationIdRef = Database.database().reference().child("notifications").child(invitationId)
//        deleteNotificationIdRef.removeValue()
//        invitations.remove(at: cellTag)
//        collectionView.reloadData()
    }
    
    func handleRejectConfirmed(action: UIAlertAction) {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let invitation = invitations[cellTag]
//        guard let invitationId = invitation.invitationId else{
//            return
//        }
//
//        let deleteUserNotIdRef = Database.database().reference().child("user-notifications").child(uid).child(invitationId)
//        deleteUserNotIdRef.removeValue()
//        let changeNotificationIdRef = Database.database().reference().child("notifications").child(invitationId)
//        changeNotificationIdRef.updateChildValues(["rejection": "1"])
//        invitations.remove(at: cellTag)
//        collectionView.reloadData()
    }
    
    func handleConfirmConfirmed(action: UIAlertAction) {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let invitation = invitations[cellTag]
//        guard let invitationId = invitation.invitationId else{
//            return
//        }
//        guard let inviteeId = invitation.player1 else{
//            return
//        }
//        guard let tourneyId = invitation.tourneyid else {
//            return
//        }
//        
//        let deleteUserNotIdRef = Database.database().reference().child("user-notifications").child(uid).child(invitationId)
//        deleteUserNotIdRef.removeValue()
//        let changeNotificationIdRef = Database.database().reference().child("notifications").child(invitationId)
//        changeNotificationIdRef.updateChildValues(["active": "1"])
//        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("teams")
//        let createTeamInTourneyRef = ref.childByAutoId()
//        let values = ["player1": inviteeId, "player2": uid, "wins": 0, "losses": 0, "rank": highestCurrentRank + 1] as [String : Any]
//        createTeamInTourneyRef.updateChildValues(values, withCompletionBlock: {
//            (error:Error?, ref:DatabaseReference) in
//            
//            if let error = error {
//                print("Data could not be saved: \(error).")
//                return
//            }
//            
//            let userNotificationsRef = Database.database().reference().child("user-notifications").child(uid)
//            if let teamId = createTeamInTourneyRef.key {
//                userNotificationsRef.updateChildValues([teamId: 1])
//                let inviteeNotificationsRef = Database.database().reference().child("user-notifications").child(inviteeId)
//                inviteeNotificationsRef.updateChildValues([teamId: 1])
//            }
//            
//            self.dismiss(animated: true, completion: nil)
//            
//            print("Data saved successfully!")
//            
//            
//        })
//        invitations.remove(at: cellTag)
//        collectionView.reloadData()
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