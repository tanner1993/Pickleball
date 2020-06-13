//
//  FindFriends.swift
//  Pickleball
//
//  Created by Tanner Rozier on 1/13/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FindFriends: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    let cellId2 = "cellId2"
    var players = [Player]()
    var searchResults = [Player]()
    var textFields = [UITextField]()
    var dropDownButtons = [UIButton]()
    let blackView = UIView()
    var selectedDropDown = -1
    var buttonsCreated = 0
    var sender = 0
    var createMatch: CreateMatch?
    var matchView: MatchView?
    var teammateId = "none"
    var opp1Id = "none"
    var opp2Id = "none"
    var teams = [Team]()
    var tourneyId = "none"
    var tourneyName = "none"
    var simpleInvite = 0
    var tourneyOpenInvites = [String]()
    var tourneySimpleInvites = [String]()
    var tourneyStandings = TourneyStandings()
    var startTime: Double = 0
    var whichTourney = Int()
    var tourneyList: TourneyList?
    
    var friends = [Player]()
    var almostFriends = [Player]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsers()
        setupViews()
        if sender > 1 {
            fetchFriends()
        }
        
        self.collectionView!.register(FriendListCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = .white
        if sender == 0 {
            collectionView?.contentInset = UIEdgeInsets(top: 281, left: 0, bottom: 0, right: 0)
            collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 281, left: 0, bottom: 0, right: 0)
        } else {
            collectionView?.contentInset = UIEdgeInsets(top: 336, left: 0, bottom: 0, right: 0)
            collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 336, left: 0, bottom: 0, right: 0)
        }
        setupFilterCollectionView()
        
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        titleLabel.text = "Find Friends"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.navigationItem.titleView = titleLabel
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
        for index in textFields {
            index.resignFirstResponder()
        }
        self.view.endEditing(true)
    }
    
    @objc func handleSearchFilter() {
        searchBar.resignFirstResponder()
        
        if myFriendsCheck.isOn {
            searchResults = friends
            collectionView.reloadData()
            return
        }
        
        searchResults = players
        
        
        if textFields[0].text! != "Any" {
            searchResults = searchResults.filter({ (player) -> Bool in
                let skillLevel = Float(textFields[0].text!)
                return player.skill_level! == skillLevel
            })
        }
        if textFields[1].text! != "Any" {
            searchResults = searchResults.filter({ (player) -> Bool in
                let state = textFields[1].text!
                return player.state! == state
            })
        }
        if textFields[2].text! != "Any" {
            searchResults = searchResults.filter({ (player) -> Bool in
                let county = textFields[2].text!
                return player.county! == county
            })
        }
        if textFields[3].text! != "Any" {
            searchResults = searchResults.filter({ (player) -> Bool in
                let sex = textFields[3].text!
                return player.sex! == sex
            })
        }
        if textFields[4].text! != "Any" {
            searchResults = searchResults.filter({ (player) -> Bool in
                let age_group = textFields[4].text!
                return player.age_group! == age_group
            })
        }
        //playersFoundNumber.text = "\(searchResults.count)"
        collectionView.reloadData()
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
                    print(deviceId)
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
                        self.friends = self.friends.sorted { p1, p2 in
                            return (p1.name!) < (p2.name!)
                        }
                    }
                    DispatchQueue.main.async { self.collectionView.reloadData() }
                }
            })
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: view.frame.width, height: 80)
        } else {
            return CGSize(width: view.frame.width, height: 50)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            playersFoundNumber.text = "\(searchResults.count)"
            return searchResults.count
        } else {
            switch selectedDropDown {
            case 0:
                return skillLevels.count
            case 1:
                return states.count
            case 2:
                return counties.count
            case 3:
                return sexes.count
            case 4:
                return ageGroups.count
            default:
                return 0
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FriendListCell
            cell.messageButton.isHidden = true
            cell.playerLocation.isHidden = false
            cell.player = searchResults[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! ProfileMenuCell
            switch selectedDropDown {
            case 0:
                cell.menuItem.text = "\(skillLevels[indexPath.item])"
            case 1:
                cell.menuItem.text = states[indexPath.item]
            case 2:
                cell.menuItem.text = counties[indexPath.item]
            case 3:
                cell.menuItem.text = sexes[indexPath.item]
            case 4:
                cell.menuItem.text = ageGroups[indexPath.item]
            default:
                return cell
            }
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let playerProfile = StartupPage()
            playerProfile.findFriends = self
            playerProfile.playerId = searchResults[indexPath.item].id ?? "none"
            playerProfile.whichFriend = indexPath.item
            playerProfile.isFriend = 3
            if sender == 0 {
                navigationController?.pushViewController(playerProfile, animated: true)
            } else if sender == 1 {
                let friendNavController = UINavigationController(rootViewController: playerProfile)
                //friendList.hidesBottomBarWhenPushed = true
                playerProfile.findFriendSender = 1
                friendNavController.navigationBar.barTintColor = UIColor.init(r: 88, g: 148, b: 200)
                friendNavController.navigationBar.tintColor = .white
                friendNavController.navigationBar.isTranslucent = false
                present(friendNavController, animated: true, completion: nil)
                
            } else if sender == 2 || sender == 3 || sender == 4 {
                returnPlayerDetails(whichOne: indexPath.item)
            } else if sender == 11 || sender == 12 {
                uploadNewPlayerPossibly(whichOne: indexPath.item)
            } else {
                if tourneyId != "none" {
                    if simpleInvite == 0 {
                        sendTourneyInvitation(toId: searchResults[indexPath.item].id ?? "none", deviceId: searchResults[indexPath.item].deviceId ?? "none")
                    } else {
                        sendSimpleInvite(toId: searchResults[indexPath.item].id ?? "none", deviceId: searchResults[indexPath.item].deviceId ?? "none")
                    }
                }
            }
        } else {
            switch selectedDropDown {
            case 0:
                textFields[0].text = "\(skillLevels[indexPath.item])"
            case 1:
                textFields[1].text = states[indexPath.item]
            case 2:
                textFields[2].text = "\(counties[indexPath.item])"
            case 3:
                textFields[3].text = sexes[indexPath.item]
            case 4:
                textFields[4].text = ageGroups[indexPath.item]
            default:
                print("failed")
            }
            dismissMenu()
        }
    }
    
    var whichPlayerForGuest = Int()
    
    func uploadNewPlayerPossibly(whichOne: Int) {
        whichPlayerForGuest = whichOne
        let newalert = UIAlertController(title: "Are you sure?", message: "Do you want to invite \(searchResults[whichOne].name ?? "none") to this match? It can't be undone", preferredStyle: UIAlertController.Style.alert)
        newalert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        newalert.addAction(UIAlertAction(title: "Yes I'm sure", style: UIAlertAction.Style.default, handler: uploadNewPlayer))
        self.present(newalert, animated: true, completion: nil)
    }
    
    func uploadNewPlayer(action: UIAlertAction) {
        var values = [String: Any]()
        var confirmers = matchView!.match.team1_scores!
        if sender == 11 {
            confirmers[1] = 0
            values = ["team_1_player_2": searchResults[whichPlayerForGuest].id ?? "none", "team1_scores": confirmers] as [String : Any]
            matchView?.matchViewOrganizer.confirmCheck2.isHidden = true
            matchView?.matchViewOrganizer.guestTeammateButton.isHidden = true
            matchView?.matchViewOrganizer.userPlayer2.isHidden = false
            self.matchView?.matchFeed?.matches[matchView!.whichItem].team_1_player_2 = searchResults[whichPlayerForGuest].id ?? "none"
            self.matchView?.matchFeed?.matches[matchView!.whichItem].team1_scores = confirmers
        } else if sender == 12 {
            confirmers[3] = 0
            values = ["team_2_player_2": searchResults[whichPlayerForGuest].id ?? "none", "team1_scores": confirmers] as [String : Any]
            matchView?.matchViewOrganizer.confirmCheck4.isHidden = true
            matchView?.matchViewOrganizer.guestOpponentButton.isHidden = true
            matchView?.matchViewOrganizer.oppPlayer2.isHidden = false
            self.matchView?.matchFeed?.matches[matchView!.whichItem].team_2_player_2 = searchResults[whichPlayerForGuest].id ?? "none"
            self.matchView?.matchFeed?.matches[matchView!.whichItem].team1_scores = confirmers
        }
        let ref = Database.database().reference().child("matches").child(matchView!.matchId)
        ref.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            let notificationsRef = Database.database().reference().child("user_matches")
            let childUpdates = ["/\(self.searchResults[self.whichPlayerForGuest].id ?? "none")/\(self.matchView!.matchId)/": 1]
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
                guard let uid = Auth.auth().currentUser?.uid else {
                    return
                }
            Database.database().reference().child("users").child(uid).child("name").observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value {
                    let nameOnInvite = value as? String ?? "none"
                    let pusher = PushNotificationHandler()
                    pusher.setupPushNotification(deviceId: self.searchResults[self.whichPlayerForGuest].deviceId ?? "none", message: "\(nameOnInvite) invited you to play in a match with them", title: "Match Invite")
                }
            })
            })
        })
        let idList = [matchView!.match.team_1_player_1!,  sender == 11 ? searchResults[whichPlayerForGuest].id ?? "none" : matchView!.match.team_1_player_2!, matchView!.match.team_2_player_1!, sender == 12 ? searchResults[whichPlayerForGuest].id ?? "none" : matchView!.match.team_2_player_2!]
        matchView?.getPlayerNames(idList: idList)
        matchView?.matchFeed?.tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func returnPlayerDetails(whichOne: Int) {
        switch sender {
        case 2:
            createMatch?.teammate.id = searchResults[whichOne].id ?? "none"
            createMatch?.teammate.name = searchResults[whichOne].name ?? "none"
            createMatch?.teammate.skillLevel = "\(searchResults[whichOne].skill_level ?? 1.0)"
            createMatch?.teammate.deviceId = searchResults[whichOne].deviceId ?? "none"
        case 3:
            createMatch?.opponent1.id = searchResults[whichOne].id ?? "none"
            createMatch?.opponent1.name = searchResults[whichOne].name ?? "none"
            createMatch?.opponent1.skillLevel = "\(searchResults[whichOne].skill_level ?? 1.0)"
            createMatch?.opponent1.deviceId = searchResults[whichOne].deviceId ?? "none"
        case 4:
            createMatch?.opponent2.id = searchResults[whichOne].id ?? "none"
            createMatch?.opponent2.name = searchResults[whichOne].name ?? "none"
            createMatch?.opponent2.skillLevel = "\(searchResults[whichOne].skill_level ?? 1.0)"
            createMatch?.opponent2.deviceId = searchResults[whichOne].deviceId ?? "none"
        default:
            print("failed")
        }
        createMatch?.getPlayerDetails()
        dismiss(animated: true, completion: nil)
    }
    
    func handleDismiss(action: UIAlertAction) {
        if simpleInvite == 0 {
            tourneyStandings.navigationItem.rightBarButtonItem = nil
        }
        dismiss(animated: true, completion: nil)
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
        let values = ["type": "tourney_invite", "fromId": uid, "toId": toId, "timestamp": timeStamp, "tourneyId": tourneyId, "tourneyName": tourneyName] as [String : Any]
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
        
        let check2 = checkAlreadySimpleInvited(toId: toId)
        if check2 == false {
            let alreadyRegistered = UIAlertController(title: "No need", message: "This player has already been invited", preferredStyle: .alert)
            alreadyRegistered.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alreadyRegistered, animated: true, completion: nil)
            return
        }
        
        let joinInviteConfirmed = UIAlertController(title: "Successfully sent tourney invite", message: "It's waiting in the player's inbox", preferredStyle: .alert)
        joinInviteConfirmed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(joinInviteConfirmed, animated: true, completion: nil)
        let uid = Auth.auth().currentUser!.uid
        let timeStamp = Int(Date().timeIntervalSince1970)
        self.tourneySimpleInvites.append(toId)
        self.tourneyList?.myTourneys[whichTourney].simpleInvites?.append(toId)
        let ref = Database.database().reference().child("notifications")
        let notificationRef = ref.childByAutoId()
        let values = ["type": "tourney_invite_simple", "fromId": uid, "toId": toId, "timestamp": timeStamp, "tourneyId": tourneyId, "tourneyName": tourneyName] as [String : Any]
        notificationRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            
            let notificationsRef = Database.database().reference()
            let notificationId = notificationRef.key!
            let childUpdates = ["/\("user_notifications")/\(toId)/\(notificationId)/": 1, "/\("tourneys")/\(self.tourneyId)/\("simpleInvites")/": self.tourneySimpleInvites] as [String : Any]
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
    
    func checkAlreadySimpleInvited(toId: String) -> Bool {
        if tourneySimpleInvites.contains(toId) == true {
            return false
        } else {
            return true
        }
    }
    
    let whiteContainerView: UIView = {
        let wc = UIView()
        wc.translatesAutoresizingMaskIntoConstraints = false
        wc.backgroundColor = .white
        return wc
    }()
    
    let whiteContainerView2: UIView = {
        let wc = UIView()
        wc.translatesAutoresizingMaskIntoConstraints = false
        wc.backgroundColor = .white
        return wc
    }()
    
    let filtersLabel: UILabel = {
        let fl = UILabel()
        fl.text = "Filters"
        fl.backgroundColor = .white
        fl.textColor = UIColor.init(r: 88, g: 148, b: 200)
        fl.font = UIFont(name: "HelveticaNeue", size: 24)
        fl.textAlignment = .center
        fl.translatesAutoresizingMaskIntoConstraints = false
        return fl
    }()
    
    let playersFound: UILabel = {
        let fl = UILabel()
        fl.text = "Players Found:"
        fl.backgroundColor = .white
        fl.textColor = .black
        fl.font = UIFont(name: "HelveticaNeue-Light", size: 24)
        fl.textAlignment = .center
        fl.adjustsFontSizeToFitWidth = true
        fl.translatesAutoresizingMaskIntoConstraints = false
        return fl
    }()
    
    let playersFoundNumber: UILabel = {
        let fl = UILabel()
        fl.backgroundColor = .white
        fl.adjustsFontSizeToFitWidth = true
        fl.textColor = UIColor.init(r: 88, g: 148, b: 200)
        fl.font = UIFont(name: "HelveticaNeue-Light", size: 24)
        fl.textAlignment = .center
        fl.translatesAutoresizingMaskIntoConstraints = false
        return fl
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        button.setTitle("Filter Players", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSearchFilter), for: .touchUpInside)
        return button
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let inputsArray = ["Skill Level", "State", "County", "Sex", "Age Group"]
    
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
    
    let myFriendsLabel: UILabel = {
        let fl = UILabel()
        fl.text = "My Friends:"
        fl.textColor = UIColor.init(r: 88, g: 148, b: 200)
        fl.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        fl.adjustsFontSizeToFitWidth = true
        fl.textAlignment = .center
        fl.translatesAutoresizingMaskIntoConstraints = false
        return fl
    }()
    
    let myFriendsCheck: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.addTarget(self, action: #selector(handleSwitchChanged), for: .valueChanged)
        return uiSwitch
    }()
    
    @objc func handleSwitchChanged() {
        searchBar.isHidden = myFriendsCheck.isOn ? true : false
        whiteContainerView2.isHidden = myFriendsCheck.isOn ? true : false
        whiteContainerView.isHidden = myFriendsCheck.isOn ? true : false
        searchButton.isHidden = myFriendsCheck.isOn ? true : false
        separatorView.isHidden = myFriendsCheck.isOn ? true : false
        filtersLabel.isHidden = myFriendsCheck.isOn ? true : false
        playersFoundNumber.isHidden = myFriendsCheck.isOn ? true : false
        playersFound.isHidden = myFriendsCheck.isOn ? true : false
        inputContainer.isHidden = myFriendsCheck.isOn ? true : false
        collectionView?.contentInset = myFriendsCheck.isOn ? UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0) : UIEdgeInsets(top: 336, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = myFriendsCheck.isOn ? UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0) : UIEdgeInsets(top: 336, left: 0, bottom: 0, right: 0)
        handleSearchFilter()
    }
    
    let inputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc func handleReturn() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        view.addSubview(whiteContainerView2)
        view.addSubview(searchBar)
        if sender == 0 {
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            whiteContainerView2.topAnchor.constraint(equalTo: searchBar.topAnchor, constant: 0).isActive = true
            whiteContainerView2.heightAnchor.constraint(equalToConstant: 281).isActive = true
        } else {
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
            view.addSubview(backButton)
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4).isActive = true
            if #available(iOS 13.0, *) {
                backButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            } else {
                backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
            }
            backButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
            backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            whiteContainerView2.topAnchor.constraint(equalTo: backButton.topAnchor, constant: 0).isActive = true
            whiteContainerView2.heightAnchor.constraint(equalToConstant: 331).isActive = true
        }
        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        searchBar.delegate = self
        
        whiteContainerView2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        whiteContainerView2.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        view.addSubview(whiteContainerView)
        whiteContainerView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0).isActive = true
        whiteContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        whiteContainerView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        whiteContainerView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        whiteContainerView.addSubview(filtersLabel)
        filtersLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4).isActive = true
        filtersLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        filtersLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - 8).isActive = true
        filtersLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        whiteContainerView.addSubview(playersFound)
        playersFound.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4).isActive = true
        playersFound.leftAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playersFound.widthAnchor.constraint(equalToConstant: view.frame.width / 2 - 50).isActive = true
        playersFound.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        whiteContainerView.addSubview(playersFoundNumber)
        playersFoundNumber.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4).isActive = true
        playersFoundNumber.leftAnchor.constraint(equalTo: playersFound.rightAnchor).isActive = true
        playersFoundNumber.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        playersFoundNumber.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let inputBox = createInputContainer(topAnchor: whiteContainerView, anchorConstant: 0, numberInputs: 5, vertSepDistance: 150, inputs: inputsArray, inputTypes: [1, 1, 1, 1, 1])
        
        self.textFields[0].text = "Any"
        self.textFields[1].text = "Any"
        self.textFields[2].text = "Any"
        self.textFields[3].text = "Any"
        self.textFields[4].text = "Any"
        
        view.addSubview(searchButton)
        searchButton.topAnchor.constraint(equalTo: inputBox.bottomAnchor, constant: 10).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: view.frame.width - 100).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(separatorView)
        separatorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 5).isActive = true
        separatorView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        if sender > 1 {
            view.addSubview(myFriendsLabel)
            myFriendsLabel.topAnchor.constraint(equalTo: backButton.topAnchor).isActive = true
            myFriendsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -60).isActive = true
            myFriendsLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
            myFriendsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            view.addSubview(myFriendsCheck)
            myFriendsCheck.topAnchor.constraint(equalTo: myFriendsLabel.topAnchor, constant: 5).isActive = true
            myFriendsCheck.leftAnchor.constraint(equalTo: myFriendsLabel.rightAnchor, constant: 1).isActive = true
        }
        
    }
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Name of player"
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
                    let state = value["state"] as? String ?? "No State"
                    let county = value["county"] as? String ?? "No County"
                    let deviceId = value["deviceId"] as? String ?? "none"
                    let sex = value["sex"] as? String ?? "none"
                    let birthdate = value["birthdate"] as? Double ?? 0
                    let ageGroup = player.getAgeGroup(birthdate: birthdate)
                    player.name = name
                    player.username = username
                    player.id = child.key
                    player.skill_level = skillLevel
                    player.halo_level = haloLevel
                    player.state = state
                    player.county = county
                    player.deviceId = deviceId
                    player.sex = sex
                    player.age_group = ageGroup
                    
                    if player.id != self.teammateId && player.id != self.opp1Id && player.id != self.opp2Id && player.id != Auth.auth().currentUser?.uid {
                        self.players.append(player)
                    }
                    DispatchQueue.main.async {
                        self.searchResults = self.players
                        self.collectionView.reloadData()
                        //self.playersFoundNumber.text = "\(self.searchResults.count)"
                    }
                }
            }
        }
    }
    
    let filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    func setupFilterCollectionView() {
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.register(ProfileMenuCell.self, forCellWithReuseIdentifier: cellId2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func handleDropDownFinish() {
        for index in textFields {
            index.resignFirstResponder()
        }
        self.view.endEditing(true)
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu)))
            window.addSubview(blackView)
            window.addSubview(filterCollectionView)
            filterCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 350)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.filterCollectionView.frame = CGRect(x: 0, y: window.frame.height - 350, width: window.frame.width, height: 350)
            }, completion: nil)
        }
    }
    
    @objc func dismissMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.filterCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 350)
            }
        })
    }
    
    @objc func handledropDown(sender: UIButton) {
        selectedDropDown = sender.tag
        filterCollectionView.reloadData()
        //collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: [], animated: false)
        handleDropDownFinish()
    }
    
    let states = ["Any", "Utah"]
    let counties = ["Any", "Beaver", "Box Elder", "Cache", "Carbon", "Daggett", "Davis", "Duchesne", "Emery", "Garfield", "Grand", "Iron", "Juab", "Kane", "Millard", "Morgan", "Piute", "Rich", "Salt Lake", "San Juan", "Sanpete", "Sevier", "Summit", "Tooele", "Uintah", "Utah", "Wasatch", "Washington", "Wayne", "Weber"]
    let skillLevels = ["Any", "2.0", "2.5", "3.0", "3.5", "4.0", "4.5", "5.0"]
    let sexes = ["Any", "Male", "Female"]
    let ageGroups = ["Any", "0 - 18", "19 - 34", "35 - 49", "50+"]
    
}

extension FindFriends: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text != "" {
            searchResults = players.filter({ (player) -> Bool in
                guard let text = searchBar.text else {return false}
                return player.name!.localizedCaseInsensitiveContains(text)
            })
        } else {
            searchResults = players
        }
        //handleFilter()
        //self.playersFoundNumber.text = "\(self.searchResults.count)"
        collectionView.reloadData()
        
    }
    
    func createInputContainer(topAnchor: UIView, anchorConstant: Int, numberInputs: Int, vertSepDistance: Int, inputs: [String], inputTypes: [Int]) -> UIView {
        
        
        view.addSubview(inputContainer)
        inputContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainer.topAnchor.constraint(equalTo: topAnchor.bottomAnchor, constant: CGFloat(anchorConstant)).isActive = true
        inputContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -12).isActive = true
        inputContainer.heightAnchor.constraint(equalToConstant: CGFloat(numberInputs * 30)).isActive = true
        
        var anchorShift = -30
        
        for (index, element) in inputs.enumerated() {
            anchorShift += 30
            let label: UILabel = {
                let lb = UILabel()
                lb.text = element
                lb.textColor = .white
                lb.translatesAutoresizingMaskIntoConstraints = false
                lb.font = UIFont(name: "HelveticaNeue", size: 15)
                return lb
            }()
            
            let textField: UITextField = {
                let tf = UITextField()
                tf.textColor = .white
                tf.text = "Any"
                tf.translatesAutoresizingMaskIntoConstraints = false
                tf.font = UIFont(name: "HelveticaNeue-Light", size: 15)
                return tf
            }()
            
            textFields.append(textField)
            
            let separatorView: UIView = {
                let view = UIView()
                view.backgroundColor = .white
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            let verticalSeparatorView: UIView = {
                let view = UIView()
                view.backgroundColor = .white
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            inputContainer.addSubview(label)
            label.leftAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: 12).isActive = true
            label.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: CGFloat(anchorShift)).isActive = true
            label.rightAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: CGFloat(vertSepDistance)).isActive = true
            label.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            inputContainer.addSubview(textField)
            textField.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 8).isActive = true
            textField.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
            textField.rightAnchor.constraint(equalTo: inputContainer.rightAnchor, constant: 4).isActive = true
            textField.heightAnchor.constraint(equalTo: label.heightAnchor).isActive = true
            
            if inputTypes[index] == 1 {
                buttonsCreated += 1
                let dropDown: UIButton = {
                    let button = UIButton(type: .system)
                    button.translatesAutoresizingMaskIntoConstraints = false
                    button.tag = buttonsCreated - 1
                    button.addTarget(self, action: #selector(handledropDown), for: .touchUpInside)
                    return button
                }()
                dropDownButtons.append(dropDown)
                
                inputContainer.addSubview(dropDownButtons[buttonsCreated - 1])
                dropDownButtons[buttonsCreated - 1].leftAnchor.constraint(equalTo: label.rightAnchor, constant: 8).isActive = true
                dropDownButtons[buttonsCreated - 1].topAnchor.constraint(equalTo: label.topAnchor).isActive = true
                dropDownButtons[buttonsCreated - 1].rightAnchor.constraint(equalTo: inputContainer.rightAnchor, constant: 4).isActive = true
                dropDownButtons[buttonsCreated - 1].heightAnchor.constraint(equalTo: label.heightAnchor).isActive = true
            }
            
            inputContainer.addSubview(separatorView)
            separatorView.leftAnchor.constraint(equalTo: inputContainer.leftAnchor).isActive = true
            separatorView.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
            separatorView.rightAnchor.constraint(equalTo: inputContainer.rightAnchor).isActive = true
            separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            inputContainer.addSubview(verticalSeparatorView)
            verticalSeparatorView.rightAnchor.constraint(equalTo: label.rightAnchor).isActive = true
            verticalSeparatorView.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
            verticalSeparatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
            verticalSeparatorView.heightAnchor.constraint(equalTo: label.heightAnchor, constant: -8).isActive = true
            
        }
        
        return inputContainer
        
    }
    
}
