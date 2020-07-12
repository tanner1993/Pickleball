//
//  LikeList.swift
//  Pickleball
//
//  Created by Tanner Rozier on 6/15/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

class LikeList: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var likes = [String]()
    var quickLogin = false
    //var loginPage = LoginPage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    let likeTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likes.count
    }
    
    let cellId = "cellId"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if quickLogin {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SimplePlayerCell
            cell.playerUserName.text = likes[indexPath.item]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SimplePlayerCell
            let nameRef = Database.database().reference().child("users").child(likes[indexPath.row]).child("name")
            nameRef.observeSingleEvent(of: .value, with: {(snapshot) in
                guard let value = snapshot.value else {
                    return
                }
                let playerName = value as? String ?? "none"
                cell.playerUserName.text = playerName
            })
            let countyRef = Database.database().reference().child("users").child(likes[indexPath.row]).child("county")
            countyRef.observeSingleEvent(of: .value, with: {(snapshot) in
                guard let value = snapshot.value else {
                    return
                }
                let playerCounty = value as? String ?? "none"
                cell.playerLocation.text = "\(playerCounty), Utah"
            })
            let skillRef = Database.database().reference().child("users").child(likes[indexPath.row]).child("skill_level")
            skillRef.observeSingleEvent(of: .value, with: {(snapshot) in
                guard let value = snapshot.value else {
                    return
                }
                let playerSkill = value as? Float ?? 0
                cell.skillLevel.text = "\(playerSkill)"
            })
            let appRef = Database.database().reference().child("users").child(likes[indexPath.row]).child("exp")
            appRef.observeSingleEvent(of: .value, with: {(snapshot) in
                guard let value = snapshot.value else {
                    return
                }
                let playerExp = value as? Int ?? 0
                let player = Player()
                let playerLevel = player.haloLevel(exp: playerExp)
                cell.appLevel.text = "\(playerLevel)"
            })
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func setupViews() {
        backgroundColor = .white
        likeTableView.dataSource = self
        likeTableView.delegate = self
        likeTableView.register(SimplePlayerCell.self, forCellReuseIdentifier: cellId)
        //likeTableView.separatorStyle = .none
        
        addSubview(likedByLabel)
        likedByLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        likedByLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        likedByLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        likedByLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        addSubview(likeTableView)
        likeTableView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        likeTableView.topAnchor.constraint(equalTo: likedByLabel.bottomAnchor).isActive = true
        likeTableView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        likeTableView.heightAnchor.constraint(equalTo: heightAnchor, constant: -35).isActive = true
    }
    
    let likedByLabel: UILabel = {
        let label = UILabel()
        label.text = "Liked by"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .center
        return label
    }()
}
