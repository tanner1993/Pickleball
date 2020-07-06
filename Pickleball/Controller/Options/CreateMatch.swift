//
//  CreateMatch.swift
//  Pickleball
//
//  Created by Tanner Rozier on 3/3/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

class CreateMatch: UIViewController {
    
//    var activityIndicatorView: UIActivityIndicatorView!
//
//    override func loadView() {
//        super.loadView()
//
//        activityIndicatorView = UIActivityIndicatorView(style: .gray)
//
//    }
    
    struct player {
        var id: String
        var name: String
        var skillLevel: String
        var deviceId: String
    }
    var opponentChallenge = false
    var matchFeed: MatchFeed?
    var teammate = player(id: "none", name: "none", skillLevel: "none", deviceId: "none")
    var opponent1 = player(id: "none", name: "none", skillLevel: "none", deviceId: "none")
    var opponent2 = player(id: "none", name: "none", skillLevel: "none", deviceId: "none")
    var startupPage: StartupPage?
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let createLabel: UILabel = {
        let label = UILabel()
        label.text = "Invite your friends to play a match with you"
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    func getPlayerDetails() {
        if teammate.id != "none" {
            teammateLabel.text = teammate.name
            selectTeammateButton.setTitle("", for: .normal)
        }
        if opponent1.id != "none" {
            opponentLabel1.text = opponent1.name
            selectOpponentButton1.setTitle("", for: .normal)
        }
        if opponent2.id != "none" {
            opponentLabel2.text = opponent2.name
            selectOpponentButton2.setTitle("", for: .normal)
        }
    }
    
    func setupNavbarAndTitle() {
        view.addSubview(matchSymbol)
        matchSymbol.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        matchSymbol.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6).isActive = true
        matchSymbol.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -150).isActive = true
        matchSymbol.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        
        view.addSubview(createLabel)
        createLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createLabel.topAnchor.constraint(equalTo: matchSymbol.bottomAnchor, constant: 2).isActive = true
        createLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        if view.frame.width < 375 {
            createLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16)
            createLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        } else {
            createLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        }
        
        view.addSubview(cancelButton)
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSelectPlayer(sender: UIButton) {
        if sender.tag == 5 {
            teammateLabel.text = "Guest Player"
            selectTeammateButton.setTitle("", for: .normal)
            teammate.id = "Guest"
            teammate.name = "Guest Player"
            teammate.skillLevel = "Guest"
            teammate.deviceId = "Guest"
        } else if sender.tag == 6 {
            opponentLabel2.text = "Guest Player"
            selectOpponentButton2.setTitle("", for: .normal)
            opponent2.id = "Guest"
            opponent2.name = "Guest Player"
            opponent2.skillLevel = "Guest"
            opponent2.deviceId = "Guest"
        } else {
            let layout = UICollectionViewFlowLayout()
            let playerList = FindFriends(collectionViewLayout: layout)
            playerList.sender = sender.tag
            playerList.createMatch = self
            playerList.teammateId = teammate.id
            playerList.opp1Id = opponent1.id
            playerList.opp2Id = opponent2.id
            present(playerList, animated: true, completion: nil)
        }
    }
    
    @objc func handleCreateMatch() {
        if singlesDoublesControl.selectedSegmentIndex == 1 {
            if teammate.id == "none" || opponent1.id == "none" || opponent2.id == "none" {
                let createMatchFailed = UIAlertController(title: "Cannot create match", message: "Must choose 1 teammate and 2 opponents", preferredStyle: .alert)
                createMatchFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(createMatchFailed, animated: true, completion: nil)
                return
            }
        } else {
            if opponent1.id == "none" {
                let createMatchFailed = UIAlertController(title: "Cannot create match", message: "Must choose an opponent", preferredStyle: .alert)
                createMatchFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(createMatchFailed, animated: true, completion: nil)
                return
            }
        }
        let createMatchConfirmed = UIAlertController(title: "Successfully created the match", message: "Check 'My Matches' in the 'PLAY' tab to see it", preferredStyle: .alert)
        createMatchConfirmed.addAction(UIAlertAction(title: "OK", style: .default, handler: self.handleDismiss))
        self.present(createMatchConfirmed, animated: true, completion: nil)
        let uid = Auth.auth().currentUser!.uid
        let timeOfChallenge = Date().timeIntervalSince1970
        let ref = Database.database().reference().child("matches")
        let createMatchRef = ref.childByAutoId()
        var style = Int()
        switch matchesControl.selectedSegmentIndex {
        case 0:
            style = 0
        case 1:
            style = 1
        case 2:
            style = 2
        default:
            style = 0
        }
        var values = [String : Any]()
        var teammateGuestValue = 0
        var opponentGuestValue = 0
        teammateGuestValue = teammate.id == "Guest" ? 1 : 0
        opponentGuestValue = opponent2.id == "Guest" ? 1 : 0
        if singlesDoublesControl.selectedSegmentIndex == 1 {
            values = ["active": 0, "team_1_player_1": uid, "team_1_player_2": teammate.id, "team_2_player_1": opponent1.id, "team_2_player_2": opponent2.id, "team1_scores": [1, teammateGuestValue, 0, opponentGuestValue, 0], "team2_scores": [0, 0, 0, 0, 0], "time": timeOfChallenge, "style": style]
        } else {
            values = ["active": 0, "team_1_player_1": uid, "team_2_player_1": opponent1.id, "team1_scores": [1, 0, 0, 0, 0], "team2_scores": [0, 0, 0, 0, 0], "time": timeOfChallenge, "style": style]
        }
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
            let notificationsRef = Database.database().reference().child("user_matches")
            
            var childUpdates = [String : Any]()
            if self.singlesDoublesControl.selectedSegmentIndex == 1 {
                if self.teammate.id == "Guest" && self.opponent2.id == "Guest" {
                    childUpdates = ["/\(uid)/\(notificationId)/": 0, "/\(self.opponent1.id)/\(notificationId)/": 1]
                } else if self.teammate.id == "Guest" {
                    childUpdates = ["/\(uid)/\(notificationId)/": 0, "/\(self.opponent1.id)/\(notificationId)/": 1, "/\(self.opponent2.id)/\(notificationId)/": 1]
                } else if self.opponent2.id == "Guest" {
                    childUpdates = ["/\(uid)/\(notificationId)/": 0, "/\(self.teammate.id)/\(notificationId)/": 1, "/\(self.opponent1.id)/\(notificationId)/": 1]
                } else {
                    childUpdates = ["/\(uid)/\(notificationId)/": 0, "/\(self.teammate.id)/\(notificationId)/": 1, "/\(self.opponent1.id)/\(notificationId)/": 1, "/\(self.opponent2.id)/\(notificationId)/": 1]
                }
            } else {
                childUpdates = ["/\(uid)/\(notificationId)/": 0, "/\(self.opponent1.id)/\(notificationId)/": 1]
            }
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
                Database.database().reference().child("users").child(uid).child("name").observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value {
                        let nameOnInvite = value as? String ?? "none"
                        let pusher = PushNotificationHandler()
                        if self.singlesDoublesControl.selectedSegmentIndex == 1 {
                            pusher.setupPushNotification(deviceId: self.teammate.deviceId, message: "\(nameOnInvite) invited you to play in a match with them", title: "Match Invite")
                            pusher.setupPushNotification(deviceId: self.opponent2.deviceId, message: "\(nameOnInvite) invited you to play in a match with them", title: "Match Invite")
                        }
                        pusher.setupPushNotification(deviceId: self.opponent1.deviceId, message: "\(nameOnInvite) invited you to play in a match with them", title: "Match Invite")
                    }
                })
                let matchT = Match2()
                matchT.active = 0
                matchT.winner = 0
                matchT.submitter = 0
                matchT.team_1_player_1 = uid
                matchT.team_1_player_2 = self.teammate.id
                matchT.team_2_player_1 = self.opponent1.id
                matchT.team_2_player_2 = self.opponent2.id
                matchT.team1_scores = [1, teammateGuestValue, 0, opponentGuestValue, 0]
                matchT.team2_scores = [0, 0, 0, 0, 0]
                matchT.matchId = matchId
                matchT.time = timeOfChallenge
                matchT.style = style
                matchT.forfeit = 0
                if self.singlesDoublesControl.selectedSegmentIndex == 1 {
                    matchT.doubles = true
                } else {
                    matchT.doubles = false
                    matchT.team_1_player_2 = "Player not found"
                    matchT.team_2_player_2 = "Player not found"
                }
                self.matchFeed?.matches.insert(matchT, at: 0)
                self.startupPage?.createdMatch = matchT
                self.matchFeed?.tableView.reloadData()
                
                
            })
            
        })
    }
    
    func handleDismiss(action: UIAlertAction) {
        dismiss(animated: true, completion: nil)
        startupPage?.popStartup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.startAnimating()
        setupNavbarAndTitle()
        view.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        setupViews()
    }
    
    let createMatchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Match Invitations", for: .normal)
        button.layer.shadowOpacity = 0.4
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 28)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCreateMatch), for: .touchUpInside)
        button.setTitleShadowColor(.black, for: .normal)
        return button
    }()
    
    let matchSymbol: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.image = UIImage(named: "match_symbol")
        bi.isUserInteractionEnabled = true
        return bi
    }()

    let inputsContainerViewTeam1: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let userNameLabel: UILabel = {
        let lb = UILabel()
        //lb.text = "loading..."
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        lb.textAlignment = .center
        lb.textColor = .black
        return lb
    }()
    
    let activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separatorView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let vsLabel: UILabel = {
        let lb = UILabel()
        lb.text = "VS"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        lb.textAlignment = .center
        lb.textColor = .white
        return lb
    }()
    
    let inputsContainerViewTeam2: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let selectTeammateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Teammate", for: .normal)
        button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 2
        button.addTarget(self, action: #selector(handleSelectPlayer), for: .touchUpInside)
        return button
    }()
    
    let teammateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        return label
    }()
    
    let guestTeammateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("USE\nGUEST", for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.tag = 5
        button.addTarget(self, action: #selector(handleSelectPlayer), for: .touchUpInside)
        return button
    }()
    
    let selectOpponentButton1: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Opponent 1", for: .normal)
        button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 3
        button.addTarget(self, action: #selector(handleSelectPlayer), for: .touchUpInside)
        return button
    }()
    
    let opponentLabel1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        return label
    }()
    
    let selectOpponentButton2: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Opponent 2", for: .normal)
        button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 4
        button.addTarget(self, action: #selector(handleSelectPlayer), for: .touchUpInside)
        return button
    }()
    
    let guestOpponentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("USE\nGUEST", for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.tag = 6
        button.addTarget(self, action: #selector(handleSelectPlayer), for: .touchUpInside)
        return button
    }()
    
    let opponentLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        return label
    }()
    
    let matchesLabel: UILabel = {
        let label = UILabel()
        label.text = "# of games"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    let singlesDoublesControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Singles", "Doubles"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        let font = UIFont.systemFont(ofSize: 16)
        sc.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleDoublesChange), for: .valueChanged)
        return sc
    }()
    
    
    
    let matchesControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Single", "2 out of 3", "3 out of 5"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        let font = UIFont.systemFont(ofSize: 16)
        sc.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        sc.tintColor = .white
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    @objc func handleDoublesChange() {
        usernameLabelHeight?.constant = singlesDoublesControl.selectedSegmentIndex == 1 ? 50 : 100
        opponent1LabelHeight?.constant = singlesDoublesControl.selectedSegmentIndex == 1 ? 50 : 100
        opponent1ButtonHeight?.constant = singlesDoublesControl.selectedSegmentIndex == 1 ? 50 : 100
        selectTeammateButton.isHidden = singlesDoublesControl.selectedSegmentIndex == 1 ? false : true
        teammateLabel.isHidden = singlesDoublesControl.selectedSegmentIndex == 1 ? false : true
        selectOpponentButton2.isHidden = singlesDoublesControl.selectedSegmentIndex == 1 ? false : true
        opponentLabel2.isHidden = singlesDoublesControl.selectedSegmentIndex == 1 ? false : true
        guestTeammateButton.isHidden = singlesDoublesControl.selectedSegmentIndex == 1 ? false : true
        guestOpponentButton.isHidden = singlesDoublesControl.selectedSegmentIndex == 1 ? false : true
        separatorView1.isHidden = singlesDoublesControl.selectedSegmentIndex == 1 ? false : true
        separatorView2.isHidden = singlesDoublesControl.selectedSegmentIndex == 1 ? false : true
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var inputsContainerViewCenterYAnchor: NSLayoutConstraint?
    
    var inputsContainerViewHeightAnchor2: NSLayoutConstraint?
    var inputsContainerViewCenterYAnchor2: NSLayoutConstraint?
    
    var usernameLabelHeight: NSLayoutConstraint?
    var usernameLabelCenterY: NSLayoutConstraint?
    
    var opponent1LabelHeight: NSLayoutConstraint?
    var opponent1ButtonHeight: NSLayoutConstraint?
    var opponent1LabelCenterY: NSLayoutConstraint?
    
    func stopActivityIndicator(username: String) {
        if username.count > 0 {
            activityView.stopAnimating()
            activityView.isHidden = true
            self.userNameLabel.text = username
            self.userNameLabel.isHidden = false
        }
    }

    func setupViews() {
        
        view.addSubview(singlesDoublesControl)
        singlesDoublesControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        singlesDoublesControl.centerYAnchor.constraint(equalTo: createLabel.bottomAnchor, constant: 25).isActive = true
        singlesDoublesControl.widthAnchor.constraint(equalToConstant: 200).isActive = true
        singlesDoublesControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(inputsContainerViewTeam1)
        inputsContainerViewTeam1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerViewCenterYAnchor = inputsContainerViewTeam1.topAnchor.constraint(equalTo: createLabel.bottomAnchor, constant: 55)
        inputsContainerViewCenterYAnchor?.isActive = true
        inputsContainerViewTeam1.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerViewTeam1.heightAnchor.constraint(equalToConstant: 100)
        inputsContainerViewHeightAnchor?.isActive = true
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let userNameRef = Database.database().reference().child("users").child(uid)
        userNameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.stopActivityIndicator(username: (value["name"] as? String) ?? "")
            }
        })
        userNameLabel.isHidden = true
        inputsContainerViewTeam1.addSubview(userNameLabel)
        userNameLabel.leftAnchor.constraint(equalTo: inputsContainerViewTeam1.leftAnchor).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: inputsContainerViewTeam1.topAnchor).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: inputsContainerViewTeam1.rightAnchor).isActive = true
        usernameLabelHeight = userNameLabel.heightAnchor.constraint(equalToConstant: 50)
        usernameLabelHeight?.isActive = true
        
        inputsContainerViewTeam1.addSubview(activityView)
        activityView.leftAnchor.constraint(equalTo: inputsContainerViewTeam1.leftAnchor).isActive = true
        activityView.topAnchor.constraint(equalTo: inputsContainerViewTeam1.topAnchor).isActive = true
        activityView.rightAnchor.constraint(equalTo: inputsContainerViewTeam1.rightAnchor).isActive = true
        activityView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        inputsContainerViewTeam1.addSubview(selectTeammateButton)
        selectTeammateButton.leftAnchor.constraint(equalTo: inputsContainerViewTeam1.leftAnchor, constant: 3).isActive = true
        selectTeammateButton.bottomAnchor.constraint(equalTo: inputsContainerViewTeam1.bottomAnchor).isActive = true
        selectTeammateButton.rightAnchor.constraint(equalTo: inputsContainerViewTeam1.rightAnchor, constant: -80).isActive = true
        selectTeammateButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        inputsContainerViewTeam1.addSubview(guestTeammateButton)
        guestTeammateButton.rightAnchor.constraint(equalTo: inputsContainerViewTeam1.rightAnchor, constant: -2).isActive = true
        guestTeammateButton.bottomAnchor.constraint(equalTo: inputsContainerViewTeam1.bottomAnchor).isActive = true
        guestTeammateButton.leftAnchor.constraint(equalTo: selectTeammateButton.rightAnchor).isActive = true
        guestTeammateButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        inputsContainerViewTeam1.addSubview(separatorView1)
        separatorView1.leftAnchor.constraint(equalTo: inputsContainerViewTeam1.leftAnchor).isActive = true
        separatorView1.topAnchor.constraint(equalTo: selectTeammateButton.topAnchor).isActive = true
        separatorView1.rightAnchor.constraint(equalTo: inputsContainerViewTeam1.rightAnchor).isActive = true
        separatorView1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(inputsContainerViewTeam2)
        inputsContainerViewTeam2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerViewCenterYAnchor2 = inputsContainerViewTeam2.topAnchor.constraint(equalTo: inputsContainerViewTeam1.bottomAnchor, constant: 50)
        inputsContainerViewCenterYAnchor2?.isActive = true
        inputsContainerViewTeam2.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor2 = inputsContainerViewTeam2.heightAnchor.constraint(equalToConstant: 100)
        inputsContainerViewHeightAnchor2?.isActive = true
        
        view.addSubview(vsLabel)
        vsLabel.leftAnchor.constraint(equalTo: inputsContainerViewTeam1.leftAnchor).isActive = true
        vsLabel.topAnchor.constraint(equalTo: inputsContainerViewTeam1.bottomAnchor).isActive = true
        vsLabel.rightAnchor.constraint(equalTo: inputsContainerViewTeam1.rightAnchor).isActive = true
        vsLabel.bottomAnchor.constraint(equalTo: inputsContainerViewTeam2.topAnchor).isActive = true
        
        inputsContainerViewTeam2.addSubview(selectOpponentButton1)
        selectOpponentButton1.leftAnchor.constraint(equalTo: inputsContainerViewTeam2.leftAnchor).isActive = true
        selectOpponentButton1.topAnchor.constraint(equalTo: inputsContainerViewTeam2.topAnchor).isActive = true
        selectOpponentButton1.rightAnchor.constraint(equalTo: inputsContainerViewTeam2.rightAnchor).isActive = true
        opponent1ButtonHeight = selectOpponentButton1.heightAnchor.constraint(equalToConstant: 50)
        opponent1ButtonHeight?.isActive = true
        
        inputsContainerViewTeam2.addSubview(separatorView2)
        separatorView2.leftAnchor.constraint(equalTo: inputsContainerViewTeam2.leftAnchor).isActive = true
        separatorView2.topAnchor.constraint(equalTo: selectOpponentButton1.bottomAnchor).isActive = true
        separatorView2.rightAnchor.constraint(equalTo: inputsContainerViewTeam2.rightAnchor).isActive = true
        separatorView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputsContainerViewTeam2.addSubview(selectOpponentButton2)
        selectOpponentButton2.leftAnchor.constraint(equalTo: inputsContainerViewTeam2.leftAnchor, constant: 3).isActive = true
        selectOpponentButton2.bottomAnchor.constraint(equalTo: inputsContainerViewTeam2.bottomAnchor).isActive = true
        selectOpponentButton2.rightAnchor.constraint(equalTo: inputsContainerViewTeam2.rightAnchor, constant: -80).isActive = true
        selectOpponentButton2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        inputsContainerViewTeam2.addSubview(guestOpponentButton)
        guestOpponentButton.rightAnchor.constraint(equalTo: inputsContainerViewTeam2.rightAnchor, constant: -2).isActive = true
        guestOpponentButton.bottomAnchor.constraint(equalTo: inputsContainerViewTeam2.bottomAnchor).isActive = true
        guestOpponentButton.leftAnchor.constraint(equalTo: selectOpponentButton2.rightAnchor).isActive = true
        guestOpponentButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(matchesLabel)
        matchesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        matchesLabel.topAnchor.constraint(equalTo: inputsContainerViewTeam2.bottomAnchor, constant: 10).isActive = true
        matchesLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        matchesLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(matchesControl)
        matchesControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        matchesControl.topAnchor.constraint(equalTo: matchesLabel.bottomAnchor, constant: 4).isActive = true
        matchesControl.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        matchesControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(createMatchButton)
        createMatchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createMatchButton.topAnchor.constraint(equalTo: matchesControl.bottomAnchor, constant: 15).isActive = true
        createMatchButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        createMatchButton.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        inputsContainerViewTeam1.addSubview(teammateLabel)
        teammateLabel.leftAnchor.constraint(equalTo: inputsContainerViewTeam1.leftAnchor).isActive = true
        teammateLabel.bottomAnchor.constraint(equalTo: inputsContainerViewTeam1.bottomAnchor).isActive = true
        teammateLabel.rightAnchor.constraint(equalTo: selectTeammateButton.rightAnchor).isActive = true
        teammateLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        inputsContainerViewTeam2.addSubview(opponentLabel1)
        opponentLabel1.leftAnchor.constraint(equalTo: inputsContainerViewTeam2.leftAnchor).isActive = true
        opponentLabel1.topAnchor.constraint(equalTo: inputsContainerViewTeam2.topAnchor).isActive = true
        opponentLabel1.rightAnchor.constraint(equalTo: inputsContainerViewTeam2.rightAnchor).isActive = true
        opponent1LabelHeight = opponentLabel1.heightAnchor.constraint(equalToConstant: 50)
        opponent1LabelHeight?.isActive = true


        inputsContainerViewTeam2.addSubview(opponentLabel2)
        opponentLabel2.leftAnchor.constraint(equalTo: inputsContainerViewTeam2.leftAnchor).isActive = true
        opponentLabel2.topAnchor.constraint(equalTo: selectOpponentButton1.bottomAnchor).isActive = true
        opponentLabel2.rightAnchor.constraint(equalTo: selectOpponentButton2.rightAnchor).isActive = true
        opponentLabel2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        if singlesDoublesControl.selectedSegmentIndex == 0 {
            handleDoublesChange()
        }
    }
}
