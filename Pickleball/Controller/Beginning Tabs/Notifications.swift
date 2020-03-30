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
    
    struct tourneyPlayer {
        var idT: String
        var playerId: String
    }
    
    struct tourneyHighestRank {
        var idT: String
        var highestRank: Int
    }
    //var invitations = [Invitation]()
    var notifications = [Message]()
    let cellId = "cellId"
    let cellId2 = "cellId2"
    let cellIdNone = "loading"
    var cellTag = -1
    var currentUser2 = "nothing"
    var noNotifications = 0
    var tourneyPlayers = [tourneyPlayer]()
    var tourneyHighestRanks = [tourneyHighestRank]()
    var tourneyOpenInvites = [String]()
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    override func loadView() {
        super.loadView()
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        
    }
    
    func setupNavbarAndTitle() {
        //let plusImage = UIImage(named: "plus")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let createNewMatchButton = UIBarButtonItem(title: "Create Match", style: .plain, target: self, action: #selector(handleCreateNewMatch))
        self.navigationItem.rightBarButtonItem = createNewMatchButton
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        titleLabel.text = "Events"
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            self.fillInRow()
        }
        currentUser2 = uid
        setupNavbarAndTitle()
        setupCollectionView()
        fetchNotifications()
    }
    
    func fillInRow() {
        if notifications.count == 0 {
            noNotifications = 1
            tableView.reloadData()
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
                    if messageText == "tourney_invite" {
                        let tourneyId = value["tourneyId"] as? String ?? "none"
                        notification.tourneyId = tourneyId
                    }
                    notification.timeStamp = timeStamp
                    notification.toId = toId
                    notification.fromId = fromId
                    notification.id = notificationId
                    self.notifications.append(notification)
                    self.notifications = self.notifications.sorted { p1, p2 in
                        return (p1.timeStamp!) > (p2.timeStamp!)
                    }
                    DispatchQueue.main.async { self.tableView.reloadData()}
                }
            }, withCancel: nil)
        }, withCancel: nil)
        if let tabItems = self.tabBarController?.tabBar.items {
            let tabItem = tabItems[4]
            tabItem.badgeValue = .none
        }
    }
    
    func setupCollectionView() {
        tableView?.register(FriendInviteCell.self, forCellReuseIdentifier: cellId)
        tableView?.register(MatchNotificationCell.self, forCellReuseIdentifier: cellId2)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellIdNone)
        tableView?.backgroundColor = .white
        self.tableView.separatorStyle = .none
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count == 0 ? 1 : notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if notifications.count == 0 {
            if noNotifications == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdNone, for: indexPath)
                cell.backgroundView = activityIndicatorView
                activityIndicatorView.startAnimating()
                return cell
            } else {
                activityIndicatorView.stopAnimating()
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdNone, for: indexPath)
                cell.textLabel?.text = "No Events"
                cell.textLabel?.textAlignment = .center
                return cell
            }
        } else {
            activityIndicatorView.stopAnimating()
            if notifications[indexPath.row].message == "friend" {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FriendInviteCell
                cell.appLevel.isHidden = false
                cell.friendInvite = notifications[indexPath.row]
                cell.confirmButton.tag = indexPath.row
                cell.confirmButton.addTarget(self, action: #selector(confirmFriend), for: .touchUpInside)
                cell.rejectButton.tag = indexPath.row
                cell.rejectButton.addTarget(self, action: #selector(rejectFriend), for: .touchUpInside)
                return cell
            } else if notifications[indexPath.row].message == "match" {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! MatchNotificationCell
                cell.matchInvite = notifications[indexPath.row]
                return cell
            } else if notifications[indexPath.row].message == "reject_match" {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! MatchNotificationCell
                cell.matchInvite = notifications[indexPath.row]
                cell.viewButton.setTitle("Dismiss", for: .normal)
                cell.viewButton.tag = indexPath.row
                cell.viewButton.addTarget(self, action: #selector(dismissNotification), for: .touchUpInside)
                return cell
            } else if notifications[indexPath.row].message == "tourney_invite" {
                observeTourneyTeams(tourneyId: notifications[indexPath.row].tourneyId ?? "none")
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FriendInviteCell
                cell.appLevel.isHidden = true
                cell.friendInvite = notifications[indexPath.row]
                if let uid = Auth.auth().currentUser?.uid {
                    if uid != notifications[indexPath.row].fromId {
                        cell.confirmButton.tag = indexPath.row
                        cell.confirmButton.addTarget(self, action: #selector(confirmTourney), for: .touchUpInside)
                    } else {
                        cell.confirmButton.isHidden = true
                        cell.rejectButton.setTitle("Cancel", for: .normal)
                    }
                }
                cell.rejectButton.tag = indexPath.row
                cell.rejectButton.addTarget(self, action: #selector(rejectTourney), for: .touchUpInside)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
                return cell
            }
        }
    }
    
    func observeTourneyTeams(tourneyId: String) {
        
        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("teams")
        ref.observe(.childAdded, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                //let player1Id = value["player1"] as? String ?? "Player not found"
                //let player2Id = value["player2"] as? String ?? "Player not found"
                let rank = value["rank"] as? Int ?? 100
                self.checkRank(rank: rank, tourneyId: tourneyId)
                //self.tourneyPlayers.append(tourneyPlayer(idT: tourneyId, playerId: player1Id))
                //self.tourneyPlayers.append(tourneyPlayer(idT: tourneyId, playerId: player2Id))
            }
            
        }, withCancel: nil)
    }
    
    func checkRank(rank: Int, tourneyId: String) {
        var addNewTourney = 0
        if tourneyHighestRanks.count == 0 {
            tourneyHighestRanks.append(tourneyHighestRank(idT: tourneyId, highestRank: rank))
        } else {
            for (index, element) in tourneyHighestRanks.enumerated() {
                if element.idT == tourneyId && element.highestRank < rank {
                    tourneyHighestRanks[index].highestRank = rank
                } else if element.idT != tourneyId {
                    addNewTourney += 1
                }
            }
            if addNewTourney == tourneyHighestRanks.count {
                tourneyHighestRanks.append(tourneyHighestRank(idT: tourneyId, highestRank: rank))
            }
        }
        print(tourneyHighestRanks[0].highestRank)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if notifications.count == 0 {
            
        } else {
            if notifications[indexPath.row].message == "friend" {
                let whichNotif = indexPath.row
                let playerProfile = StartupPage()
                playerProfile.playerId = notifications[whichNotif].fromId ?? "none"
                playerProfile.isFriend = 3
                playerProfile.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(playerProfile, animated: true)
            } else if notifications[indexPath.row].message == "match" {
                let whichNotif = indexPath.row
                let matchDisplay = MatchView()
                matchDisplay.matchId = notifications[whichNotif].id ?? "none"
                matchDisplay.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(matchDisplay, animated: true)
            } else if notifications[indexPath.row].message == "reject_match" {
                
            } else if notifications[indexPath.row].message == "tourney_invite" {
//                let layout = UICollectionViewFlowLayout()
//                let tourneyStandingsPage = TourneyStandings(collectionViewLayout: layout)
//                tourneyStandingsPage.hidesBottomBarWhenPushed = true
//                tourneyStandingsPage.notificationSentYou = 1
//                tourneyStandingsPage.tourneyIdentifier = notifications[indexPath.item].tourneyId
//                navigationController?.pushViewController(tourneyStandingsPage, animated: true)
                let layout = UICollectionViewFlowLayout()
                let tourneySearch = TourneySearch()
                tourneySearch.inviteTourneyId = notifications[indexPath.item].tourneyId ?? "none"
                tourneySearch.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(tourneySearch, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func dismissNotification(sender: UIButton) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let notificationId = notifications[sender.tag].id!
        Database.database().reference().child("notifications").child(notificationId).removeValue()
        Database.database().reference().child("user_notifications").child(uid).child(notificationId).removeValue()
        notifications.remove(at: sender.tag)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(102)
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
            self.noNotifications = 1
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
        self.noNotifications = 1
    }
    
    func getHighestCurrentRank(tourneyId: String) -> Int {
        for index in tourneyHighestRanks {
            if index.idT == tourneyId {
                return index.highestRank
            }
        }
        return 0
    }
    
    @objc func confirmTourney(sender: UIButton) {
        let whichNotif = sender.tag
        guard let tourneyId = notifications[whichNotif].tourneyId, let fromId = notifications[whichNotif].fromId, let uid = Auth.auth().currentUser?.uid, let notificationId = notifications[whichNotif].id else {
            return
        }
        let highestCurrentRank = getHighestCurrentRank(tourneyId: tourneyId)
        print(highestCurrentRank)
        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("teams")
        let createTeamInTourneyRef = ref.childByAutoId()
        let values = ["player1": fromId, "player2": uid, "wins": 0, "losses": 0, "rank": highestCurrentRank + 1] as [String : Any]
        createTeamInTourneyRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
        
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
        
            Database.database().reference().child("user_tourneys").child(uid).child(tourneyId).setValue(1)
            Database.database().reference().child("user_tourneys").child(fromId).child(tourneyId).setValue(1)
            
            Database.database().reference().child("notifications").child(notificationId).removeValue()
            Database.database().reference().child("user_notifications").child(uid).child(notificationId).removeValue()
            Database.database().reference().child("user_notifications").child(fromId).child(notificationId).removeValue()
            self.notifications.remove(at: whichNotif)
            self.tableView.reloadData()
            self.noNotifications = 1
            print("Data saved successfully!")
        
        
        })
    }
    
    @objc func rejectTourney(sender: UIButton) {
        let whichNotif = sender.tag
        guard let tourneyId = notifications[whichNotif].tourneyId, let fromId = notifications[whichNotif].fromId, let toId = notifications[whichNotif].toId, let notificationId = notifications[whichNotif].id else {
            return
        }
        Database.database().reference().child("notifications").child(notificationId).removeValue()
        Database.database().reference().child("user_notifications").child(toId).child(notificationId).removeValue()
        Database.database().reference().child("user_notifications").child(fromId).child(notificationId).removeValue()
        observeTourneyInfo(whichNotif: whichNotif, fromId: fromId, toId: toId, tourneyId: tourneyId)
    }
    
    func observeTourneyInfo(whichNotif: Int, fromId: String, toId: String, tourneyId: String) {
        guard let tourneyId = notifications[whichNotif].tourneyId else {
            return
        }
        self.notifications.remove(at: whichNotif)
        self.tableView.reloadData()
        self.noNotifications = 1
        let ref = Database.database().reference().child("tourneys").child(tourneyId)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? NSDictionary {
                if let invites = value["invites"] as? [String] {
                    self.deleteTourneyInvites(invites: invites, fromId: fromId, toId: toId, tourneyId: tourneyId)
                }
            }
        }, withCancel: nil)
    }
    
    func deleteTourneyInvites(invites: [String], fromId: String, toId: String, tourneyId: String) {
        tourneyOpenInvites = invites
        tourneyOpenInvites.remove(at: tourneyOpenInvites.firstIndex(of: fromId)!)
        tourneyOpenInvites.remove(at: tourneyOpenInvites.firstIndex(of: toId)!)
        
        Database.database().reference().child("tourneys").child(tourneyId).child("invites").setValue(tourneyOpenInvites)
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
