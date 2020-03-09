//
//  MatchNotificationCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 3/4/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

class MatchNotificationCell: UITableViewCell {
    
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
    
    var matchInvite: Message? {
        didSet {
            let chatPartnerId = matchInvite?.chatPartnerId()
            var chatPartnerName = "nothing"
            let recipientNameRef = Database.database().reference().child("users").child(chatPartnerId ?? "No Id")
            recipientNameRef.observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value as? [String: AnyObject] {
                    chatPartnerName = value["username"] as? String ?? "noname"
                    let chatPartnerName2 = value["name"] as? String ?? "noname"
                    let chatPartnerId = snapshot.key
                    if chatPartnerId != self.matchInvite?.chatPartnerId() {
                        
                    } else {
                        if self.matchInvite?.message == "match" {
                            self.invitationText.text = "\(chatPartnerName) invited you to play a match with him!"
                        } else if self.matchInvite?.message == "reject_match" {
                            self.invitationText.text = "\(chatPartnerName) has rejected playing the match with you"
                        }
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
                        self.playerInitials.text = initials
                    }
                }
            })
        }
    }
    
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
    
    let viewButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 56, g: 12, b: 200)
        button.setTitle("View Match", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
    
    func setupViews() {
        addSubview(invitationText)
        invitationText.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        invitationText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        invitationText.heightAnchor.constraint(equalToConstant: 30).isActive = true
        invitationText.widthAnchor.constraint(equalToConstant: frame.width - 10).isActive = true
        
        addSubview(playerInitials)
        playerInitials.topAnchor.constraint(equalTo: invitationText.bottomAnchor, constant: 4).isActive = true
        playerInitials.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        playerInitials.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playerInitials.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(viewButton)
        viewButton.topAnchor.constraint(equalTo: invitationText.bottomAnchor, constant: 4).isActive = true
        viewButton.leftAnchor.constraint(equalTo: playerInitials.rightAnchor, constant: 4).isActive = true
        viewButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        viewButton.widthAnchor.constraint(equalToConstant: (frame.width - 70)).isActive = true
    }
}
