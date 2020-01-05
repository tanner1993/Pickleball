//
//  ProfileMenuCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 1/5/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit

class ProfileMenuCell: BaseCell {
    
    let menuItem: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Menu Item"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        
        addSubview(menuItem)
        menuItem.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        menuItem.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        menuItem.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        menuItem.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        
        addSubview(separatorView)
        separatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        separatorView.centerYAnchor.constraint(equalTo: menuItem.bottomAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
