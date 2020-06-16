//
//  SimplePlayerCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 6/16/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit

class SimplePlayerCell: UITableViewCell {

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
    
    func setupViews() {
        addSubview(playerUserName)
        playerUserName.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        playerUserName.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        playerUserName.heightAnchor.constraint(equalToConstant: frame.height / 2).isActive = true
        playerUserName.rightAnchor.constraint(equalTo: centerXAnchor, constant: 4).isActive = true
    
        addSubview(playerLocation)
        playerLocation.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        playerLocation.leftAnchor.constraint(equalTo: playerUserName.rightAnchor, constant: 4).isActive = true
        playerLocation.heightAnchor.constraint(equalToConstant: frame.height / 2).isActive = true
        playerLocation.rightAnchor.constraint(equalTo: rightAnchor, constant: -4).isActive = true
        
        addSubview(skillLevel)
        skillLevel.topAnchor.constraint(equalTo: playerUserName.bottomAnchor).isActive = true
        skillLevel.leftAnchor.constraint(equalTo: playerUserName.leftAnchor).isActive = true
        skillLevel.heightAnchor.constraint(equalToConstant: frame.height / 2).isActive = true
        skillLevel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(appLevel)
        appLevel.topAnchor.constraint(equalTo: playerUserName.bottomAnchor).isActive = true
        appLevel.leftAnchor.constraint(equalTo: skillLevel.rightAnchor, constant: 15).isActive = true
        appLevel.heightAnchor.constraint(equalToConstant: frame.height / 2).isActive = true
        appLevel.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    let playerUserName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "playerName"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "HelveticaNeue", size: 19)
        label.textAlignment = .left
        return label
    }()
    
    let playerLocation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 19)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()
    
    let skillLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        return label
    }()
    
    let appLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        return label
    }()
}
