//
//  WeekStackView.swift
//  Pickleball
//
//  Created by Tanner Rozier on 7/12/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

class WeekStackView: UICollectionViewCell {
    
    let stackView = UIStackView()
    let week1Button = UIButton()
    let week2Button = UIButton()
    let week3Button = UIButton()
    let week4Button = UIButton()
    let week5Button = UIButton()
    let opponents1 = UILabel()
    let opponents2 = UILabel()
    let opponents3 = UILabel()
    let opponents4 = UILabel()
    let opponents5 = UILabel()
    var labels = [UILabel]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    var tourneyId = String() {
        didSet {
            getPointsAndOpponents()
        }
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
        
        labels = [opponents1, opponents2, opponents3, opponents4, opponents5]
        for index in labels {
            index.textAlignment = .center
            index.font = UIFont(name: "HelveticaNeue-Light", size: 18)
            index.text = ""
            addAutoLayoutSubview(index)
        }
        
        NSLayoutConstraint.activate([
            opponents1.topAnchor.constraint(equalTo: buttons[0].topAnchor, constant: 4),
            opponents2.topAnchor.constraint(equalTo: buttons[1].topAnchor, constant: 4),
            opponents3.topAnchor.constraint(equalTo: buttons[2].topAnchor, constant: 4),
            opponents4.topAnchor.constraint(equalTo: buttons[3].topAnchor, constant: 4),
            opponents5.topAnchor.constraint(equalTo: buttons[4].topAnchor, constant: 4),
            opponents1.centerXAnchor.constraint(equalTo: centerXAnchor),
            opponents2.centerXAnchor.constraint(equalTo: centerXAnchor),
            opponents3.centerXAnchor.constraint(equalTo: centerXAnchor),
            opponents4.centerXAnchor.constraint(equalTo: centerXAnchor),
            opponents5.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func getPointsAndOpponents() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let matchesRef = Database.database().reference().child("tourneys").child(tourneyId).child("matches")
        matchesRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                if let week1Data = value["week1"] as? [String: AnyObject] {
                    for values in week1Data {
                        let team11 = values.value["team_1_player_1"] as? String ?? "none"
                        let team12 = values.value["team_1_player_2"] as? String ?? "none"
                        let team21 = values.value["team_2_player_1"] as? String ?? "none"
                        let team22 = values.value["team_2_player_2"] as? String ?? "none"
                        if uid == team11 || uid == team12 || uid == team21 || uid == team22 {
                            let match = Match2()
                            match.team_1_player_1 = team11
                            match.team_1_player_2 = team12
                            match.team_2_player_1 = team21
                            match.team_2_player_2 = team22
                            match.team_1TotalScore = values.value["team_1TotalScore"] as? Int ?? 0
                            match.team_2TotalScore = values.value["team_2TotalScore"] as? Int ?? 0
                            self.populateText(match: match, week: 1)
                        }
                    }
                }
                if let week2Data = value["week2"] as? [String: AnyObject] {
                    for values in week2Data {
                        let team11 = values.value["team_1_player_1"] as? String ?? "none"
                        let team12 = values.value["team_1_player_2"] as? String ?? "none"
                        let team21 = values.value["team_2_player_1"] as? String ?? "none"
                        let team22 = values.value["team_2_player_2"] as? String ?? "none"
                        if uid == team11 || uid == team12 || uid == team21 || uid == team22 {
                            let match = Match2()
                            match.team_1_player_1 = team11
                            match.team_1_player_2 = team12
                            match.team_2_player_1 = team21
                            match.team_2_player_2 = team22
                            match.team_1TotalScore = values.value["team_1TotalScore"] as? Int ?? 0
                            match.team_2TotalScore = values.value["team_2TotalScore"] as? Int ?? 0
                            self.populateText(match: match, week: 2)
                        }
                    }
                }
                if let week3Data = value["week3"] as? [String: AnyObject] {
                    for values in week3Data {
                        let team11 = values.value["team_1_player_1"] as? String ?? "none"
                        let team12 = values.value["team_1_player_2"] as? String ?? "none"
                        let team21 = values.value["team_2_player_1"] as? String ?? "none"
                        let team22 = values.value["team_2_player_2"] as? String ?? "none"
                        if uid == team11 || uid == team12 || uid == team21 || uid == team22 {
                            let match = Match2()
                            match.team_1_player_1 = team11
                            match.team_1_player_2 = team12
                            match.team_2_player_1 = team21
                            match.team_2_player_2 = team22
                            match.team_1TotalScore = values.value["team_1TotalScore"] as? Int ?? 0
                            match.team_2TotalScore = values.value["team_2TotalScore"] as? Int ?? 0
                            self.populateText(match: match, week: 3)
                        }
                    }
                }
                if let week4Data = value["week4"] as? [String: AnyObject] {
                    for values in week4Data {
                        let team11 = values.value["team_1_player_1"] as? String ?? "none"
                        let team12 = values.value["team_1_player_2"] as? String ?? "none"
                        let team21 = values.value["team_2_player_1"] as? String ?? "none"
                        let team22 = values.value["team_2_player_2"] as? String ?? "none"
                        if uid == team11 || uid == team12 || uid == team21 || uid == team22 {
                            let match = Match2()
                            match.team_1_player_1 = team11
                            match.team_1_player_2 = team12
                            match.team_2_player_1 = team21
                            match.team_2_player_2 = team22
                            match.team_1TotalScore = values.value["team_1TotalScore"] as? Int ?? 0
                            match.team_2TotalScore = values.value["team_2TotalScore"] as? Int ?? 0
                            self.populateText(match: match, week: 4)
                        }
                    }
                }
                if let week5Data = value["week5"] as? [String: AnyObject] {
                    for values in week5Data {
                        let team11 = values.value["team_1_player_1"] as? String ?? "none"
                        let team12 = values.value["team_1_player_2"] as? String ?? "none"
                        let team21 = values.value["team_2_player_1"] as? String ?? "none"
                        let team22 = values.value["team_2_player_2"] as? String ?? "none"
                        if uid == team11 || uid == team12 || uid == team21 || uid == team22 {
                            let match = Match2()
                            match.team_1_player_1 = team11
                            match.team_1_player_2 = team12
                            match.team_2_player_1 = team21
                            match.team_2_player_2 = team22
                            match.team_1TotalScore = values.value["team_1TotalScore"] as? Int ?? 0
                            match.team_2TotalScore = values.value["team_2TotalScore"] as? Int ?? 0
                            self.populateText(match: match, week: 5)
                        }
                    }
                }
            }
        })
    }
    
    func populateText(match: Match2, week: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        var opponent1 = ""
        var opponent2 = ""
        let buttons = [week1Button, week2Button, week3Button, week4Button, week5Button]
        if uid == match.team_1_player_1 || uid == match.team_1_player_2 {
            opponent1 = match.team_2_player_1!
            opponent2 = match.team_2_player_2!
            buttons[week - 1].setTitle("Week \(week)\nPoints scored: \(match.team_1TotalScore!)", for: .normal)
        } else {
            opponent1 = match.team_1_player_1!
            opponent2 = match.team_1_player_2!
            buttons[week - 1].setTitle("Week \(week)\nPoints scored: \(match.team_2TotalScore!)", for: .normal)
        }
        let nameRef = Database.database().reference().child("users").child(opponent1).child("name")
        nameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value {
                let playerName = value as? String ?? "noName"
                if self.labels[week-1].text == "" {
                    self.labels[week-1].text = playerName
                } else {
                    self.labels[week-1].text = playerName + " & " + self.labels[week-1].text!
                }
            }
        })
        let name2Ref = Database.database().reference().child("users").child(opponent2).child("name")
        name2Ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value {
                let playerName = value as? String ?? "noName"
                if self.labels[week-1].text == "" {
                    self.labels[week-1].text = playerName
                } else {
                    self.labels[week-1].text = self.labels[week-1].text! + " & " + playerName
                }
            }
        })
    }
}
