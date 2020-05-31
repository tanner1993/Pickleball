//
//  SelectCourtInfo.swift
//  Pickleball
//
//  Created by Tanner Rozier on 5/22/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit

class SelectCourtInfo: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        courtNameTextField.resignFirstResponder()
    }
    
    func setupViews() {
        backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        addSubview(courtSelectionLabel)
        courtSelectionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        courtSelectionLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        courtSelectionLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        courtSelectionLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -12).isActive = true
        
        addSubview(whiteBox)
        whiteBox.topAnchor.constraint(equalTo: courtSelectionLabel.bottomAnchor, constant: 10).isActive = true
        whiteBox.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        whiteBox.heightAnchor.constraint(equalToConstant: 60).isActive = true
        whiteBox.widthAnchor.constraint(equalTo: widthAnchor, constant: -12).isActive = true
        
        whiteBox.addSubview(courtNameTextField)
        courtNameTextField.topAnchor.constraint(equalTo: whiteBox.topAnchor).isActive = true
        courtNameTextField.centerXAnchor.constraint(equalTo: whiteBox.centerXAnchor).isActive = true
        courtNameTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        courtNameTextField.widthAnchor.constraint(equalTo: whiteBox.widthAnchor, constant: -12).isActive = true
        
//        addSubview(infoText)
//        infoText.topAnchor.constraint(equalTo: lookingYesOrNo.bottomAnchor, constant: 20).isActive = true
//        infoText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        infoText.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        infoText.widthAnchor.constraint(equalTo: widthAnchor, constant: -12).isActive = true
//
//        infoText.text = infoTextText
        
        addSubview(updateCourt)
        updateCourt.topAnchor.constraint(equalTo: courtNameTextField.bottomAnchor, constant: 15).isActive = true
        updateCourt.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        updateCourt.heightAnchor.constraint(equalToConstant: 60).isActive = true
        updateCourt.widthAnchor.constraint(equalTo: widthAnchor, constant: -12).isActive = true
        
        addSubview(dontShowCourt)
        dontShowCourt.topAnchor.constraint(equalTo: updateCourt.bottomAnchor, constant: 20).isActive = true
        dontShowCourt.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dontShowCourt.heightAnchor.constraint(equalToConstant: 60).isActive = true
        dontShowCourt.widthAnchor.constraint(equalTo: widthAnchor, constant: -12).isActive = true
    }

    let courtSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter in the court you most frequently play at to let other players know if they're near you!"
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    let whiteBox: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let courtNameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        tf.placeholder = "Enter Court Name Here"
        return tf
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
    
    let updateCourt: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Update Court", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 35)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    let dontShowCourt: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't Show Any Court", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 35)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    
    let infoTextText = "Switching your profile to 'Looking for opponents' will allow other players in your area to find you easier and challenge you in Match Play. To view other players looking for a challenge in your area, go to Match Play then..."
    

}
