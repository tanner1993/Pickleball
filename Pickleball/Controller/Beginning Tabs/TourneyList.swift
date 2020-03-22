//
//  TourneyList.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/24/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class TourneyList: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var tourneys = [Tourney]()
    let cellId = "cellId"
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 88, g: 148, b: 200)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let localOfficialTourneys: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Official Tourneys Near You"
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTourneys()
        setupCollectionView()
        setupViews()
        setupNavbarButtons()
        setupMyTourneysCollectionView()

    }
    
    func setupNavbarButtons() {
        let searchImage = UIImage(named: "search")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let plusImage = UIImage(named: "plus")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let searchButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearchTourneys))
        let createNewButton = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(handleCreateNewTourney))
        self.navigationItem.rightBarButtonItems = [searchButton, createNewButton]
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        titleLabel.text = "My Tourneys"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.navigationItem.titleView = titleLabel
    }
    
    @objc func handleSearchTourneys() {
        let layout = UICollectionViewFlowLayout()
        let tourneySearch = TourneySearch(collectionViewLayout: layout)
        tourneySearch.tourneyList = self
        tourneySearch.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(tourneySearch, animated: true)
    }
    
    @objc func handleCreateNewTourney() {
        let createTourney = CreateTourney()
        createTourney.tourneyList = self
        present(createTourney, animated: true, completion: nil)
    }
    
    func setupViews() {
        view.addSubview(myTourneysCollectionView)
        myTourneysCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        myTourneysCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myTourneysCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        myTourneysCollectionView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        view.addSubview(separatorView)
        separatorView.bottomAnchor.constraint(equalTo: myTourneysCollectionView.bottomAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        view.addSubview(inputsContainerView)
        inputsContainerView.topAnchor.constraint(equalTo: myTourneysCollectionView.bottomAnchor).isActive = true
        inputsContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        inputsContainerView.addSubview(localOfficialTourneys)
        localOfficialTourneys.topAnchor.constraint(equalTo: myTourneysCollectionView.bottomAnchor).isActive = true
        localOfficialTourneys.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        localOfficialTourneys.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        localOfficialTourneys.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    func fetchTourneys() {
        let rootRef = Database.database().reference()
        let query = rootRef.child("tourneys")
        query.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
                if let value = snapshot.value as? [String: AnyObject] {
                    let tourney = Tourney()
                    let name = value["name"] as? String ?? "No Name"
                    let type = value["type"] as? String ?? "No Type"
                    let skillLevel = value["skill_level"] as? Float ?? 0
                    let sex = value["sex"] as? String ?? "None"
                    let ageGroup = value["age_group"] as? String ?? "No Age Group"
                    let startDate = value["start_date"] as? Double ?? 0
                    let duration = value["duration"] as? Int ?? 0
                    let creator = value["creator"] as? String ?? "No Creator"
                    let state = value["state"] as? String ?? "No State"
                    let county = value["county"] as? String ?? "No State"
                    let active = value["active"] as? Int ?? -1
                    let finals1 = value["finals1"] as? Int ?? -1
                    let finals2 = value["finals2"] as? Int ?? -1
                    let winner = value["winner"] as? Int ?? -1
                    
                    tourney.name = name
                    tourney.type = type
                    tourney.skill_level = skillLevel
                    tourney.id = snapshot.key
                    tourney.sex = sex
                    tourney.age_group = ageGroup
                    tourney.start_date = startDate
                    tourney.duration = duration
                    tourney.creator = creator
                    tourney.state = state
                    tourney.county = county
                    tourney.active = active
                    tourney.finals1 = finals1
                    tourney.finals2 = finals2
                    tourney.winner = winner
                    self.tourneys.append(tourney)
                    
                    DispatchQueue.main.async { self.collectionView.reloadData() }
                }
        })
    }
    
    func setupCollectionView() {
        collectionView?.register(TourneyCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return tourneys.count
        } else {
            return 3
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TourneyCell
            cell.tourney = tourneys[indexPath.item]
            if indexPath.item % 2 == 0 {
                cell.backgroundColor = UIColor(displayP3Red: 88/255, green: 148/255, blue: 200/255, alpha: 0.3)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myCellId, for: indexPath) as! TourneyCell
            if indexPath.item % 2 == 0 {
                cell.backgroundColor = UIColor(displayP3Red: 88/255, green: 148/255, blue: 200/255, alpha: 0.3)
            }
            //cell.playerName.text = menuItems[indexPath.item]
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let layout = UICollectionViewFlowLayout()
            let tourneyStandingsPage = TourneyStandings(collectionViewLayout: layout)
            tourneyStandingsPage.hidesBottomBarWhenPushed = true
            tourneyStandingsPage.tourneyIdentifier = tourneys[indexPath.item].id
            tourneyStandingsPage.active = tourneys[indexPath.item].active ?? -1
            tourneyStandingsPage.finals1 = tourneys[indexPath.item].finals1 ?? -1
            tourneyStandingsPage.finals2 = tourneys[indexPath.item].finals2 ?? -1
            tourneyStandingsPage.winner = tourneys[indexPath.item].winner ?? -1
            navigationController?.pushViewController(tourneyStandingsPage, animated: true)
        } else {
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    let myTourneysCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let menuItems = ["Logout", "Edit Profile", "Poop"]
    
    func setupMyTourneysCollectionView() {
        myTourneysCollectionView.dataSource = self
        myTourneysCollectionView.delegate = self
        myTourneysCollectionView.register(TourneyCell.self, forCellWithReuseIdentifier: myCellId)
    }
    
    let myCellId = "myCellId"

}

class TourneyCell: BaseCell {
    var tourney: Tourney? {
        didSet {
            tournamentName.text = tourney?.name
            sexAndType.text = "\(tourney?.sex ?? "none")\nDoubles"
            levelAndFormat.text = "\(tourney?.skill_level ?? 0)\n\(tourney?.type ?? "None")"
            
            guard let startTime = tourney?.start_date else {
                return
            }
            let calendar = Calendar.current
            let startDater = Date(timeIntervalSince1970: startTime)
            let components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: startDater)
            let monthInt = components.month!
            let monthAbb = months[monthInt - 1].prefix(3)
            startDate.text = "\(monthAbb). \(components.day!)\n\(tourney?.state ?? "No State"), \(tourney?.county ?? "No County")"
        }
    }
    
    let tournamentName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tourney Name"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    let sexAndType: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mens\nDoubles"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let levelAndFormat: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "3.5\nLadder"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let startDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Start Date\nJanuary 15"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    let verticalSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let verticalSeparatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        addSubview(tournamentName)
        tournamentName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        tournamentName.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        tournamentName.heightAnchor.constraint(equalToConstant: 24).isActive = true
        tournamentName.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        addSubview(sexAndType)
        sexAndType.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        sexAndType.topAnchor.constraint(equalTo: tournamentName.bottomAnchor, constant: 2).isActive = true
        sexAndType.heightAnchor.constraint(equalToConstant: 45).isActive = true
        sexAndType.widthAnchor.constraint(equalToConstant: (frame.width-16) / 3).isActive = true
        
        addSubview(levelAndFormat)
        levelAndFormat.leftAnchor.constraint(equalTo: sexAndType.rightAnchor, constant: 4).isActive = true
        levelAndFormat.topAnchor.constraint(equalTo: tournamentName.bottomAnchor, constant: 2).isActive = true
        levelAndFormat.heightAnchor.constraint(equalToConstant: 45).isActive = true
        levelAndFormat.widthAnchor.constraint(equalToConstant: (frame.width-16) / 3).isActive = true
        
        addSubview(startDate)
        startDate.leftAnchor.constraint(equalTo: levelAndFormat.rightAnchor, constant: 4).isActive = true
        startDate.topAnchor.constraint(equalTo: tournamentName.bottomAnchor, constant: 2).isActive = true
        startDate.heightAnchor.constraint(equalToConstant: 45).isActive = true
        startDate.widthAnchor.constraint(equalToConstant: (frame.width-16) / 3).isActive = true
        
        addSubview(verticalSeparatorView)
        verticalSeparatorView.rightAnchor.constraint(equalTo: sexAndType.rightAnchor, constant: 2).isActive = true
        verticalSeparatorView.centerYAnchor.constraint(equalTo: sexAndType.centerYAnchor).isActive = true
        verticalSeparatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView.heightAnchor.constraint(equalTo: sexAndType.heightAnchor, constant: -12).isActive = true
        
        addSubview(verticalSeparatorView2)
        verticalSeparatorView2.rightAnchor.constraint(equalTo: levelAndFormat.rightAnchor, constant: 2).isActive = true
        verticalSeparatorView2.centerYAnchor.constraint(equalTo: sexAndType.centerYAnchor).isActive = true
        verticalSeparatorView2.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView2.heightAnchor.constraint(equalTo: sexAndType.heightAnchor, constant: -12).isActive = true
        
        addSubview(separatorView)
        separatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
}
