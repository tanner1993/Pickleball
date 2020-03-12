//
//  EmptyCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 3/11/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit

class EmptyCell: BaseCell {
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    override func setupViews() {
        
        addSubview(emptyLabel)
        emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        emptyLabel.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        emptyLabel.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
    }
}
