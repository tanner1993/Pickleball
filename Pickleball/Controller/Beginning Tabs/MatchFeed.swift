//
//  MatchFeed.swift
//  Pickleball
//
//  Created by Tanner Rozier on 3/26/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

private let cellId = "cellId"

class MatchFeed: UITableViewController {
    
    var matches = [Match2]()
    var player = Player()
    var noNotifications = 0
    let cellIdNone = "loading"
    var sender = 0
    var nameTracker = [String: String]()
    var levelTracker = [String: String]()
    var matchIds = [String]()
    var matchNotifs = [Bool]()
    var matchDeletionIndex = Int()
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    override func loadView() {
        super.loadView()
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            self.fillInRow()
        }
        view.backgroundColor = .white
        if sender == 0 {
            fetchMatches()
        } else {
            fetchMyMatches()
        }
        setupNavbarTitle()
        tableView?.register(FeedMatchCell.self, forCellReuseIdentifier: cellId)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellIdNone)
        tableView?.backgroundColor = .white
        self.tableView.separatorStyle = .none
        
        if sender == 1 {
            tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 45, right: 0)
            tableView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 45, right: 0)
            setupFindOpponents()
        }
    }
    
    func setupFindOpponents() {
        view.addSubview(findOpponents)
        findOpponents.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        findOpponents.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        findOpponents.heightAnchor.constraint(equalToConstant: 45).isActive = true
        findOpponents.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    let findOpponents: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = .white
        button.setTitle("Find opponents in your area", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleFindOpponents), for: .touchUpInside)
        return button
    }()
    
    @objc func handleFindOpponents() {
        let layout = UICollectionViewFlowLayout()
        let opponentsList = OpponentsList(collectionViewLayout: layout)
        opponentsList.matchFeed = self
        //opponentsList.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(opponentsList, animated: true)
    }
    
    func fillInRow() {
        if matches.count == 0 {
            noNotifications = 1
            tableView.reloadData()
        }
    }

    func setupNavbarTitle() {
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        if sender == 0 {
            titleLabel.text = "News Feed"
        } else {
            titleLabel.text = "My Matches"
            let plusImage = UIImage(named: "plus")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            let createNewButton = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(handleCreateNewMatch))
            self.navigationItem.rightBarButtonItem = createNewButton
        }
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.navigationItem.titleView = titleLabel
    }
    
    @objc func handleSort() {
        self.matches = self.matches.sorted { p1, p2 in
            return (p1.time!) > (p2.time!)
        }
        self.tableView.reloadData()
    }
    
    @objc func handleCreateNewMatch() {
        let createNewMatch = CreateMatch()
        createNewMatch.matchFeed = self
        createNewMatch.modalPresentationStyle = .fullScreen
        navigationController?.present(createNewMatch, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count == 0 ? 1 : matches.count
    }

//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return matches.count
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if matches.count == 0 {
            if noNotifications == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdNone, for: indexPath)
                cell.backgroundView = activityIndicatorView
                activityIndicatorView.startAnimating()
                return cell
            } else {
                activityIndicatorView.stopAnimating()
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdNone, for: indexPath)
                if sender == 0 {
                    cell.textLabel?.text = "No Match News"
                } else {
                    cell.textLabel?.text = "You do not have any matches yet. Click the PLUS in the top right to create a match or click the 'Find opponents in your area' button below"
                    cell.textLabel?.numberOfLines = 5
                    cell.textLabel?.textAlignment = .center
                    cell.textLabel?.backgroundColor = UIColor(displayP3Red: 88/255, green: 148/255, blue: 200/255, alpha: 0.3)
                    cell.textLabel?.layer.cornerRadius = 15
                    cell.textLabel?.layer.masksToBounds = true
                }
                cell.textLabel?.textAlignment = .center
                return cell
            }
        } else {
            activityIndicatorView.stopAnimating()
            noNotifications = 1
            let match = matches[indexPath.item]
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FeedMatchCell
            if sender == 0 {
                cell.headerLabel.isHidden = true
                cell.selectCourtButton.isHidden = true
                cell.courtLabel.isHidden = false
                cell.whiteBoxTopAnchor?.isActive = false
                cell.whiteBoxTopAnchor = cell.whiteBox.topAnchor.constraint(equalTo: cell.timeStamp.bottomAnchor)
                cell.whiteBoxTopAnchor?.isActive = true
            } else {
                cell.whiteBoxTopAnchor?.isActive = false
                cell.whiteBoxTopAnchor = cell.whiteBox.topAnchor.constraint(equalTo: cell.headerLabel.bottomAnchor)
                cell.whiteBoxTopAnchor?.isActive = true
                cell.courtLabel.isHidden = true
                cell.headerLabel.isHidden = false
                if match.active == 3 {
                    cell.headerLabelRightAnchor?.isActive = false
                    cell.headerLabelRightAnchor = cell.headerLabel.rightAnchor.constraint(equalTo: cell.centerXAnchor, constant: -8)
                    cell.headerLabelRightAnchor?.isActive = true
                    cell.selectCourtButton.isHidden = false
                } else {
                    cell.selectCourtButton.isHidden = true
                    cell.headerLabelRightAnchor?.isActive = false
                    cell.headerLabelRightAnchor = cell.headerLabel.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -4)
                    cell.headerLabelRightAnchor?.isActive = true
                }
            }
            if nameTracker[match.team_1_player_1 ?? "nope"] == nil {
                let player1ref = Database.database().reference().child("users").child(match.team_1_player_1 ?? "nope")
                player1ref.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? [String: AnyObject] {
                        cell.challengerTeam1.setTitle(self.getFirstAndLastInitial(name: value["name"] as? String ?? "none"), for: .normal)
                        self.nameTracker[match.team_1_player_1 ?? "nope"] = self.getFirstAndLastInitial(name: value["name"] as? String ?? "none")
                        let exp = value["exp"] as? Int ?? 0
                        cell.appLevel.text = "\(self.player.haloLevel(exp: exp))"
                        self.levelTracker[match.team_1_player_1 ?? "nope"] = "\(self.player.haloLevel(exp: exp))"
                    }
                })
            } else {
                cell.challengerTeam1.setTitle(nameTracker[match.team_1_player_1 ?? "nope"], for: .normal)
                cell.appLevel.text = levelTracker[match.team_1_player_1 ?? "nope"]
            }
            if match.doubles == true {
                if match.team_1_player_2 == "Guest" {
                    cell.challengerTeam2.setTitle("Guest Player", for: .normal)
                    cell.appLevel2.text = ""
                    cell.challengerTeam2.isUserInteractionEnabled = false
                } else {
                    if nameTracker[match.team_1_player_2 ?? "nope"] == nil {
                        let player2ref = Database.database().reference().child("users").child(match.team_1_player_2 ?? "nope")
                        player2ref.observeSingleEvent(of: .value, with: {(snapshot) in
                            if let value = snapshot.value as? [String: AnyObject] {
                                cell.challengerTeam2.setTitle(self.getFirstAndLastInitial(name: value["name"] as? String ?? "none"), for: .normal)
                                self.nameTracker[match.team_1_player_2 ?? "nope"] = self.getFirstAndLastInitial(name: value["name"] as? String ?? "none")
                                let exp = value["exp"] as? Int ?? 0
                                cell.appLevel2.text = "\(self.player.haloLevel(exp: exp))"
                                self.levelTracker[match.team_1_player_2 ?? "nope"] = "\(self.player.haloLevel(exp: exp))"
                            }
                        })
                    } else {
                        cell.challengerTeam2.setTitle(nameTracker[match.team_1_player_2 ?? "nope"], for: .normal)
                        cell.appLevel2.text = levelTracker[match.team_1_player_2 ?? "nope"]
                    }
                }
                cell.challengerTeam2.isHidden = false
                cell.appLevel2.isHidden = false
            } else {
                cell.challengerTeam2.isHidden = true
                cell.appLevel2.isHidden = true
            }
            
            if nameTracker[match.team_2_player_1 ?? "nope"] == nil {
                let player1ref2 = Database.database().reference().child("users").child(match.team_2_player_1 ?? "nope")
                player1ref2.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? [String: AnyObject] {
                        cell.challengedTeam1.setTitle(self.getFirstAndLastInitial(name: value["name"] as? String ?? "none"), for: .normal)
                        self.nameTracker[match.team_2_player_1 ?? "nope"] = self.getFirstAndLastInitial(name: value["name"] as? String ?? "none")
                        let exp = value["exp"] as? Int ?? 0
                        cell.appLevel3.text = "\(self.player.haloLevel(exp: exp))"
                        self.levelTracker[match.team_2_player_1 ?? "nope"] = "\(self.player.haloLevel(exp: exp))"
                    }
                })
            } else {
                cell.challengedTeam1.setTitle(nameTracker[match.team_2_player_1 ?? "nope"], for: .normal)
                cell.appLevel3.text = levelTracker[match.team_2_player_1 ?? "nope"]
            }
            
            if match.doubles == true {
                if match.team_2_player_2 == "Guest" {
                    cell.challengedTeam2.setTitle("Guest Player", for: .normal)
                    cell.challengedTeam2.isUserInteractionEnabled = false
                    cell.appLevel4.text = ""
                } else {
                    if nameTracker[match.team_2_player_2 ?? "nope"] == nil {
                        let player2ref2 = Database.database().reference().child("users").child(match.team_2_player_2 ?? "nope")
                        player2ref2.observeSingleEvent(of: .value, with: {(snapshot) in
                            if let value = snapshot.value as? [String: AnyObject] {
                                cell.challengedTeam2.setTitle(self.getFirstAndLastInitial(name: value["name"] as? String ?? "none"), for: .normal)
                                self.nameTracker[match.team_2_player_2 ?? "nope"] = self.getFirstAndLastInitial(name: value["name"] as? String ?? "none")
                                let exp = value["exp"] as? Int ?? 0
                                cell.appLevel4.text = "\(self.player.haloLevel(exp: exp))"
                                self.levelTracker[match.team_2_player_2 ?? "nope"] = "\(self.player.haloLevel(exp: exp))"
                            }
                        })
                    } else {
                        cell.challengedTeam2.setTitle(nameTracker[match.team_2_player_2 ?? "nope"], for: .normal)
                        cell.appLevel4.text = levelTracker[match.team_2_player_2 ?? "nope"]
                    }
                }
                cell.challengedTeam2.isHidden = false
                cell.appLevel4.isHidden = false
            } else {
                cell.challengedTeam2.isHidden = true
                cell.appLevel4.isHidden = true
            }
            let uid = Auth.auth().currentUser?.uid
            if match.active == 3 {
                if match.winner == 1 {
                    cell.challengerPlaceholder.image = UIImage(named: "winning_team_placeholder2")
                    cell.challengedPlaceholder.image = UIImage(named: "challenger_team_placeholder")
                } else if match.winner == 2 {
                    cell.challengerPlaceholder.image = UIImage(named: "challenger_team_placeholder")
                    cell.challengedPlaceholder.image = UIImage(named: "winning_team_placeholder2")
                }
            } else {
                if uid == match.team_1_player_1 || uid == match.team_1_player_2 {
                    cell.challengerPlaceholder.image = UIImage(named: "user_team_placeholder")
                    cell.challengedPlaceholder.image = UIImage(named: "plain_team_placeholder")
                } else if uid == match.team_2_player_1 || uid == match.team_2_player_2 {
                    cell.challengerPlaceholder.image = UIImage(named: "plain_team_placeholder")
                    cell.challengedPlaceholder.image = UIImage(named: "user_team_placeholder")
                } else {
                    cell.challengerPlaceholder.image = UIImage(named: "plain_team_placeholder")
                    cell.challengedPlaceholder.image = UIImage(named: "plain_team_placeholder")
                }
            }
            
            cell.editButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
            cell.editButton.tag = indexPath.item
            
            cell.selectCourtButton.addTarget(self, action: #selector(openCourtInfo), for: .touchUpInside)
            cell.selectCourtButton.tag = indexPath.item
            
            cell.challengerTeam1.tag = indexPath.item
            cell.challengerTeam1.addTarget(self, action: #selector(self.handleViewPlayer), for: .touchUpInside)
            cell.challengerTeam2.tag = indexPath.item
            cell.challengerTeam2.addTarget(self, action: #selector(self.handleViewPlayer2), for: .touchUpInside)
            cell.challengedTeam1.tag = indexPath.item
            cell.challengedTeam1.addTarget(self, action: #selector(self.handleViewPlayer3), for: .touchUpInside)
            cell.challengedTeam2.tag = indexPath.item
            cell.challengedTeam2.addTarget(self, action: #selector(self.handleViewPlayer4), for: .touchUpInside)
                    
            cell.match = match
            cell.backgroundColor = UIColor.white
            return cell
        }
    }
    
    let selectCourtInfo = SelectCourtInfo()
    let infoBackgroundHeight = 440
    let blackView = UIView()
    var matchCourtIndex = Int()
    
    @objc func openCourtInfo(sender: UIButton) {
        matchCourtIndex = sender.tag
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu4)))
            window.addSubview(blackView)
            window.addSubview(selectCourtInfo)
            selectCourtInfo.frame = CGRect(x: 24, y: window.frame.height, width: window.frame.width - 48, height: CGFloat(infoBackgroundHeight))
            selectCourtInfo.layer.cornerRadius = 10
            selectCourtInfo.layer.masksToBounds = true
            selectCourtInfo.courtSelectionLabel.text = "Enter in the court you played at if you'd like others to know!"
            selectCourtInfo.updateCourt.addTarget(self, action: #selector(handleUpdateCourt), for: .touchUpInside)
            selectCourtInfo.dontShowCourt.addTarget(self, action: #selector(handleDontShowCourt), for: .touchUpInside)
            blackView.frame = window.frame
            blackView.alpha = 0

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
             self.selectCourtInfo.frame = CGRect(x: 24, y: window.frame.height - CGFloat(self.infoBackgroundHeight + 140), width: window.frame.width - 48, height: CGFloat(self.infoBackgroundHeight))
            }, completion: nil)

        }
    }
    
    @objc func dismissMenu4() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
             self.selectCourtInfo.frame = CGRect(x: 24, y: window.frame.height, width: window.frame.width - 48, height: CGFloat(self.infoBackgroundHeight))
            }
        })
        selectCourtInfo.courtNameTextField.resignFirstResponder()
    }
    
    @objc func handleUpdateCourt() {
        guard let courtName = selectCourtInfo.courtNameTextField.text else {
            return
        }
        if courtName.count < 3 || courtName.count > 25 {
            let newalert = UIAlertController(title: "Sorry", message: "Invalid Court Name. Must be between 3 and 25 characters", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        } else {
            Database.database().reference().child("matches").child(matches[matchCourtIndex].matchId!).child("court").setValue(courtName)
            matches[matchCourtIndex].court = courtName
            tableView.reloadData()
//            profileView.selectCourtButton.setTitle(courtName, for: .normal)
//            profileView.selectCourtButton.setTitleColor(.black, for: .normal)
        }
        dismissMenu4()
    }
    
    @objc func handleDontShowCourt() {
        Database.database().reference().child("matches").child(matches[matchCourtIndex].matchId!).child("court").setValue("none")
        matches[matchCourtIndex].court = "none"
        tableView.reloadData()
//        profileView.selectCourtButton.setTitle("No Court Selected", for: .normal)
//        profileView.selectCourtButton.setTitleColor(UIColor(r: 150, g: 150, b: 150), for: .normal)
        dismissMenu4()
    }
    
    func getFirstAndLastInitial(name: String) -> String {
        var initials = ""
        var finalChar = 0
        for char in name {
            if finalChar == 0 {
                initials.append(char)
            }
            if finalChar == 1 {
                initials.append(char)
                initials.append(".")
                break
            }

            if char == " " {
                finalChar = 1
            }
        }
        return initials
    }
    
    @objc func handleDelete(sender: UIButton) {
        matchDeletionIndex = sender.tag
        let newalert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this Match?", preferredStyle: UIAlertController.Style.alert)
        newalert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        newalert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: handleDeleteConfirmed))
        self.present(newalert, animated: true, completion: nil)
    }
    
    func handleDeleteConfirmed(action: UIAlertAction) {
        let matchToDelete = matches[matchDeletionIndex]
        var referencesNeedDeletion = [String]()
        if matchToDelete.doubles == true {
            referencesNeedDeletion.append(matchToDelete.team_1_player_2!)
            referencesNeedDeletion.append(matchToDelete.team_2_player_2!)
        }
        referencesNeedDeletion.append(matchToDelete.team_1_player_1!)
        referencesNeedDeletion.append(matchToDelete.team_2_player_1!)
        for index in referencesNeedDeletion {
            Database.database().reference().child("user_matches").child(index).child(matchToDelete.matchId!).removeValue()
        }
        Database.database().reference().child("matches").child(matchToDelete.matchId!).removeValue()
        matches.remove(at: matchDeletionIndex)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if matches.count > 0 {
            if sender == 1 {
                let matchDisplay = MatchView()
                matchDisplay.matchId = matches[indexPath.item].matchId ?? "none"
                matchDisplay.match = matches[indexPath.item]
                matchDisplay.whichItem = indexPath.item
                matchDisplay.matchFeed = self
                navigationController?.pushViewController(matchDisplay, animated: true)
                if matches[indexPath.item].seen == false {
                    disableNotification(matchIndex: indexPath.item)
                }
            }
        }
    }
    
    func disableNotification(matchIndex: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("user_matches").child(uid).child(matches[matchIndex].matchId!).setValue(0)
        matches[matchIndex].seen = true
        matchNotifs[matchIndex] = true
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if sender == 1 {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sender == 0 {
            return view.frame.width / 1.875 + 66
        } else {
            return view.frame.width / 1.875 + 66
        }
    }
    
    @objc func handleViewPlayer(sender: UIButton) {
        let whichOne = sender.tag
        let playerProfile = StartupPage()
        playerProfile.hidesBottomBarWhenPushed = true
        playerProfile.playerId = matches[whichOne].team_1_player_1!
        playerProfile.isFriend = 3
        navigationController?.pushViewController(playerProfile, animated: true)
    }
    
    @objc func handleViewPlayer2(sender: UIButton) {
        let whichOne = sender.tag
        let playerProfile = StartupPage()
        playerProfile.hidesBottomBarWhenPushed = true
        playerProfile.playerId = matches[whichOne].team_1_player_2!
        playerProfile.isFriend = 3
        navigationController?.pushViewController(playerProfile, animated: true)
    }
    
    @objc func handleViewPlayer3(sender: UIButton) {
        let whichOne = sender.tag
        let playerProfile = StartupPage()
        playerProfile.hidesBottomBarWhenPushed = true
        playerProfile.playerId = matches[whichOne].team_2_player_1!
        playerProfile.isFriend = 3
        navigationController?.pushViewController(playerProfile, animated: true)
    }
    
    @objc func handleViewPlayer4(sender: UIButton) {
        let whichOne = sender.tag
        let playerProfile = StartupPage()
        playerProfile.hidesBottomBarWhenPushed = true
        playerProfile.playerId = matches[whichOne].team_2_player_2!
        playerProfile.isFriend = 3
        navigationController?.pushViewController(playerProfile, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if sender == 0 {
//            return nil
//        }
//    }
    
//    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
//    func fetchMatches() {
//        let ref = Database.database().reference().child("completed_matches").queryLimited(toLast: 10)
//        ref.observe(.childAdded, with: { (snapshot) in
//                if let value = snapshot.value as? NSDictionary {
//                    let matchT = Match2()
//                    let active = value["active"] as? Int ?? 0
//                    let submitter = value["submitter"] as? Int ?? 0
//                    let winner = value["winner"] as? Int ?? 0
//                    let team_1_player_1 = value["team_1_player_1"] as? String ?? "Player not found"
//                    let team_1_player_2 = value["team_1_player_2"] as? String ?? "Player not found"
//                    let team_2_player_1 = value["team_2_player_1"] as? String ?? "Player not found"
//                    let team_2_player_2 = value["team_2_player_2"] as? String ?? "Player not found"
//                    let team1_scores = value["team1_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
//                    let team2_scores = value["team2_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
//                    let time = value["time"] as? Double ?? Date().timeIntervalSince1970
//                    let style = value["style"] as? Int ?? 0
//                    let forfeit = value["forfeit"] as? Int ?? 0
//                    matchT.active = active
//                    matchT.winner = winner
//                    matchT.submitter = submitter
//                    matchT.team_1_player_1 = team_1_player_1
//                    matchT.team_1_player_2 = team_1_player_2
//                    matchT.team_2_player_1 = team_2_player_1
//                    matchT.team_2_player_2 = team_2_player_2
//                    matchT.team1_scores = team1_scores
//                    matchT.team2_scores = team2_scores
//                    matchT.matchId = snapshot.key
//                    matchT.time = time
//                    matchT.style = style
//                    matchT.forfeit = forfeit
//                    matchT.doubles = team_1_player_2 == "Player not found" ? false : true
//                    self.matches.append(matchT)
//                    self.matches = self.matches.sorted { p1, p2 in
//                        return (p1.time!) > (p2.time!)
//                    }
//                    DispatchQueue.main.async { self.tableView.reloadData()}
//                }
//        }, withCancel: nil)
//    }
    
    func fetchMatches() {
        let ref = Database.database().reference().child("matches").queryOrdered(byChild: "active").queryEqual(toValue: 3).queryLimited(toLast: 10)
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
                    let team1_scores = value["team1_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                    let team2_scores = value["team2_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                    let time = value["time"] as? Double ?? Date().timeIntervalSince1970
                    let style = value["style"] as? Int ?? 0
                    let forfeit = value["forfeit"] as? Int ?? 0
                    let court = value["court"] as? String ?? "none"
                    matchT.court = court
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
                    matchT.style = style
                    matchT.forfeit = forfeit
                    matchT.doubles = team_1_player_2 == "Player not found" ? false : true
                    self.matches.append(matchT)
                    self.matches = self.matches.sorted { p1, p2 in
                        return (p1.time!) > (p2.time!)
                    }
                    DispatchQueue.main.async { self.tableView.reloadData()}
                }
        }, withCancel: nil)
    }
    
    func fetchMyMatches() {
        for (index, element) in matchIds.enumerated() {
            let rootRef = Database.database().reference()
            let query = rootRef.child("matches").child(element)
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    let matchT = Match2()
                    let active = value["active"] as? Int ?? 0
                    let submitter = value["submitter"] as? Int ?? 0
                    let winner = value["winner"] as? Int ?? 0
                    let style = value["style"] as? Int ?? 0
                    let team_1_player_1 = value["team_1_player_1"] as? String ?? "Player not found"
                    let team_1_player_2 = value["team_1_player_2"] as? String ?? "Player not found"
                    let team_2_player_1 = value["team_2_player_1"] as? String ?? "Player not found"
                    let team_2_player_2 = value["team_2_player_2"] as? String ?? "Player not found"
                    let team1_scores = value["team1_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                    let team2_scores = value["team2_scores"] as? [Int] ?? [1, 1, 1, 1, 1]
                    let time = value["time"] as? Double ?? Date().timeIntervalSince1970
                    let forfeit = value["forfeit"] as? Int ?? 0
                    let court = value["court"] as? String ?? "none"
                    matchT.court = court
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
                    matchT.forfeit = forfeit
                    matchT.style = style
                    matchT.doubles = team_1_player_2 == "Player not found" ? false : true
                    matchT.seen = self.matchNotifs[index] == true ? true : false
                    let currentTime = Date().timeIntervalSince1970
                    if (time + Double(86400 * 31)) < currentTime {
                        self.deleteMatchExpiration(matchToDelete: matchT)
                    } else {
                        self.matches.append(matchT)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }, withCancel: nil)
        }
    }
    
    func deleteMatchExpiration(matchToDelete: Match2) {
        var referencesNeedDeletion = [String]()
        if matchToDelete.doubles == true {
            referencesNeedDeletion.append(matchToDelete.team_1_player_2!)
            referencesNeedDeletion.append(matchToDelete.team_2_player_2!)
        }
        referencesNeedDeletion.append(matchToDelete.team_1_player_1!)
        referencesNeedDeletion.append(matchToDelete.team_2_player_1!)
        for index in referencesNeedDeletion {
            Database.database().reference().child("user_matches").child(index).child(matchToDelete.matchId!).removeValue()
        }
        Database.database().reference().child("matches").child(matchToDelete.matchId!).removeValue()
    }

}
