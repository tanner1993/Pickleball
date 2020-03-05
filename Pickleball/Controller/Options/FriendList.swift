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
    var tourneyId = "none"
    var whoSent = 0
    var connect: Connect?
    var createMatch: CreateMatch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchFriends()
        
        self.collectionView!.register(FriendListCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        if whoSent == 0 {
            setupNavbar()
        } else {
            setupForPlayerSelection()
        }
    }
    
    let selectPlayerLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Select Player"
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
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleReturn), for: .touchUpInside)
        return button
    }()
    
    @objc func handleReturn() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupForPlayerSelection() {
        collectionView?.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        
        view.addSubview(selectPlayerLabel)
        selectPlayerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectPlayerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        selectPlayerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        selectPlayerLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Return", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+Friend", style: .plain, target: self, action: #selector(handleSearchFriends))
        
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
        var friendStrings = [String]()
        var almostFriendStrings = [String]()
        for index in friends {
            friendStrings.append(index.id ?? "noId")
        }
        for index in almostFriends {
            almostFriendStrings.append(index.id ?? "noId")
        }
        findFriends.friends = friendStrings
        findFriends.almostFriends = almostFriendStrings
        navigationController?.pushViewController(findFriends, animated: true)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendListCell
        cell.player = friends[indexPath.item]
        cell.messageButton.tag = indexPath.item
        cell.messageButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        if whoSent != 0 {
            cell.messageButton.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if whoSent == 0 {
            if tourneyId == "none" {
                let playerProfile = StartupPage()
                playerProfile.playerId = friends[indexPath.item].id ?? "none"
                playerProfile.isFriend = 2
                navigationController?.pushViewController(playerProfile, animated: true)
            } else {
                sendTourneyInvitation(toId: friends[indexPath.item].id ?? "none")
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
        case 2:
            createMatch?.opponent1.id = friends[whichOne].id ?? "none"
            createMatch?.opponent1.username = friends[whichOne].username ?? "none"
            createMatch?.opponent1.skillLevel = "\(friends[whichOne].skill_level ?? 1.0)"
        case 3:
            createMatch?.opponent2.id = friends[whichOne].id ?? "none"
            createMatch?.opponent2.username = friends[whichOne].username ?? "none"
            createMatch?.opponent2.skillLevel = "\(friends[whichOne].skill_level ?? 1.0)"
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
    
    func sendTourneyInvitation(toId: String) {
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("notifications")
        let notificationRef = ref.childByAutoId()
        let values = ["fromId": uid, "toId": toId, "requiresInput": 1, "tourneyId": tourneyId] as [String : Any]
        notificationRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            
            let notificationsRef = Database.database().reference().child("user_notifications")
            let notificationId = notificationRef.key!
            let childUpdates = ["/\(uid)/\(notificationId)/": 1, "/\(toId)/\(notificationId)/": 1]
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
                
                
            })
            
        })
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
                        self.friends.append(player)
                    }
                    DispatchQueue.main.async { self.collectionView.reloadData() }
                }
            })
        })
    }


}
