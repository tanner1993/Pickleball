//
//  FriendList.swift
//  Pickleball
//
//  Created by Tanner Rozier on 1/13/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

private let reuseIdentifier = "Cell"

class FriendList: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var friends = [Player]()
    var almostFriends = [Player]()
    var teams = [Team]()
    var tourneyId = "none"
    var whoSent = 0
    var connect: Connect?
    var createMatch: CreateMatch?
    var noNotifications = 0
    var teammateId = "none"
    var opp1Id = "none"
    var opp2Id = "none"
    var tourneyOpenInvites = [String]()
    var tourneyStandings = TourneyStandings()
    var startTime: Double = 0
    var simpleInvite = 0
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    override func loadView() {
        super.loadView()

        activityIndicatorView = UIActivityIndicatorView(style: .gray)

    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.fetchFriends()
//        if (friends.count == 0) {
//            activityIndicatorView.startAnimating()
//
//
//            dispatchQueue.async {
//                Thread.sleep(forTimeInterval: 3)
//
//                OperationQueue.main.addOperation() {
//                    self.activityIndicatorView.stopAnimating()
//
//                    self.collectionView.reloadData()
//
//                }
//            }
//        }
//    }
    
    let cellId = "poop"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            self.fillInRow()
        }
        fetchFriends()
        
        self.collectionView!.register(FriendListCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(EmptyCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .white
        if whoSent != 0 || tourneyId != "none" {
            setupForPlayerSelection()
        } else {
            setupNavbar()
        }
        if tourneyId != "none" {
            observeTourneyTeams()
        }
    }
    
    func fillInRow() {
        if friends.count == 0 {
            noNotifications = 1
            collectionView.reloadData()
        }
    }
    
    let selectPlayerLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Select Player"
        lb.numberOfLines = 2
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        lb.textAlignment = .center
        lb.textColor = UIColor.init(r: 88, g: 148, b: 200)
        return lb
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = .white
        button.setTitle("Return", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleReturn), for: .touchUpInside)
        return button
    }()
    
    @objc func handleReturn() {
        dismiss(animated: true, completion: nil)
    }
    
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
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    func setupForPlayerSelection() {
        collectionView?.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        if tourneyId != "none" {
            let normalTime = "Invite a friend to join you in this tournament\nRegistration ends on: "
            let attributedTime = NSMutableAttributedString(string: normalTime)
            let attrb = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 14), NSAttributedString.Key.foregroundColor : UIColor.init(r: 88, g: 148, b: 200)]
            let calendar = Calendar.current
            let startDater = Date(timeIntervalSince1970: startTime)
            let components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: startDater)
            let monthInt = components.month!
            let monthAbb = months[monthInt - 1].prefix(3)
            let boldTime = "\(monthAbb). \(components.day!)"
            let boldTimeString = NSAttributedString(string: boldTime, attributes: attrb as [NSAttributedString.Key : Any])
            attributedTime.append(boldTimeString)
            selectPlayerLabel.attributedText = attributedTime
            selectPlayerLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        }
        
        view.addSubview(whiteBox)
        whiteBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        whiteBox.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        whiteBox.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        whiteBox.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        view.addSubview(selectPlayerLabel)
        selectPlayerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectPlayerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        selectPlayerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        selectPlayerLabel.heightAnchor.constraint(equalToConstant: tourneyId != "none" ? 60 : 40).isActive = true
        
        view.addSubview(separatorView)
        separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        separatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Return", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Find Friends", style: .plain, target: self, action: #selector(handleSearchFriends))
        
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        titleLabel.text = "My Friends"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.navigationItem.titleView = titleLabel
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: view.frame.width, height: 80)
    }
    
    @objc func handleSearchFriends() {
        let layout = UICollectionViewFlowLayout()
        let findFriends = FindFriends(collectionViewLayout: layout)
//        var friendStrings = [String]()
//        var almostFriendStrings = [String]()
//        for index in friends {
//            friendStrings.append(index.id ?? "noId")
//        }
//        for index in almostFriends {
//            almostFriendStrings.append(index.id ?? "noId")
//        }
//        findFriends.friends = friendStrings
//        findFriends.almostFriends = almostFriendStrings
        navigationController?.pushViewController(findFriends, animated: true)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count == 0 ? 1 : friends.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if friends.count == 0 {
            if noNotifications == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
                cell.backgroundView = activityIndicatorView
                activityIndicatorView.startAnimating()
                return cell
            } else {
                activityIndicatorView.stopAnimating()
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EmptyCell
                cell.emptyLabel.text = "You have no friends :(,\nclick HERE to find friends!"
                cell.emptyLabel.numberOfLines = 2
                return cell
            }
        } else {
            activityIndicatorView.stopAnimating()
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendListCell
            cell.messageButton.tag = indexPath.item
            cell.messageButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
            if whoSent != 0 || tourneyId != "none" {
                cell.messageButton.isHidden = true
            }
            cell.player = friends[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(noNotifications)
        print(friends.count)
        if noNotifications == 1 && friends.count == 0 {
            let layout = UICollectionViewFlowLayout()
            let findFriends = FindFriends(collectionViewLayout: layout)
            findFriends.sender = 1
            present(findFriends, animated: true, completion: nil)
        } else if friends.count == 0 {
            
        } else if whoSent == 0 {
            if tourneyId == "none" {
                let playerProfile = StartupPage()
                playerProfile.playerId = friends[indexPath.item].id ?? "none"
                playerProfile.isFriend = 2
                navigationController?.pushViewController(playerProfile, animated: true)
            } else {
                if simpleInvite == 0 {
                    sendTourneyInvitation(toId: friends[indexPath.item].id ?? "none", deviceId: friends[indexPath.item].deviceId ?? "none")
                } else {
                    sendSimpleInvite(toId: friends[indexPath.item].id ?? "none", deviceId: friends[indexPath.item].deviceId ?? "none")
                }
            }
        } else {
            returnPlayerDetails(whichOne: indexPath.item)
        }
    }
    
    func returnPlayerDetails(whichOne: Int) {
        switch whoSent {
        case 1:
            createMatch?.teammate.id = friends[whichOne].id ?? "none"
            createMatch?.teammate.username = friends[whichOne].username ?? "none"
            createMatch?.teammate.skillLevel = "\(friends[whichOne].skill_level ?? 1.0)"
            createMatch?.teammate.deviceId = friends[whichOne].deviceId ?? "none"
        case 2:
            createMatch?.opponent1.id = friends[whichOne].id ?? "none"
            createMatch?.opponent1.username = friends[whichOne].username ?? "none"
            createMatch?.opponent1.skillLevel = "\(friends[whichOne].skill_level ?? 1.0)"
            createMatch?.opponent1.deviceId = friends[whichOne].deviceId ?? "none"
        case 3:
            createMatch?.opponent2.id = friends[whichOne].id ?? "none"
            createMatch?.opponent2.username = friends[whichOne].username ?? "none"
            createMatch?.opponent2.skillLevel = "\(friends[whichOne].skill_level ?? 1.0)"
            createMatch?.opponent2.deviceId = friends[whichOne].deviceId ?? "none"
        default:
            print("failed")
        }
        createMatch?.getPlayerDetails()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sendMessage(sender: UIButton) {
        let whichFriend = sender.tag
        dismiss(animated: true, completion: nil)
        guard let recipientId = friends[whichFriend].id else {
            return
        }
        connect?.presentChatLogs(recipientId: recipientId)
    }
    
    func sendTourneyInvitation(toId: String, deviceId: String) {
        let check = checkAlreadyRegistered(toId: toId)
        if check == false {
            let alreadyRegistered = UIAlertController(title: "Sorry", message: "This player has already registered for this tourney", preferredStyle: .alert)
            alreadyRegistered.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alreadyRegistered, animated: true, completion: nil)
            return
        }
        let checkI = checkAlreadyInvited(toId: toId)
        if checkI == false {
            let alreadyInvited = UIAlertController(title: "Sorry", message: "This player has already been invited to this tourney", preferredStyle: .alert)
            alreadyInvited.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alreadyInvited, animated: true, completion: nil)
            return
        }
        let joinInviteConfirmed = UIAlertController(title: "Successfully sent tourney invite", message: "Have your friend check their notifications to accept!", preferredStyle: .alert)
        joinInviteConfirmed.addAction(UIAlertAction(title: "OK", style: .default, handler: self.handleDismiss))
        self.present(joinInviteConfirmed, animated: true, completion: nil)
        let uid = Auth.auth().currentUser!.uid
        let timeStamp = Int(Date().timeIntervalSince1970)
        let ref = Database.database().reference().child("notifications")
        let notificationRef = ref.childByAutoId()
        let values = ["type": "tourney_invite", "fromId": uid, "toId": toId, "timestamp": timeStamp, "tourneyId": tourneyId] as [String : Any]
        notificationRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            
            let notificationsRef = Database.database().reference()
            let notificationId = notificationRef.key!
            self.tourneyOpenInvites.append(uid)
            self.tourneyOpenInvites.append(toId)
            let childUpdates = ["/\("user_notifications")/\(uid)/\(notificationId)/": 0, "/\("user_notifications")/\(toId)/\(notificationId)/": 1, "/\("tourneys")/\(self.tourneyId)/\("invites")/": self.tourneyOpenInvites] as [String : Any]
            notificationsRef.updateChildValues(childUpdates, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if error != nil {
                    let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(messageSendFailed, animated: true, completion: nil)
                    print("Data could not be saved: \(String(describing: error)).")
                    return
                }
                
                print("Crazy data 2 saved!")
                Database.database().reference().child("users").child(uid).child("name").observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value {
                        let nameOnInvite = value as? String ?? "none"
                        let pusher = PushNotificationHandler()
                        pusher.setupPushNotification(deviceId: deviceId, message: "\(nameOnInvite) wants you to play in a tourney with them", title: "Tourney Invite")
                        //self.setupPushNotification(deviceId: self.playersDeviceId, nameOnInvite: nameOnInvite)
                    }
                })
                
            })
            
        })
    }
    
    func sendSimpleInvite(toId: String, deviceId: String) {
        let check = checkAlreadyRegistered(toId: toId)
        if check == false {
            let alreadyRegistered = UIAlertController(title: "No need", message: "This player has already registered for this tourney", preferredStyle: .alert)
            alreadyRegistered.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alreadyRegistered, animated: true, completion: nil)
            return
        }
        let joinInviteConfirmed = UIAlertController(title: "Successfully sent tourney invite", message: "It's waiting in your friends inbox", preferredStyle: .alert)
        joinInviteConfirmed.addAction(UIAlertAction(title: "OK", style: .default, handler: self.handleDismiss))
        self.present(joinInviteConfirmed, animated: true, completion: nil)
        let uid = Auth.auth().currentUser!.uid
        let timeStamp = Int(Date().timeIntervalSince1970)
        let ref = Database.database().reference().child("notifications")
        let notificationRef = ref.childByAutoId()
        let values = ["type": "tourney_invite_simple", "fromId": uid, "toId": toId, "timestamp": timeStamp, "tourneyId": tourneyId] as [String : Any]
        notificationRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            
            let notificationsRef = Database.database().reference()
            let notificationId = notificationRef.key!
            let childUpdates = ["/\("user_notifications")/\(toId)/\(notificationId)/": 1] as [String : Any]
            notificationsRef.updateChildValues(childUpdates, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if error != nil {
                    let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(messageSendFailed, animated: true, completion: nil)
                    print("Data could not be saved: \(String(describing: error)).")
                    return
                }
                
                print("Crazy data 2 saved!")
                Database.database().reference().child("users").child(uid).child("name").observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value {
                        let nameOnInvite = value as? String ?? "none"
                        let pusher = PushNotificationHandler()
                        pusher.setupPushNotification(deviceId: deviceId, message: "\(nameOnInvite) wants you to check out a tourney", title: "Tourney Invite")
                        //self.setupPushNotification(deviceId: self.playersDeviceId, nameOnInvite: nameOnInvite)
                    }
                })
                
            })
            
        })
    }
    
    func handleDismiss(action: UIAlertAction) {
        if simpleInvite == 0 {
            tourneyStandings.navigationItem.rightBarButtonItem = nil
        }
        dismiss(animated: true, completion: nil)
    }
    
    func observeTourneyTeams() {

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
    
    func checkAlreadyRegistered(toId: String) -> Bool {
        for index in teams {
            if index.player1 == toId || index.player2 == toId {
                return false
            }
        }
        return true
    }
    
    func checkAlreadyInvited(toId: String) -> Bool {
        if tourneyOpenInvites.contains(toId) == true {
            return false
        } else {
            return true
        }
    }

    func fetchFriends() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let friendsRef = Database.database().reference().child("friends").child(uid)
        friendsRef.observe(.childAdded, with: {(snapshot) in
            let friendId = snapshot.key
            let fullFriend: Bool = snapshot.value! as! Bool
            let rootRef = Database.database().reference().child("users").child(friendId)
            rootRef.observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    let player = Player()
                    let name = value["name"] as? String ?? "No Name"
                    let username = value["username"] as? String ?? "No Username"
                    let state = value["state"] as? String ?? "No State"
                    let county = value["county"] as? String ?? "No county"
                    let skillLevel = value["skill_level"] as? Float ?? 0.0
                    let exp = value["exp"] as? Int ?? 0
                    let haloLevel = player.haloLevel(exp: exp)
                    let deviceId = value["deviceId"] as? String ?? "none"
                    player.deviceId = deviceId
                    player.name = name
                    player.username = username
                    player.id = friendId
                    player.skill_level = skillLevel
                    player.halo_level = haloLevel
                    player.state = state
                    player.county = county
                    if fullFriend == false {
                        self.almostFriends.append(player)
                    } else {
                        if friendId != self.teammateId && friendId != self.opp1Id && friendId != self.opp2Id {
                            self.friends.append(player)
                        }
                    }
                    DispatchQueue.main.async { self.collectionView.reloadData() }
                }
            })
        })
    }


}
