//
//  PieBackgroundPopup.swift
//  Pickleball
//
//  Created by Tanner Rozier on 5/25/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Charts

class PieBackgroundPopup: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    var pieChart2CenterYAnchor: NSLayoutConstraint?
    
    func setupViews() {
        backgroundColor = .white
        addSubview(pieChart2)
        pieChart2.heightAnchor.constraint(equalToConstant: 230).isActive = true
        pieChart2.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pieChart2CenterYAnchor = pieChart2.centerYAnchor.constraint(equalTo: centerYAnchor)
        pieChart2CenterYAnchor?.isActive = true
        pieChart2.widthAnchor.constraint(equalToConstant: 230).isActive = true
        
        addSubview(haloLevel2)
        haloLevel2.heightAnchor.constraint(equalToConstant: 90).isActive = true
        haloLevel2.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        haloLevel2.widthAnchor.constraint(equalToConstant: 150).isActive = true
        haloLevel2.centerYAnchor.constraint(equalTo: pieChart2.centerYAnchor).isActive = true
        
        addSubview(haloLevelTitle)

        haloLevelTitle.topAnchor.constraint(equalTo: haloLevel2.bottomAnchor, constant: 0).isActive = true
        haloLevelTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        haloLevelTitle.heightAnchor.constraint(equalToConstant: 25).isActive = true
        haloLevelTitle.widthAnchor.constraint(equalToConstant: 125).isActive = true
        
        addSubview(haloLevelTitle2)
        haloLevelTitle2.heightAnchor.constraint(equalToConstant: 60).isActive = true
        haloLevelTitle2.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        haloLevelTitle2.widthAnchor.constraint(equalTo: widthAnchor, constant: -12).isActive = true
        haloLevelTitle2.bottomAnchor.constraint(equalTo: pieChart2.topAnchor, constant: 15).isActive = true
        
        addSubview(levelUpLabel)
        levelUpLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        levelUpLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        levelUpLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -12).isActive = true
        levelUpLabel.bottomAnchor.constraint(equalTo: haloLevelTitle2.topAnchor, constant: 0).isActive = true
        
        addSubview(haloLevelTitle3)
        haloLevelTitle3.heightAnchor.constraint(equalToConstant: 80).isActive = true
        haloLevelTitle3.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        haloLevelTitle3.widthAnchor.constraint(equalTo: widthAnchor, constant: -12).isActive = true
        haloLevelTitle3.topAnchor.constraint(equalTo: pieChart2.bottomAnchor, constant: -15).isActive = true
        infoTextLevel.text = "This represents your experience on the app. The more games you win the higher your level will become, but losing will also drop you in experience resulting a drop in level as well. The higher level of a player you beat results in more experience gained, additionally, losing to somebody lower than you will result in a higher experience loss. Every 5 levels you gain you will receive a new title and new players all start out as 'Kitchen Residents' until they get a number of wins under their belt."
        addSubview(infoTextLevel)
        infoTextLevel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        infoTextLevel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoTextLevel.widthAnchor.constraint(equalTo: widthAnchor, constant: -12).isActive = true
        infoTextLevel.topAnchor.constraint(equalTo: pieChart2.bottomAnchor, constant: -15).isActive = true
    }
    
    let haloLevelTitle: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    let haloLevel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 100)
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.textAlignment = .center
        return label
    }()
    
    let levelUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Level Up!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 50)
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.textAlignment = .center
        return label
    }()
    
    let haloLevelTitle2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.text = "You leveled up!"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let haloLevelTitle3: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.textAlignment = .center
        return label
    }()
    
    let pieBackroundHeight2 = 440
    
    let pieChart2: PieChartView = {
        let bi = PieChartView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.isUserInteractionEnabled = false
        return bi
    }()
    
    let infoTextLevel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.textAlignment = .center
        label.isSelectable = false
        label.isEditable = false
        label.textColor = .black
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()

}
