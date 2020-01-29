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
    var tourneyId = "none"
    
    var connect: Connect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchFriends()
        
        self.collectionView!.register(PlayerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
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
        findFriends.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(findFriends, animated: true)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PlayerCell
        cell.player = friends[indexPath.item]
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if tourneyId == "none" {
            dismiss(animated: true, completion: nil)
            guard let recipientId = friends[indexPath.item].id else {
                return
            }
            connect?.presentChatLogs(recipientId: recipientId)
        } else {
            sendTourneyInvitation(toId: friends[indexPath.item].id ?? "none")
        }
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
                    self.friends.append(player)
                    DispatchQueue.main.async { self.collectionView.reloadData() }
                }
            })
        })
    }


}
