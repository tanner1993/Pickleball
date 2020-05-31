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
            let tourneyName = friendInvite?.tourneyName ?? "none"
            if friendInvite?.seen ?? true {
                notifBadge.isHidden = true
            } else {
                notifBadge.isHidden = false
            }
            let recipientNameRef = Database.database().reference().child("users").child(fromId == uid ? toId : fromId)
            recipientNameRef.observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value as? [String: AnyObject] {
                    let name = value["name"] as? String ?? "No Name"
                    let abbName = name.getFirstAndLastInitial
                    print(abbName)
                    if self.friendInvite?.message == "tourney_invite" {
                        self.notificationTitle.text = "Tourney Request"
                        self.confirmFriendButton.isHidden = true
                        self.rejectFriendButton.isHidden = true
                        self.dismissTourneyButton.isHidden = true
                        if uid != fromId {
                            self.confirmTourneyButton.isHidden = false
                            self.rejectTourneyButton.isHidden = false
                            self.revokeTourneyInvitation.isHidden = true
                        } else {
                            self.confirmTourneyButton.isHidden = true
                            self.rejectTourneyButton.isHidden = true
                            self.revokeTourneyInvitation.isHidden = false
                        }
                        self.friendSymbol.image = UIImage(named: "tourney_symbol")
                        self.friendSymbol2.image = UIImage(named: "tourney_symbol")
                        self.friendSymbol.isHidden = false
                        self.friendSymbol2.isHidden = false
                        self.invitationText.text = fromId != uid ? "\(name) wants you to be their teammate in the tournament: \(tourneyName). Click to view tournament or confirm/reject below:" : "You invited \(name) to play with you in the tournament: \(tourneyName). Click to view tournament or revoke the invitation below:"
                    } else if self.friendInvite?.message == "tourney_invite_simple" {
                        self.notificationTitle.text = "Tourney Notification"
                        self.confirmTourneyButton.isHidden = true
                        self.confirmFriendButton.isHidden = true
                        self.rejectTourneyButton.isHidden = true
                        self.rejectFriendButton.isHidden = true
                        self.dismissTourneyButton.isHidden = false
                        self.revokeTourneyInvitation.isHidden = true
                        self.friendSymbol.image = UIImage(named: "tourney_symbol")
                        self.friendSymbol2.image = UIImage(named: "tourney_symbol")
                        self.friendSymbol.isHidden = false
                        self.friendSymbol2.isHidden = false
                        self.invitationText.text = "\(name) wants you to register for their tournament: \(tourneyName). Click to view tournament or dismiss this notification below:"
                    } else {
                        self.notificationTitle.text = "Friend Request"
                        self.confirmTourneyButton.isHidden = true
                        self.confirmFriendButton.isHidden = false
                        self.rejectTourneyButton.isHidden = true
                        self.rejectFriendButton.isHidden = false
                        self.dismissTourneyButton.isHidden = true
                        self.revokeTourneyInvitation.isHidden = true
                        self.friendSymbol.image = UIImage(named: "friend_request")
                        self.friendSymbol2.image = UIImage(named: "friend_request")
                        self.friendSymbol.isHidden = false
                        self.friendSymbol2.isHidden = false
                        self.invitationText.text = "\(name) wants to be your friend. Click to view their profile or confirm/reject below:"
                    }
                    if let seconds = self.friendInvite?.timeStamp {

                        let dateTime = Date(timeIntervalSince1970: seconds)
                        let days = self.dayDifference(from: seconds)

                        let dateFormatter = DateFormatter()
                        if days == "week" {
                            dateFormatter.dateFormat = "MM/dd/yy"
                            self.timeStamp.text = "Created: \(dateFormatter.string(from: dateTime))"
                        } else {
                            dateFormatter.dateFormat = "hh:mm a"
                            if self.friendInvite?.message == "tourney_invite" || self.friendInvite?.message == "tourney_invite_simple" {
                                self.timeStamp.text = fromId == uid ? "Tourney invite sent \(days), \(dateFormatter.string(from: dateTime))" : "Tourney invite sent by \(abbName) \(days), \(dateFormatter.string(from: dateTime))"
                            } else {
                                self.timeStamp.text = "Friend request sent by \(abbName) \(days), \(dateFormatter.string(from: dateTime))"
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
    
//    let playerInitials: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
//        label.textColor = .white
//        label.layer.cornerRadius = 25
//        label.layer.masksToBounds = true
//        label.font = UIFont(name: "HelveticaNeue", size: 25)
//        label.textAlignment = .center
//        return label
//    }()
    
    let notifBadge: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.backgroundColor = .red
        label.text = "1"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let timeStamp: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 170, g: 170, b: 170)
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textAlignment = .right
        return label
    }()
    
    let rejectFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reject", for: .normal)
        button.isHidden = true
        button.setTitleColor(UIColor.init(r: 252, g: 16, b: 13), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let rejectTourneyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reject", for: .normal)
        button.isHidden = true
        button.setTitleColor(UIColor.init(r: 252, g: 16, b: 13), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let confirmFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.setTitle("Accept", for: .normal)
        button.setTitleColor(UIColor.init(r: 32, g: 140, b: 21), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let confirmTourneyButton: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.setTitle("Accept", for: .normal)
        button.setTitleColor(UIColor.init(r: 32, g: 140, b: 21), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let dismissTourneyButton: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(UIColor.init(r: 252, g: 16, b: 13), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let revokeTourneyInvitation: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.setTitle("Revoke Invitation", for: .normal)
        button.setTitleColor(UIColor.init(r: 252, g: 16, b: 13), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let invitationText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
//    let skillLevel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = ""
//        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
//        label.font = UIFont(name: "HelveticaNeue", size: 25)
//        label.textAlignment = .left
//        return label
//    }()
//    
//    let appLevel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "playerName"
//        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
//        label.font = UIFont(name: "HelveticaNeue", size: 25)
//        label.textAlignment = .left
//        return label
//    }()
    
//    let playerName: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "playerName"
//        label.numberOfLines = 2
//        label.font = UIFont(name: "HelveticaNeue", size: 15)
//        label.textAlignment = .left
//        return label
//    }()
    
    let notificationTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let friendSymbol: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.isHidden = true
        bi.isUserInteractionEnabled = true
        return bi
    }()
    
    let friendSymbol2: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.isHidden = true
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
        
        addSubview(notifBadge)
        notifBadge.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        notifBadge.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        notifBadge.heightAnchor.constraint(equalToConstant: 24).isActive = true
        notifBadge.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        addSubview(timeStamp)
        timeStamp.topAnchor.constraint(equalTo: topAnchor, constant: 1).isActive = true
        timeStamp.leftAnchor.constraint(equalTo: rightAnchor, constant: -300).isActive = true
        timeStamp.heightAnchor.constraint(equalToConstant: 25).isActive = true
        timeStamp.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        
        addSubview(friendSymbol)
        friendSymbol.topAnchor.constraint(equalTo: timeStamp.bottomAnchor, constant: 4).isActive = true
        friendSymbol.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        friendSymbol.heightAnchor.constraint(equalToConstant: 70).isActive = true
        friendSymbol.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        addSubview(friendSymbol2)
        friendSymbol2.topAnchor.constraint(equalTo: timeStamp.bottomAnchor, constant: 4).isActive = true
        friendSymbol2.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        friendSymbol2.heightAnchor.constraint(equalToConstant: 70).isActive = true
        friendSymbol2.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        addSubview(notificationTitle)
        notificationTitle.topAnchor.constraint(equalTo: timeStamp.bottomAnchor, constant: 4).isActive = true
        notificationTitle.rightAnchor.constraint(equalTo: friendSymbol2.leftAnchor, constant: -4).isActive = true
        notificationTitle.heightAnchor.constraint(equalToConstant: 35).isActive = true
        notificationTitle.leftAnchor.constraint(equalTo: friendSymbol.rightAnchor, constant: 4).isActive = true
        
//        addSubview(playerName)
//        playerName.topAnchor.constraint(equalTo: timeStamp.bottomAnchor, constant: 4).isActive = true
//        playerName.leftAnchor.constraint(equalTo: friendSymbol.rightAnchor, constant: 4).isActive = true
//        playerName.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        playerName.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
//        addSubview(skillLevel)
//        skillLevel.topAnchor.constraint(equalTo: playerName.bottomAnchor).isActive = true
//        skillLevel.leftAnchor.constraint(equalTo: playerName.leftAnchor).isActive = true
//        skillLevel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        skillLevelWidth = skillLevel.widthAnchor.constraint(equalToConstant: 40)
//        skillLevelWidth?.isActive = true
//
//        addSubview(appLevel)
//        appLevel.topAnchor.constraint(equalTo: playerName.bottomAnchor).isActive = true
//        appLevel.leftAnchor.constraint(equalTo: skillLevel.rightAnchor, constant: 15).isActive = true
//        appLevel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        appLevel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(invitationText)
        invitationText.topAnchor.constraint(equalTo: friendSymbol2.bottomAnchor, constant: 2).isActive = true
        invitationText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        invitationText.heightAnchor.constraint(equalToConstant: 60).isActive = true
        invitationText.widthAnchor.constraint(equalTo: widthAnchor, constant: -24).isActive = true
        
        addSubview(confirmFriendButton)
        confirmFriendButton.topAnchor.constraint(equalTo: invitationText.bottomAnchor, constant: 3).isActive = true
        confirmFriendButton.leftAnchor.constraint(equalTo: centerXAnchor, constant: 2).isActive = true
        confirmFriendButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        confirmFriendButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).isActive = true
        
        addSubview(confirmTourneyButton)
        confirmTourneyButton.topAnchor.constraint(equalTo: invitationText.bottomAnchor, constant: 3).isActive = true
        confirmTourneyButton.leftAnchor.constraint(equalTo: centerXAnchor, constant: 2).isActive = true
        confirmTourneyButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        confirmTourneyButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).isActive = true

        addSubview(rejectFriendButton)
        rejectFriendButton.topAnchor.constraint(equalTo: invitationText.bottomAnchor, constant: 3).isActive = true
        rejectFriendButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
        rejectFriendButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        rejectFriendButton.rightAnchor.constraint(equalTo: centerXAnchor, constant: -2).isActive = true
        
        addSubview(rejectTourneyButton)
        rejectTourneyButton.topAnchor.constraint(equalTo: invitationText.bottomAnchor, constant: 3).isActive = true
        rejectTourneyButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
        rejectTourneyButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        rejectTourneyButton.rightAnchor.constraint(equalTo: centerXAnchor, constant: -2).isActive = true
        
        addSubview(dismissTourneyButton)
        dismissTourneyButton.topAnchor.constraint(equalTo: invitationText.bottomAnchor, constant: 3).isActive = true
        dismissTourneyButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dismissTourneyButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        dismissTourneyButton.widthAnchor.constraint(equalTo: widthAnchor, constant: -24).isActive = true
        
        addSubview(revokeTourneyInvitation)
        revokeTourneyInvitation.topAnchor.constraint(equalTo: invitationText.bottomAnchor, constant: 3).isActive = true
        revokeTourneyInvitation.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        revokeTourneyInvitation.heightAnchor.constraint(equalToConstant: 35).isActive = true
        revokeTourneyInvitation.widthAnchor.constraint(equalTo: widthAnchor, constant: -24).isActive = true
        
        addSubview(separatorView)
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        separatorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

    }
}
