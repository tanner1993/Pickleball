//
//  TourneySearch.swift
//  Pickleball
//
//  Created by Tanner Rozier on 1/9/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class TourneySearch: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    let cellId2 = "cellId2"
    var tourneys = [Tourney]()
    var searchResults = [Tourney]()
    var textFields = [UITextField]()
    var dropDownButtons = [UIButton]()
    let blackView = UIView()
    var selectedDropDown = -1
    var buttonsCreated = 0
    var inviteTourneyId = "none"
    var myCreatedTourneys = false
    
    var tourneyList: TourneyList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.register(TourneyCell.self, forCellReuseIdentifier: cellId)
        
        if inviteTourneyId == "none" {
            setupFilterCollectionView()
            fetchTourneys()
            setupViews()
            tableView?.contentInset = UIEdgeInsets(top: 281, left: 0, bottom: 0, right: 0)
            tableView?.scrollIndicatorInsets = UIEdgeInsets(top: 281, left: 0, bottom: 0, right: 0)
        } else if inviteTourneyId == "created" {
            
        } else {
            fetchTourney()
        }
        
        tableView?.backgroundColor = .white
        self.tableView.separatorStyle = .none

    }
    
    @objc func resignResponders() {
        searchBar.resignFirstResponder()
        for index in textFields {
            index.resignFirstResponder()
        }
        self.view.endEditing(true)
    }
    
    func fetchTourney() {
        let rootRef = Database.database().reference()
        let query = rootRef.child("tourneys").child(inviteTourneyId)
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            if let value = snapshot.value as? [String: AnyObject] {
                let tourney = Tourney()
                let name = value["name"] as? String ?? "No Name"
                let type = value["type"] as? String ?? "No Type"
                let skillLevel = value["skill_level"] as? Float ?? 0
                let sex = value["sex"] as? String ?? "None"
                let ageGroup = value["age_group"] as? String ?? "No Age Group"
                let startDate = value["start_date"] as? Double ?? 0
                let time = value["time"] as? Double ?? 0
                let endDate = value["duration"] as? Double ?? 0
                let creator = value["creator"] as? String ?? "No Creator"
                let state = value["state"] as? String ?? "No State"
                let county = value["county"] as? String ?? "No State"
                let active = value["active"] as? Int ?? -1
                let finals1 = value["finals1"] as? Int ?? -1
                let finals2 = value["finals2"] as? Int ?? -1
                let winner = value["winner"] as? Int ?? -1
                let style = value["style"] as? Int ?? -1
                let daysToPlay = value["daysToPlay"] as? Int ?? -1
                let publicBool = value["public"] as? Bool ?? true
                tourney.daysToPlay = daysToPlay
                tourney.publicBool = publicBool
                if let teams = value["teams"] as? [String: AnyObject] {
                    var teams3 = [Team]()
                    for index in teams {
                        let team = Team()
                        let player1Id = index.value["player1"] as? String ?? "Player not found"
                        let player2Id = index.value["player2"] as? String ?? "Player not found"
                        let rank = index.value["rank"] as? Int ?? 100
                        let wins = index.value["wins"] as? Int ?? -1
                        let losses = index.value["losses"] as? Int ?? -1
                        team.player2 = player2Id
                        team.player1 = player1Id
                        team.rank = rank
                        team.wins = wins
                        team.losses = losses
                        team.teamId = index.key
                        teams3.append(team)
                    }
                    tourney.teams = teams3
                    tourney.regTeams = teams3.count
                }
                if let tourneyYetToView = value["yet_to_view"] as? [String] {
                    tourney.yetToView = tourneyYetToView
                }
                
                if let invites = value["invites"] as? [String] {
                    tourney.invites = invites
                } else {
                    tourney.invites = ["none"]
                }
                
                if let simpleInvites = value["simpleInvites"] as? [String] {
                    tourney.simpleInvites = simpleInvites
                } else {
                    tourney.simpleInvites = ["none"]
                }
                
                tourney.name = name
                tourney.type = type
                tourney.skill_level = skillLevel
                tourney.id = snapshot.key
                tourney.sex = sex
                tourney.age_group = ageGroup
                tourney.start_date = startDate
                tourney.time = time
                tourney.end_date = endDate
                tourney.creator = creator
                tourney.state = state
                tourney.county = county
                tourney.active = active
                tourney.finals1 = finals1
                tourney.finals2 = finals2
                tourney.winner = winner
                tourney.style = style
                self.searchResults.append(tourney)
                
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        })
    }
    
    @objc func handleSearchFilter() {
        searchBar.resignFirstResponder()
        searchResults = tourneys
//        if myCreatedTourneyCheck.isOn {
//            guard let uid = Auth.auth().currentUser?.uid else {
//                return
//            }
//            searchResults = searchResults.filter({ (tourney) -> Bool in
//                let creator = uid
//                return tourney.creator! == creator
//            })
//            tableView.reloadData()
//            return
//        }
        
        if textFields[0].text! != "Any" {
            searchResults = searchResults.filter({ (tourney) -> Bool in
                let skillLevel = Float(textFields[0].text!)
                return tourney.skill_level! == skillLevel
            })
        }
        if textFields[1].text! != "Any" {
        searchResults = searchResults.filter({ (tourney) -> Bool in
            let state = textFields[1].text!
            return tourney.state! == state
        })
        }
        if textFields[2].text! != "Any" {
        searchResults = searchResults.filter({ (tourney) -> Bool in
            let county = textFields[2].text!
            return tourney.county! == county
        })
        }
        if textFields[3].text! != "Any" {
        searchResults = searchResults.filter({ (tourney) -> Bool in
            let sex = textFields[3].text!
            return tourney.sex! == sex
        })
        }
        if textFields[4].text! != "Any" {
        searchResults = searchResults.filter({ (tourney) -> Bool in
            let age_group = textFields[4].text!
            return tourney.age_group! == age_group
        })
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TourneyCell
        cell.tourney = searchResults[indexPath.item]
        if indexPath.item % 2 == 0 {
            cell.backgroundColor = UIColor(displayP3Red: 88/255, green: 148/255, blue: 200/255, alpha: 0.3)
        } else {
            cell.backgroundColor = .white
        }
        cell.editButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        cell.editButton.tag = indexPath.item
        cell.blueInfoSquare.addTarget(self, action: #selector(handleShowTourneyInfo), for: .touchUpInside)
        cell.blueInfoSquare.tag = indexPath.item
        return cell
    }
    
    @objc func handleShowTourneyInfo(sender: UIButton) {
        let tourneyInfo = TourneyInfo()
        tourneyInfo.tourney = searchResults[sender.tag]
        navigationController?.present(tourneyInfo, animated: true, completion: nil)
    }
    
    @objc func handleEdit(sender: UIButton) {
        let tourneyIndex = sender.tag
        let createTourney = CreateTourney()
        createTourney.tourneySearch = self
        createTourney.tourneyIndex = tourneyIndex
        createTourney.sender = true
        createTourney.tourneyInfo = searchResults[tourneyIndex]
        present(createTourney, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == self.collectionView {
//            return CGSize(width: view.frame.width, height: 175)
//        } else {
            return CGSize(width: view.frame.width, height: 50)
        //}
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == self.collectionView {
//            return searchResults.count
//        } else {
            switch selectedDropDown {
            case 0:
                return skillLevels.count
            case 1:
                return states.count
            case 2:
                return counties.count
            case 3:
                return sexes.count
            case 4:
                return ageGroups.count
            default:
                return 0
            }
        //}
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        if collectionView == self.collectionView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TourneyCell
//            cell.tourney = searchResults[indexPath.item]
//
//            return cell
//        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! ProfileMenuCell
            switch selectedDropDown {
            case 0:
                cell.menuItem.text = "\(skillLevels[indexPath.item])"
            case 1:
                cell.menuItem.text = states[indexPath.item]
            case 2:
                cell.menuItem.text = counties[indexPath.item]
            case 3:
                cell.menuItem.text = sexes[indexPath.item]
            case 4:
                cell.menuItem.text = ageGroups[indexPath.item]
            default:
                return cell
            }
            return cell
       // }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let layout = UICollectionViewFlowLayout()
//        let tourneyStandingsPage = TourneyStandings(collectionViewLayout: layout)
//        tourneyStandingsPage.hidesBottomBarWhenPushed = true
//        tourneyStandingsPage.thisTourney = searchResults[indexPath.row]
//        let teams = searchResults[indexPath.row].teams ?? [Team]()
//        let sortedTeams = teams.sorted { p1, p2 in
//            return (p1.rank!) < (p2.rank!)
//        }
//        tourneyStandingsPage.teams = sortedTeams
//        navigationController?.pushViewController(tourneyStandingsPage, animated: true)
        let whichRowSelected = indexPath.item
        if searchResults[whichRowSelected].type == "Ladder" {
            let layout = UICollectionViewFlowLayout()
            let tourneyStandingsPage = TourneyStandings(collectionViewLayout: layout)
            tourneyStandingsPage.hidesBottomBarWhenPushed = true
            tourneyStandingsPage.thisTourney = searchResults[whichRowSelected]
            let teams = searchResults[whichRowSelected].teams ?? [Team]()
            let sortedTeams = teams.sorted { p1, p2 in
                return (p1.rank!) < (p2.rank!)
            }
            tourneyStandingsPage.teams = sortedTeams
            navigationController?.pushViewController(tourneyStandingsPage, animated: true)
        } else {
            searchResults[whichRowSelected].setupRoundRobinWeekChallenges()
            let layout = UICollectionViewFlowLayout()
            let roundRobinPage = RoundRobinStandings(collectionViewLayout: layout)
            roundRobinPage.hidesBottomBarWhenPushed = true
            roundRobinPage.roundRobinTourney = searchResults[whichRowSelected]
            let teams = searchResults[whichRowSelected].teams ?? [Team]()
            let sortedTeams = teams.sorted { p1, p2 in
                return (p1.points ?? 0, -p1.rank!) > (p2.points ?? 0, -p2.rank!)
            }
            roundRobinPage.teams = sortedTeams
            navigationController?.pushViewController(roundRobinPage, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == self.collectionView {
//            let layout = UICollectionViewFlowLayout()
//            let tourneyStandingsPage = TourneyStandings(collectionViewLayout: layout)
//            tourneyStandingsPage.thisTourney = searchResults[indexPath.item]
//            navigationController?.pushViewController(tourneyStandingsPage, animated: true)
//        } else {
            switch selectedDropDown {
            case 0:
                textFields[0].text = "\(skillLevels[indexPath.item])"
            case 1:
                textFields[1].text = states[indexPath.item]
            case 2:
                textFields[2].text = "\(counties[indexPath.item])"
            case 3:
                textFields[3].text = sexes[indexPath.item]
            case 4:
                textFields[4].text = ageGroups[indexPath.item]
            default:
                print("failed")
            }
            dismissMenu()
       // }
    }
    
    let whiteContainerView2: UIView = {
        let wc = UIView()
        wc.translatesAutoresizingMaskIntoConstraints = false
        wc.backgroundColor = .white
        return wc
    }()
    
    let filtersLabel: UILabel = {
        let fl = UILabel()
        fl.text = "Filters"
        fl.backgroundColor = .white
        fl.textColor = UIColor.init(r: 88, g: 148, b: 200)
        fl.font = UIFont(name: "AmericanTypewriter-Bold", size: 24)
        fl.textAlignment = .center
        fl.translatesAutoresizingMaskIntoConstraints = false
//        fl.isUserInteractionEnabled = true
//        let labelTap = UITapGestureRecognizer(target: self, action: #selector(resignResponders))
//        fl.addGestureRecognizer(labelTap)
        return fl
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        button.setTitle("Filter Tourneys", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSearchFilter), for: .touchUpInside)
        return button
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let inputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    let createdTourneysLabel: UILabel = {
//        let fl = UILabel()
//        fl.text = "Created"
//        fl.textColor = UIColor.init(r: 88, g: 148, b: 200)
//        fl.font = UIFont(name: "HelveticaNeue-Light", size: 18)
//        fl.adjustsFontSizeToFitWidth = true
//        fl.textAlignment = .center
//        fl.translatesAutoresizingMaskIntoConstraints = false
//        return fl
//    }()
//
//    let myCreatedTourneyCheck: UISwitch = {
//        let uiSwitch = UISwitch()
//        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
//        uiSwitch.addTarget(self, action: #selector(handleSwitchChanged), for: .valueChanged)
//        return uiSwitch
//    }()
    
//    @objc func handleSwitchChanged() {
//        searchBar.isHidden = myCreatedTourneyCheck.isOn ? true : false
//        whiteContainerView2.isHidden = myCreatedTourneyCheck.isOn ? true : false
//        whiteContainerView.isHidden = myCreatedTourneyCheck.isOn ? true : false
//        searchButton.isHidden = myCreatedTourneyCheck.isOn ? true : false
//        separatorView.isHidden = myCreatedTourneyCheck.isOn ? true : false
//        filtersLabel.isHidden = myCreatedTourneyCheck.isOn ? true : false
//        inputContainer.isHidden = myCreatedTourneyCheck.isOn ? true : false
//        tableView?.contentInset = myCreatedTourneyCheck.isOn ? UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0) : UIEdgeInsets(top: 281, left: 0, bottom: 0, right: 0)
//        tableView?.scrollIndicatorInsets = myCreatedTourneyCheck.isOn ? UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0) : UIEdgeInsets(top: 281, left: 0, bottom: 0, right: 0)
//        handleSearchFilter()
//    }
    

    let inputsArray = ["Skill Level", "State", "County", "Sex", "Age Group"]
    
    func setupViews() {
        
        view.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalToConstant: view.frame.width - 8).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        searchBar.delegate = self
        
        view.addSubview(whiteContainerView2)
        whiteContainerView2.topAnchor.constraint(equalTo: searchBar.topAnchor, constant: 0).isActive = true
        whiteContainerView2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        whiteContainerView2.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        whiteContainerView2.heightAnchor.constraint(equalToConstant: 281).isActive = true
        
        view.bringSubviewToFront(searchBar)
        
        whiteContainerView2.addSubview(filtersLabel)
        filtersLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4).isActive = true
        filtersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        filtersLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        filtersLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let inputBox = createInputContainer(topAnchor: filtersLabel, anchorConstant: 0, numberInputs: 5, vertSepDistance: 150, inputs: inputsArray, inputTypes: [1, 1, 1, 1, 1])
        textFields[0].text = "Any"
        textFields[1].text = "Any"
        textFields[2].text = "Any"
        textFields[3].text = "Any"
        textFields[4].text = "Any"
        
        view.addSubview(searchButton)
        searchButton.topAnchor.constraint(equalTo: inputBox.bottomAnchor, constant: 10).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: view.frame.width - 100).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(separatorView)
        separatorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 5).isActive = true
        separatorView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
//        view.addSubview(createdTourneysLabel)
//        createdTourneysLabel.topAnchor.constraint(equalTo: searchBar.topAnchor).isActive = true
//        createdTourneysLabel.leftAnchor.constraint(equalTo: searchBar.rightAnchor, constant: 4).isActive = true
//        createdTourneysLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        createdTourneysLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        view.addSubview(myCreatedTourneyCheck)
//        myCreatedTourneyCheck.topAnchor.constraint(equalTo: searchBar.topAnchor, constant: 9).isActive = true
//        myCreatedTourneyCheck.leftAnchor.constraint(equalTo: createdTourneysLabel.rightAnchor, constant: 1).isActive = true
//        myCreatedTourneyCheck.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        myCreatedTourneyCheck.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }

    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Name of tourney"
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.showsCancelButton = true
        return sb
    }()
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
                let time = value["time"] as? Double ?? 0
                let endDate = value["duration"] as? Double ?? 0
                let creator = value["creator"] as? String ?? "No Creator"
                let state = value["state"] as? String ?? "No State"
                let county = value["county"] as? String ?? "No State"
                let active = value["active"] as? Int ?? -1
                let finals1 = value["finals1"] as? Int ?? -1
                let finals2 = value["finals2"] as? Int ?? -1
                let winner = value["winner"] as? Int ?? -1
                let style = value["style"] as? Int ?? -1
                let daysToPlay = value["daysToPlay"] as? Int ?? -1
                let publicBool = value["public"] as? Bool ?? true
                tourney.daysToPlay = daysToPlay
                tourney.publicBool = publicBool
                if let teams = value["teams"] as? [String: AnyObject] {
                    var teams3 = [Team]()
                    for index in teams {
                        let team = Team()
                        let player1Id = index.value["player1"] as? String ?? "Player not found"
                        let player2Id = index.value["player2"] as? String ?? "Player not found"
                        let rank = index.value["rank"] as? Int ?? 100
                        let wins = index.value["wins"] as? Int ?? -1
                        let losses = index.value["losses"] as? Int ?? -1
                        team.player2 = player2Id
                        team.player1 = player1Id
                        team.rank = rank
                        team.wins = wins
                        team.losses = losses
                        team.teamId = index.key
                        teams3.append(team)
                    }
                    tourney.teams = teams3
                    tourney.regTeams = teams3.count
                }
                if let tourneyYetToView = value["yet_to_view"] as? [String] {
                    tourney.yetToView = tourneyYetToView
                }
                if let invites = value["invites"] as? [String] {
                    tourney.invites = invites
                } else {
                    tourney.invites = ["none"]
                }
                
                if let simpleInvites = value["simpleInvites"] as? [String] {
                    tourney.simpleInvites = simpleInvites
                } else {
                    tourney.simpleInvites = ["none"]
                }
                tourney.name = name
                tourney.type = type
                tourney.skill_level = skillLevel
                tourney.id = snapshot.key
                tourney.sex = sex
                tourney.age_group = ageGroup
                tourney.start_date = startDate
                tourney.time = time
                tourney.end_date = endDate
                tourney.creator = creator
                tourney.state = state
                tourney.county = county
                tourney.active = active
                tourney.finals1 = finals1
                tourney.finals2 = finals2
                tourney.winner = winner
                tourney.style = style
                if publicBool {
                    self.tourneys.append(tourney)
                }
                
                DispatchQueue.main.async {
                    self.searchResults = self.tourneys
                    self.tableView.reloadData()
                    
                }
            }
        })
    }
    
    let filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    func setupFilterCollectionView() {
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.register(ProfileMenuCell.self, forCellWithReuseIdentifier: cellId2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func handleDropDownFinish() {
        for index in textFields {
            index.resignFirstResponder()
        }
        self.view.endEditing(true)
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu)))
            window.addSubview(blackView)
            window.addSubview(filterCollectionView)
            filterCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 350)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.filterCollectionView.frame = CGRect(x: 0, y: window.frame.height - 350, width: window.frame.width, height: 350)
            }, completion: nil)
        }
    }
    
    @objc func dismissMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.filterCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 350)
            }
        })
    }
    
    @objc func handledropDown(sender: UIButton) {
        selectedDropDown = sender.tag
        filterCollectionView.reloadData()
        //collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: [], animated: false)
        handleDropDownFinish()
    }
    
    let states = ["Any", "Utah"]
    let counties = ["Any", "Beaver", "Box Elder", "Cache", "Carbon", "Daggett", "Davis", "Duchesne", "Emery", "Garfield", "Grand", "Iron", "Juab", "Kane", "Millard", "Morgan", "Piute", "Rich", "Salt Lake", "San Juan", "Sanpete", "Sevier", "Summit", "Tooele", "Uintah", "Utah", "Wasatch", "Washington", "Wayne", "Weber"]
    
    let types = ["Any", "Ladder"]
    let skillLevels = ["Any", "2.0", "2.5", "3.0", "3.5", "4.0", "4.5", "5.0"]
    let sexes = ["Any", "Mens", "Womens", "Mixed"]
    
    let ageGroups = ["Any", "0-18", "19 - 34", "35-49", "50+"]

}

extension TourneySearch: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text != "" {
            searchResults = tourneys.filter({ (tourney) -> Bool in
                guard let text = searchBar.text else {return false}
                return tourney.name!.localizedCaseInsensitiveContains(text)
            })
        } else {
            searchResults = tourneys
        }
        //handleFilter()
        tableView.reloadData()
        
    }
    
    
    func createInputContainer(topAnchor: UIView, anchorConstant: Int, numberInputs: Int, vertSepDistance: Int, inputs: [String], inputTypes: [Int]) -> UIView {
        
        view.addSubview(inputContainer)
        inputContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainer.topAnchor.constraint(equalTo: topAnchor.bottomAnchor, constant: CGFloat(anchorConstant)).isActive = true
        inputContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -12).isActive = true
        inputContainer.heightAnchor.constraint(equalToConstant: CGFloat(numberInputs * 30)).isActive = true
        
        var anchorShift = -30
        
        for (index, element) in inputs.enumerated() {
            anchorShift += 30
            let label: UILabel = {
                let lb = UILabel()
                lb.text = element
                lb.textColor = .white
                lb.translatesAutoresizingMaskIntoConstraints = false
                lb.font = UIFont(name: "HelveticaNeue", size: 15)
                return lb
            }()
            
            let textField: UITextField = {
                let tf = UITextField()
                tf.textColor = .white
                //tf.placeholder = "Name"
                //                if inputTypes[index] == 1 {
                //                    tf.is
                //                }
                tf.translatesAutoresizingMaskIntoConstraints = false
                tf.font = UIFont(name: "HelveticaNeue-Light", size: 15)
                return tf
            }()
            
            textFields.append(textField)
            
            let separatorView: UIView = {
                let view = UIView()
                view.backgroundColor = .white
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            let verticalSeparatorView: UIView = {
                let view = UIView()
                view.backgroundColor = .white
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            inputContainer.addSubview(label)
            label.leftAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: 12).isActive = true
            label.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: CGFloat(anchorShift)).isActive = true
            label.rightAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: CGFloat(vertSepDistance)).isActive = true
            label.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            inputContainer.addSubview(textField)
            textField.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 8).isActive = true
            textField.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
            textField.rightAnchor.constraint(equalTo: inputContainer.rightAnchor, constant: 4).isActive = true
            textField.heightAnchor.constraint(equalTo: label.heightAnchor).isActive = true
            
            if inputTypes[index] == 1 {
                buttonsCreated += 1
                let dropDown: UIButton = {
                    let button = UIButton(type: .system)
                    button.translatesAutoresizingMaskIntoConstraints = false
                    button.tag = buttonsCreated - 1
                    button.addTarget(self, action: #selector(handledropDown), for: .touchUpInside)
                    return button
                }()
                dropDownButtons.append(dropDown)
                
                inputContainer.addSubview(dropDownButtons[buttonsCreated - 1])
                dropDownButtons[buttonsCreated - 1].leftAnchor.constraint(equalTo: label.rightAnchor, constant: 8).isActive = true
                dropDownButtons[buttonsCreated - 1].topAnchor.constraint(equalTo: label.topAnchor).isActive = true
                dropDownButtons[buttonsCreated - 1].rightAnchor.constraint(equalTo: inputContainer.rightAnchor, constant: 4).isActive = true
                dropDownButtons[buttonsCreated - 1].heightAnchor.constraint(equalTo: label.heightAnchor).isActive = true
            }
            
            inputContainer.addSubview(separatorView)
            separatorView.leftAnchor.constraint(equalTo: inputContainer.leftAnchor).isActive = true
            separatorView.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
            separatorView.rightAnchor.constraint(equalTo: inputContainer.rightAnchor).isActive = true
            separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            inputContainer.addSubview(verticalSeparatorView)
            verticalSeparatorView.rightAnchor.constraint(equalTo: label.rightAnchor).isActive = true
            verticalSeparatorView.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
            verticalSeparatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
            verticalSeparatorView.heightAnchor.constraint(equalTo: label.heightAnchor, constant: -8).isActive = true
            
        }
        
        return inputContainer
        
    }
    
}


