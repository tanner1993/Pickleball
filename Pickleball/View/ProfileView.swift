//
//  ProfileView.swift
//  Pickleball
//
//  Created by Tanner Rozier on 5/20/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FBSDKCoreKit
import FBSDKShareKit

class ProfileView: UIView {
    
//    var nameTracker = [String: String]()
//    var levelTracker = [String: String]()
//    let player = Player()
//
//    var recentMatches = [Match2]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
//    let recentMatchesTableView: UITableView = {
//        let cv = UITableView()
//        cv.backgroundColor = .white
//        return cv
//    }()
//
//    let cellId2 = "cellId2"
//
//    func setupRecentMatchesTableView() {
//        recentMatchesTableView.dataSource = self
//        recentMatchesTableView.delegate = self
//        recentMatchesTableView.register(FeedMatchCell.self, forCellReuseIdentifier: cellId2)
//    }
    
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
    }
    
    func setupViews() {
        scrollView.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        let Width = Float(frame.width)
        let ratio: Float = 375.0 / 550.0
        scrollView.contentSize = CGSize(width: Double(Width), height: Double(Width / ratio))
        addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    
        
        setupPieChart()
        
        scrollView.addSubview(skillLevelLabel)
        let skillLevelLabelLoc = calculateButtonPosition(x: 540, y: 485, w: 400, h: 55, wib: 750, hib: 1100, wia: Float(frame.width), hia: Width / ratio)
        
        skillLevelLabel.centerYAnchor.constraint(equalTo: scrollView.topAnchor, constant: CGFloat(skillLevelLabelLoc.Y)).isActive = true
        skillLevelLabel.centerXAnchor.constraint(equalTo: scrollView.leftAnchor, constant: CGFloat(skillLevelLabelLoc.X)).isActive = true
        skillLevelLabel.heightAnchor.constraint(equalToConstant: CGFloat(skillLevelLabelLoc.H)).isActive = true
        skillLevelLabel.widthAnchor.constraint(equalToConstant: CGFloat(skillLevelLabelLoc.W)).isActive = true
        
        scrollView.addSubview(whiteBoxUpper)
        whiteBoxUpper.topAnchor.constraint(equalTo: topAnchor).isActive = true
        whiteBoxUpper.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        whiteBoxUpper.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        whiteBoxUpper.bottomAnchor.constraint(equalTo: skillLevelLabel.bottomAnchor).isActive = true
        
            
        scrollView.addSubview(haloLevel)
        let haloLevelLoc = calculateButtonPosition(x: 375, y: 236.5, w: 250, h: 175, wib: 750, hib: 1100, wia: Float(frame.width), hia: Width / ratio)
        
        haloLevel.centerYAnchor.constraint(equalTo: scrollView.topAnchor, constant: CGFloat(haloLevelLoc.Y)).isActive = true
        haloLevel.centerXAnchor.constraint(equalTo: scrollView.leftAnchor, constant: CGFloat(haloLevelLoc.X)).isActive = true
        haloLevel.heightAnchor.constraint(equalToConstant: CGFloat(haloLevelLoc.H)).isActive = true
        haloLevel.widthAnchor.constraint(equalToConstant: CGFloat(haloLevelLoc.W)).isActive = true
        
        scrollView.addSubview(haloLevelTitle)
        //let haloLevelTitleLoc = calculateButtonPosition(x: 550, y: 255, w: 200, h: 50, wib: 750, hib: 1100, wia: 375, hia: 550)

        haloLevelTitle.topAnchor.constraint(equalTo: haloLevel.bottomAnchor, constant: -2).isActive = true
        haloLevelTitle.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        haloLevelTitle.heightAnchor.constraint(equalToConstant: 25).isActive = true
        haloLevelTitle.widthAnchor.constraint(equalToConstant: 125).isActive = true
        
        scrollView.addSubview(playerName)
        let playerNameLoc = calculateButtonPosition(x: 375, y: 40, w: 705, h: 60, wib: 750, hib: 1100, wia: Float(frame.width), hia: Width / ratio)
        
        playerName.centerYAnchor.constraint(equalTo: scrollView.topAnchor, constant: CGFloat(playerNameLoc.Y)).isActive = true
        playerName.centerXAnchor.constraint(equalTo: scrollView.leftAnchor, constant: CGFloat(playerNameLoc.X)).isActive = true
        playerName.heightAnchor.constraint(equalToConstant: CGFloat(playerNameLoc.H)).isActive = true
        playerName.widthAnchor.constraint(equalToConstant: CGFloat(playerNameLoc.W)).isActive = true
        
        scrollView.addSubview(location)
        let locationLoc = calculateButtonPosition(x: 216.75, y: 485, w: 383.5, h: 50, wib: 750, hib: 1100, wia: Float(frame.width), hia: Width / ratio)
        
        location.centerYAnchor.constraint(equalTo: scrollView.topAnchor, constant: CGFloat(locationLoc.Y)).isActive = true
        location.centerXAnchor.constraint(equalTo: scrollView.leftAnchor, constant: CGFloat(locationLoc.X)).isActive = true
        location.heightAnchor.constraint(equalToConstant: CGFloat(locationLoc.H)).isActive = true
        location.widthAnchor.constraint(equalToConstant: CGFloat(locationLoc.W)).isActive = true
        
        scrollView.addSubview(ageGroup)
        let ageGroupLoc = calculateButtonPosition(x: 216.75, y: 440, w: 383.5, h: 50, wib: 750, hib: 1100, wia: Float(frame.width), hia: Width / ratio)
        
        ageGroup.centerYAnchor.constraint(equalTo: scrollView.topAnchor, constant: CGFloat(ageGroupLoc.Y)).isActive = true
        ageGroup.centerXAnchor.constraint(equalTo: scrollView.leftAnchor, constant: CGFloat(ageGroupLoc.X)).isActive = true
        ageGroup.heightAnchor.constraint(equalToConstant: CGFloat(ageGroupLoc.H)).isActive = true
        ageGroup.widthAnchor.constraint(equalToConstant: CGFloat(ageGroupLoc.W)).isActive = true
        
//        scrollView.addSubview(matchesWon)
//
//        matchesWon.topAnchor.constraint(equalTo: whiteBoxUpper.bottomAnchor, constant: 8).isActive = true
//        matchesWon.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
//        matchesWon.heightAnchor.constraint(equalToConstant: 45).isActive = true
//        matchesWon.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        scrollView.addSubview(matchesPlayed)
        
        matchesPlayed.topAnchor.constraint(equalTo: whiteBoxUpper.bottomAnchor, constant: 8).isActive = true
        matchesPlayed.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        matchesPlayed.heightAnchor.constraint(equalToConstant: 45).isActive = true
        matchesPlayed.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        scrollView.addSubview(winRatio)
        
        winRatio.topAnchor.constraint(equalTo: matchesPlayed.bottomAnchor, constant: 8).isActive = true
        winRatio.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        winRatio.heightAnchor.constraint(equalToConstant: 45).isActive = true
        winRatio.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
//        scrollView.addSubview(matchesWonLabel)
//
//        matchesWonLabel.topAnchor.constraint(equalTo: whiteBoxUpper.bottomAnchor, constant: 8).isActive = true
//        matchesWonLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
//        matchesWonLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
//        matchesWonLabel.rightAnchor.constraint(equalTo: matchesWon.leftAnchor).isActive = true
        
        scrollView.addSubview(matchesPlayedLabel)
        
        matchesPlayedLabel.topAnchor.constraint(equalTo: whiteBoxUpper.bottomAnchor, constant: 8).isActive = true
        matchesPlayedLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        matchesPlayedLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        matchesPlayedLabel.rightAnchor.constraint(equalTo: matchesPlayed.leftAnchor).isActive = true
        
        scrollView.addSubview(winRatioLabel)
        
        winRatioLabel.topAnchor.constraint(equalTo: matchesPlayed.bottomAnchor, constant: 8).isActive = true
        winRatioLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        winRatioLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        winRatioLabel.rightAnchor.constraint(equalTo: matchesPlayed.leftAnchor).isActive = true
        
        scrollView.addSubview(courtLabel)
        
        courtLabel.topAnchor.constraint(equalTo: winRatioLabel.bottomAnchor, constant: 8).isActive = true
        courtLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        courtLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        courtLabel.widthAnchor.constraint(equalToConstant: 104).isActive = true
        
        scrollView.addSubview(selectCourtButton)
        
        selectCourtButton.topAnchor.constraint(equalTo: winRatioLabel.bottomAnchor, constant: 8).isActive = true
        selectCourtButton.leftAnchor.constraint(equalTo: courtLabel.rightAnchor, constant: 8).isActive = true
        selectCourtButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        selectCourtButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        scrollView.addSubview(courtText)
        
        courtText.topAnchor.constraint(equalTo: winRatioLabel.bottomAnchor, constant: 8).isActive = true
        courtText.leftAnchor.constraint(equalTo: courtLabel.rightAnchor, constant: 8).isActive = true
        courtText.heightAnchor.constraint(equalToConstant: 45).isActive = true
        courtText.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        scrollView.addSubview(challengeStatusLabel)
        let text = "Challenge Status"
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, text.count))
        challengeStatusLabel.attributedText = attributedText
        challengeStatusLabel.topAnchor.constraint(equalTo: courtLabel.bottomAnchor, constant: 4).isActive = true
        challengeStatusLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        challengeStatusLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        challengeStatusLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        scrollView.addSubview(challengeStatusButton)
        
        challengeStatusButton.topAnchor.constraint(equalTo: challengeStatusLabel.bottomAnchor, constant: 4).isActive = true
        challengeStatusButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        challengeStatusButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        challengeStatusButton.widthAnchor.constraint(equalTo: widthAnchor, constant: -40).isActive = true
        
        scrollView.addSubview(challengePrompter)
        
        challengePrompter.bottomAnchor.constraint(equalTo: challengeStatusButton.bottomAnchor, constant: -1).isActive = true
        challengePrompter.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        challengePrompter.heightAnchor.constraint(equalToConstant: 20).isActive = true
        challengePrompter.widthAnchor.constraint(equalTo: widthAnchor, constant: -40).isActive = true
        
//        scrollView.addSubview(recentMatchesTableView)
//        recentMatchesTableView.topAnchor.constraint(equalTo: challengeStatusButton.bottomAnchor, constant: 4).isActive = true
//        recentMatchesTableView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        recentMatchesTableView.heightAnchor.constraint(equalToConstant: 250).isActive = true
//        recentMatchesTableView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        scrollView.sendSubviewToBack(whiteBoxUpper)
            
        scrollView.addSubview(whiteBox)
        whiteBox.topAnchor.constraint(equalTo: topAnchor).isActive = true
        whiteBox.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        whiteBox.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        whiteBox.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        whiteBox.addSubview(activityView)
        activityView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        activityView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        activityView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        activityView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
            
        }
    
    func setupPieChart() {
        let currentExp = PieChartDataEntry(value: 3, label: nil)
        let goalExp = PieChartDataEntry(value: 150, label: nil)
        let chartDataSet = PieChartDataSet(entries: [currentExp, goalExp], label: nil)
        chartDataSet.drawValuesEnabled = false
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [UIColor.init(r: 120, g: 207, b: 138), UIColor.white]
        chartDataSet.colors = colors
        pieChart.data = chartData
        pieChart.legend.enabled = false
        pieChart.holeRadiusPercent = 0.93
        pieChart.transparentCircleColor = UIColor.init(r: 120, g: 207, b: 138)
        pieChart.transparentCircleRadiusPercent = 0.94
        pieChart.isUserInteractionEnabled = false
        scrollView.addSubview(pieChart)
        pieChart.heightAnchor.constraint(equalToConstant: 230).isActive = true
        pieChart.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pieChart.widthAnchor.constraint(equalToConstant: 230).isActive = true
        pieChart.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 269 / 2).isActive = true
        scrollView.bringSubviewToFront(haloLevel)
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isScrollEnabled = true
        sv.backgroundColor = .white
        sv.minimumZoomScale = 1.0
        //sv.maximumZoomScale = 2.5
        return sv
    }()
    
    let activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let whiteBox: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let whiteBoxUpper: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let pieChart: PieChartView = {
        let bi = PieChartView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        return bi
    }()
    
    let skillLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 75)
        label.textAlignment = .center
        return label
    }()
    
    let tourneyNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.backgroundColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        return tf
    }()
    
    let skillLevelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "USAPA Self Rating: "
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let haloLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 100)
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let haloLevelTitle: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    let playerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .left
        return label
    }()
    
    let location: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .left
        return label
    }()
    
    let ageGroup: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .left
        return label
    }()
    
//    let matchesWon: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .white
//        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
//        label.textAlignment = .right
//        return label
//    }()
    
    let matchesPlayed: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        label.textAlignment = .right
        return label
    }()
    
    let winRatio: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        label.textAlignment = .right
        return label
    }()
    
//    let matchesWonLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Matches Won"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .white
//        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
//        label.textAlignment = .left
//        return label
//    }()
    
    let matchesPlayedLabel: UILabel = {
        let label = UILabel()
        label.text = "Matches Played"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        label.textAlignment = .left
        return label
    }()
    
    let winRatioLabel: UILabel = {
        let label = UILabel()
        label.text = "Match Win Ratio"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        label.textAlignment = .left
        return label
    }()
    
    let challengeStatusLabel: UILabel = {
        let label = UILabel()
        //label.text = "Challenge Status"
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        label.textAlignment = .center
        //label.layer.cornerRadius = 7
        //label.layer.masksToBounds = true
        return label
    }()
    
    let challengeStatusButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25)
        button.titleLabel?.numberOfLines = 2
        button.setTitleColor(UIColor(r: 150, g: 150, b: 150), for: .normal)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        return button
    }()
    
    let challengePrompter: UILabel = {
            let label = UILabel()
        label.isHidden = true
            label.text = "Click here to challenge"
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black
            label.font = UIFont(name: "HelveticaNeue-Light", size: 15)
            label.textAlignment = .center
            return label
        }()
    
    let courtLabel: UILabel = {
        let label = UILabel()
        label.text = "Court:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        label.textAlignment = .left
        return label
    }()
    
    let selectCourtButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.isHidden = true
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(UIColor(r: 150, g: 150, b: 150), for: .normal)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        return button
    }()
    
    let courtText: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(r: 150, g: 150, b: 150)
        label.layer.masksToBounds = true
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.backgroundColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return frame.width / 1.875 + 26
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        recentMatches.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let match = recentMatches[indexPath.item]
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! FeedMatchCell
//        cell.headerLabel.isHidden = true
//        if nameTracker[match.team_1_player_1 ?? "nope"] == nil {
//            let player1ref = Database.database().reference().child("users").child(match.team_1_player_1 ?? "nope")
//            player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
//                if let value = snapshot.value as? [String: AnyObject] {
//                    //cell.challengerTeam1.setTitle(self.getFirstAndLastInitial(name: value["name"] as? String ?? "none"), for: .normal)
//                    //self.nameTracker[match.team_1_player_1 ?? "nope"] = self.getFirstAndLastInitial(name: value["name"] as? String ?? "none")
//                    let exp = value["exp"] as? Int ?? 0
//                    cell.appLevel.text = "\(self.player.haloLevel(exp: exp))"
//                    self.levelTracker[match.team_1_player_1 ?? "nope"] = "\(self.player.haloLevel(exp: exp))"
//                }
//            })
//        } else {
//            cell.challengerTeam1.setTitle(nameTracker[match.team_1_player_1 ?? "nope"], for: .normal)
//            cell.appLevel.text = levelTracker[match.team_1_player_1 ?? "nope"]
//        }
//        if match.doubles == true {
//            cell.challengerTeam2.isHidden = false
//            cell.appLevel2.isHidden = false
//            if nameTracker[match.team_1_player_2 ?? "nope"] == nil {
//                let player2ref = Database.database().reference().child("users").child(match.team_1_player_2 ?? "nope")
//                player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
//                    if let value = snapshot.value as? [String: AnyObject] {
//                        //cell.challengerTeam2.setTitle(self.getFirstAndLastInitial(name: value["name"] as? String ?? "none"), for: .normal)
//                        //self.nameTracker[match.team_1_player_2 ?? "nope"] = self.getFirstAndLastInitial(name: value["name"] as? String ?? "none")
//                        let exp = value["exp"] as? Int ?? 0
//                        cell.appLevel2.text = "\(self.player.haloLevel(exp: exp))"
//                        self.levelTracker[match.team_1_player_2 ?? "nope"] = "\(self.player.haloLevel(exp: exp))"
//                    }
//                })
//            } else {
//                cell.challengerTeam2.setTitle(nameTracker[match.team_1_player_2 ?? "nope"], for: .normal)
//                cell.appLevel2.text = levelTracker[match.team_1_player_2 ?? "nope"]
//            }
//        } else {
//            cell.challengerTeam2.isHidden = true
//            cell.appLevel2.isHidden = true
//        }
//
//        if nameTracker[match.team_2_player_1 ?? "nope"] == nil {
//            let player1ref2 = Database.database().reference().child("users").child(match.team_2_player_1 ?? "nope")
//            player1ref2.observeSingleEvent(of: .value, with: {(snapshot) in
//                if let value = snapshot.value as? [String: AnyObject] {
//                    //cell.challengedTeam1.setTitle(self.getFirstAndLastInitial(name: value["name"] as? String ?? "none"), for: .normal)
//                    //self.nameTracker[match.team_2_player_1 ?? "nope"] = self.getFirstAndLastInitial(name: value["name"] as? String ?? "none")
//                    let exp = value["exp"] as? Int ?? 0
//                    cell.appLevel3.text = "\(self.player.haloLevel(exp: exp))"
//                    self.levelTracker[match.team_2_player_1 ?? "nope"] = "\(self.player.haloLevel(exp: exp))"
//                }
//            })
//        } else {
//            cell.challengedTeam1.setTitle(nameTracker[match.team_2_player_1 ?? "nope"], for: .normal)
//            cell.appLevel3.text = levelTracker[match.team_2_player_1 ?? "nope"]
//        }
//
//        if match.doubles == true {
//            cell.challengedTeam2.isHidden = false
//            cell.appLevel4.isHidden = false
//            if nameTracker[match.team_2_player_2 ?? "nope"] == nil {
//                let player2ref2 = Database.database().reference().child("users").child(match.team_2_player_2 ?? "nope")
//                player2ref2.observeSingleEvent(of: .value, with: {(snapshot) in
//                    if let value = snapshot.value as? [String: AnyObject] {
//                        //cell.challengedTeam2.setTitle(self.getFirstAndLastInitial(name: value["name"] as? String ?? "none"), for: .normal)
//                        //self.nameTracker[match.team_2_player_2 ?? "nope"] = self.getFirstAndLastInitial(name: value["name"] as? String ?? "none")
//                        let exp = value["exp"] as? Int ?? 0
//                        cell.appLevel4.text = "\(self.player.haloLevel(exp: exp))"
//                        self.levelTracker[match.team_2_player_2 ?? "nope"] = "\(self.player.haloLevel(exp: exp))"
//                    }
//                })
//            } else {
//                cell.challengedTeam2.setTitle(nameTracker[match.team_2_player_2 ?? "nope"], for: .normal)
//                cell.appLevel4.text = levelTracker[match.team_2_player_2 ?? "nope"]
//            }
//        } else {
//            cell.challengedTeam2.isHidden = true
//            cell.appLevel4.isHidden = true
//        }
//        let uid = Auth.auth().currentUser?.uid
//        if match.active == 3 {
//            if match.winner == 1 {
//                cell.challengerPlaceholder.image = UIImage(named: "winning_team_placeholder2")
//                cell.challengedPlaceholder.image = UIImage(named: "challenger_team_placeholder")
//            } else if match.winner == 2 {
//                cell.challengerPlaceholder.image = UIImage(named: "challenger_team_placeholder")
//                cell.challengedPlaceholder.image = UIImage(named: "winning_team_placeholder2")
//            }
//        } else {
//            if uid == match.team_1_player_1 || uid == match.team_1_player_2 {
//                cell.challengerPlaceholder.image = UIImage(named: "user_team_placeholder")
//                cell.challengedPlaceholder.image = UIImage(named: "plain_team_placeholder")
//            } else if uid == match.team_2_player_1 || uid == match.team_2_player_2 {
//                cell.challengerPlaceholder.image = UIImage(named: "plain_team_placeholder")
//                cell.challengedPlaceholder.image = UIImage(named: "user_team_placeholder")
//            } else {
//                cell.challengerPlaceholder.image = UIImage(named: "plain_team_placeholder")
//                cell.challengedPlaceholder.image = UIImage(named: "plain_team_placeholder")
//            }
//        }
//
//        //cell.editButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
//        //cell.editButton.tag = indexPath.item
//
//        cell.challengerTeam1.tag = indexPath.item
//        //cell.challengerTeam1.addTarget(self, action: #selector(self.handleViewPlayer), for: .touchUpInside)
//        cell.challengerTeam2.tag = indexPath.item
//        //cell.challengerTeam2.addTarget(self, action: #selector(self.handleViewPlayer2), for: .touchUpInside)
//        cell.challengedTeam1.tag = indexPath.item
//        //cell.challengedTeam1.addTarget(self, action: #selector(self.handleViewPlayer3), for: .touchUpInside)
//        cell.challengedTeam2.tag = indexPath.item
//        //cell.challengedTeam2.addTarget(self, action: #selector(self.handleViewPlayer4), for: .touchUpInside)
//
//        cell.match = match
//        cell.backgroundColor = UIColor.white
//        return cell
//    }

}
