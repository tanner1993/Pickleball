//
//  TourneyLayout.swift
//  Pickleball
//
//  Created by Tanner Rozier on 8/30/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

protocol FeedCellProtocol {
    func pushNavigation(_ vc: UIViewController)
}

extension TourneyStandings: FeedCellProtocol {
    func pushNavigation(_ vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
        destroyBubble()
    }
}

class TourneyStandings: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var tourneyListPage: TourneyList?
    var matches = [Match2]()
    var allMatches = [Match2]()
    var teams = [Team]()
    let tourneystatus = 1
    let cellId = "cellId"
    let rmCellId = "rmCellId"
    let mmCellId = "mmCellId"
    let threeSectionTitles = ["Overall", "My Matches", "Recent Matches"]
    var notificationSentYou = 0
    var tourneyOpenInvites = [String]()
    let blackView = UIView()
    var tourneyNameAll = "none"
    var tourneyListIndex = -1
    var currentSelection = 0
    var thisTourney = Tourney()
    var yetToView = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yetToView = thisTourney.yetToView ?? [String]()
        if let active = thisTourney.active {
            if active >= 2 {
                setupSemisView()
            }
        }
        observeTourneyInfo()
        observeTourneyTeams()
        //observeMyTourneyMatches()
        observeAllTourneyMatches()
        makeBubble()
        
        setupTourneyMenuBar()
        setupCollectionView()
        setupTitle()
    }
    
    func makeBubble() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        if yetToView.contains(uid) {
            notifBadge.isHidden = false
        }
    }
    
    func destroyBubble() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        guard let tourneyId = thisTourney.id else {
            return
        }
        if yetToView.contains(uid) {
            notifBadge.isHidden = true
            Database.database().reference().child("tourney_notifications").child(uid).child(tourneyId).removeValue()
            yetToView.remove(at: yetToView.firstIndex(of: uid)!)
            Database.database().reference().child("tourneys").child(tourneyId).child("yet_to_view").setValue(yetToView)
            tourneyListPage?.removeBadge(whichOne: tourneyListIndex)
        }
    }
    
    func observeTourneyInfo() {
        guard let tourneyId = thisTourney.id else {
            return
        }
        let ref = Database.database().reference().child("tourneys").child(tourneyId)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? NSDictionary {
                if let invites = value["invites"] as? [String] {
                    self.tourneyOpenInvites = invites
                    self.setupNavBarButtons()
                } else {
                    self.setupNavBarButtons()
                }
            }
        }, withCancel: nil)
    }
    
    let finalsScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .white
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isScrollEnabled = true
        sv.contentSize = CGSize(width: 1125, height: 300)
        return sv
    }()
    
    let viewTourneyStats: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View Tourney Stats", for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 28)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        button.isHidden = true
        button.addTarget(self, action: #selector(handleViewTourneyStats), for: .touchUpInside)
        return button
    }()
    
    let finalsBackground: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.image = UIImage(named: "finalsView")
        bi.isUserInteractionEnabled = true
        return bi
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc func handleViewTourneyStats() {
        let tourneyStats = TourneyStats()
        tourneyStats.teams = teams
        tourneyStats.allMatches = allMatches
        tourneyStats.thisTourney = thisTourney
        navigationController?.pushViewController(tourneyStats, animated: true)
    }
    
    func setupSemisView() {
        
        view.addSubview(finalsScrollView)
        finalsScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        finalsScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        finalsScrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        finalsScrollView.heightAnchor.constraint(equalToConstant: 320).isActive = true
        
        finalsScrollView.addSubview(finalsBackground)
        finalsBackground.leftAnchor.constraint(equalTo: finalsScrollView.leftAnchor).isActive = true
        finalsBackground.topAnchor.constraint(equalTo: finalsScrollView.topAnchor).isActive = true
        finalsBackground.widthAnchor.constraint(equalToConstant: 1125).isActive = true
        finalsBackground.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        finalsBackground.addSubview(separatorView)
        separatorView.leftAnchor.constraint(equalTo: finalsBackground.leftAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 355).isActive = true
        separatorView.widthAnchor.constraint(equalToConstant: 1125).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        finalsBackground.addSubview(viewTourneyStats)
        viewTourneyStats.centerXAnchor.constraint(equalTo: finalsBackground.rightAnchor, constant: -(view.frame.width / 2)).isActive = true
        viewTourneyStats.bottomAnchor.constraint(equalTo: finalsBackground.centerYAnchor, constant: 125).isActive = true
        viewTourneyStats.widthAnchor.constraint(equalToConstant: 220).isActive = true
        viewTourneyStats.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        setupSemiTeams()
    }
    
    func observeTourneyTeams() {
        
        guard let tourneyId = thisTourney.id , let active = thisTourney.active else {
            return
        }
        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("teams").queryOrdered(byChild: "rank")
        ref.observe(.childAdded, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let team = Team()
                let player1Id = value["player1"] as? String ?? "Player not found"
                let player2Id = value["player2"] as? String ?? "Player not found"
                let rank = value["rank"] as? Int ?? 100
                let wins = value["wins"] as? Int ?? -1
                let losses = value["losses"] as? Int ?? -1
                team.player2 = player2Id
                team.player1 = player1Id
                team.rank = rank
                team.wins = wins
                team.losses = losses
                if active >= 2 {
                    switch rank {
                    case 1:
                        self.getNamesAndWins(which: 1, player1: player1Id, player2: player2Id, winsf: wins, lossesf: losses)
                    case 2:
                        self.getNamesAndWins(which: 3, player1: player1Id, player2: player2Id, winsf: wins, lossesf: losses)
                    case 3:
                        self.getNamesAndWins(which: 4, player1: player1Id, player2: player2Id, winsf: wins, lossesf: losses)
                    case 4:
                        self.getNamesAndWins(which: 2, player1: player1Id, player2: player2Id, winsf: wins, lossesf: losses)
                    default:
                        print("not top 4")
                    }
                }
                team.teamId = snapshot.key
                self.teams.append(team)
                DispatchQueue.main.async { self.collectionView.reloadData() }
            }
            
        }, withCancel: nil)
    }
    
    func getNamesAndWins(which: Int, player1: String, player2: String, winsf: Int, lossesf: Int) {
        let player1ref = Database.database().reference().child("users").child(player1)
        player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.player1s[which - 1].text = value["username"] as? String
                if self.thisTourney.active == 3 {
                    self.player1s[4].text = self.thisTourney.finals1 == 1 ? self.player1s[0].text : self.player1s[1].text
                } else if self.thisTourney.active == 4 {
                    self.player1s[5].text = self.thisTourney.finals2 == 2 ? self.player1s[2].text : self.player1s[3].text
                } else if self.thisTourney.active == 5 || self.thisTourney.active == 6 {
                    self.player1s[4].text = self.thisTourney.finals1 == 1 ? self.player1s[0].text : self.player1s[1].text
                    self.player1s[5].text = self.thisTourney.finals2 == 2 ? self.player1s[2].text : self.player1s[3].text
                }
                if self.thisTourney.active == 6 {
                    var correctTeam = 0
                    switch self.thisTourney.winner {
                    case 1:
                        correctTeam = 1
                    case 2:
                        correctTeam = 3
                    case 3:
                        correctTeam = 4
                    case 4:
                        correctTeam = 2
                    default:
                        print("failed correct")
                    }
                    self.player1s[6].text = self.player1s[correctTeam - 1].text
                }
            }
        })
        
        let player2ref = Database.database().reference().child("users").child(player2)
        player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.player2s[which - 1].text = value["username"] as? String
                if self.thisTourney.active == 3 {
                    self.player2s[4].text = self.thisTourney.finals1 == 1 ? self.player2s[0].text : self.player2s[1].text
                } else if self.thisTourney.active == 4 {
                    self.player2s[5].text = self.thisTourney.finals2 == 2 ? self.player2s[2].text : self.player2s[3].text
                } else if self.thisTourney.active == 5 || self.thisTourney.active == 6 {
                    self.player2s[4].text = self.thisTourney.finals1 == 1 ? self.player2s[0].text : self.player2s[1].text
                    self.player2s[5].text = self.thisTourney.finals2 == 2 ? self.player2s[2].text : self.player2s[3].text
                }
                if self.thisTourney.active == 6 {
                    var correctTeam = 0
                    switch self.thisTourney.winner {
                    case 1:
                        correctTeam = 1
                    case 2:
                        correctTeam = 3
                    case 3:
                        correctTeam = 4
                    case 4:
                        correctTeam = 2
                    default:
                        print("failed correct")
                    }
                    self.player2s[6].text = self.player2s[correctTeam - 1].text
                }
            }
        })
        
        wins[which - 1].text = "Wins: \(winsf)"
        losses[which - 1].text = "Losses: \(lossesf)"
        if self.thisTourney.active == 3 {
            self.wins[4].text = self.thisTourney.finals1 == 1 ? self.wins[0].text : self.wins[1].text
            self.losses[4].text = self.thisTourney.finals1 == 1 ? self.losses[0].text : self.losses[1].text
        } else if self.thisTourney.active == 4 {
            self.wins[5].text = self.thisTourney.finals2 == 2 ? self.wins[2].text : self.wins[3].text
            self.losses[5].text = self.thisTourney.finals2 == 2 ? self.losses[2].text : self.losses[3].text
        } else if self.thisTourney.active == 5 || self.thisTourney.active == 6 {
            self.wins[4].text = self.thisTourney.finals1 == 1 ? self.wins[0].text : self.wins[1].text
            self.losses[4].text = self.thisTourney.finals1 == 1 ? self.losses[0].text : self.losses[1].text
            self.wins[5].text = self.thisTourney.finals2 == 2 ? self.wins[2].text : self.wins[3].text
            self.losses[5].text = self.thisTourney.finals2 == 2 ? self.losses[2].text : self.losses[3].text
        }
        if self.thisTourney.active == 6 {
            var correctTeam = 0
            switch self.thisTourney.winner {
            case 1:
                correctTeam = 1
            case 2:
                correctTeam = 3
            case 3:
                correctTeam = 4
            case 4:
                correctTeam = 2
            default:
                print("failed correct")
            }
            self.wins[6].text = self.wins[correctTeam - 1].text
            self.losses[6].text = self.losses[correctTeam - 1].text
        }
    }
    
    func observeAllTourneyMatches() {
        guard let tourneyId = thisTourney.id, let uid = Auth.auth().currentUser?.uid else {
            return
        }

        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("matches")
        ref.observe(.childAdded, with: { (snapshot) in
                    if let value = snapshot.value as? NSDictionary {
                        let matchT = Match2()
                        let active = value["active"] as? Int ?? 0
                        let submitter = value["submitter"] as? Int ?? 0
                        let winner = value["winner"] as? Int ?? 0
                        let team_1_player_1 = value["team_1_player_1"] as? String ?? "Player not found"
                        let team_1_player_2 = value["team_1_player_2"] as? String ?? "Player not found"
                        let team_2_player_1 = value["team_2_player_1"] as? String ?? "Player not found"
                        let team_2_player_2 = value["team_2_player_2"] as? String ?? "Player not found"
                        let idList = [team_1_player_1, team_1_player_2, team_2_player_1, team_2_player_2]
                        let team1_scores = value["team1_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                        let team2_scores = value["team2_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                        let time = value["time"] as? Double ?? Date().timeIntervalSince1970
                        matchT.active = active
                        matchT.winner = winner
                        matchT.submitter = submitter
                        matchT.team_1_player_1 = team_1_player_1
                        matchT.team_1_player_2 = team_1_player_2
                        matchT.team_2_player_1 = team_2_player_1
                        matchT.team_2_player_2 = team_2_player_2
                        matchT.team1_scores = team1_scores
                        matchT.team2_scores = team2_scores
                        matchT.matchId = snapshot.key
                        matchT.time = time
                        if idList.contains(uid) == true {
                            self.matches.append(matchT)
                            self.matches = self.matches.sorted { p1, p2 in
                                return (p1.time!) > (p2.time!)
                            }
                        }
                        self.allMatches.append(matchT)
                        self.allMatches = self.allMatches.sorted { p1, p2 in
                            return (p1.time!) > (p2.time!)
                        }
            }
            
            
        }, withCancel: nil)
    }
    
    private func setupNavBarButtons() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        if tourneyOpenInvites.contains(uid) != true {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(handleEnterTourney))
        } else if tourneyOpenInvites.contains(uid) && thisTourney.active ?? 1 == 0 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Invite Friends", style: .plain, target: self, action: #selector(handleInviteFriends))
        }
        if thisTourney.active ?? 1 > 0 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(handleRefreshList))
        }
    }
    
    @objc func handleInviteFriends() {
        let layout = UICollectionViewFlowLayout()
        let friendList = FriendList(collectionViewLayout: layout)
        friendList.tourneyId = thisTourney.id ?? "none"
        friendList.tourneyOpenInvites = tourneyOpenInvites
        friendList.tourneyStandings = self
        friendList.startTime = thisTourney.start_date ?? 0
        friendList.simpleInvite = 1
        navigationController?.present(friendList, animated: true, completion: nil)
    }
    
    
    
    @objc func handleRefreshList() {
        let currentItem = collectionView.indexPathsForVisibleItems[0].item
        if currentItem == 0 {
            teams.removeAll()
            observeTourneyTeams()
        } else if currentItem == 1 {
            teams.removeAll()
            matches.removeAll()
            allMatches.removeAll()
            observeTourneyTeams()
            observeAllTourneyMatches()
        } else if currentItem == 2 {
            teams.removeAll()
            matches.removeAll()
            allMatches.removeAll()
            observeTourneyTeams()
            observeAllTourneyMatches()
        }
        
        if thisTourney.active ?? 0 >= 2 {
            observeTourneyInfo2()
        }
    }
    
    func observeTourneyInfo2() {
        guard let tourneyId = thisTourney.id else {
            return
        }
        let ref = Database.database().reference().child("tourneys").child(tourneyId)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let finals1 = value["finals1"] as? Int ?? -1
                let finals2 = value["finals2"] as? Int ?? -1
                let winner = value["winner"] as? Int ?? -1
                let active = value["active"] as? Int ?? -1
                self.resetThisTourneyValues(finals1: finals1, finals2: finals2, winner: winner, active: active)
            }
        }, withCancel: nil)
    }
    
    func resetThisTourneyValues(finals1: Int, finals2: Int, winner: Int, active: Int) {
        thisTourney.active = active
        thisTourney.finals1 = finals1
        thisTourney.finals2 = finals2
        thisTourney.winner = winner
        changeViews()
    }
    
    @objc func handleReturn() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleEnterTourney() {
        let layout = UICollectionViewFlowLayout()
        let friendList = FriendList(collectionViewLayout: layout)
        friendList.tourneyId = thisTourney.id ?? "none"
        friendList.tourneyOpenInvites = tourneyOpenInvites
        friendList.tourneyStandings = self
        friendList.startTime = thisTourney.start_date ?? 0
        navigationController?.present(friendList, animated: true, completion: nil)
        
    }
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    private func setupTitle() {
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        
        if thisTourney.active == 0 {
            let normalTime = "\(thisTourney.name ?? "none")\nReg. ends: "
            let attributedTime = NSMutableAttributedString(string: normalTime)
            let attrb = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 14), NSAttributedString.Key.foregroundColor : UIColor.white]
            let calendar = Calendar.current
            let startDater = Date(timeIntervalSince1970: thisTourney.start_date ?? 0)
            let components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: startDater)
            let monthInt = components.month!
            let monthAbb = months[monthInt - 1].prefix(3)
            let boldTime = "\(monthAbb). \(components.day!)"
            let boldTimeString = NSAttributedString(string: boldTime, attributes: attrb as [NSAttributedString.Key : Any])
            attributedTime.append(boldTimeString)
            titleLabel.attributedText = attributedTime
        } else if thisTourney.active == 1 {
            let normalTime = "\(thisTourney.name ?? "none")\nLadder ends: "
            let attributedTime = NSMutableAttributedString(string: normalTime)
            let attrb = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 14), NSAttributedString.Key.foregroundColor : UIColor.white]
            let calendar = Calendar.current
            let weeksLong: Double = Double(thisTourney.duration ?? 2)
            let secondsLong: Double = weeksLong * 7 * 86400
            print(secondsLong)
            let startDater = Date(timeIntervalSince1970: ((thisTourney.time ?? Date().timeIntervalSince1970) + secondsLong))
            let components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: startDater)
            let monthInt = components.month!
            let monthAbb = months[monthInt - 1].prefix(3)
            let boldTime = "\(monthAbb). \(components.day!)"
            let boldTimeString = NSAttributedString(string: boldTime, attributes: attrb as [NSAttributedString.Key : Any])
            attributedTime.append(boldTimeString)
            titleLabel.attributedText = attributedTime
        } else if thisTourney.active ?? 1 > 1 && thisTourney.active ?? 1 < 5 {
            titleLabel.text = "\(thisTourney.name ?? "none")\n(semifinal)"
        } else if thisTourney.active == 5 {
            titleLabel.text = "\(thisTourney.name ?? "none")\n(final)"
        } else if thisTourney.active == 6 {
            titleLabel.text = "\(thisTourney.name ?? "none")\n(completed)"
        }
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        if thisTourney.creator == uid && thisTourney.active ?? 3 < 2 {
            setupFilterCollectionView()
            let labelTap = UITapGestureRecognizer(target: self, action: #selector(handleDropDownFinish))
            titleLabel.addGestureRecognizer(labelTap)
            titleLabel.isUserInteractionEnabled = true
        } else {
            titleLabel.isUserInteractionEnabled = false
        }
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        navigationItem.titleView = titleLabel
    }
    
    let filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    let cellId2 = "cellId23"
    
    func setupFilterCollectionView() {
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.register(ProfileMenuCell.self, forCellWithReuseIdentifier: cellId2)
    }
    
    let dropDownOption = ["Registration", "Ongoing Ladder", "Semifinal"]
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func handleDropDownFinish() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu)))
            window.addSubview(blackView)
            window.addSubview(filterCollectionView)
            filterCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 320)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.filterCollectionView.frame = CGRect(x: 0, y: window.frame.height - 320, width: window.frame.width, height: 320)
            }, completion: nil)
        }
    }
    
    @objc func dismissMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.filterCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 320)
            }
        })
    }
    
    private func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(MatchCell.self, forCellWithReuseIdentifier: rmCellId)
        collectionView?.register(MyMatchesCell.self, forCellWithReuseIdentifier: mmCellId)
        
        collectionView?.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
//        if view.frame.width > 375 {
//            collectionView?.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
//            collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
//        } else {
//            collectionView?.contentInset = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
//            collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
//        }
        if UIDevice.current.hasNotch {
            collectionView?.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
            collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        } else {
            collectionView?.contentInset = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
            collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
        }
        collectionView?.isPagingEnabled = true
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
        
        //setTitleForIndex(index: menuIndex)
    }
    
//    private func setTitleForIndex(index: Int) {
//        if let titleLabels = navigationItem.titleView as? UILabel {
//            titleLabels.text = threeSectionTitles[index]
//        }
//    }
    
    lazy var menusBar: TourneyMenuBar = {
        let mb = TourneyMenuBar()
        mb.tourneystandings = self
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
    }()
    
    let notifBadge: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.backgroundColor = .red
        label.text = "1"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private func setupTourneyMenuBar() {
        
        view.addSubview(menusBar)
        menusBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        menusBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        menusBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        menusBar.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(notifBadge)
        notifBadge.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 38).isActive = true
        notifBadge.topAnchor.constraint(equalTo: menusBar.topAnchor, constant: 1).isActive = true
        notifBadge.widthAnchor.constraint(equalToConstant: 16).isActive = true
        notifBadge.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menusBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 3
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        menusBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition:[])
        
        //setTitleForIndex(index: Int(index))
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return 3
        }
        return dropDownOption.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            if indexPath.item == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mmCellId, for: indexPath) as! MyMatchesCell
                cell.tourneyIdentifier = thisTourney.id
                cell.matches = matches
                cell.teams = teams
                cell.active = thisTourney.active ?? 0
                cell.yetToView = yetToView
                cell.finals1 = thisTourney.finals1 ?? -1
                cell.finals2 = thisTourney.finals2 ?? -1
                cell.delegate = self
                return cell
            } else if indexPath.item == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rmCellId, for: indexPath) as! MatchCell
                cell.tourneyIdentifier = thisTourney.id
                cell.matches = allMatches
                cell.teams = teams
                cell.active = thisTourney.active ?? 0
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
            cell.teams = teams
            cell.delegate = self
            cell.active = thisTourney.active ?? 0
            cell.tourneyIdentifier = thisTourney.id
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! ProfileMenuCell
            cell.menuItem.text = dropDownOption[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: view.frame.width, height: view.frame.height - 35)
        } else {
            return CGSize(width: view.frame.width, height: 80)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != self.collectionView {
            handleChangeTourneyActive(newActive: indexPath.item)
            dismissMenu()
        }
    }
    
    func handleChangeTourneyActive(newActive: Int) {
        guard let tourneyId = thisTourney.id else {
            return
        }
        if newActive == 2 {
            let createMatchFailed = UIAlertController(title: "Are you sure?", message: "Once semi-finals start you can't go back", preferredStyle: .alert)
            createMatchFailed.addAction(UIAlertAction(title: "Nevermind", style: .default, handler: nil))
            createMatchFailed.addAction(UIAlertAction(title: "I'm sure", style: .default, handler: handleImSure))
            self.present(createMatchFailed, animated: true, completion: nil)
        } else if newActive == 1 {
            Database.database().reference().child("tourneys").child(tourneyId).child("active").setValue(newActive)
            Database.database().reference().child("tourneys").child(tourneyId).child("time").setValue(Date().timeIntervalSince1970)
            thisTourney.active = newActive
            resetupTitle()
        } else {
            Database.database().reference().child("tourneys").child(tourneyId).child("active").setValue(newActive)
            thisTourney.active = newActive
            resetupTitle()
        }
    }
    
    func handleImSure(action: UIAlertAction) {
        Database.database().reference().child("tourneys").child(thisTourney.id ?? "none").child("active").setValue(2)
        thisTourney.active = 2
        resetupTitle()
    }
    
    func resetupTitle() {
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        if thisTourney.active == 0 {
            titleLabel.text = "\(tourneyNameAll)\n(registration period)"
        } else if thisTourney.active == 1 {
            titleLabel.text = "\(tourneyNameAll)\n(ongoing)"
        } else if thisTourney.active == 5 {
            titleLabel.text = "\(tourneyNameAll)\n(final)"
        } else if thisTourney.active == 6 {
            titleLabel.text = "\(tourneyNameAll)\n(completed)"
        } else if thisTourney.active ?? 0 >= 2 {
            titleLabel.text = "\(tourneyNameAll)\n(semifinal)"
            handleSetupSemifinal1()
        }
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.isUserInteractionEnabled = false
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        navigationItem.titleView = titleLabel
    }
    
    func handleSetupSemifinal1() {
        var team1stIndex = -1
        var team2ndIndex = -1
        var team3rdIndex = -1
        var team4thIndex = -1
        for (index, element) in teams.enumerated() {
            if element.rank == 1 {
                team1stIndex = index
            } else if element.rank == 2 {
                team2ndIndex = index
            } else if element.rank == 3 {
                team3rdIndex = index
            } else if element.rank == 4 {
                team4thIndex = index
            }
        }
        handleSetupSemifinal2(team_1_player_1: teams[team1stIndex].player1!, team_1_player_2: teams[team1stIndex].player2!, team_2_player_1: teams[team4thIndex].player1!, team_2_player_2: teams[team4thIndex].player2!)
        handleSetupSemifinal2(team_1_player_1: teams[team2ndIndex].player1!, team_1_player_2: teams[team2ndIndex].player2!, team_2_player_1: teams[team3rdIndex].player1!, team_2_player_2: teams[team3rdIndex].player2!)
    }
    
    func handleSetupSemifinal2(team_1_player_1: String, team_1_player_2: String, team_2_player_1: String, team_2_player_2: String) {
        guard let uid = Auth.auth().currentUser?.uid, let tourneyId = thisTourney.id else {
            return
        }
        
        let timeOfChallenge = Date().timeIntervalSince1970
        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("matches")
        let createMatchRef = ref.childByAutoId()
        let values = ["active": 1, "team_1_player_1": team_1_player_1, "team_1_player_2": team_1_player_2, "team_2_player_1": team_2_player_1, "team_2_player_2": team_2_player_2, "team1_scores": [0, 0, 0, 0, 0], "team2_scores": [0, 0, 0, 0, 0], "time": timeOfChallenge] as [String : Any]
        createMatchRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            guard let matchId = createMatchRef.key else {
                return
            }
            
            
            
            let notificationId = matchId
            let notificationsRef = Database.database().reference()
            let childUpdates = ["/\("tourney_notifications")/\(team_1_player_1)/\(tourneyId)/": team_1_player_1 == uid ? 0 : 1, "/\("tourney_notifications")/\(team_1_player_2)/\(tourneyId)/": team_1_player_2 == uid ? 0 : 1, "/\("tourney_notifications")/\(team_2_player_1)/\(tourneyId)/": team_2_player_1 == uid ? 0 : 1, "/\("tourney_notifications")/\(team_2_player_2)/\(tourneyId)/": team_2_player_2 == uid ? 0 : 1] as [String : Any]
            notificationsRef.updateChildValues(childUpdates, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if error != nil {
                    let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(messageSendFailed, animated: true, completion: nil)
                    print("Data could not be saved: \(String(describing: error)).")
                    return
                }
                
                print("Crazy data 2 saved!")
                
                
            })
            
        })
    }
    
    var player1s = [UILabel]()
    var player2s = [UILabel]()
    var wins = [UILabel]()
    var losses = [UILabel]()
    var tourneySymbols = [UIImageView]()
    var whiteViews = [UIView]()
    
    func setupSemiTeams() {
        
        for index in 1...7 {
            let player1_1: UILabel = {
                let label = UILabel()
                label.text = "???"
                label.translatesAutoresizingMaskIntoConstraints = false
                label.font = UIFont(name: "HelveticaNeue", size: 24)
                label.textAlignment = .left
                return label
            }()
            
            let player2_1: UILabel = {
                let label = UILabel()
                label.text = "???"
                label.translatesAutoresizingMaskIntoConstraints = false
                label.font = UIFont(name: "HelveticaNeue", size: 24)
                label.textAlignment = .left
                return label
            }()
            
            let wins_1: UILabel = {
                let label = UILabel()
                label.text = "???"
                label.translatesAutoresizingMaskIntoConstraints = false
                label.textColor = UIColor.init(r: 32, g: 140, b: 21)
                label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
                label.textAlignment = .right
                return label
            }()
            
            let losses_1: UILabel = {
                let label = UILabel()
                label.text = "???"
                label.textColor = UIColor.init(r: 252, g: 16, b: 13)
                label.translatesAutoresizingMaskIntoConstraints = false
                label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
                label.textAlignment = .right
                return label
            }()
            
            let tourneySymbol: UIImageView = {
                let bi = UIImageView()
                bi.translatesAutoresizingMaskIntoConstraints = false
                bi.contentMode = .scaleAspectFit
                bi.image = UIImage(named: "tourney_symbol")
                bi.isHidden = true
                return bi
            }()
            
            let whiteView: UIView = {
                let view = UIView()
                view.backgroundColor = .white
                view.isHidden = true
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            player1s.append(player1_1)
            player2s.append(player2_1)
            wins.append(wins_1)
            losses.append(losses_1)
            tourneySymbols.append(tourneySymbol)
            whiteViews.append(whiteView)
            
            finalsBackground.addSubview(player1s[index - 1])
            
            let player1_1Loc = calculateButtonPosition(x: playerXs[index - 1], y: player1Ys[index - 1], w: playerLabelWidth, h: playerLabelHeight, wib: 2250, hib: 600, wia: 1125, hia: 300)
            player1s[index - 1].centerYAnchor.constraint(equalTo: finalsBackground.topAnchor, constant: CGFloat(player1_1Loc.Y)).isActive = true
            player1s[index - 1].centerXAnchor.constraint(equalTo: finalsBackground.leftAnchor, constant: CGFloat(player1_1Loc.X)).isActive = true
            player1s[index - 1].heightAnchor.constraint(equalToConstant: CGFloat(player1_1Loc.H)).isActive = true
            player1s[index - 1].widthAnchor.constraint(equalToConstant: CGFloat(player1_1Loc.W)).isActive = true
            
            finalsBackground.addSubview(player2s[index - 1])
            
            let player2_1Loc = calculateButtonPosition(x: playerXs[index - 1], y: player2Ys[index - 1], w: playerLabelWidth, h: playerLabelHeight, wib: 2250, hib: 600, wia: 1125, hia: 300)
            player2s[index - 1].centerYAnchor.constraint(equalTo: finalsBackground.topAnchor, constant: CGFloat(player2_1Loc.Y)).isActive = true
            player2s[index - 1].centerXAnchor.constraint(equalTo: finalsBackground.leftAnchor, constant: CGFloat(player2_1Loc.X)).isActive = true
            player2s[index - 1].heightAnchor.constraint(equalToConstant: CGFloat(player2_1Loc.H)).isActive = true
            player2s[index - 1].widthAnchor.constraint(equalToConstant: CGFloat(player2_1Loc.W)).isActive = true
            
            finalsBackground.addSubview(wins[index - 1])
            
            let wins_1Loc = calculateButtonPosition(x: winXs[index - 1], y: winYs[index - 1], w: teamWinWidth, h: teamWinHeight, wib: 2250, hib: 600, wia: 1125, hia: 300)
            wins[index - 1].centerYAnchor.constraint(equalTo: finalsBackground.topAnchor, constant: CGFloat(wins_1Loc.Y)).isActive = true
            wins[index - 1].centerXAnchor.constraint(equalTo: finalsBackground.leftAnchor, constant: CGFloat(wins_1Loc.X)).isActive = true
            wins[index - 1].heightAnchor.constraint(equalToConstant: CGFloat(wins_1Loc.H)).isActive = true
            wins[index - 1].widthAnchor.constraint(equalToConstant: CGFloat(wins_1Loc.W)).isActive = true
            
            finalsBackground.addSubview(losses[index - 1])
            
            let losses_1Loc = calculateButtonPosition(x: winXs[index - 1], y: lossYs[index - 1], w: teamWinWidth, h: teamWinHeight, wib: 2250, hib: 600, wia: 1125, hia: 300)
            losses[index - 1].centerYAnchor.constraint(equalTo: finalsBackground.topAnchor, constant: CGFloat(losses_1Loc.Y)).isActive = true
            losses[index - 1].centerXAnchor.constraint(equalTo: finalsBackground.leftAnchor, constant: CGFloat(losses_1Loc.X)).isActive = true
            losses[index - 1].heightAnchor.constraint(equalToConstant: CGFloat(losses_1Loc.H)).isActive = true
            losses[index - 1].widthAnchor.constraint(equalToConstant: CGFloat(losses_1Loc.W)).isActive = true
            
            finalsBackground.addSubview(whiteViews[index - 1])
            let tourneySymbolLoc = calculateButtonPosition(x: tourneyXs[index - 1], y: tourneyYs[index - 1], w: tourneyWidth, h: tourneyHeight, wib: 2250, hib: 600, wia: 1125, hia: 300)
            
            whiteViews[index - 1].centerYAnchor.constraint(equalTo: finalsBackground.topAnchor, constant: CGFloat(tourneySymbolLoc.Y)).isActive = true
            whiteViews[index - 1].centerXAnchor.constraint(equalTo: finalsBackground.leftAnchor, constant: CGFloat(tourneySymbolLoc.X)).isActive = true
            whiteViews[index - 1].heightAnchor.constraint(equalToConstant: CGFloat(tourneySymbolLoc.H)).isActive = true
            whiteViews[index - 1].widthAnchor.constraint(equalToConstant: CGFloat(tourneySymbolLoc.W)).isActive = true
            
            finalsBackground.addSubview(tourneySymbols[index - 1])
            
            tourneySymbols[index - 1].centerYAnchor.constraint(equalTo: finalsBackground.topAnchor, constant: CGFloat(tourneySymbolLoc.Y)).isActive = true
            tourneySymbols[index - 1].centerXAnchor.constraint(equalTo: finalsBackground.leftAnchor, constant: CGFloat(tourneySymbolLoc.X)).isActive = true
            tourneySymbols[index - 1].heightAnchor.constraint(equalToConstant: CGFloat(tourneySymbolLoc.H)).isActive = true
            tourneySymbols[index - 1].widthAnchor.constraint(equalToConstant: CGFloat(tourneySymbolLoc.W)).isActive = true
            
        }
        changeViews()
    }
    
    let playerLabelWidth: Float = 350
    let playerLabelHeight: Float = 70
    let teamWinWidth: Float = 180
    let teamWinHeight: Float = 38
    let playerXs: [Float] = [345, 345, 345, 345, 1106.6, 1106.6, 1858.1]
    let player1Ys: [Float] = [53.7, 188.7, 365.7, 500, 209.8, 343.9, 276.7]
    let player2Ys: [Float] = [110, 245, 422, 556, 266.1, 400.2, 333]
    let winXs: [Float] = [600, 600, 600, 600, 1361.6, 1361.6, 2113.1]
    let winYs: [Float] = [53.7, 188.7, 365.7, 500, 209.8, 343.9, 276.7]
    let lossYs: [Float] = [110, 245, 422, 556, 266.1, 400.2, 333]
    let tourneyXs: [Float] = [93, 93, 93, 93, 854.4, 854.4, 1604.6]
    let tourneyYs: [Float] = [77.36, 211.5, 389.5, 523.5, 233.36, 367.6, 300.76]
    let tourneyWidth: Float = 128
    let tourneyHeight: Float = 100
    
    let nameFonts = UIFont(name: "HelveticaNeue", size: 25)
    let winFonts = UIFont(name: "HelveticaNeue-Light", size: 20)
    
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
    }
    
    func changeViews() {
        guard let active = thisTourney.active else {
            return
        }
        if active == 3 {
            tourneySymbols[0].isHidden = false
            tourneySymbols[1].isHidden = false
            whiteViews[0].isHidden = false
            whiteViews[1].isHidden = false
            if thisTourney.finals1 == 1 {
                player1s[1].alpha = 0.2
                player2s[1].alpha = 0.2
                wins[1].alpha = 0.2
                losses[1].alpha = 0.2
                tourneySymbols[1].image = UIImage(named: "tourney_symbol_br")
                tourneySymbols[1].alpha = 0.4
            } else {
                player1s[0].alpha = 0.2
                player2s[0].alpha = 0.2
                wins[0].alpha = 0.2
                losses[0].alpha = 0.2
                tourneySymbols[0].image = UIImage(named: "tourney_symbol_br")
                tourneySymbols[0].alpha = 0.4
            }
        } else if active == 4 {
            tourneySymbols[2].isHidden = false
            tourneySymbols[3].isHidden = false
            whiteViews[2].isHidden = false
            whiteViews[3].isHidden = false
            if thisTourney.finals2 == 2 {
                player1s[3].alpha = 0.2
                player2s[3].alpha = 0.2
                wins[3].alpha = 0.2
                losses[3].alpha = 0.2
                tourneySymbols[3].image = UIImage(named: "tourney_symbol_br")
                tourneySymbols[3].alpha = 0.4
            } else {
                player1s[2].alpha = 0.2
                player2s[2].alpha = 0.2
                wins[2].alpha = 0.2
                losses[2].alpha = 0.2
                tourneySymbols[2].image = UIImage(named: "tourney_symbol_br")
                tourneySymbols[2].alpha = 0.4
            }
        } else if active >= 5 {
            tourneySymbols[0].isHidden = false
            tourneySymbols[1].isHidden = false
            tourneySymbols[2].isHidden = false
            tourneySymbols[3].isHidden = false
            whiteViews[0].isHidden = false
            whiteViews[1].isHidden = false
            whiteViews[2].isHidden = false
            whiteViews[3].isHidden = false
            if thisTourney.finals1 == 1 {
                player1s[1].alpha = 0.2
                player2s[1].alpha = 0.2
                wins[1].alpha = 0.2
                losses[1].alpha = 0.2
                tourneySymbols[1].image = UIImage(named: "tourney_symbol_br")
                tourneySymbols[1].alpha = 0.4
            } else {
                player1s[0].alpha = 0.2
                player2s[0].alpha = 0.2
                wins[0].alpha = 0.2
                losses[0].alpha = 0.2
                tourneySymbols[0].image = UIImage(named: "tourney_symbol_br")
                tourneySymbols[0].alpha = 0.4
            }
            if thisTourney.finals2 == 2 {
                player1s[3].alpha = 0.2
                player2s[3].alpha = 0.2
                wins[3].alpha = 0.2
                losses[3].alpha = 0.2
                tourneySymbols[3].image = UIImage(named: "tourney_symbol_br")
                tourneySymbols[3].alpha = 0.4
            } else {
                player1s[2].alpha = 0.2
                player2s[2].alpha = 0.2
                wins[2].alpha = 0.2
                losses[2].alpha = 0.2
                tourneySymbols[2].image = UIImage(named: "tourney_symbol_br")
                tourneySymbols[2].alpha = 0.4
            }
        }
        if active == 6 {
            viewTourneyStats.isHidden = false
            tourneySymbols[4].isHidden = false
            tourneySymbols[5].isHidden = false
            tourneySymbols[6].isHidden = false
            tourneySymbols[6].image = UIImage(named: "tourney_symbol_go")
            var correctTeam = 0
            switch thisTourney.winner {
            case 1:
                correctTeam = 1
            case 2:
                correctTeam = 3
            case 3:
                correctTeam = 4
            case 4:
                correctTeam = 2
            default:
                print("failed correct")
            }
            if correctTeam == 1 || correctTeam == 2 {
                player1s[5].alpha = 0.2
                player2s[5].alpha = 0.2
                wins[5].alpha = 0.2
                losses[5].alpha = 0.2
                tourneySymbols[5].image = UIImage(named: "tourney_symbol_si")
                tourneySymbols[5].alpha = 0.6
            } else {
                player1s[4].alpha = 0.2
                player2s[4].alpha = 0.2
                wins[4].alpha = 0.2
                losses[4].alpha = 0.2
                tourneySymbols[4].image = UIImage(named: "tourney_symbol_si")
                tourneySymbols[4].alpha = 0.6
            }
        }
    }

}

