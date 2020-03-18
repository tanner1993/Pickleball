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
    
    var matches = [Match]()
    var allMatches = [Match]()
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeTourneyInfo()
        observeTourneyTeams()
        observeMyTourneyMatches()
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
                let tourneyActive = value["active"] as? Int ?? -1
                if let invites = value["invites"] as? [String] {
                    self.tourneyOpenInvites = invites
                    self.setupNavBarButtons()
                } else {
                    self.setupNavBarButtons()
                }
                self.setupTitle(active1: tourneyActive, tournName: tourneyName)
            }
        }, withCancel: nil)
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
                team.teamId = snapshot.key
                self.teams.append(team)
                DispatchQueue.main.async { self.collectionView.reloadData() }
            }
            
        }, withCancel: nil)
    }
    
    func observeMyTourneyMatches() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user-notifications").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let matchId = snapshot.key
            guard let tourneyId = snapshot.value as? String else {
                return
            }
            if tourneyId == self.tourneyIdentifier {
                let matchReference = Database.database().reference().child("tourneys").child(tourneyId).child("matches").child(matchId)
                
                matchReference.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? NSDictionary {
                        let match = Match()
                        let active = value["active"] as? Int ?? 0
                        let challengerTeamId = value["challenger_team"] as? String ?? "Team not found"
                        let challengedTeamId = value["challenged_team"] as? String ?? "Team not found"
                        let challengerScores = value["challenger_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                        let challengedScores = value["challenged_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                        let submitter = value["submitter"] as? String ?? "No submitter yet"
                        let winner = value["winner"] as? String ?? "No winner yet"
                        let time = value["time"] as? Double ?? Date().timeIntervalSince1970
                        match.active = active
                        match.submitter = submitter
                        match.winner = winner
                        match.challengerTeamId = challengerTeamId
                        match.challengedTeamId = challengedTeamId
                        match.challengerScores = challengerScores
                        match.challengedScores = challengedScores
                        match.matchId = matchId
                        match.time = time
                        self.matches.append(match)
                        self.matches = self.matches.sorted { p1, p2 in
                            return (p1.time!) > (p2.time!)
                        }
                        //DispatchQueue.main.async { self.collectionView.reloadData() }
                    }
                    
                }, withCancel: nil)
            }
            
            
        }, withCancel: nil)
        
    }
    
    func observeAllTourneyMatches() {
        guard let tourneyId = tourneyIdentifier else {
            return
        }
        let ref = Database.database().reference().child("tourneys").child(tourneyId).child("matches").queryOrdered(byChild: "rank")
        ref.observe(.childAdded, with: { (snapshot) in
                    if let value = snapshot.value as? NSDictionary {
                        let match = Match()
                        let active = value["active"] as? Int ?? 0
                        let challengerTeamId = value["challenger_team"] as? String ?? "Team not found"
                        let challengedTeamId = value["challenged_team"] as? String ?? "Team not found"
                        let challengerScores = value["challenger_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                        let challengedScores = value["challenged_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                        let submitter = value["submitter"] as? String ?? "No submitter yet"
                        let winner = value["winner"] as? String ?? "No winner yet"
                        let time = value["time"] as? Double ?? Date().timeIntervalSince1970
                        match.active = active
                        match.submitter = submitter
                        match.winner = winner
                        match.challengerTeamId = challengerTeamId
                        match.challengedTeamId = challengedTeamId
                        match.challengerScores = challengerScores
                        match.challengedScores = challengedScores
                        match.matchId = snapshot.key
                        match.time = time
                        self.allMatches.append(match)
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
    
    private func setupTitle(active1: Int, tournName: String) {
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        active = active1
        titleLabel.text = "\(tournName)\n(registration period)"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        navigationItem.titleView = titleLabel
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
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        cell.tourneyIdentifier = tourneyIdentifier
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 35)
    }

}

