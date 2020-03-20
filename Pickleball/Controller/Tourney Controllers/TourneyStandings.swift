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
    }
}

class TourneyStandings: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var matches = [Match2]()
    var allMatches = [Match2]()
    var teams = [Team]()
    let tourneystatus = 1
    let cellId = "cellId"
    let rmCellId = "rmCellId"
    let mmCellId = "mmCellId"
    let threeSectionTitles = ["Overall", "Recent Matches", "My Matches"]
    var tourneyIdentifier: String?
    var notificationSentYou = 0
    var active = -1
    var tourneyOpenInvites = [String]()
    let blackView = UIView()
    var tourneyNameAll = "none"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeTourneyInfo()
        observeTourneyTeams()
        //observeMyTourneyMatches()
        observeAllTourneyMatches()
        
//        if notificationSentYou == 0 {
//            setupNavBarButtons()
//        }
        
        setupTourneyMenuBar()
        setupCollectionView()
        
    }
    
    func observeTourneyInfo() {
        guard let tourneyId = tourneyIdentifier else {
            return
        }
        let ref = Database.database().reference().child("tourneys").child(tourneyId)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let tourneyName = value["name"] as? String ?? "none"
                self.tourneyNameAll = tourneyName
                let tourneyActive = value["active"] as? Int ?? -1
                if tourneyActive == 2 {
                    self.setupSemisView()
                }
                let tourneyCreator = value["creator"] as? String ?? "none"
                if let invites = value["invites"] as? [String] {
                    self.tourneyOpenInvites = invites
                    self.setupNavBarButtons()
                } else {
                    self.setupNavBarButtons()
                }
                self.setupTitle(active1: tourneyActive, tournName: tourneyName, tournCreator: tourneyCreator)
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
    
    let finalsBackground: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.image = UIImage(named: "finalsView")
        bi.isUserInteractionEnabled = true
        return bi
    }()
    
    func setupSemisView() {
        
        view.addSubview(finalsScrollView)
        finalsScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        finalsScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        finalsScrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        finalsScrollView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        finalsScrollView.addSubview(finalsBackground)
        finalsBackground.leftAnchor.constraint(equalTo: finalsScrollView.leftAnchor).isActive = true
        finalsBackground.topAnchor.constraint(equalTo: finalsScrollView.topAnchor).isActive = true
        finalsBackground.widthAnchor.constraint(equalToConstant: 1125).isActive = true
        finalsBackground.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        setupSemiTeams()
    }
    
    func observeTourneyTeams() {
        
        guard let tourneyId = tourneyIdentifier else {
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
                if self.active == 2 {
                    switch rank {
                    case 1:
                        self.getNamesAndWins(which: 1, player1: player1Id, player2: player2Id, wins: wins, losses: losses)
                    case 2:
                        self.getNamesAndWins(which: 2, player1: player1Id, player2: player2Id, wins: wins, losses: losses)
                    case 3:
                        self.getNamesAndWins(which: 3, player1: player1Id, player2: player2Id, wins: wins, losses: losses)
                    case 4:
                        self.getNamesAndWins(which: 4, player1: player1Id, player2: player2Id, wins: wins, losses: losses)
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
    
    func getNamesAndWins(which: Int, player1: String, player2: String, wins: Int, losses: Int) {
        let player1ref = Database.database().reference().child("users").child(player1)
        player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.player1_1.text = value["username"] as? String
            }
        })
        
        let player2ref = Database.database().reference().child("users").child(player2)
        player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.player2_1.text = value["username"] as? String
            }
        })
        
        wins_1.text = "Wins: \(wins)"
        losses_1.text = "Losses: \(losses)"
    }
    
//    func observeMyTourneyMatches() {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let ref = Database.database().reference().child("user-notifications").child(uid)
//        ref.observe(.childAdded, with: { (snapshot) in
//            let matchId = snapshot.key
//            guard let tourneyId = snapshot.value as? String else {
//                return
//            }
//            if tourneyId == self.tourneyIdentifier {
//                let matchReference = Database.database().reference().child("tourneys").child(tourneyId).child("matches").child(matchId)
//
//                matchReference.observeSingleEvent(of: .value, with: {(snapshot) in
//                    if let value = snapshot.value as? NSDictionary {
//                        let match = Match()
//                        let active = value["active"] as? Int ?? 0
//                        let challengerTeamId = value["challenger_team"] as? String ?? "Team not found"
//                        let challengedTeamId = value["challenged_team"] as? String ?? "Team not found"
//                        let challengerScores = value["challenger_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
//                        let challengedScores = value["challenged_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
//                        let submitter = value["submitter"] as? String ?? "No submitter yet"
//                        let winner = value["winner"] as? String ?? "No winner yet"
//                        let time = value["time"] as? Double ?? Date().timeIntervalSince1970
//                        match.active = active
//                        match.submitter = submitter
//                        match.winner = winner
//                        match.challengerTeamId = challengerTeamId
//                        match.challengedTeamId = challengedTeamId
//                        match.challengerScores = challengerScores
//                        match.challengedScores = challengedScores
//                        match.matchId = matchId
//                        match.time = time
//                        self.matches.append(match)
//                        self.matches = self.matches.sorted { p1, p2 in
//                            return (p1.time!) > (p2.time!)
//                        }
//                        //DispatchQueue.main.async { self.collectionView.reloadData() }
//                    }
//
//                }, withCancel: nil)
//            }
//
//
//        }, withCancel: nil)
//
//    }
    
    func observeAllTourneyMatches() {
        guard let tourneyId = tourneyIdentifier, let uid = Auth.auth().currentUser?.uid else {
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
        }
    }
    
    @objc func handleReturn() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleEnterTourney() {
        let layout = UICollectionViewFlowLayout()
        let friendList = FriendList(collectionViewLayout: layout)
        friendList.tourneyId = tourneyIdentifier!
        friendList.tourneyOpenInvites = tourneyOpenInvites
        friendList.tourneyStandings = self
        navigationController?.present(friendList, animated: true, completion: nil)
        
    }
    
    private func setupTitle(active1: Int, tournName: String, tournCreator: String) {
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        active = active1
        if active == 0 {
            titleLabel.text = "\(tournName)\n(registration period)"
        } else if active == 1 {
            titleLabel.text = "\(tournName)\n(ongoing)"
        } else if active == 2 {
            titleLabel.text = "\(tournName)\n(semifinal)"
        } else if active == 3 {
            titleLabel.text = "\(tournName)\n(final)"
        }
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        if tournCreator == uid {
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
    
    let dropDownOption = ["Registration", "Ongoing Ladder", "Semifinal", "Final"]
    
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
        collectionView?.contentInset = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
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
    
    private func setupTourneyMenuBar() {
        
        view.addSubview(menusBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menusBar)
        view.addConstraintsWithFormat(format: "V:|[v0(35)]", views: menusBar)
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rmCellId, for: indexPath) as! MatchCell
                cell.tourneyIdentifier = tourneyIdentifier
                cell.matches = allMatches
                cell.teams = teams
                return cell
            } else if indexPath.item == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mmCellId, for: indexPath) as! MyMatchesCell
                cell.tourneyIdentifier = tourneyIdentifier
                cell.matches = matches
                cell.teams = teams
                cell.delegate = self
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
            cell.teams = teams
            cell.delegate = self
            cell.active = active
            cell.tourneyIdentifier = tourneyIdentifier
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
        Database.database().reference().child("tourneys").child(tourneyIdentifier ?? "none").child("active").setValue(newActive)
        active = newActive
        resetupTitle()
    }
    
    func resetupTitle() {
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        if active == 0 {
            titleLabel.text = "\(tourneyNameAll)\n(registration period)"
        } else if active == 1 {
            titleLabel.text = "\(tourneyNameAll)\n(ongoing)"
        } else if active == 2 {
            titleLabel.text = "\(tourneyNameAll)\n(semifinal)"
            handleSetupSemifinal1()
        } else if active == 3 {
            titleLabel.text = "\(tourneyNameAll)\n(final)"
        }
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
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
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let timeOfChallenge = Date().timeIntervalSince1970
        let ref = Database.database().reference().child("tourneys").child(tourneyIdentifier ?? "none").child("matches")
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
            let childUpdates = ["/\("tourney_notifications")/\(team_1_player_1)/\(self.tourneyIdentifier)/": team_1_player_1 == uid ? 0 : 1, "/\("tourney_notifications")/\(team_1_player_2)/\(self.tourneyIdentifier)/": team_1_player_2 == uid ? 0 : 1, "/\("tourney_notifications")/\(team_2_player_1)/\(self.tourneyIdentifier)/": team_2_player_1 == uid ? 0 : 1, "/\("tourney_notifications")/\(team_2_player_2)/\(self.tourneyIdentifier)/": team_2_player_2 == uid ? 0 : 1] as [String : Any]
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
    
    func setupSemiTeams() {
        finalsBackground.addSubview(player1_1)
        
        let player1_1Loc = calculateButtonPosition(x: 197.5, y: 53.7, w: 340, h: 70, wib: 2250, hib: 600, wia: 1125, hia: 300)
        player1_1.centerYAnchor.constraint(equalTo: finalsBackground.topAnchor, constant: CGFloat(player1_1Loc.Y)).isActive = true
        player1_1.centerXAnchor.constraint(equalTo: finalsBackground.leftAnchor, constant: CGFloat(player1_1Loc.X)).isActive = true
        player1_1.heightAnchor.constraint(equalToConstant: CGFloat(player1_1Loc.H)).isActive = true
        player1_1.widthAnchor.constraint(equalToConstant: CGFloat(player1_1Loc.W)).isActive = true
        
        finalsBackground.addSubview(player2_1)
        
        let player2_1Loc = calculateButtonPosition(x: 537.2, y: 53.7, w: 340, h: 70, wib: 2250, hib: 600, wia: 1125, hia: 300)
        player2_1.centerYAnchor.constraint(equalTo: finalsBackground.topAnchor, constant: CGFloat(player2_1Loc.Y)).isActive = true
        player2_1.centerXAnchor.constraint(equalTo: finalsBackground.leftAnchor, constant: CGFloat(player2_1Loc.X)).isActive = true
        player2_1.heightAnchor.constraint(equalToConstant: CGFloat(player2_1Loc.H)).isActive = true
        player2_1.widthAnchor.constraint(equalToConstant: CGFloat(player2_1Loc.W)).isActive = true
        
        finalsBackground.addSubview(wins_1)
        
        let wins_1Loc = calculateButtonPosition(x: 250, y: 115.6, w: 180, h: 38, wib: 2250, hib: 600, wia: 1125, hia: 300)
        wins_1.centerYAnchor.constraint(equalTo: finalsBackground.topAnchor, constant: CGFloat(wins_1Loc.Y)).isActive = true
        wins_1.centerXAnchor.constraint(equalTo: finalsBackground.leftAnchor, constant: CGFloat(wins_1Loc.X)).isActive = true
        wins_1.heightAnchor.constraint(equalToConstant: CGFloat(wins_1Loc.H)).isActive = true
        wins_1.widthAnchor.constraint(equalToConstant: CGFloat(wins_1Loc.W)).isActive = true
        
        finalsBackground.addSubview(losses_1)
        
        let losses_1Loc = calculateButtonPosition(x: 483, y: 115.6, w: 180, h: 38, wib: 2250, hib: 600, wia: 1125, hia: 300)
        losses_1.centerYAnchor.constraint(equalTo: finalsBackground.topAnchor, constant: CGFloat(losses_1Loc.Y)).isActive = true
        losses_1.centerXAnchor.constraint(equalTo: finalsBackground.leftAnchor, constant: CGFloat(losses_1Loc.X)).isActive = true
        losses_1.heightAnchor.constraint(equalToConstant: CGFloat(losses_1Loc.H)).isActive = true
        losses_1.widthAnchor.constraint(equalToConstant: CGFloat(losses_1Loc.W)).isActive = true
    }
    
    let nameFonts = UIFont(name: "HelveticaNeue", size: 25)
    let winFonts = UIFont(name: "HelveticaNeue-Light", size: 20)
    
    let player1_1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let player2_1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let wins_1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    let losses_1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
    }

}

