//
//  FeedMatchCell.swift
//  Pickleball
//
//  Created by Tanner Rozier on 3/26/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

class FeedMatchCell: UITableViewCell {
    
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
    
    func dayDifference(from interval : TimeInterval) -> String
    {
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: interval)
        let startOfNow = calendar.startOfDay(for: Date())
        let startOfTimeStamp = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
        let day = components.day!
        if abs(day) < 2 {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            formatter.doesRelativeDateFormatting = true
            return formatter.string(from: date)
        } else if abs(day) > 7 {
            return "week"
        } else {
            return "\(-day) days ago"
        }
    }
 
    
    var match = Match2() {
        didSet {
            let player = Player()
//            let player1ref = Database.database().reference().child("users").child(match.team_1_player_1 ?? "nope")
//            player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
//                if let value = snapshot.value as? [String: AnyObject] {
//                    self.challengerTeam1.setTitle(value["username"] as? String, for: .normal)
//                    let exp = value["exp"] as? Int ?? 0
//                    self.appLevel.text = "\(player.haloLevel(exp: exp))"
//                }
//            })
//
//            let player2ref = Database.database().reference().child("users").child(match.team_1_player_2 ?? "nope")
//            player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
//                if let value = snapshot.value as? [String: AnyObject] {
//                    self.challengerTeam2.setTitle(value["username"] as? String, for: .normal)
//                    let exp = value["exp"] as? Int ?? 0
//                    self.appLevel2.text = "\(player.haloLevel(exp: exp))"
//                }
//            })
//
//            let player1ref2 = Database.database().reference().child("users").child(match.team_2_player_1 ?? "nope")
//            player1ref2.observeSingleEvent(of: .value, with: {(snapshot) in
//                if let value = snapshot.value as? [String: AnyObject] {
//                    self.challengedTeam1.setTitle(value["username"] as? String, for: .normal)
//                    let exp = value["exp"] as? Int ?? 0
//                    self.appLevel3.text = "\(player.haloLevel(exp: exp))"
//                }
//            })
//
//            let player2ref2 = Database.database().reference().child("users").child(match.team_2_player_2 ?? "nope")
//            player2ref2.observeSingleEvent(of: .value, with: {(snapshot) in
//                if let value = snapshot.value as? [String: AnyObject] {
//                    self.challengedTeam2.setTitle(value["username"] as? String, for: .normal)
//                    let exp = value["exp"] as? Int ?? 0
//                    self.appLevel4.text = "\(player.haloLevel(exp: exp))"
//                }
//            })
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let width = Float(screenWidth)
            let height = Float(screenWidth / 1.875)
            if let seconds = self.match.time {
                
                let dateTime = Date(timeIntervalSince1970: seconds)
                let days = self.dayDifference(from: seconds)
                
                let dateFormatter = DateFormatter()
                if days == "week" {
                    dateFormatter.dateFormat = "MM/dd/yy"
                    self.timeStamp.text = dateFormatter.string(from: dateTime)
                } else {
                    dateFormatter.dateFormat = "hh:mm a"
                    if self.match.active == 0 {
                        self.timeStamp.text = "Match created on: \(days), \(dateFormatter.string(from: dateTime))"
                    } else if match.active == 1 || match.active == 2 {
                        self.timeStamp.text = "Match confirmed on: \(days), \(dateFormatter.string(from: dateTime))"
                    } else if match.active == 3 {
                        self.timeStamp.text = "Match completed: \(days), \(dateFormatter.string(from: dateTime))"
                    }
                }
            }
            switch match.active {
            case 0:
                headerLabel.text = "Pre-Match Confirmation"
            case 1:
                headerLabel.text = "Enter Scores"
            case 2:
                headerLabel.text = "Confirm Scores"
            case 3:
                headerLabel.text = "Match Complete"
            default:
                print("")
            }
            timeStamp.textColor = .black
            grayBox.isHidden = true
            addSubview(grayBox)
            grayBox.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            grayBox.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            grayBox.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
            grayBox.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            if match.winner == 1 && match.active == 3 {
                tourneySymbol.isHidden = false
                tourneySymbol2.isHidden = true
                bringSubviewToFront(grayBox)
                bringSubviewToFront(challengerPlaceholder)
                bringSubviewToFront(challengerTeam1)
                bringSubviewToFront(challengerTeam2)
                bringSubviewToFront(tourneySymbol)
                whiteBox.addSubview(tourneySymbol)
                let tourneyLoc = calculateButtonPosition(x: 90, y: 92, w: 100, h: 140, wib: 750, hib: 400, wia: width, hia: height)
                tourneySymbol.centerYAnchor.constraint(equalTo: whiteBox.topAnchor, constant: CGFloat(tourneyLoc.Y)).isActive = true
                tourneySymbol.centerXAnchor.constraint(equalTo: whiteBox.leftAnchor, constant: CGFloat(tourneyLoc.X)).isActive = true
                tourneySymbol.heightAnchor.constraint(equalToConstant: CGFloat(tourneyLoc.H)).isActive = true
                tourneySymbol.widthAnchor.constraint(equalToConstant: CGFloat(tourneyLoc.W)).isActive = true
            } else if match.winner == 2 && match.active == 3 {
                tourneySymbol.isHidden = true
                tourneySymbol2.isHidden = false
                bringSubviewToFront(grayBox)
                bringSubviewToFront(challengedPlaceholder)
                bringSubviewToFront(challengedTeam1)
                bringSubviewToFront(challengedTeam2)
                bringSubviewToFront(tourneySymbol2)
                let tourneyLoc2 = calculateButtonPosition(x: 90, y: 308, w: 100, h: 140, wib: 750, hib: 400, wia: width, hia: height)
                    
                whiteBox.addSubview(tourneySymbol2)
                tourneySymbol2.centerYAnchor.constraint(equalTo: whiteBox.topAnchor, constant: CGFloat(tourneyLoc2.Y)).isActive = true
                tourneySymbol2.centerXAnchor.constraint(equalTo: whiteBox.leftAnchor, constant: CGFloat(tourneyLoc2.X)).isActive = true
                tourneySymbol2.heightAnchor.constraint(equalToConstant: CGFloat(tourneyLoc2.H)).isActive = true
                tourneySymbol2.widthAnchor.constraint(equalToConstant: CGFloat(tourneyLoc2.W)).isActive = true
                }
            if match.active != 0 {
                match1Label.text = "\(match.team1_scores?[0] ?? -1)"
                match2Label.text = "\(match.team1_scores?[1] ?? -1)"
                match3Label.text = "\(match.team1_scores?[2] ?? -1)"
                match4Label.text = "\(match.team1_scores?[3] ?? -1)"
                match5Label.text = "\(match.team1_scores?[4] ?? -1)"
                match1Label2.text = "\(match.team2_scores?[0] ?? -1)"
                match2Label2.text = "\(match.team2_scores?[1] ?? -1)"
                match3Label2.text = "\(match.team2_scores?[2] ?? -1)"
                match4Label2.text = "\(match.team2_scores?[3] ?? -1)"
                match5Label2.text = "\(match.team2_scores?[4] ?? -1)"
            } else {
                match1Label.text = ""
                match2Label.text = ""
                match3Label.text = ""
                match4Label.text = ""
                match5Label.text = ""
                match1Label2.text = ""
                match2Label2.text = ""
                match3Label2.text = ""
                match4Label2.text = ""
                match5Label2.text = ""
            }
//            guard let startTime = match.time else {
//                return
//            }
//            if match.active == 3 {
//                timeLeftLabel.text = "FIN"
//            } else {
//                if match.active == 0 && (startTime + 86400) < Date().timeIntervalSince1970 {
//                    timeLeftLabel.text = "match\nexp"
//                } else if (startTime + (86400 * 3)) < Date().timeIntervalSince1970 {
//                    timeLeftLabel.text = "match\nexp"
//                } else {
//                    var hoursLeft: Double = 0
//                    if match.active == 0 {
//                        hoursLeft = ((startTime + 86400) - Date().timeIntervalSince1970) / 3600
//                    } else {
//                        hoursLeft = ((startTime + (86400 * 3)) - Date().timeIntervalSince1970) / 3600
//                    }
//                    let hoursRounded = hoursLeft.round(nearest: 1)
//                    if hoursRounded == 0 {
//                        timeLeftLabel.text = "<0.5\ndays\nleft"
//                    } else {
//                        timeLeftLabel.text = "\(hoursRounded)\nhours\nleft"
//                    }
//                }
//            }
        }
    }
    
    let tourneySymbol: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.isUserInteractionEnabled = true
        bi.image = UIImage(named: "tourney_symbol")
        return bi
    }()
    
    let timeStamp: UILabel = {
        let label = UILabel()
        label.text = "HH:MM:SS"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 170, g: 170, b: 170)
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textAlignment = .right
        return label
    }()
    
    let appLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .right
        return label
    }()
    
    let appLevel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .right
        return label
    }()
    
    let appLevel3: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .right
        return label
    }()
    
    let appLevel4: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .right
        return label
    }()
    
    let tourneySymbol2: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.isUserInteractionEnabled = true
        bi.image = UIImage(named: "tourney_symbol")
        return bi
    }()
    
    let challengerPlaceholder: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let challengedPlaceholder: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let timePlaceholder: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "match_time_placeholder")
        return image
    }()
    
    let timeLeftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "5 Days Left"
        label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    let match1Placeholder: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "plain_score_placeholder")
        return image
    }()
    
    let match2Placeholder: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "plain_score_placeholder")
        return image
    }()
    
    let match3Placeholder: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "plain_score_placeholder")
        return image
    }()
    
    let match4Placeholder: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "plain_score_placeholder")
        return image
    }()
    
    let match5Placeholder: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "plain_score_placeholder")
        return image
    }()
    
    let challenged: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Challenged:"
        label.font = UIFont(name: "HelveticaNeue", size: 21)
        label.textAlignment = .center
        return label
    }()
    
    let teamRank1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        label.font = UIFont(name: "HelveticaNeue", size: 65)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let teamRank2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        label.isHidden = true
        label.font = UIFont(name: "HelveticaNeue", size: 65)
        label.textAlignment = .center
        return label
    }()
    
    let challengerTeam1: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let challengerTeam2: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let challengedTeam1: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let challengedTeam2: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 25)
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let team11: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        return label
    }()
    let team12: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        return label
    }()
    let team21: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        return label
    }()
    let team22: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .left
        return label
    }()
    
    let match1Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textAlignment = .center
        return label
    }()
    let match2Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textAlignment = .center
        return label
    }()
    let match3Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textAlignment = .center
        return label
    }()
    let match4Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textAlignment = .center
        return label
    }()
    let match5Label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    let match1Label2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textAlignment = .center
        return label
    }()
    let match2Label2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textAlignment = .center
        return label
    }()
    let match3Label2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textAlignment = .center
        return label
    }()
    let match4Label2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textAlignment = .center
        return label
    }()
    let match5Label2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    let grayBox: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 220/255, green: 220/255, blue: 220/255, alpha: 0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let whiteBox: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        label.textAlignment = .center
        return label
    }()
    
    let confirmCheck1: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "confirmed_check")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let confirmCheck2: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "confirmed_check")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let confirmCheck3: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "confirmed_check")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let confirmCheck4: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "confirmed_check")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    func setupViews() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let width = Float(screenWidth)
        let height = Float(screenWidth / 1.875)
        
        addSubview(timeStamp)
        timeStamp.topAnchor.constraint(equalTo: topAnchor, constant: 1).isActive = true
        timeStamp.leftAnchor.constraint(equalTo: rightAnchor, constant: -275).isActive = true
        timeStamp.heightAnchor.constraint(equalToConstant: 25).isActive = true
        timeStamp.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        
        addSubview(headerLabel)
        headerLabel.topAnchor.constraint(equalTo: timeStamp.bottomAnchor).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        addSubview(whiteBox)
        whiteBox.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        whiteBox.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        whiteBox.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        whiteBox.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        whiteBox.addSubview(challengerPlaceholder)
        
        let challengerPlaceholderLoc = calculateButtonPosition(x: 303, y: 92, w: 582, h: 165, wib: 750, hib: 400, wia: width, hia: height)
        
        challengerPlaceholder.centerYAnchor.constraint(equalTo: whiteBox.topAnchor, constant: CGFloat(challengerPlaceholderLoc.Y)).isActive = true
        challengerPlaceholder.centerXAnchor.constraint(equalTo: whiteBox.leftAnchor, constant: CGFloat(challengerPlaceholderLoc.X)).isActive = true
        challengerPlaceholder.heightAnchor.constraint(equalToConstant: CGFloat(challengerPlaceholderLoc.H)).isActive = true
        challengerPlaceholder.widthAnchor.constraint(equalToConstant: CGFloat(challengerPlaceholderLoc.W)).isActive = true
        
        whiteBox.addSubview(challengedPlaceholder)
        
        let challengedPlaceholderLoc = calculateButtonPosition(x: 303, y: 308, w: 582, h: 165, wib: 750, hib: 400, wia: width, hia: height)
        
        challengedPlaceholder.centerYAnchor.constraint(equalTo: whiteBox.topAnchor, constant: CGFloat(challengedPlaceholderLoc.Y)).isActive = true
        challengedPlaceholder.centerXAnchor.constraint(equalTo: whiteBox.leftAnchor, constant: CGFloat(challengedPlaceholderLoc.X)).isActive = true
        challengedPlaceholder.heightAnchor.constraint(equalToConstant: CGFloat(challengedPlaceholderLoc.H)).isActive = true
        challengedPlaceholder.widthAnchor.constraint(equalToConstant: CGFloat(challengedPlaceholderLoc.W)).isActive = true
        
        whiteBox.addSubview(appLevel)
        appLevel.topAnchor.constraint(equalTo: challengerPlaceholder.topAnchor).isActive = true
        appLevel.rightAnchor.constraint(equalTo: challengerPlaceholder.rightAnchor, constant: -10).isActive = true
        appLevel.heightAnchor.constraint(equalTo: challengerPlaceholder.heightAnchor, multiplier: 1/2).isActive = true
        appLevel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        whiteBox.addSubview(appLevel2)
        appLevel2.topAnchor.constraint(equalTo: challengerPlaceholder.centerYAnchor).isActive = true
        appLevel2.rightAnchor.constraint(equalTo: challengerPlaceholder.rightAnchor, constant: -10).isActive = true
        appLevel2.heightAnchor.constraint(equalTo: challengerPlaceholder.heightAnchor, multiplier: 1/2).isActive = true
        appLevel2.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        whiteBox.addSubview(appLevel3)
        appLevel3.topAnchor.constraint(equalTo: challengedPlaceholder.topAnchor).isActive = true
        appLevel3.rightAnchor.constraint(equalTo: challengedPlaceholder.rightAnchor, constant: -10).isActive = true
        appLevel3.heightAnchor.constraint(equalTo: challengedPlaceholder.heightAnchor, multiplier: 1/2).isActive = true
        appLevel3.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        whiteBox.addSubview(appLevel4)
        appLevel4.topAnchor.constraint(equalTo: challengedPlaceholder.centerYAnchor).isActive = true
        appLevel4.rightAnchor.constraint(equalTo: challengedPlaceholder.rightAnchor, constant: -10).isActive = true
        appLevel4.heightAnchor.constraint(equalTo: challengedPlaceholder.heightAnchor, multiplier: 1/2).isActive = true
        appLevel4.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        whiteBox.addSubview(challenged)
        
        let challengedLoc = calculateButtonPosition(x: 250, y: 198, w: 350, h: 50, wib: 750, hib: 400, wia: width, hia: height)
        
        challenged.centerYAnchor.constraint(equalTo: whiteBox.topAnchor, constant: CGFloat(challengedLoc.Y)).isActive = true
        challenged.centerXAnchor.constraint(equalTo: whiteBox.leftAnchor, constant: CGFloat(challengedLoc.X)).isActive = true
        challenged.heightAnchor.constraint(equalToConstant: CGFloat(challengedLoc.H)).isActive = true
        challenged.widthAnchor.constraint(equalToConstant: CGFloat(challengedLoc.W)).isActive = true
        
        whiteBox.addSubview(challengerTeam1)
        whiteBox.addSubview(challengedTeam1)
        whiteBox.addSubview(challengerTeam2)
        whiteBox.addSubview(challengedTeam2)
        whiteBox.addSubview(team11)
        whiteBox.addSubview(team12)
        whiteBox.addSubview(team21)
        whiteBox.addSubview(team22)
        whiteBox.addSubview(match1Label)
        whiteBox.addSubview(match2Label)
        whiteBox.addSubview(match3Label)
        whiteBox.addSubview(match4Label)
        whiteBox.addSubview(match5Label)
        whiteBox.addSubview(match1Label2)
        whiteBox.addSubview(match2Label2)
        whiteBox.addSubview(match3Label2)
        whiteBox.addSubview(match4Label2)
        whiteBox.addSubview(match5Label2)
        
        let teamRankLoc = calculateButtonPosition(x: 90, y: 92, w: 100, h: 140, wib: 750, hib: 400, wia: width, hia: height)
        
        whiteBox.addSubview(teamRank1)
        teamRank1.centerYAnchor.constraint(equalTo: whiteBox.topAnchor, constant: CGFloat(teamRankLoc.Y)).isActive = true
        teamRank1.centerXAnchor.constraint(equalTo: whiteBox.leftAnchor, constant: CGFloat(teamRankLoc.X)).isActive = true
        teamRank1.heightAnchor.constraint(equalToConstant: CGFloat(teamRankLoc.H)).isActive = true
        teamRank1.widthAnchor.constraint(equalToConstant: CGFloat(teamRankLoc.W)).isActive = true
        
        let teamRankLoc2 = calculateButtonPosition(x: 90, y: 308, w: 100, h: 140, wib: 750, hib: 400, wia: width, hia: height)
        
        whiteBox.addSubview(teamRank2)
        teamRank2.centerYAnchor.constraint(equalTo: whiteBox.topAnchor, constant: CGFloat(teamRankLoc2.Y)).isActive = true
        teamRank2.centerXAnchor.constraint(equalTo: whiteBox.leftAnchor, constant: CGFloat(teamRankLoc2.X)).isActive = true
        teamRank2.heightAnchor.constraint(equalToConstant: CGFloat(teamRankLoc2.H)).isActive = true
        teamRank2.widthAnchor.constraint(equalToConstant: CGFloat(teamRankLoc2.W)).isActive = true
        
        team11.topAnchor.constraint(equalTo: challengerPlaceholder.topAnchor, constant: 5).isActive = true
        team11.leftAnchor.constraint(equalTo: teamRank1.rightAnchor).isActive = true
        team11.rightAnchor.constraint(equalTo: challengerPlaceholder.rightAnchor).isActive = true
        team11.bottomAnchor.constraint(equalTo: challengerPlaceholder.centerYAnchor).isActive = true
        
        team12.topAnchor.constraint(equalTo: challengerPlaceholder.centerYAnchor).isActive = true
        team12.leftAnchor.constraint(equalTo: teamRank1.rightAnchor).isActive = true
        team12.rightAnchor.constraint(equalTo: challengerPlaceholder.rightAnchor).isActive = true
        team12.bottomAnchor.constraint(equalTo: challengerPlaceholder.bottomAnchor, constant: -5).isActive = true
        
        team21.topAnchor.constraint(equalTo: challengedPlaceholder.topAnchor, constant: 5).isActive = true
        team21.leftAnchor.constraint(equalTo: teamRank2.rightAnchor).isActive = true
        team21.rightAnchor.constraint(equalTo: challengedPlaceholder.rightAnchor).isActive = true
        team21.bottomAnchor.constraint(equalTo: challengedPlaceholder.centerYAnchor).isActive = true
        
        team22.topAnchor.constraint(equalTo: challengedPlaceholder.centerYAnchor).isActive = true
        team22.leftAnchor.constraint(equalTo: teamRank2.rightAnchor).isActive = true
        team22.rightAnchor.constraint(equalTo: challengedPlaceholder.rightAnchor).isActive = true
        team22.bottomAnchor.constraint(equalTo: challengedPlaceholder.bottomAnchor, constant: -5).isActive = true
        
        challengerTeam1.topAnchor.constraint(equalTo: challengerPlaceholder.topAnchor, constant: 5).isActive = true
        challengerTeam1.leftAnchor.constraint(equalTo: teamRank1.rightAnchor).isActive = true
        challengerTeam1.rightAnchor.constraint(equalTo: challengerPlaceholder.rightAnchor).isActive = true
        challengerTeam1.bottomAnchor.constraint(equalTo: challengerPlaceholder.centerYAnchor).isActive = true
        
        challengerTeam2.topAnchor.constraint(equalTo: challengerPlaceholder.centerYAnchor).isActive = true
        challengerTeam2.leftAnchor.constraint(equalTo: teamRank1.rightAnchor).isActive = true
        challengerTeam2.rightAnchor.constraint(equalTo: challengerPlaceholder.rightAnchor).isActive = true
        challengerTeam2.bottomAnchor.constraint(equalTo: challengerPlaceholder.bottomAnchor, constant: -5).isActive = true
        
        challengedTeam1.topAnchor.constraint(equalTo: challengedPlaceholder.topAnchor, constant: 5).isActive = true
        challengedTeam1.leftAnchor.constraint(equalTo: teamRank2.rightAnchor).isActive = true
        challengedTeam1.rightAnchor.constraint(equalTo: challengedPlaceholder.rightAnchor).isActive = true
        challengedTeam1.bottomAnchor.constraint(equalTo: challengedPlaceholder.centerYAnchor).isActive = true
        
        challengedTeam2.topAnchor.constraint(equalTo: challengedPlaceholder.centerYAnchor).isActive = true
        challengedTeam2.leftAnchor.constraint(equalTo: teamRank2.rightAnchor).isActive = true
        challengedTeam2.rightAnchor.constraint(equalTo: challengedPlaceholder.rightAnchor).isActive = true
        challengedTeam2.bottomAnchor.constraint(equalTo: challengedPlaceholder.bottomAnchor, constant: -5).isActive = true
        
        whiteBox.addSubview(match1Placeholder)
        let match1PlaceholderLoc = calculateButtonPosition(x: 672, y: 42, w: 146, h: 62, wib: 750, hib: 400, wia: width, hia: height)
        match1Placeholder.centerYAnchor.constraint(equalTo: whiteBox.topAnchor, constant: CGFloat(match1PlaceholderLoc.Y)).isActive = true
        match1Placeholder.centerXAnchor.constraint(equalTo: whiteBox.leftAnchor, constant: CGFloat(match1PlaceholderLoc.X)).isActive = true
        match1Placeholder.heightAnchor.constraint(equalToConstant: CGFloat(match1PlaceholderLoc.H)).isActive = true
        match1Placeholder.widthAnchor.constraint(equalToConstant: CGFloat(match1PlaceholderLoc.W)).isActive = true
        
        whiteBox.addSubview(match2Placeholder)
        let match2PlaceholderLoc = calculateButtonPosition(x: 672, y: 120, w: 146, h: 62, wib: 750, hib: 400, wia: width, hia: height)
        match2Placeholder.centerYAnchor.constraint(equalTo: whiteBox.topAnchor, constant: CGFloat(match2PlaceholderLoc.Y)).isActive = true
        match2Placeholder.centerXAnchor.constraint(equalTo: whiteBox.leftAnchor, constant: CGFloat(match2PlaceholderLoc.X)).isActive = true
        match2Placeholder.heightAnchor.constraint(equalToConstant: CGFloat(match2PlaceholderLoc.H)).isActive = true
        match2Placeholder.widthAnchor.constraint(equalToConstant: CGFloat(match2PlaceholderLoc.W)).isActive = true
        
        whiteBox.addSubview(match3Placeholder)
        let match3PlaceholderLoc = calculateButtonPosition(x: 672, y: 198, w: 146, h: 62, wib: 750, hib: 400, wia: width, hia: height)
        match3Placeholder.centerYAnchor.constraint(equalTo: whiteBox.topAnchor, constant: CGFloat(match3PlaceholderLoc.Y)).isActive = true
        match3Placeholder.centerXAnchor.constraint(equalTo: whiteBox.leftAnchor, constant: CGFloat(match3PlaceholderLoc.X)).isActive = true
        match3Placeholder.heightAnchor.constraint(equalToConstant: CGFloat(match3PlaceholderLoc.H)).isActive = true
        match3Placeholder.widthAnchor.constraint(equalToConstant: CGFloat(match3PlaceholderLoc.W)).isActive = true
        
        whiteBox.addSubview(match4Placeholder)
        let match4PlaceholderLoc = calculateButtonPosition(x: 672, y: 276, w: 146, h: 62, wib: 750, hib: 400, wia: width, hia: height)
        match4Placeholder.centerYAnchor.constraint(equalTo: whiteBox.topAnchor, constant: CGFloat(match4PlaceholderLoc.Y)).isActive = true
        match4Placeholder.centerXAnchor.constraint(equalTo: whiteBox.leftAnchor, constant: CGFloat(match4PlaceholderLoc.X)).isActive = true
        match4Placeholder.heightAnchor.constraint(equalToConstant: CGFloat(match4PlaceholderLoc.H)).isActive = true
        match4Placeholder.widthAnchor.constraint(equalToConstant: CGFloat(match4PlaceholderLoc.W)).isActive = true
        
        whiteBox.addSubview(match5Placeholder)
        let match5PlaceholderLoc = calculateButtonPosition(x: 672, y: 354, w: 146, h: 62, wib: 750, hib: 400, wia: width, hia: height)
        match5Placeholder.centerYAnchor.constraint(equalTo: whiteBox.topAnchor, constant: CGFloat(match5PlaceholderLoc.Y)).isActive = true
        match5Placeholder.centerXAnchor.constraint(equalTo: whiteBox.leftAnchor, constant: CGFloat(match5PlaceholderLoc.X)).isActive = true
        match5Placeholder.heightAnchor.constraint(equalToConstant: CGFloat(match5PlaceholderLoc.H)).isActive = true
        match5Placeholder.widthAnchor.constraint(equalToConstant: CGFloat(match5PlaceholderLoc.W)).isActive = true
        
        match1Label.topAnchor.constraint(equalTo: match1Placeholder.topAnchor).isActive = true
        match1Label.leftAnchor.constraint(equalTo: match1Placeholder.leftAnchor, constant: 2).isActive = true
        match1Label.rightAnchor.constraint(equalTo: match1Placeholder.centerXAnchor, constant: -1).isActive = true
        match1Label.bottomAnchor.constraint(equalTo: match1Placeholder.bottomAnchor).isActive = true
        
        match2Label.topAnchor.constraint(equalTo: match2Placeholder.topAnchor).isActive = true
        match2Label.leftAnchor.constraint(equalTo: match2Placeholder.leftAnchor, constant: 2).isActive = true
        match2Label.rightAnchor.constraint(equalTo: match2Placeholder.centerXAnchor, constant: -1).isActive = true
        match2Label.bottomAnchor.constraint(equalTo: match2Placeholder.bottomAnchor).isActive = true
        
        match3Label.topAnchor.constraint(equalTo: match3Placeholder.topAnchor).isActive = true
        match3Label.leftAnchor.constraint(equalTo: match3Placeholder.leftAnchor, constant: 2).isActive = true
        match3Label.rightAnchor.constraint(equalTo: match3Placeholder.centerXAnchor, constant: -1).isActive = true
        match3Label.bottomAnchor.constraint(equalTo: match3Placeholder.bottomAnchor).isActive = true
        
        match4Label.topAnchor.constraint(equalTo: match4Placeholder.topAnchor).isActive = true
        match4Label.leftAnchor.constraint(equalTo: match4Placeholder.leftAnchor, constant: 2).isActive = true
        match4Label.rightAnchor.constraint(equalTo: match4Placeholder.centerXAnchor, constant: -1).isActive = true
        match4Label.bottomAnchor.constraint(equalTo: match4Placeholder.bottomAnchor).isActive = true
        
        match5Label.topAnchor.constraint(equalTo: match5Placeholder.topAnchor).isActive = true
        match5Label.leftAnchor.constraint(equalTo: match5Placeholder.leftAnchor, constant: 2).isActive = true
        match5Label.rightAnchor.constraint(equalTo: match5Placeholder.centerXAnchor, constant: -1).isActive = true
        match5Label.bottomAnchor.constraint(equalTo: match5Placeholder.bottomAnchor).isActive = true
        
        match1Label2.topAnchor.constraint(equalTo: match1Placeholder.topAnchor).isActive = true
        match1Label2.rightAnchor.constraint(equalTo: match1Placeholder.rightAnchor, constant: -2).isActive = true
        match1Label2.leftAnchor.constraint(equalTo: match1Placeholder.centerXAnchor, constant: 1).isActive = true
        match1Label2.bottomAnchor.constraint(equalTo: match1Placeholder.bottomAnchor).isActive = true
        
        match2Label2.topAnchor.constraint(equalTo: match2Placeholder.topAnchor).isActive = true
        match2Label2.rightAnchor.constraint(equalTo: match2Placeholder.rightAnchor, constant: -2).isActive = true
        match2Label2.leftAnchor.constraint(equalTo: match2Placeholder.centerXAnchor, constant: 1).isActive = true
        match2Label2.bottomAnchor.constraint(equalTo: match2Placeholder.bottomAnchor).isActive = true
        
        match3Label2.topAnchor.constraint(equalTo: match3Placeholder.topAnchor).isActive = true
        match3Label2.rightAnchor.constraint(equalTo: match3Placeholder.rightAnchor, constant: -2).isActive = true
        match3Label2.leftAnchor.constraint(equalTo: match3Placeholder.centerXAnchor, constant: 1).isActive = true
        match3Label2.bottomAnchor.constraint(equalTo: match3Placeholder.bottomAnchor).isActive = true
        
        match4Label2.topAnchor.constraint(equalTo: match4Placeholder.topAnchor).isActive = true
        match4Label2.rightAnchor.constraint(equalTo: match4Placeholder.rightAnchor, constant: -2).isActive = true
        match4Label2.leftAnchor.constraint(equalTo: match4Placeholder.centerXAnchor, constant: 1).isActive = true
        match4Label2.bottomAnchor.constraint(equalTo: match4Placeholder.bottomAnchor).isActive = true
        
        match5Label2.topAnchor.constraint(equalTo: match5Placeholder.topAnchor).isActive = true
        match5Label2.rightAnchor.constraint(equalTo: match5Placeholder.rightAnchor, constant: -2).isActive = true
        match5Label2.leftAnchor.constraint(equalTo: match5Placeholder.centerXAnchor, constant: 1).isActive = true
        match5Label2.bottomAnchor.constraint(equalTo: match5Placeholder.bottomAnchor).isActive = true
        
        whiteBox.addSubview(separatorView)
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        separatorView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
    }
}
