//
//  RoundRobinStandings.swift
//  Pickleball
//
//  Created by Tanner Rozier on 7/5/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase


class RoundRobinStandings: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var tourneyListPage: TourneyList?
    var tourneyOpenInvites = [String]()
    var roundRobinTourney = Tourney()
    let cellId = "cellId"
    let cellId2 = "cellId2"
    var teams = [Team]()
    var tourneyListIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupTitle()
        setupNavBarButtons()
        setupTourneyMenuBar()
        
        if roundRobinTourney.yetToView == nil {
            roundRobinTourney.yetToView = [String]()
        }
        makeBubble()
    }
    
    func makeBubble() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        if roundRobinTourney.yetToView?.contains(uid) ?? false {
            notifBadge.isHidden = false
        }
    }
    
    func destroyBubble() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        if roundRobinTourney.yetToView?.contains(uid) ?? false {
            notifBadge.isHidden = true
            let yetToView = roundRobinTourney.yetToView!
            roundRobinTourney.yetToView?.remove(at: (yetToView.firstIndex(of: uid)!))
            Database.database().reference().child("tourneys").child(roundRobinTourney.id!).child("yet_to_view").setValue(roundRobinTourney.yetToView!)
            tourneyListPage?.changeTourneyYetToView(yetToViewNew: roundRobinTourney.yetToView!, whichOne: tourneyListIndex)
        }
    }
    
    func setupNavBarButtons() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        if roundRobinTourney.invites?.contains(uid) != true {
            if teams.count >= 6 {
                
            } else {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(handleEnterTourney))
            }
        } else if roundRobinTourney.invites?.contains(uid) == true && roundRobinTourney.active ?? 1 == 0 {
            navigationItem.rightBarButtonItem = nil
        }
        if roundRobinTourney.active ?? 1 > 0 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(handleRefreshList))
        }
    }
    
    private func setupTitle() {
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        titleLabel.text = "\(roundRobinTourney.name ?? "none")\nClick here for more info"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(handleShowTourneyInfo))
        titleLabel.addGestureRecognizer(labelTap)
        titleLabel.isUserInteractionEnabled = true
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        navigationItem.titleView = titleLabel
    }

    @objc func handleRefreshList() {
        let currentItem = collectionView.indexPathsForVisibleItems[0].item
        if currentItem == 0 {
            observeTourneyTeams()
        }
    }
    
    func observeTourneyTeams() {
        roundRobinTourney.observeTourneyTeams(rank: false, completion:{ (result) in
            guard let teamResults = result else {
                print("failed to get rresult")
                return
            }
            self.teams = teamResults
            self.collectionView.reloadData()
        })
    }
    
    @objc func handleEnterTourney() {
        let layout = UICollectionViewFlowLayout()
        let playerList = FindFriends(collectionViewLayout: layout)
        playerList.tourneyId = roundRobinTourney.id ?? "none"
        playerList.tourneyName = roundRobinTourney.name ?? "none"
        playerList.tourneyOpenInvites = tourneyOpenInvites
        playerList.roundRobinStandings = self
        playerList.tourneyType = roundRobinTourney.type ?? "Round Robin"
        playerList.startTime = roundRobinTourney.start_date ?? 0
        playerList.sender = 5
        playerList.teams = teams
        navigationController?.present(playerList, animated: true, completion: nil)
        
    }
    
    @objc func handleShowTourneyInfo() {
        let tourneyInfo = TourneyInfo()
        tourneyInfo.tourney = roundRobinTourney
        navigationController?.present(tourneyInfo, animated: true, completion: nil)
    }
    
    private func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(WeekStackView.self, forCellWithReuseIdentifier: cellId2)
        
        
        collectionView?.backgroundColor = UIColor.init(displayP3Red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
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
        
    }
    
    lazy var menusBar: RoundRobinMenuBar = {
        let mb = RoundRobinMenuBar()
        mb.roundRobinStandings = self
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
        notifBadge.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        notifBadge.topAnchor.constraint(equalTo: menusBar.topAnchor, constant: 1).isActive = true
        notifBadge.widthAnchor.constraint(equalToConstant: 16).isActive = true
        notifBadge.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menusBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 2
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        menusBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition:[])
        
        //setTitleForIndex(index: Int(index))
        
    }
    
    //MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! WeekStackView
            for (index, element) in [cell.week1Button, cell.week2Button, cell.week3Button, cell.week4Button, cell.week5Button].enumerated() {
                element.addTarget(self, action: #selector(openWeekMatches), for: .touchUpInside)
                element.tag = index + 1
            }
            cell.tourneyId = roundRobinTourney.id!
            destroyBubble()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
            cell.teams = teams
            //cell.delegate = self
            cell.type = roundRobinTourney.type!
            cell.active = roundRobinTourney.active ?? 0
            cell.tourneyIdentifier = roundRobinTourney.id
            cell.tourneyName = roundRobinTourney.name!
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 35)
    }
    
    //MARK: - Targets
    
    @objc func openWeekMatches(sender: UIButton) {
        if roundRobinTourney.active == 0 {
            let newalert = UIAlertController(title: "Not yet!", message: "Once the tourney begins you will find your matches here!", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
        } else {
            let weeklyMatches = WeeklyMatches()
            weeklyMatches.tourney = roundRobinTourney
            weeklyMatches.week = sender.tag
            weeklyMatches.teams = teams
            navigationController?.pushViewController(weeklyMatches, animated: true)
        }
    }

}
