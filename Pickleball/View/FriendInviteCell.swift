//
//  FriendInviteCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 3/1/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

class FriendInviteCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var friendInvite: Message? {
        didSet {
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            let fromId = friendInvite?.fromId ?? "none"
            let toId = friendInvite?.toId ?? "none"
            if friendInvite?.message == "tourney_invite" {
                let tourneyId = friendInvite?.tourneyId ?? "none"
                    let ref = Database.database().reference().child("tourneys").child(tourneyId)
                    ref.observeSingleEvent(of: .value, with: {(snapshot) in
                        if let value = snapshot.value as? NSDictionary {
                            let tourneyName = value["name"] as? String ?? "none"
                            self.skillLevel.text = tourneyName
                            self.skillLevelWidth?.constant = 150
                        }
                    }, withCancel: nil)
            }
            let recipientNameRef = Database.database().reference().child("users").child(fromId == uid ? toId : fromId)
            recipientNameRef.observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value as? [String: AnyObject] {
                    //let name = value["name"] as? String ?? "No Name"
                    let username = value["username"] as? String ?? "No Username"
                    //let state = value["state"] as? String ?? "No State"
                    //let county = value["county"] as? String ?? "No county"
                    let skillsLevel = value["skill_level"] as? Float ?? 0.0
                    let exp = value["exp"] as? Int ?? 0
                    let haloLevel = self.playerObject.haloLevel(exp: exp)
                    if self.friendInvite?.message == "tourney_invite" {
                        self.playerName.font = UIFont(name: "HelveticaNeue", size: 13)
                        self.playerName.text = fromId == uid ? "You invited \(username) to a tourney:" : "\(username) invited you to a tourney:"
                        self.friendSymbol.image = UIImage(named: "tourney_symbol")
                    } else {
                        self.playerName.font = UIFont(name: "HelveticaNeue", size: 15)
                        self.playerName.text = "\(username) wants to be your friend"
                        self.friendSymbol.image = UIImage(named: "friend_request")
                        self.appLevel.text = "\(haloLevel)"
                        self.skillLevel.text = "\(skillsLevel)"
                        self.skillLevelWidth?.constant = 40
                    }
                    if let seconds = self.friendInvite?.timeStamp {
                        
                        let dateTime = Date(timeIntervalSince1970: seconds)
                        let days = self.dayDifference(from: seconds)
                        
                        let dateFormatter = DateFormatter()
                        if days == "week" {
                            dateFormatter.dateFormat = "MM/dd/yy"
                            self.timeStamp.text = dateFormatter.string(from: dateTime)
                        } else {
                            dateFormatter.dateFormat = "hh:mm a"
                            if self.friendInvite?.message == "tourney_invite" {
                                self.timeStamp.text = fromId == uid ? "Tourney invite sent: \(days), \(dateFormatter.string(from: dateTime))" : "Tourney invite sent by \(username): \(days), \(dateFormatter.string(from: dateTime))"
                            } else {
                                self.timeStamp.text = "Friend request sent by \(username): \(days), \(dateFormatter.string(from: dateTime))"
                            }
                        }
                    }
                }
            })
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
    
    let playerObject = Player()
    
    let playerInitials: UILabel = {
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
    
    let timeStamp: UILabel = {
        let label = UILabel()
        label.text = "HH:MM:SS"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 170, g: 170, b: 170)
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textAlignment = .right
        return label
    }()
    
    let rejectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reject", for: .normal)
        button.setTitleColor(UIColor.init(r: 252, g: 16, b: 13), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Accept", for: .normal)
        button.setTitleColor(UIColor.init(r: 32, g: 140, b: 21), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func confirmFriend() {
        
    }
    
    let invitationText: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 24
        label.layer.masksToBounds = true
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    let skillLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        return label
    }()
    
    let appLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "playerName"
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        return label
    }()
    
    let playerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "playerName"
        label.numberOfLines = 2
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textAlignment = .left
        return label
    }()
    
    let friendSymbol: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.isUserInteractionEnabled = true
        return bi
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var skillLevelWidth: NSLayoutConstraint?
    
    func setupViews() {
        
        addSubview(timeStamp)
        timeStamp.topAnchor.constraint(equalTo: topAnchor, constant: 1).isActive = true
        timeStamp.leftAnchor.constraint(equalTo: rightAnchor, constant: -275).isActive = true
        timeStamp.heightAnchor.constraint(equalToConstant: 25).isActive = true
        timeStamp.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        
        addSubview(friendSymbol)
        friendSymbol.topAnchor.constraint(equalTo: timeStamp.bottomAnchor, constant: 4).isActive = true
        friendSymbol.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        friendSymbol.heightAnchor.constraint(equalToConstant: 70).isActive = true
        friendSymbol.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        addSubview(playerName)
        playerName.topAnchor.constraint(equalTo: timeStamp.bottomAnchor, constant: 4).isActive = true
        playerName.leftAnchor.constraint(equalTo: friendSymbol.rightAnchor, constant: 4).isActive = true
        playerName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playerName.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        addSubview(skillLevel)
        skillLevel.topAnchor.constraint(equalTo: playerName.bottomAnchor).isActive = true
        skillLevel.leftAnchor.constraint(equalTo: playerName.leftAnchor).isActive = true
        skillLevel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        skillLevelWidth = skillLevel.widthAnchor.constraint(equalToConstant: 40)
        skillLevelWidth?.isActive = true
        
        addSubview(appLevel)
        appLevel.topAnchor.constraint(equalTo: playerName.bottomAnchor).isActive = true
        appLevel.leftAnchor.constraint(equalTo: skillLevel.rightAnchor, constant: 15).isActive = true
        appLevel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        appLevel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(confirmButton)
        confirmButton.topAnchor.constraint(equalTo: timeStamp.bottomAnchor, constant: 1).isActive = true
        confirmButton.leftAnchor.constraint(equalTo: playerName.rightAnchor, constant: 1).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        confirmButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).isActive = true

        addSubview(rejectButton)
        rejectButton.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: 1).isActive = true
        rejectButton.leftAnchor.constraint(equalTo: playerName.rightAnchor, constant: 1).isActive = true
        rejectButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        rejectButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).isActive = true
        
        addSubview(separatorView)
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        separatorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

    }
}
