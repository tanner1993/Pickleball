//
//  StartupPage.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/12/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import Alamofire
import Charts
import FBSDKLoginKit
import FBSDKShareKit

extension UIView {

    func takeScreenshot() -> UIImage {

        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}

class StartupPage: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let player = Player()
    let blackView = UIView()
    var playerId = "none"
    var isFriend = 0
    var findFriends: FindFriends?
    var friendList: FriendList?
    var notificationsPage: Notifications?
    var whichFriend = -1
    var mainMenu: MainMenu?
    var findFriendSender = 0
    var newUser = 0
    var playersDeviceId = String()
    var notificationNumber = -1
    var opponentsList: OpponentsList?
    var createdMatch = Match2()
    
    let profileView = ProfileView(frame: CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.width)!, height: (UIApplication.shared.keyWindow?.frame.height)!))
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbarTitle()
        profileView.activityView.startAnimating()
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        print(newUser)
        if newUser == 1 {
            print("yessss")
        }
        print(playerId)
        if playerId == "none" {
            setupNavbarButtons()
            setupCollectionView()
//            fetchNotifications()
//            fetchMessages()
//            fetchTourneyNotifications()
//            fetchMatchNotifications()
            observePlayerProfile()
        } else if playerId == uid {
            observePlayerProfile()
            setupNavbarButtons()
        } else if isFriend == 3 {
            fetchFriends()
            observePlayerProfile()
        } else {
            setupNavbarButtons()
            observePlayerProfile()
        }
        setupSendMessageButton()
        if findFriendSender != 0 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Return", style: .plain, target: self, action: #selector(handleCancel))
        }
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(handleAppLevelTap))
        profileView.haloLevel.addGestureRecognizer(labelTap)
        
    }
    

    
    @objc func handleAppLevelTap() {
        openMenu2(newExp: playerExp, newLevel: Int(profileView.haloLevel.text!)!, infoBool: false)
        pieBackground2.haloLevel2.text = profileView.haloLevel.text!
        pieBackground2.haloLevelTitle.text = profileView.haloLevelTitle.text!
    }
    
    var challengeYesOrNo = Bool()
    
    func setupSendMessageButton() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        if playerId == "none" || playerId == uid {
            profileView.sendMessageButton.isHidden = true
        } else {
            profileView.sendMessageButton.addTarget(self, action: #selector(presentChatLogs), for: .touchUpInside)
        }
    }
    
    @objc func presentChatLogs() {
        let layout = UICollectionViewFlowLayout()
        let chatLogs = ChatLogs(collectionViewLayout: layout)
        //chatLogs.hidesBottomBarWhenPushed = true
        chatLogs.recipientId = playerId
        navigationController?.pushViewController(chatLogs, animated: true)
    }
    
    func setupChangeStatusButton(challenge: Bool) {
        challengeYesOrNo = challenge
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        profileView.challengeStatusButton.setTitle(challenge ? "Looking For Opponents" : "Not Looking For Opponents", for: .normal)
        profileView.challengeStatusButton.setTitleColor(challenge ? UIColor.init(r: 120, g: 207, b: 138) : UIColor(r: 150, g: 150, b: 150), for: .normal)
        if playerId == "none" {
            profileView.challengeStatusButton.addTarget(self, action: #selector(openInfo), for: .touchUpInside)
        } else {
            if challenge && playerId != uid {
                profileView.challengeStatusButton.addTarget(self, action: #selector(handleChallengePlayer), for: .touchUpInside)
                profileView.challengePrompter.isHidden = false
            } else {
                profileView.challengeStatusButton.isEnabled = false
            }
        }
    }
    
    func setupChangeCourtButton(court: String) {
        if playerId == "none" {
            profileView.selectCourtButton.isHidden = false
            profileView.selectCourtButton.addTarget(self, action: #selector(openCourtInfo), for: .touchUpInside)
            if court == "none" {
                profileView.selectCourtButton.setTitle("No Court Selected", for: .normal)
            } else {
                profileView.selectCourtButton.setTitle(court, for: .normal)
                profileView.selectCourtButton.setTitleColor(.black, for: .normal)
            }
        } else {
            profileView.courtText.isHidden = false
            if court == "none" {
                profileView.courtText.text = "No Court Selected"
            } else {
                profileView.courtText.text = court
                profileView.courtText.textColor = .black
            }
        }
    }
    
    @objc func openCourtInfo() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu4)))
            window.addSubview(blackView)
            window.addSubview(selectCourtInfo)
            selectCourtInfo.frame = CGRect(x: 24, y: window.frame.height, width: window.frame.width - 48, height: CGFloat(infoBackgroundHeight))
            selectCourtInfo.layer.cornerRadius = 10
            selectCourtInfo.layer.masksToBounds = true
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
    
    @objc func handleUpdateCourt() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        guard let courtName = selectCourtInfo.courtNameTextField.text else {
            return
        }
        if courtName.count < 3 || courtName.count > 25 {
            let newalert = UIAlertController(title: "Sorry", message: "Invalid Court Name. Must be between 3 and 25 characters", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        } else {
            Database.database().reference().child("users").child(uid).child("court").setValue(courtName)
            profileView.selectCourtButton.setTitle(courtName, for: .normal)
            profileView.selectCourtButton.setTitleColor(.black, for: .normal)
        }
        dismissMenu4()
    }
    
    func popStartup() {
        self.opponentsList?.createdMatch = createdMatch
        navigationController?.popViewController(animated: false)
        opponentsList?.popOpponents()
    }
    
    @objc func handleDontShowCourt() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).child("court").setValue("none")
        profileView.selectCourtButton.setTitle("No Court Selected", for: .normal)
        profileView.selectCourtButton.setTitleColor(UIColor(r: 150, g: 150, b: 150), for: .normal)
        dismissMenu4()
    }
    
    @objc func handleChallengePlayer() {
        let newalert = UIAlertController(title: "Challenge Opponent", message: "Do you want to create a match with this opponent?", preferredStyle: UIAlertController.Style.alert)
        newalert.addAction(UIAlertAction(title: "Not now", style: UIAlertAction.Style.default, handler: nil))
        newalert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: handleOpenCreateMatch))
        self.present(newalert, animated: true, completion: nil)
    }
    
    func handleOpenCreateMatch(action: UIAlertAction) {
        let createNewMatch = CreateMatch()
        createNewMatch.modalPresentationStyle = .fullScreen
        createNewMatch.opponentChallenge = true
        createNewMatch.opponent1.id = playerId
        createNewMatch.opponent1.name = profileView.playerName.text ?? "none"
        createNewMatch.opponent1.skillLevel = profileView.skillLevel.text ?? "none"
        createNewMatch.opponent1.deviceId = playersDeviceId
        createNewMatch.getPlayerDetails()
        createNewMatch.selectOpponentButton1.isEnabled = false
        createNewMatch.singlesDoublesControl.selectedSegmentIndex = 1
        createNewMatch.startupPage = self
        navigationController?.present(createNewMatch, animated: true, completion: nil)
    }
        
        let selectCourtInfo = SelectCourtInfo()
        let infoBackground = ChangeStatusInfo()
        let infoBackgroundHeight = 440
    
    @objc func openInfo() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu3)))
            window.addSubview(blackView)
            window.addSubview(infoBackground)
            infoBackground.frame = CGRect(x: 24, y: window.frame.height, width: window.frame.width - 48, height: CGFloat(infoBackgroundHeight))
            infoBackground.layer.cornerRadius = 10
            infoBackground.layer.masksToBounds = true
            infoBackground.lookingToggle.isOn = challengeYesOrNo ? true : false
            infoBackground.handleSwitchChanged()
            infoBackground.changeStatus.addTarget(self, action: #selector(changeChallengeStatus), for: .touchUpInside)
            blackView.frame = window.frame
            blackView.alpha = 0

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
             self.infoBackground.frame = CGRect(x: 24, y: window.frame.height - CGFloat(self.infoBackgroundHeight + 140), width: window.frame.width - 48, height: CGFloat(self.infoBackgroundHeight))
            }, completion: nil)

        }
    }

    @objc func dismissMenu3() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
             self.infoBackground.frame = CGRect(x: 24, y: window.frame.height, width: window.frame.width - 48, height: CGFloat(self.infoBackgroundHeight))
            }
        })
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
    
    @objc func changeChallengeStatus() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).child("challenge").setValue(infoBackground.lookingToggle.isOn ? true : false)
        profileView.challengeStatusButton.setTitle(infoBackground.lookingToggle.isOn ? "Looking For Opponents" : "Not Looking For Opponents", for: .normal)
        profileView.challengeStatusButton.setTitleColor(infoBackground.lookingToggle.isOn ? UIColor.init(r: 120, g: 207, b: 138) : UIColor(r: 150, g: 150, b: 150), for: .normal)
        dismissMenu3()
    }
    
    @objc func handleLogout() {
        dismiss(animated: true, completion: nil)
//        if AccessToken.isCurrentAccessTokenActive {
//            mainMenu?.welcomePage?.handleFBLogout()
//        } else {
//            mainMenu?.welcomePage?.handleLogout()
//        }
        mainMenu?.welcomePage?.handleLogout()
    }
    
    @objc func handleViewTourneys() {
        let tourneyListPage = TourneyList()
        navigationController?.pushViewController(tourneyListPage, animated: true)
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    let cellId = "cellId"
    
    let menuItems = ["Logout", "Edit Profile", "Dismiss"]
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProfileMenuCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProfileMenuCell
        cell.menuItem.text = menuItems[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func fetchFriends() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let friendsRef = Database.database().reference().child("friends").child(uid).child(playerId)
        friendsRef.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let friendCheck = snapshot.value else {
                return
            }
            let friendCheckNum = friendCheck as? Int ?? -1
            if friendCheckNum == 1 {
                self.isFriend = 2
                self.setupNavbarButtons()
            } else if friendCheckNum == 0 {
                self.isFriend = 1
                self.setupNavbarButtons()
            } else if friendCheckNum == -1 {
                self.isFriend = 0
                self.secondaryFriendCheck()
                //self.setupNavbarButtons()
            }
        })
    }
    
    func secondaryFriendCheck() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let friendsRef = Database.database().reference().child("friends").child(playerId).child(uid)
        friendsRef.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let friendCheck = snapshot.value else {
                return
            }
            let friendCheckNum = friendCheck as? Int ?? -1
            if friendCheckNum == 1 {
                self.isFriend = 2
                self.setupNavbarButtons()
            } else if friendCheckNum == 0 {
                self.isFriend = 3
                self.setupNavbarButtons()
            } else if friendCheckNum == -1 {
                self.isFriend = 0
                self.setupNavbarButtons()
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            handleLogout()
            dismissMenu()
        case 1:
            let editProfile = EditProfile()
            editProfile.sender = 2
            editProfile.startupPage = self
            present(editProfile, animated: true, completion: nil)
            dismissMenu()
        case 2:
            dismissMenu()
        default:
            print("failed")
            dismissMenu()
        }
    }
    
    @objc func openMenu() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu)))
            window.addSubview(blackView)
            window.addSubview(collectionView)
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 165)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height - 165, width: window.frame.width, height: 165)
            }, completion: nil)
        }
    }
    
    @objc func dismissMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 165)
            }
        })
    }
    
    func setupNavbarButtons() {
        if playerId == "none" {
            let image = UIImage(named: "menu")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(openMenu))
        } else if isFriend == 0 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Request Friend", style: .plain, target: self, action: #selector(sendFriendInvitation))
        } else if isFriend == 1 {
            let friendButton = UIBarButtonItem(title: "Requested", style: .plain, target: self, action: #selector(sendFriendInvitation))
            friendButton.isEnabled = false
            self.navigationItem.rightBarButtonItem = friendButton
        } else if isFriend == 2 {
            let friendButton = UIBarButtonItem(title: "Unfriend", style: .plain, target: self, action: #selector(sendFriendInvitation))
            self.navigationItem.rightBarButtonItem = friendButton
        } else if isFriend == 3 && notificationNumber != -1 {
            let friendButton = UIBarButtonItem(title: "Accept Friend", style: .plain, target: self, action: #selector(acceptFriendInvitation))
            self.navigationItem.rightBarButtonItem = friendButton
        }
    }
    
    @objc func acceptFriendInvitation() {
        player.acceptFriendRequest(playerId: playerId, notificationId: notificationsPage?.notifications[notificationNumber].id ?? "none")
        notificationsPage?.notifications.remove(at: notificationNumber)
        notificationsPage?.noNotifications = 1
        notificationsPage?.tableView.reloadData()
        isFriend = 2
        setupNavbarButtons()
    }
    
    func setupNavbarTitle() {
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        titleLabel.text = playerId == "none" ? "My Profile" : "Player Profile"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.navigationItem.titleView = titleLabel
    }
    
    @objc func sendFriendInvitation() {
        if isFriend == 0 {
            player.sendFriendRequest(playerId: playerId, playersDeviceId: playersDeviceId)
            findFriends?.searchResults[whichFriend].friend = 1
            isFriend = 1
            setupNavbarButtons()
        } else if isFriend == 2 {
            player.revokeFriend(playerId: playerId)
            findFriends?.searchResults[whichFriend].friend = 0
            friendList?.friends.remove(at: whichFriend)
            friendList?.collectionView.reloadData()
            isFriend = 0
            setupNavbarButtons()
        }
        
        
    }
    
    func updateLevel() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let userRef = Database.database().reference().child("users").child(uid).child("exp")
        userRef.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let exp = snapshot.value else {
                return
            }
            let expValue = exp as? Int ?? -1
            let haloValue = self.player.haloLevel(exp: expValue)
            if self.profileView.haloLevel.text! != "\(haloValue)" {
                self.setChart(exp: expValue)
                self.profileView.haloLevel.text = "\(haloValue)"
            }
            if self.profileView.haloLevelTitle.text ?? "0" != self.player.levelTitle(level: haloValue) {
                self.profileView.haloLevelTitle.text = self.player.levelTitle(level: haloValue)
            }
        })
    }
        
    
    func checkLevelUp() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let userRef = Database.database().reference().child("users").child(uid).child("oldLevel")
        userRef.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let oldLevel = snapshot.value else {
                return
            }
            let oldLevelValue = oldLevel as? Int ?? -1
            if oldLevelValue != 0 && oldLevelValue != -1 {
                self.handleLevelUp(oldLevel: oldLevelValue)
                self.updateLevel()
            } else {
                self.updateLevel()
            }
        })
    }
    
    func handleLevelUp(oldLevel: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let userRef = Database.database().reference().child("users").child(uid).child("exp")
        userRef.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let exp = snapshot.value else {
                return
            }
            let expValue = exp as? Int ?? -1
            let haloValue = self.player.haloLevel(exp: expValue)
            if haloValue > oldLevel {
                self.pieBackground2.haloLevelTitle2.text = "You moved up from level \(oldLevel) to level \(haloValue)!"
                if self.player.levelTitle(level: oldLevel) != self.player.levelTitle(level: haloValue) {
                    self.pieBackground2.haloLevelTitle3.text = "You graduated from '\(self.player.levelTitle(level: oldLevel))' to '\(self.player.levelTitle(level: haloValue))'"
                } else {
                    self.pieBackground2.haloLevelTitle3.text = "You're currently '\(self.player.levelTitle(level: haloValue))'"
                }
                self.pieBackground2.haloLevel2.text = "\(haloValue)"
                self.openMenu2(newExp: expValue, newLevel: haloValue, infoBool: true)
            }
            Database.database().reference().child("users").child(uid).child("oldLevel").setValue(0)
        })
    }

    let pieBackroundHeight2 = 440
    
    let pieBackground2 = PieBackgroundPopup()
    
    func openMenu2(newExp: Int, newLevel: Int, infoBool: Bool) {
        let bounds = self.player.findExpBounds(exp: newExp)
        let startExp = bounds[0]
        let endExp = bounds[1]
        
        let currentExp = PieChartDataEntry(value: Double(newExp - startExp), label: nil)
        let goalExp = PieChartDataEntry(value: Double(endExp - newExp), label: nil)
        let chartDataSet = PieChartDataSet(entries: [currentExp, goalExp], label: nil)
        chartDataSet.drawValuesEnabled = false
        
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [UIColor.init(r: 120, g: 207, b: 138), UIColor.white]
        chartDataSet.colors = colors
        pieBackground2.layer.cornerRadius = 10
        pieBackground2.layer.masksToBounds = true
        pieBackground2.pieChart2.data = chartData
        pieBackground2.pieChart2.legend.enabled = false
        pieBackground2.pieChart2.holeRadiusPercent = 0.93
        pieBackground2.pieChart2.transparentCircleColor = UIColor.init(r: 120, g: 207, b: 138)
        pieBackground2.pieChart2.transparentCircleRadiusPercent = 0.94
        if infoBool {
            pieBackground2.pieChart2CenterYAnchor?.isActive = false
            pieBackground2.pieChart2CenterYAnchor = pieBackground2.pieChart2.centerYAnchor.constraint(equalTo: pieBackground2.centerYAnchor)
            pieBackground2.pieChart2CenterYAnchor?.isActive = true
            pieBackground2.levelUpLabel.isHidden = false
            pieBackground2.haloLevelTitle2.isHidden = false
            pieBackground2.haloLevelTitle3.isHidden = false
            pieBackground2.infoTextLevel.isHidden = true
            pieBackground2.haloLevelTitle.isHidden = true
        } else {
            pieBackground2.pieChart2CenterYAnchor?.isActive = false
            pieBackground2.pieChart2CenterYAnchor = pieBackground2.pieChart2.topAnchor.constraint(equalTo: pieBackground2.topAnchor, constant: 8)
            pieBackground2.pieChart2CenterYAnchor?.isActive = true
            pieBackground2.levelUpLabel.isHidden = true
            pieBackground2.haloLevelTitle2.isHidden = true
            pieBackground2.haloLevelTitle3.isHidden = true
            pieBackground2.infoTextLevel.isHidden = false
            pieBackground2.haloLevelTitle.isHidden = false
        }
           if let window = UIApplication.shared.keyWindow {
               blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
               blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu2)))
               window.addSubview(blackView)
               window.addSubview(pieBackground2)
               pieBackground2.frame = CGRect(x: 24, y: window.frame.height, width: window.frame.width - 48, height: CGFloat(pieBackroundHeight2))
               blackView.frame = window.frame
               blackView.alpha = 0
               
               UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                   self.blackView.alpha = 1
                self.pieBackground2.frame = CGRect(x: 24, y: window.frame.height - CGFloat(self.pieBackroundHeight2 + 140), width: window.frame.width - 48, height: CGFloat(self.pieBackroundHeight2))
               }, completion: nil)
            
           }
       }
       
       @objc func dismissMenu2() {
           UIView.animate(withDuration: 0.5, animations: {
               self.blackView.alpha = 0
               if let window = UIApplication.shared.keyWindow {
                self.pieBackground2.frame = CGRect(x: 24, y: window.frame.height, width: window.frame.width - 48, height: CGFloat(self.pieBackroundHeight2))
               }
           })
       }
    
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        if playerId == "none" {
            checkLevelUp()
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
//    func fetchTourneyNotifications() {
//        var foundTourney = false
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let ref = Database.database().reference().child("user_tourneys").child(uid)
//        ref.observe(.childAdded, with: {(snapshot) in
//            guard let notificationSeen = snapshot.value else {
//                return
//            }
//            let notifNumber = notificationSeen as? Int ?? -1
//            if notifNumber == 1 && foundTourney == false {
//                foundTourney = true
//                if let tabItems = self.tabBarController?.tabBar.items {
//                    let tabItem = tabItems[1]
//                    if tabItem.badgeValue == "M" {
//                        tabItem.badgeValue = "2"
//                    } else {
//                        tabItem.badgeValue = "T"
//                    }
//                }
//            }
//            
//        })
//    }
//    
//    func fetchMatchNotifications() {
//        var foundMatch = false
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let ref = Database.database().reference().child("user_matches").child(uid)
//        ref.observe(.childAdded, with: {(snapshot) in
//            guard let notificationSeen = snapshot.value else {
//                return
//            }
//            let notifNumber = notificationSeen as? Int ?? -1
//            print(notifNumber)
//            if notifNumber == 1 && foundMatch == false {
//                foundMatch = true
//                if let tabItems = self.tabBarController?.tabBar.items {
//                    let tabItem = tabItems[1]
//                    if tabItem.badgeValue == "T" {
//                        tabItem.badgeValue = "2"
//                    } else {
//                        tabItem.badgeValue = "M"
//                    }
//                }
//            }
//            
//        })
//    }
//    
//    
//    func fetchNotifications() {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let ref = Database.database().reference().child("user_notifications").child(uid).queryLimited(toLast: 1)
//        ref.observeSingleEvent(of: .childAdded, with: {(snapshot) in
//            guard let notificationSeen = snapshot.value else {
//                return
//            }
//            let notifNumber = notificationSeen as? Int ?? -1
//            if notifNumber == 1 {
//                if let tabItems = self.tabBarController?.tabBar.items {
//                    let tabItem = tabItems[4]
//                    tabItem.badgeValue = "1"
//                }
//            }
//        })
//    }
//    
//    func fetchMessages() {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let ref = Database.database().reference().child("user_messages").child(uid)
//        ref.observe(.childAdded, with: {(snapshot) in
//            let recipientId = snapshot.key
//            let ref2 = Database.database().reference().child("user_messages").child(uid).child(recipientId).queryLimited(toLast: 1)
//            ref2.observe(.childAdded, with: {(snapshot) in
//                guard let messageSeen = snapshot.value else {
//                    return
//                }
//                let messageSeenNum = messageSeen as? Int ?? -1
//                if messageSeenNum == 1 {
//                    if let tabItems = self.tabBarController?.tabBar.items {
//                        let tabItem = tabItems[3]
//                        tabItem.badgeValue = "1"
//                    }
//                }
//            })
//        })
//    }
    
    var playerExp = Int()
    
    func observePlayerProfile() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("users").child(playerId == "none" ? uid : playerId)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? NSDictionary {
                
                let normalSkill = "USAPA Self Rating: "
                let boldSkill = "\(value["skill_level"] as? Float ?? 0)"
                let attributedSkill = NSMutableAttributedString(string: normalSkill)
                let attrb = [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 23), NSAttributedString.Key.foregroundColor : UIColor.init(r: 88, g: 148, b: 200)]
                let boldSkillString = NSAttributedString(string: boldSkill, attributes: attrb as [NSAttributedString.Key : Any])
                attributedSkill.append(boldSkillString)
                self.profileView.skillLevelLabel.attributedText = attributedSkill
                
                let sex = value["sex"] as? String ?? "Unspecified"
                self.profileView.sexLabel.text = sex
                let exp = value["exp"] as? Int ?? 0
                self.playerExp = exp
                self.setChart(exp: exp)
                self.profileView.haloLevel.text = "\(self.player.haloLevel(exp: exp))"
                self.profileView.haloLevelTitle.text = self.player.levelTitle(level: self.player.haloLevel(exp: exp))
                self.profileView.playerName.text = value["name"] as? String ?? "no name"
                let state = value["state"] as? String ?? "no state"
                self.stopAnimatingActivity(state: state)
                let county = value["county"] as? String ?? "no state"
                self.profileView.location.text = "\(state), \(county)"
                let birthdate = value["birthdate"] as? Double ?? 0
                self.profileView.ageGroup.text = self.getAgeGroup(birthdate: birthdate)
                let matchesWon1 = value["match_wins"] as? Int ?? 0
                let matchesLost1 = value["match_losses"] as? Int ?? 0
                //self.profileView.matchesWon.text = "\(matchesWon1)"
                self.profileView.matchesPlayed.text = "\(matchesLost1 + matchesWon1)"
                let winRatio = Double(matchesWon1) / (Double(matchesWon1) + Double(matchesLost1))
                let winRatioRounded = winRatio.round(nearest: 0.01)
                self.profileView.winRatio.text = (matchesWon1 + matchesLost1) == 0 ? "\(0)" : "\(winRatioRounded)"
                
                let deviceId = value["deviceId"] as? String ?? "none"
                let challenge = value["challenge"] as? Bool ?? false
                self.setupChangeStatusButton(challenge: challenge)
                
                let court = value["court"] as? String ?? "none"
                self.setupChangeCourtButton(court: court)
                if self.playerId == "none" {
                    self.uploadDeviceId(deviceId: deviceId)
                } else {
                    self.playersDeviceId = deviceId
                    
                }
            }
        }, withCancel: nil)
    }
    
    func setupRecentMatches() {
        
    }
    
    func setChart(exp: Int) {
            
            
            let bounds = self.player.findExpBounds(exp: exp)
            let startExp = bounds[0]
            let endExp = bounds[1]
            
            let currentExp = PieChartDataEntry(value: Double(exp - startExp), label: nil)
            let goalExp = PieChartDataEntry(value: Double(endExp - exp), label: nil)
            let chartDataSet = PieChartDataSet(entries: [currentExp, goalExp], label: nil)
            chartDataSet.drawValuesEnabled = false
            
            let chartData = PieChartData(dataSet: chartDataSet)
            let colors = [UIColor.init(r: 120, g: 207, b: 138), UIColor.white]
            chartDataSet.colors = colors
            self.profileView.pieChart.data = chartData
    }
    
    func uploadDeviceId(deviceId: String) {
        let newDeviceId = AppDelegate.DeviceId
        if deviceId == "none" || deviceId != newDeviceId {
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            Database.database().reference().child("users").child(uid).child("deviceId").setValue(newDeviceId)
        }
    }
    
    func stopAnimatingActivity(state: String) {
        profileView.activityView.isHidden = true
        profileView.activityView.stopAnimating()
        profileView.whiteBox.isHidden = true
    }
    
    func getAgeGroup(birthdate: Double) -> String {
        let now = Double((Date().timeIntervalSince1970))
        let yearsOld = (now - birthdate) / 60.0 / 60.0 / 24.0 / 365.0
        switch yearsOld {
        case 0..<19:
            return "0 - 18"
        case 19..<35:
            return "19 - 34"
        case 35..<50:
            return "35 - 49"
        case 50..<125:
            return "50+"
        default:
            return "no age group"
        }
    }
    
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
    }

}
