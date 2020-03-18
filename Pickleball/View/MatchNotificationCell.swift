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
        //backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var matchInvite: Message? {
        didSet {
            let fromId = matchInvite?.fromId ?? "none"
            let recipientNameRef = Database.database().reference().child("users").child(fromId)
            recipientNameRef.observeSingleEvent(of: .value, with: {(snapshot) in
                if let value = snapshot.value as? [String: AnyObject] {
                    let fromName = value["username"] as? String ?? "noname"
                    self.matchTitleText.text = "Match: \(self.matchInvite?.toId ?? "none")"
                    if let seconds = self.matchInvite?.timeStamp {
                        
                        let dateTime = Date(timeIntervalSince1970: seconds)
                        let days = self.dayDifference(from: seconds)
                        
                        let dateFormatter = DateFormatter()
                        if days == "week" {
                            dateFormatter.dateFormat = "MM/dd/yy"
                            self.timeStamp.text = dateFormatter.string(from: dateTime)
                        } else {
                            dateFormatter.dateFormat = "hh:mm a"
                            self.timeStamp.text = "Created by \(fromName): \(days), \(dateFormatter.string(from: dateTime))"
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
    
    let matchSymbol: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.image = UIImage(named: "match_symbol")
        bi.isUserInteractionEnabled = true
        return bi
    }()
    
    let matchSymbol2: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.image = UIImage(named: "match_symbol")
        bi.isUserInteractionEnabled = true
        return bi
    }()
    
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
    
    let matchTitleText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
        label.textAlignment = .center
        return label
    }()
    
    let matchInfoText: UILabel = {
        let label = UILabel()
        label.text = "Doubles, Best 3/5"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .center
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
    
    
    func setupViews() {
        
        addSubview(timeStamp)
        timeStamp.topAnchor.constraint(equalTo: topAnchor, constant: 1).isActive = true
        timeStamp.leftAnchor.constraint(equalTo: rightAnchor, constant: -250).isActive = true
        timeStamp.heightAnchor.constraint(equalToConstant: 25).isActive = true
        timeStamp.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        
        addSubview(matchSymbol)
        matchSymbol.topAnchor.constraint(equalTo: timeStamp.bottomAnchor, constant: 1).isActive = true
        matchSymbol.leftAnchor.constraint(equalTo: leftAnchor, constant: 3).isActive = true
        matchSymbol.heightAnchor.constraint(equalToConstant: 60).isActive = true
        matchSymbol.widthAnchor.constraint(equalToConstant: 85).isActive = true
        
        addSubview(matchSymbol2)
        matchSymbol2.topAnchor.constraint(equalTo: timeStamp.bottomAnchor, constant: 1).isActive = true
        matchSymbol2.rightAnchor.constraint(equalTo: rightAnchor, constant: -3).isActive = true
        matchSymbol2.heightAnchor.constraint(equalToConstant: 60).isActive = true
        matchSymbol2.widthAnchor.constraint(equalToConstant: 85).isActive = true
        
        addSubview(matchTitleText)
        matchTitleText.topAnchor.constraint(equalTo: timeStamp.bottomAnchor, constant: 1).isActive = true
        matchTitleText.leftAnchor.constraint(equalTo: matchSymbol.rightAnchor, constant: 2).isActive = true
        matchTitleText.heightAnchor.constraint(equalToConstant: 40).isActive = true
        matchTitleText.rightAnchor.constraint(equalTo: matchSymbol2.leftAnchor, constant: -2).isActive = true
        
//        addSubview(playerInitials)
//        playerInitials.topAnchor.constraint(equalTo: invitationText.bottomAnchor, constant: 4).isActive = true
//        playerInitials.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
//        playerInitials.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        playerInitials.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(matchInfoText)
        matchInfoText.topAnchor.constraint(equalTo: matchTitleText.bottomAnchor, constant: 0).isActive = true
        matchInfoText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        matchInfoText.heightAnchor.constraint(equalToConstant: 30).isActive = true
        matchInfoText.widthAnchor.constraint(equalToConstant: frame.width - 10).isActive = true
        
        addSubview(separatorView)
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        separatorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
