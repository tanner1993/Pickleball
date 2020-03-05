//
//  Connect.swift
//  Pickleball
//
//  Created by Tanner Rozier on 12/31/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

private let reuseIdentifier = "Cell"

class Connect: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var players = [Player]()
    var messages = [Message]()
    var messageChecker = 0
    var currentUser = "nothing"
    
    let messagesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
        label.text = "My Messages"
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(messagesLabel)
        messagesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        messagesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        messagesLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        messagesLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(separatorView)
        separatorView.bottomAnchor.constraint(equalTo: messagesLabel.bottomAnchor).isActive = true
        separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        print("connect didload")
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        currentUser = uid

        self.collectionView!.register(RecentMessagesCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        collectionView.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        titleLabel.text = "Connect"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.navigationItem.titleView = titleLabel
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Friends", style: .plain, target: self, action: #selector(handleNewMessage))
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.collectionView.reloadData()
//        }
        
        fetchFirstMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkUser()
        print("connect willappear")
        print(currentUser)
    }
    
    func checkUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        if currentUser != uid {
            messages.removeAll()
            collectionView.collectionViewLayout.invalidateLayout()
            messageChecker = 0
            fetchFirstMessages()
            currentUser = uid
        }
    }
    
    @objc func handleNewMessage(){
        let layout = UICollectionViewFlowLayout()
        let friendList = FriendList(collectionViewLayout: layout)
        friendList.connect = self
        let friendNavController = UINavigationController(rootViewController: friendList)
        //friendList.hidesBottomBarWhenPushed = true
        friendNavController.navigationBar.barTintColor = UIColor.init(r: 88, g: 148, b: 200)
        friendNavController.navigationBar.tintColor = .white
        friendNavController.navigationBar.isTranslucent = false
        navigationController?.present(friendNavController, animated: true, completion: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecentMessagesCell
        cell.message = messages[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let recipientId = messages[indexPath.item].chatPartnerId() else {
            return
        }
        presentChatLogs(recipientId: recipientId)
    }
    
    func presentChatLogs(recipientId: String) {
        let layout = UICollectionViewFlowLayout()
        let chatLogs = ChatLogs(collectionViewLayout: layout)
        chatLogs.hidesBottomBarWhenPushed = true
        chatLogs.recipientId = recipientId
        navigationController?.pushViewController(chatLogs, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func fetchFirstMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user_messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let recipientId = snapshot.key
            let ref2 = Database.database().reference().child("user_messages").child(uid).child(recipientId).queryLimited(toLast: 1)
            ref2.observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                let messageSeen = snapshot.value! as! Int
                if messageSeen == 1 {
                    Database.database().reference().child("user_messages").child(uid).child(recipientId).child(messageId).setValue(0, andPriority: .none)
                }
                let messagesReference = Database.database().reference().child("messages").child(messageId)
                messagesReference.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? NSDictionary {
                        let message = Message()
                        let messageText = value["message"] as? String ?? "No text"
                        let timeStamp = value["timestamp"] as? Double ?? Double(Date().timeIntervalSince1970)
                        let toId = value["toId"] as? String ?? "No toId"
                        let fromId = value["fromId"] as? String ?? "No fromId"
                        message.message = messageText
                        message.timeStamp = timeStamp
                        message.toId = toId
                        message.fromId = fromId
                        message.id = messageId
                        for (index, element) in self.messages.enumerated() {
                            if (element.toId == message.toId && element.fromId == message.fromId) || (element.toId == message.fromId && element.fromId == message.toId) {
                                self.messages[index] = message
                                self.messageChecker = 1
                                break
                            }                        }
                        if self.messageChecker == 0 {
                            DispatchQueue.main.async { self.messages.append(message)
                                self.messages = self.messages.sorted { p1, p2 in
                                    return (p1.timeStamp!) > (p2.timeStamp!)
                                }
                            }
                        }
                        self.messageChecker = 0
                        DispatchQueue.main.async { self.collectionView.reloadData()}
                    }
                }, withCancel: nil)
            }, withCancel: nil)
        }, withCancel: nil)
        if let tabItems = self.tabBarController?.tabBar.items {
            let tabItem = tabItems[2]
            tabItem.badgeValue = .none
        }
    }

}

class RecentMessagesCell: BaseCell {
    
    var message: Message? {
        didSet {
            recentMessage.text = message?.message
            let chatPartnerId = message?.chatPartnerId()
            var chatPartnerName = "nothing"
            let recipientNameRef = Database.database().reference().child("users").child(chatPartnerId ?? "No Id")
            recipientNameRef.observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value as? [String: AnyObject] {
                    chatPartnerName = value["username"] as? String ?? "noname"
                    let chatPartnerName2 = value["name"] as? String ?? "noname"
                    let chatPartnerId = snapshot.key
                    if chatPartnerId != self.message?.chatPartnerId() {
                        
                    } else {
                        self.playerName.text = chatPartnerName
                        var initials = ""
                        var finalChar = 0
                        for (index, char) in chatPartnerName2.enumerated() {
                            if index == 0 {
                                initials.append(char)
                            }
                            if finalChar == 1 {
                                initials.append(char)
                                break
                            }
                            
                            if char == " " {
                                finalChar = 1
                            }
                        }
                        self.playerHaloLevel.text = initials
                    }
                }
            })
            
            if let seconds = message?.timeStamp {
//                let now = Date().timeIntervalSince1970
//                if now -
                
                let dateTime = Date(timeIntervalSince1970: seconds)
                let days = dayDifference(from: seconds)
                
                let dateFormatter = DateFormatter()
                if days == "week" {
                    dateFormatter.dateFormat = "MM/dd/yy"
                    timeStamp.text = dateFormatter.string(from: dateTime)
                } else {
                    dateFormatter.dateFormat = "hh:mm a"
                    timeStamp.text = "\(days), \(dateFormatter.string(from: dateTime))"
                }
            }
            
            
        }
    }
    
    func dayDifference(from interval : TimeInterval) -> String
    {
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: interval)
        let startOfNow = calendar.startOfDay(for: Date())
        let startOfTimeStamp = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
        let day = components.day!
        if abs(day) < 2 {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            formatter.doesRelativeDateFormatting = true
            return formatter.string(from: date)
        } else if abs(day) > 7 {
            return "week"
        } else {
            return "\(-day) days ago"
        }
    }
    
    let playerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.textColor = UIColor.init(r: 220, g: 220, b: 220)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textAlignment = .left
        return label
    }()
    
    let playerHaloLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        label.textColor = .white
        label.layer.cornerRadius = 25
        label.layer.masksToBounds = true
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let recentMessage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 170, g: 170, b: 170)
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textAlignment = .left
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let timeStamp: UILabel = {
        let label = UILabel()
        label.text = "HH:MM:SS"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 170, g: 170, b: 170)
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textAlignment = .right
        return label
    }()
    
    override func setupViews() {
        addSubview(playerHaloLevel)
        playerHaloLevel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        playerHaloLevel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        playerHaloLevel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playerHaloLevel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(playerName)
        playerName.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        playerName.leftAnchor.constraint(equalTo: playerHaloLevel.rightAnchor, constant: 6).isActive = true
        playerName.heightAnchor.constraint(equalToConstant: 25).isActive = true
        playerName.rightAnchor.constraint(equalTo: rightAnchor, constant: -150).isActive = true
        
        addSubview(timeStamp)
        timeStamp.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        timeStamp.leftAnchor.constraint(equalTo: playerName.rightAnchor, constant: 0).isActive = true
        timeStamp.heightAnchor.constraint(equalToConstant: 25).isActive = true
        timeStamp.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        
        addSubview(recentMessage)
        recentMessage.topAnchor.constraint(equalTo: playerName.bottomAnchor).isActive = true
        recentMessage.leftAnchor.constraint(equalTo: playerHaloLevel.rightAnchor, constant: 6).isActive = true
        recentMessage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        recentMessage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        addSubview(separatorView)
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}
