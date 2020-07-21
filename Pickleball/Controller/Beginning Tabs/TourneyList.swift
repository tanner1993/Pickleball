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
import FBSDKShareKit

class TourneyList: UITableViewController {

    var myTourneys = [Tourney]()
    let cellId = "cellId"
    var sender = 0
    let cellIdNone = "loading"
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    override func loadView() {
        super.loadView()
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        
    }
    
    var noNotifications = 0
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 88, g: 148, b: 200)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func loadUpMyCreatedTourneys(createdTourney: Tourney) {
        let tourneySearch = TourneySearch()
        tourneySearch.tourneyList = self
        tourneySearch.inviteTourneyId = "created"
        tourneySearch.searchResults.append(createdTourney)
        navigationController?.pushViewController(tourneySearch, animated: true)
    }
    
//    let localOfficialTourneys: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
//        label.textColor = .white
//        label.textAlignment = .center
//        label.text = "Official Tourneys Near You"
//        return label
//    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTourneys()
        setupNavbarButtons()
        setupCollectionView()
        setupViews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            self.fillInRow()
        }
    }
    
    func fillInRow() {
        if myTourneys.count == 0 {
            noNotifications = 1
            tableView.reloadData()
        }
    }
    
    func setupNavbarButtons() {
        let searchImage = UIImage(named: "search")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let plusImage = UIImage(named: "plus")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let searchButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearchTourneys))
        let createNewButton = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(handleCreateNewTourney))
        self.navigationItem.rightBarButtonItems = [searchButton, createNewButton]
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Official", style: .plain, target: self, action: #selector(handleOfficalTourneys))
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        titleLabel.text = "My Tourneys"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.navigationItem.titleView = titleLabel
    }
    
//    @objc func handleOfficalTourneys() {
//        let tourneyOfficial = TourneyList()
//        tourneyOfficial.hidesBottomBarWhenPushed = true
//        tourneyOfficial.sender = 1
//        navigationController?.pushViewController(tourneyOfficial, animated: true)
//    }
    
    @objc func handleSearchTourneys() {
        let tourneySearch = TourneySearch()
        tourneySearch.tourneyList = self
        navigationController?.pushViewController(tourneySearch, animated: true)
    }
    
    @objc func handleCreateNewTourney() {
        let newalert = UIAlertController(title: "Create Tourney", message: "What type of Tourney do you want to create", preferredStyle: UIAlertController.Style.alert)
        newalert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        newalert.addAction(UIAlertAction(title: "Ladder", style: UIAlertAction.Style.default, handler: handleLadder))
        newalert.addAction(UIAlertAction(title: "Round Robin", style: UIAlertAction.Style.default, handler: handleRoundRobin))
        self.present(newalert, animated: true, completion: nil)
    }
    
    func handleLadder(action: UIAlertAction) {
        let createTourney = CreateTourney()
        createTourney.tourneyList = self
        createTourney.modalPresentationStyle = .fullScreen
        present(createTourney, animated: true, completion: nil)
    }
    
    func handleRoundRobin(action: UIAlertAction) {
        let createTourney = CreateRoundRobinTourney()
        createTourney.tourneyList = self
        createTourney.modalPresentationStyle = .fullScreen
        present(createTourney, animated: true, completion: nil)
    }
    
    func setupViews() {
        
    }

    func fetchTourneys() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user_tourneys").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let tourneyId = snapshot.key
            let rootRef = Database.database().reference()
            let query = rootRef.child("tourneys").child(tourneyId)
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                //print(snapshot)
                if let value = snapshot.value as? [String: AnyObject] {
                    let tourney = Tourney()
                    let name = value["name"] as? String ?? "No Name"
                    let type = value["type"] as? String ?? "No Type"
                    let skillLevel = value["skill_level"] as? Float ?? 0
                    let sex = value["sex"] as? String ?? "None"
                    let ageGroup = value["age_group"] as? String ?? "No Age Group"
                    let startDate = value["start_date"] as? Double ?? 0
                    let time = value["time"] as? Double ?? Date().timeIntervalSince1970
                    let endDate = value["duration"] as? Double ?? 0
                    let creator = value["creator"] as? String ?? "No Creator"
                    let state = value["state"] as? String ?? "No State"
                    let county = value["county"] as? String ?? "No State"
                    let active = value["active"] as? Int ?? -1
                    let finals1 = value["finals1"] as? Int ?? -1
                    let finals2 = value["finals2"] as? Int ?? -1
                    let winner = value["winner"] as? Int ?? -1
                    let style = value["style"] as? Int ?? 1
                    let daysToPlay = value["daysToPlay"] as? Int ?? 3
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
                            let wins = index.value["wins"] as? Int ?? 0
                            let losses = index.value["losses"] as? Int ?? 0
                            let points = index.value["points"] as? Int ?? 0
                            team.player2 = player2Id
                            team.player1 = player1Id
                            team.rank = rank
                            team.wins = wins
                            team.losses = losses
                            team.teamId = index.key
                            team.points = points
                            teams3.append(team)
                        }
                        tourney.teams = teams3
                        tourney.regTeams = teams3.count
                    }
                    if let matches = value["matches"] as? [String: AnyObject] {
                        var matchesArray = [Match2]()
                        for index in matches {
                            let match = Match2()
                            let active = index.value["active"] as? Int ?? 0
                            let submitter = index.value["submitter"] as? Int ?? 0
                            let winner = index.value["winner"] as? Int ?? 0
                            let team_1_player_1 = index.value["team_1_player_1"] as? String ?? "Player not found"
                            let team_1_player_2 = index.value["team_1_player_2"] as? String ?? "Player not found"
                            let team_2_player_1 = index.value["team_2_player_1"] as? String ?? "Player not found"
                            let team_2_player_2 = index.value["team_2_player_2"] as? String ?? "Player not found"
                            let team1_scores = index.value["team1_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                            let team2_scores = index.value["team2_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                            let time = index.value["time"] as? Double ?? Date().timeIntervalSince1970
                            let style = index.value["style"] as? Int ?? 0
                            match.active = active
                            match.winner = winner
                            match.submitter = submitter
                            match.team_1_player_1 = team_1_player_1
                            match.team_1_player_2 = team_1_player_2
                            match.team_2_player_1 = team_2_player_1
                            match.team_2_player_2 = team_2_player_2
                            match.team1_scores = team1_scores
                            match.team2_scores = team2_scores
                            match.matchId = snapshot.key
                            match.time = time
                            match.style = style
                            match.doubles = true
                            match.matchId = index.key
                            matchesArray.append(match)
                        }
                        tourney.matches = matchesArray
                    }
                    
                    if let tourneyYetToView = value["yet_to_view"] as? [String] {
                        guard let uid = Auth.auth().currentUser?.uid else {
                            return
                        }
                        tourney.yetToView = tourneyYetToView
                        if tourneyYetToView.contains(uid) {
                            tourney.notifBubble = 1
                        }
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
                    self.myTourneys.append(tourney)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        }, withCancel: nil)
        
    }
    
//    func fetchOfficialTourneys() {
//        let rootRef = Database.database().reference()
//        let query = rootRef.child("tourneys")
//        query.observe(.childAdded, with: { (snapshot) in
//            print(snapshot)
//            if let value = snapshot.value as? [String: AnyObject] {
//                let tourney = Tourney()
//                let name = value["name"] as? String ?? "No Name"
//                let type = value["type"] as? String ?? "No Type"
//                let skillLevel = value["skill_level"] as? Float ?? 0
//                let sex = value["sex"] as? String ?? "None"
//                let ageGroup = value["age_group"] as? String ?? "No Age Group"
//                let startDate = value["start_date"] as? Double ?? 0
//                let time = value["time"] as? Double ?? Date().timeIntervalSince1970
//                let duration = value["duration"] as? Int ?? 0
//                let creator = value["creator"] as? String ?? "No Creator"
//                let state = value["state"] as? String ?? "No State"
//                let county = value["county"] as? String ?? "No State"
//                let active = value["active"] as? Int ?? -1
//                let finals1 = value["finals1"] as? Int ?? -1
//                let finals2 = value["finals2"] as? Int ?? -1
//                let winner = value["winner"] as? Int ?? -1
//                let official = value["official"] as? Int ?? -1
//                let teams = value["teams"]
//                if let turd = teams {
//                    tourney.regTeams = turd.count
//                } else {
//                    tourney.regTeams = 0
//                }
//
//                tourney.name = name
//                tourney.type = type
//                tourney.skill_level = skillLevel
//                tourney.id = snapshot.key
//                tourney.sex = sex
//                tourney.age_group = ageGroup
//                tourney.start_date = startDate
//                tourney.time = time
//                tourney.duration = duration
//                tourney.creator = creator
//                tourney.state = state
//                tourney.county = county
//                tourney.active = active
//                tourney.finals1 = finals1
//                tourney.finals2 = finals2
//                tourney.winner = winner
//                if official == 1 {
//                    self.myTourneys.append(tourney)
//                }
//
//                DispatchQueue.main.async { self.tableView.reloadData() }
//            }
//        })
//    }
    
    func setupCollectionView() {
        tableView?.register(TourneyCell.self, forCellReuseIdentifier: cellId)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellIdNone)
        tableView?.backgroundColor = .white
        self.tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTourneys.count == 0 ? 1 : myTourneys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if myTourneys.count == 0 {
            if noNotifications == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdNone, for: indexPath)
                cell.backgroundView = activityIndicatorView
                activityIndicatorView.startAnimating()
                return cell
            } else {
                activityIndicatorView.stopAnimating()
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdNone, for: indexPath)
                cell.textLabel?.text = "You are not registered for any tournaments yet.\nClick HERE for more info"
                cell.textLabel?.numberOfLines = 3
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.backgroundColor = UIColor(displayP3Red: 88/255, green: 148/255, blue: 200/255, alpha: 0.3)
                cell.textLabel?.layer.cornerRadius = 15
                cell.textLabel?.layer.masksToBounds = true
                return cell
            }
        } else {
            activityIndicatorView.stopAnimating()
            noNotifications = 1
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TourneyCell
            cell.tourney = myTourneys[indexPath.item]
            cell.editButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
            cell.editButton.tag = indexPath.item
            cell.invitePlayers.addTarget(self, action: #selector(handleInviteFriends), for: .touchUpInside)
            cell.invitePlayers.tag = indexPath.item
            cell.blueInfoSquare.addTarget(self, action: #selector(handleShowTourneyInfo), for: .touchUpInside)
            cell.blueInfoSquare.tag = indexPath.item
            if indexPath.item % 2 == 0 {
                cell.backgroundColor = UIColor(displayP3Red: 88/255, green: 148/255, blue: 200/255, alpha: 0.3)
            } else {
                cell.backgroundColor = .white
            }
            
            return cell
        }
    }
    
    @objc func handleShowTourneyInfo(sender: UIButton) {
        let tourneyInfo = TourneyInfo()
        tourneyInfo.tourney = myTourneys[sender.tag]
        navigationController?.present(tourneyInfo, animated: true, completion: nil)
    }
    
    @objc func handleInviteFriends(sender: UIButton) {
        let layout = UICollectionViewFlowLayout()
        let playerList = FindFriends(collectionViewLayout: layout)
        playerList.tourneyId = myTourneys[sender.tag].id ?? "none"
        playerList.whichTourney = sender.tag
        playerList.tourneyList = self
        playerList.tourneyOpenInvites = myTourneys[sender.tag].invites ?? ["none"]
        playerList.tourneySimpleInvites = myTourneys[sender.tag].simpleInvites ?? ["none"]
        playerList.sender = 5
        playerList.tourneyName = myTourneys[sender.tag].name ?? "none"
        playerList.simpleInvite = 1
        playerList.teams = myTourneys[sender.tag].teams ?? [Team]()
        navigationController?.present(playerList, animated: true, completion: nil)
    }
    
    @objc func handleEdit(sender: UIButton) {
        let tourneyIndex = sender.tag
        let tourneySelected = myTourneys[tourneyIndex]
        if tourneySelected.type == "Ladder" {
            let createTourney = CreateTourney()
            createTourney.sender = true
            createTourney.tourneyList = self
            createTourney.tourneyIndex = tourneyIndex
            createTourney.tourneyInfo = myTourneys[tourneyIndex]
            let indexPath = IndexPath(row: sender.tag, section: 0)
            let shareContent = SharePhoto()
            shareContent.image = tableView.cellForRow(at: indexPath)?.takeScreenshot()
            shareContent.isUserGenerated = true
            let sharePhotoContent = SharePhotoContent()
            sharePhotoContent.photos = [shareContent]
            createTourney.shareButton.shareContent = sharePhotoContent
            present(createTourney, animated: true, completion: nil)
        } else {
            let createTourney = CreateRoundRobinTourney()
            createTourney.sender = true
            createTourney.tourneyList = self
            createTourney.tourneyIndex = tourneyIndex
            createTourney.tourneyInfo = myTourneys[tourneyIndex]
            let indexPath = IndexPath(row: sender.tag, section: 0)
            let shareContent = SharePhoto()
            shareContent.image = tableView.cellForRow(at: indexPath)?.takeScreenshot()
            shareContent.isUserGenerated = true
            let sharePhotoContent = SharePhotoContent()
            sharePhotoContent.photos = [shareContent]
            createTourney.shareButton.shareContent = sharePhotoContent
            present(createTourney, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if myTourneys.count == 0 && noNotifications == 1 {
            let tourneyInfo = TourneyInfo()
            tourneyInfo.typeOfInfo = 1
            navigationController?.present(tourneyInfo, animated: true, completion: nil)
        } else {
            handleViewTourney(whichRowSelected: indexPath.row)
        }
    }
    
    func handleViewTourney(whichRowSelected: Int) {
        if myTourneys[whichRowSelected].type == "Ladder" {
            let layout = UICollectionViewFlowLayout()
            let tourneyStandingsPage = TourneyStandings(collectionViewLayout: layout)
            tourneyStandingsPage.hidesBottomBarWhenPushed = true
            tourneyStandingsPage.tourneyListIndex = whichRowSelected
            tourneyStandingsPage.thisTourney = myTourneys[whichRowSelected]
            let teams = myTourneys[whichRowSelected].teams ?? [Team]()
            let sortedTeams = teams.sorted { p1, p2 in
                return (p1.rank!) < (p2.rank!)
            }
            tourneyStandingsPage.teams = sortedTeams
            tourneyStandingsPage.tourneyListPage = self
            navigationController?.pushViewController(tourneyStandingsPage, animated: true)
        } else {
            myTourneys[whichRowSelected].setupRoundRobinWeekChallenges()
            let layout = UICollectionViewFlowLayout()
            let roundRobinPage = RoundRobinStandings(collectionViewLayout: layout)
            roundRobinPage.hidesBottomBarWhenPushed = true
            roundRobinPage.roundRobinTourney = myTourneys[whichRowSelected]
            roundRobinPage.tourneyListIndex = whichRowSelected
            let teams = myTourneys[whichRowSelected].teams ?? [Team]()
            let sortedTeams = teams.sorted { p1, p2 in
                return (p1.points!, -p1.rank!) > (p2.points!, -p2.rank!)
            }
            roundRobinPage.teams = sortedTeams
            roundRobinPage.tourneyListPage = self
            navigationController?.pushViewController(roundRobinPage, animated: true)
        }
        disableNotification(tourneyIndex: whichRowSelected)
    }
    
    func disableNotification(tourneyIndex: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("user_tourneys").child(uid).child(myTourneys[tourneyIndex].id!).setValue(0)
    }
    
    func removeBadge(whichOne: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        myTourneys[whichOne].notifBubble = 0
        let yettooooview = myTourneys[whichOne].yetToView!
        myTourneys[whichOne].yetToView?.remove(at: yettooooview.firstIndex(of: uid)!)
        tableView.reloadData()
    }
    
    func changeTourneyYetToView(yetToViewNew: [String], whichOne: Int) {
        myTourneys[whichOne].notifBubble = 0
        myTourneys[whichOne].yetToView = yetToViewNew
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

class TourneyCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tourney: Tourney? {
        didSet {
            
            if tourney?.notifBubble == 1 {
                notifBadge.isHidden = false
            } else {
                notifBadge.isHidden = true
            }
            
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            if uid == tourney?.creator {
                editButton.isHidden = false
            } else {
                editButton.isHidden = true
            }
            
            if uid == tourney?.creator && tourney?.active == 0 {
                invitePlayers.isHidden = false
                registrationPeriod.isHidden = true
            } else {
                invitePlayers.isHidden = true
                registrationPeriod.isHidden = false
            }
            
            let attrbReg = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 20), NSAttributedString.Key.foregroundColor : tourney?.active == 0 ? UIColor.green : UIColor.red]
            
            let normalRegistration = "Registration is: "
            let boldRegistration = tourney?.active == 0 ? "OPEN" : "CLOSED"
            let attributedRegistration = NSMutableAttributedString(string: normalRegistration)
            let boldRegistrationString = NSAttributedString(string: boldRegistration, attributes: attrbReg as [NSAttributedString.Key : Any])
            attributedRegistration.append(boldRegistrationString)
            
            registrationPeriod.attributedText = attributedRegistration
            
            let normalSkill = "Skill Level: "
            let boldSkill = "\(tourney?.skill_level ?? 0)"
            let attributedSkill = NSMutableAttributedString(string: normalSkill)
            let attrb = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 20), NSAttributedString.Key.foregroundColor : UIColor.init(r: 88, g: 148, b: 200)]
            let boldSkillString = NSAttributedString(string: boldSkill, attributes: attrb as [NSAttributedString.Key : Any])
            attributedSkill.append(boldSkillString)
            tournamentName.text = tourney?.name
            sexAndType.text = "\(tourney?.sex ?? "none") Doubles"
            skillLevel.attributedText = attributedSkill
            
            let normalType = "Type: "
            let boldType = "\(tourney?.type ?? "None")"
            let attributedType = NSMutableAttributedString(string: normalType)
            let boldTypeString = NSAttributedString(string: boldType, attributes: attrb as [NSAttributedString.Key : Any])
            attributedType.append(boldTypeString)
            
            type.attributedText = attributedType
            
            let normalTime = "Start Date: "
            let attributedTime = NSMutableAttributedString(string: normalTime)
            
            let normalState = "State: "
            let boldState = "\(tourney?.state ?? "No State")"
            let attributedState = NSMutableAttributedString(string: normalState)
            let boldStateString = NSAttributedString(string: boldState, attributes: attrb as [NSAttributedString.Key : Any])
            attributedState.append(boldStateString)
            state.attributedText = attributedState
            
            let normalCounty = "County: "
            let boldCounty = "\(tourney?.county ?? "No County")"
            let attributedCounty = NSMutableAttributedString(string: normalCounty)
            let boldCountyString = NSAttributedString(string: boldCounty, attributes: attrb as [NSAttributedString.Key : Any])
            attributedCounty.append(boldCountyString)
            county.attributedText = attributedCounty
            
            guard let endTime = tourney?.start_date else {
                return
            }
            let adjustedEndTime = endTime + (86400*35)
            let normalTime2 = "End Date: "
            let calendar2 = Calendar.current
            let startDater2 = Date(timeIntervalSince1970: adjustedEndTime)
            let components2 = calendar2.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: startDater2)
            let monthInt2 = components2.month!
            let monthAbb2 = months[monthInt2 - 1].prefix(3)
            let boldTime2 = "\(monthAbb2). \(components2.day!)"
            let attributedTime2 = NSMutableAttributedString(string: normalTime2)
            let boldTimeString2 = NSAttributedString(string: boldTime2, attributes: attrb as [NSAttributedString.Key : Any])
            attributedTime2.append(boldTimeString2)
            duration.attributedText = attributedTime2
            
            let normalReg = "Reg. Teams: "
            let boldReg = "\(tourney?.regTeams ?? 0)"
            let attributedReg = NSMutableAttributedString(string: normalReg)
            let boldRegString = NSAttributedString(string: boldReg, attributes: attrb as [NSAttributedString.Key : Any])
            attributedReg.append(boldRegString)
            registered.attributedText = attributedReg
            
            guard let startTime = tourney?.start_date else {
                return
            }
            let calendar = Calendar.current
            let startDater = Date(timeIntervalSince1970: startTime)
            let components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: startDater)
            let monthInt = components.month!
            let monthAbb = months[monthInt - 1].prefix(3)
            let boldTime = "\(monthAbb). \(components.day!)"
            let boldTimeString = NSAttributedString(string: boldTime, attributes: attrb as [NSAttributedString.Key : Any])
            attributedTime.append(boldTimeString)
            startDate.attributedText = attributedTime
        }
    }
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let invitePlayers: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Invite players to register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    let registrationPeriod: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        return label
    }()
    
    let notifBadge: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.layer.cornerRadius = 14
        label.layer.masksToBounds = true
        label.backgroundColor = .red
        label.text = "1"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let tournamentName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tourney Name"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 26)
        label.textAlignment = .center
        return label
    }()
    
    let sexAndType: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mens\nDoubles"
        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textAlignment = .left
        return label
    }()
    
    let skillLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.textAlignment = .left
        return label
    }()
    
    let type: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.textAlignment = .left
        return label
    }()
    
    let startDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.textAlignment = .left
        return label
    }()
    
    let state: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.textAlignment = .left
        return label
    }()
    
    let county: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.textAlignment = .left
        return label
    }()
    
    let duration: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.textAlignment = .left
        return label
    }()
    
    let registered: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.textAlignment = .left
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
    
    let infoImage: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.isUserInteractionEnabled = false
        bi.image = UIImage(named: "infoIBlue")
        return bi
    }()
    
    let blueInfoSquare: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupViews() {
        addSubview(tournamentName)
        tournamentName.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        tournamentName.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        tournamentName.heightAnchor.constraint(equalToConstant: 34).isActive = true
        tournamentName.widthAnchor.constraint(equalTo: widthAnchor, constant: -80).isActive = true
        
        addSubview(editButton)
        editButton.rightAnchor.constraint(equalTo: tournamentName.leftAnchor).isActive = true
        editButton.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        editButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        addSubview(infoImage)
        infoImage.leftAnchor.constraint(equalTo: tournamentName.rightAnchor, constant: 3).isActive = true
        infoImage.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        infoImage.heightAnchor.constraint(equalToConstant: 34).isActive = true
        infoImage.widthAnchor.constraint(equalToConstant: 34).isActive = true
        
        addSubview(blueInfoSquare)
        blueInfoSquare.leftAnchor.constraint(equalTo: tournamentName.rightAnchor, constant: 5).isActive = true
        blueInfoSquare.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        blueInfoSquare.heightAnchor.constraint(equalToConstant: 34).isActive = true
        blueInfoSquare.widthAnchor.constraint(equalToConstant: 34).isActive = true
        
        addSubview(notifBadge)
        notifBadge.rightAnchor.constraint(equalTo: blueInfoSquare.leftAnchor, constant: -4).isActive = true
        notifBadge.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        notifBadge.heightAnchor.constraint(equalToConstant: 28).isActive = true
        notifBadge.widthAnchor.constraint(equalToConstant: 28).isActive = true
        
        addSubview(sexAndType)
        sexAndType.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        sexAndType.topAnchor.constraint(equalTo: tournamentName.bottomAnchor, constant: 2).isActive = true
        sexAndType.heightAnchor.constraint(equalToConstant: 30).isActive = true
        sexAndType.rightAnchor.constraint(equalTo: centerXAnchor, constant: -2).isActive = true
        
        addSubview(skillLevel)
        skillLevel.leftAnchor.constraint(equalTo: sexAndType.leftAnchor).isActive = true
        skillLevel.topAnchor.constraint(equalTo: sexAndType.bottomAnchor, constant: 2).isActive = true
        skillLevel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        skillLevel.rightAnchor.constraint(equalTo: sexAndType.rightAnchor).isActive = true
        
        addSubview(type)
        type.leftAnchor.constraint(equalTo: sexAndType.leftAnchor).isActive = true
        type.topAnchor.constraint(equalTo: skillLevel.bottomAnchor, constant: 2).isActive = true
        type.heightAnchor.constraint(equalToConstant: 30).isActive = true
        type.rightAnchor.constraint(equalTo: sexAndType.rightAnchor).isActive = true
        
        addSubview(startDate)
        startDate.leftAnchor.constraint(equalTo: sexAndType.leftAnchor).isActive = true
        startDate.topAnchor.constraint(equalTo: type.bottomAnchor, constant: 2).isActive = true
        startDate.heightAnchor.constraint(equalToConstant: 30).isActive = true
        startDate.rightAnchor.constraint(equalTo: sexAndType.rightAnchor).isActive = true
        
        addSubview(duration)
        duration.leftAnchor.constraint(equalTo: centerXAnchor, constant: 4).isActive = true
        duration.topAnchor.constraint(equalTo: tournamentName.bottomAnchor, constant: 2).isActive = true
        duration.heightAnchor.constraint(equalToConstant: 30).isActive = true
        duration.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).isActive = true
        
        addSubview(state)
        state.leftAnchor.constraint(equalTo: duration.leftAnchor).isActive = true
        state.topAnchor.constraint(equalTo: sexAndType.bottomAnchor, constant: 2).isActive = true
        state.heightAnchor.constraint(equalToConstant: 30).isActive = true
        state.rightAnchor.constraint(equalTo: duration.rightAnchor).isActive = true
        
        addSubview(county)
        county.leftAnchor.constraint(equalTo: duration.leftAnchor).isActive = true
        county.topAnchor.constraint(equalTo: skillLevel.bottomAnchor, constant: 2).isActive = true
        county.heightAnchor.constraint(equalToConstant: 30).isActive = true
        county.rightAnchor.constraint(equalTo: duration.rightAnchor).isActive = true
        
        addSubview(registered)
        registered.leftAnchor.constraint(equalTo: duration.leftAnchor).isActive = true
        registered.topAnchor.constraint(equalTo: type.bottomAnchor, constant: 2).isActive = true
        registered.heightAnchor.constraint(equalToConstant: 30).isActive = true
        registered.rightAnchor.constraint(equalTo: duration.rightAnchor).isActive = true
        
        addSubview(invitePlayers)
        invitePlayers.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        invitePlayers.topAnchor.constraint(equalTo: registered.bottomAnchor, constant: 2).isActive = true
        invitePlayers.heightAnchor.constraint(equalToConstant: 30).isActive = true
        invitePlayers.widthAnchor.constraint(equalTo: widthAnchor, constant: -100).isActive = true
        
        addSubview(registrationPeriod)
        registrationPeriod.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        registrationPeriod.topAnchor.constraint(equalTo: registered.bottomAnchor, constant: 2).isActive = true
        registrationPeriod.heightAnchor.constraint(equalToConstant: 30).isActive = true
        registrationPeriod.widthAnchor.constraint(equalTo: widthAnchor, constant: -100).isActive = true
        
        addSubview(verticalSeparatorView)
        verticalSeparatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        verticalSeparatorView.topAnchor.constraint(equalTo: sexAndType.topAnchor).isActive = true
        verticalSeparatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView.bottomAnchor.constraint(equalTo: startDate.bottomAnchor, constant: -12).isActive = true
        
        addSubview(separatorView)
        separatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
}
