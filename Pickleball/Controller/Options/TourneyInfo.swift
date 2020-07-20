//
//  TourneyInfo.swift
//  Pickleball
//
//  Created by Tanner Rozier on 5/19/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

class TourneyInfo: UIViewController {
    
    var tourney: Tourney?
    var typeOfInfo = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Return", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        scrollView.backgroundColor = .white
        let Width = Float(view.frame.width)
        if typeOfInfo == 1 {
            scrollView.contentSize = CGSize(width: Double(Width), height: Double(600))
        } else if tourney?.type == "Ladder" {
            scrollView.contentSize = CGSize(width: Double(Width), height: Double(1500))
        } else {
            scrollView.contentSize = CGSize(width: Double(Width), height: Double(700))
        }
        view.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
                
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        scrollView.addSubview(TournamentInfo)
        TournamentInfo.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5).isActive = true
        TournamentInfo.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        TournamentInfo.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -12).isActive = true
        TournamentInfo.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(cancelButton)
        cancelButton.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 4).isActive = true
        cancelButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(registrationLabel)
        registrationLabel.topAnchor.constraint(equalTo: TournamentInfo.bottomAnchor, constant: 5).isActive = true
        registrationLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        registrationLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -12).isActive = true
        registrationLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        scrollView.addSubview(regText)
        regText.topAnchor.constraint(equalTo: registrationLabel.bottomAnchor, constant: 5).isActive = true
        regText.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        regText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -12).isActive = true
        regText.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        if typeOfInfo == 1 {
            regText.text = registrationGenericText
            registrationLabel.text = registrationGenericLabel
        } else {
            guard let startTime = tourney?.start_date else {
                return
            }
            let calendar = Calendar.current
            let startDater = Date(timeIntervalSince1970: startTime)
            let components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: startDater)
            let monthInt = components.month!
            let monthAbb = months[monthInt - 1].prefix(3)
            let boldTime = "\(monthAbb). \(components.day!)"
            if tourney?.type == "Ladder" {
                regText.text = "Registration for this tournament will be open until \(boldTime). After this date challenges and matches can be played. You can register for a tournament by pressing the 'Register' button in the top right corner of the tournament's page. If it is a doubles tourney, you will need to send another player an invite and they will need to accept the invite in their notifications tab in order for both of you to be officially registered for a tournament. If you want to invite someone else, you can revoke your invitation and then invite another player."
            } else {
                regText.text = "Registration for this tournament will be open until \(boldTime) or 6 teams have registered. After this time teams can start playing their Round Robin Matches. You can register for a tournament by pressing the 'Register' button in the top right corner of the tournament's page. If it is a doubles tourney, you will need to send another player an invite and they will need to accept the invite in their notifications tab in order for both of you to be officially registered for a tournament. If you want to invite someone else, you can revoke your invitation and then invite another player."
            }
            
            scrollView.addSubview(typeLabel)
            typeLabel.topAnchor.constraint(equalTo: regText.bottomAnchor, constant: 5).isActive = true
            typeLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            typeLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -12).isActive = true
            typeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            scrollView.addSubview(typeText)
            if tourney?.type == "Ladder" {
                typeText.text = "This tournament will be played as a \(tourney?.type ?? "Ladder") type tournament. A ladder type tournament is a way for many people locally to participate over a longer amount of time than a typical single day or weekend tournament. After every team is registered, any team can challenge another team that is within a rank of 3 of their own rank. If you beat a team that is ranked higher than you, you take over their ranking and they drop down one ranking, shifting down any other teams that would be affected as well. If you beat somebody at a lower rank than you, you still go up one rank. This is to encourage those who are playing more to tend to be at the top of the list. You can't just sit at a high rank without continually playing and moving up. At the end of the challenge period, the top 4 teams will move into a traditional tournament style play to determine the first place winner."
            } else {
                typeText.text = "This tournament will be played as a \(tourney?.type ?? "Round Robin") type tournament. A Round Robin tournament has each team play a match with every other team in the tournament. The team that scores the most points after playing every team is the winner! The matches will be separated into weeks, but the matches can be played out of order if desired."
            }
            typeText.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 5).isActive = true
            typeText.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            typeText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -12).isActive = true
            typeText.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            if tourney?.type == "Ladder" {
                scrollView.addSubview(challengeLabel)
                challengeLabel.topAnchor.constraint(equalTo: typeText.bottomAnchor, constant: 5).isActive = true
                challengeLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
                challengeLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -12).isActive = true
                challengeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
                
                scrollView.addSubview(challengeText)
                challengeText.text = "After the registration period is over, you can challenge a team by selecting them in the 'Standings' list of teams. You will see info about the team and a 'Challenge' button. Select the 'Challenge' button to send them a challenge. If the 'Challenge' button is faded out slightly, that means they are already in a challenge and you will need to wait for them to finish that challenge before you can challenge them. Once you challenge a team, they have 24 hoours to accept the challenge or you can submit a forfeit for them which will result in a loss for them and a win for you."
                challengeText.topAnchor.constraint(equalTo: challengeLabel.bottomAnchor, constant: 5).isActive = true
                challengeText.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
                challengeText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -12).isActive = true
                challengeText.heightAnchor.constraint(equalToConstant: 200).isActive = true
                
                scrollView.addSubview(daysToPlayLabel)
                daysToPlayLabel.topAnchor.constraint(equalTo: challengeText.bottomAnchor, constant: 5).isActive = true
                daysToPlayLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
                daysToPlayLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -12).isActive = true
                daysToPlayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
                
                scrollView.addSubview(daysToPlayText)
                daysToPlayText.text = "After a challenge has been accepted, you will have \(tourney?.daysToPlay ?? 3) days to complete the match and submit the scores before it will be deleted so other players can challenge you or the opponent. If you submit the scores to a match and the opponent does not confirm them within 24 hours, then you can confirm the scores for them."
                daysToPlayText.topAnchor.constraint(equalTo: daysToPlayLabel.bottomAnchor, constant: 5).isActive = true
                daysToPlayText.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
                daysToPlayText.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -12).isActive = true
                daysToPlayText.heightAnchor.constraint(equalToConstant: 200).isActive = true
            }
        }
        
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
    
    let TournamentInfo: UILabel = {
        let label = UILabel()
        label.text = "Tournament Info"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let registrationLabel: UILabel = {
        let label = UILabel()
        label.text = "Registration"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let regText: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.textAlignment = .center
        label.isSelectable = false
        label.isEditable = false
        label.textColor = .black
        label.backgroundColor = UIColor(displayP3Red: 88/255, green: 148/255, blue: 200/255, alpha: 0.4)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Tournament Style"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let typeText: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.textAlignment = .center
        label.isSelectable = false
        label.isEditable = false
        label.textColor = .black
        label.backgroundColor = UIColor(displayP3Red: 88/255, green: 148/255, blue: 200/255, alpha: 0.4)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    let challengeLabel: UILabel = {
        let label = UILabel()
        label.text = "Challenging"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let challengeText: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.textAlignment = .center
        label.isSelectable = false
        label.isEditable = false
        label.textColor = .black
        label.backgroundColor = UIColor(displayP3Red: 88/255, green: 148/255, blue: 200/255, alpha: 0.4)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    let daysToPlayLabel: UILabel = {
        let label = UILabel()
        label.text = "Days to Complete Match"
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let daysToPlayText: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.textAlignment = .center
        label.isSelectable = false
        label.isEditable = false
        label.textColor = .black
        label.backgroundColor = UIColor(displayP3Red: 88/255, green: 148/255, blue: 200/255, alpha: 0.4)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    let registrationGenericLabel = "How do I register?"
    let registrationGenericText = "To register for a tournament, click on the search button at the top right. From the search page you can filter your search then click 'Search Tourneys' to view the available tournaments. If the registration period of the tournament is still going, then you can register for a tournament by pressing the 'Register' button in the top right corner of the tournament's page. If it is a doubles tourney, you will need to send another player an invite and they will need to accept the invite in their notifications tab in order for both of you to be officially registered for a tournament. If you want to invite someone else, you can revoke your invitation and then invite another player."
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
}
