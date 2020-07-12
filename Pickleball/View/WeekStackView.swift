//
//  WeekStackView.swift
//  Pickleball
//
//  Created by Tanner Rozier on 7/12/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit

class WeekStackView: UICollectionViewCell {
    
    let stackView = UIStackView()
    let week1Button = UIButton()
    let week2Button = UIButton()
    let week3Button = UIButton()
    let week4Button = UIButton()
    let week5Button = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = .white
        addAutoLayoutSubview(stackView)
        stackView.fillSuperview()
        let buttons = [week1Button, week2Button, week3Button, week4Button, week5Button]
        for index in 0...(buttons.count - 1) {
            buttons[index].setTitle("Week \(index + 1)\nPoints scored: 0", for: .normal)
            buttons[index].titleLabel?.textAlignment = .center
            buttons[index].titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
            buttons[index].titleLabel?.numberOfLines = 2
            buttons[index].setTitleColor(.black, for: .normal)
        }
        stackView.addArrangedSubviews(buttons)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
    }
}
