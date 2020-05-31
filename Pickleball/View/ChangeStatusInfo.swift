//
//  TourneyInfoView.swift
//  Pickleball
//
//  Created by Tanner Rozier on 5/19/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit

class ChangeStatusInfo: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        addSubview(challengeStatusLabel)
        challengeStatusLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        challengeStatusLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        challengeStatusLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        challengeStatusLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -12).isActive = true
        
        addSubview(lookingToggle)
        lookingToggle.topAnchor.constraint(equalTo: challengeStatusLabel.bottomAnchor, constant: 20).isActive = true
        lookingToggle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(lookingYesOrNo)
        lookingYesOrNo.topAnchor.constraint(equalTo: lookingToggle.bottomAnchor, constant: 2).isActive = true
        lookingYesOrNo.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        lookingYesOrNo.heightAnchor.constraint(equalToConstant: 60).isActive = true
        lookingYesOrNo.widthAnchor.constraint(equalTo: widthAnchor, constant: -12).isActive = true
        
        addSubview(infoText)
        infoText.topAnchor.constraint(equalTo: lookingYesOrNo.bottomAnchor, constant: 20).isActive = true
        infoText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        infoText.heightAnchor.constraint(equalToConstant: 170).isActive = true
        infoText.widthAnchor.constraint(equalTo: widthAnchor, constant: -12).isActive = true
        
        infoText.text = infoTextText
        
        addSubview(changeStatus)
        changeStatus.topAnchor.constraint(equalTo: infoText.bottomAnchor, constant: 5).isActive = true
        changeStatus.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        changeStatus.heightAnchor.constraint(equalToConstant: 45).isActive = true
        changeStatus.widthAnchor.constraint(equalTo: widthAnchor, constant: -12).isActive = true
    }

    let challengeStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Let players in your area know if you are looking for opponents!"
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    let lookingToggle: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.addTarget(self, action: #selector(handleSwitchChanged), for: .valueChanged)
        return uiSwitch
    }()
    
    let lookingYesOrNo: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    let infoText: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.textAlignment = .center
        label.isSelectable = false
        label.isEditable = false
        label.textColor = .white
        label.backgroundColor = nil
        label.backgroundColor = UIColor(displayP3Red: 68/255, green: 128/255, blue: 180/255, alpha: 0.4)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    let changeStatus: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = .white
        button.setTitle("Change Status", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 35)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleSwitchChanged() {
        lookingYesOrNo.text = lookingToggle.isOn ? "I am looking for opponents to play with" : "I am not currently looking for opponents to play with"
        lookingYesOrNo.textColor = lookingToggle.isOn ? .green : UIColor(r: 220, g: 220, b: 220)
    }
    
    let infoTextText = "Switching your profile to 'Looking for opponents' will allow other players in your area to find you easier and challenge you in Match Play. To view other players looking for a challenge in your area, go to Match Play then click on 'Find opponents in your area'"
}
