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

class StartupPage: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let player = Player()
    let blackView = UIView()
    var playerId = "none"
    var isFriend = 0
    var findFriends: FindFriends?
    var whichFriend = -1
    var mainMenu: MainMenu?
    var findFriendSender = 0
    var newUser = 0
    var playersDeviceId = String()
    
    
//    var activityIndicatorView: UIActivityIndicatorView!
//
//    override func loadView() {
//        super.loadView()
//
//        activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
//    }
    
    let pieChart: PieChartView = {
        let bi = PieChartView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.isUserInteractionEnabled = true
        return bi
    }()
    
    let backgroundImage: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.image = UIImage(named: "user_dashboard")
        bi.isUserInteractionEnabled = true
        return bi
    }()
    
    let skillLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 75)
        label.textAlignment = .center
        return label
    }()
    
    let tourneyNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.backgroundColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        return tf
    }()
    
    let skillLevelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "USAPA Self Rating: "
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let haloLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 100)
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.textAlignment = .center
        return label
    }()
    
    let haloLevelTitle: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    let playerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .left
        return label
    }()
    
    let location: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .left
        return label
    }()
    
    let ageGroup: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .left
        return label
    }()
    
    let tourneysEntered: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        label.textAlignment = .right
        return label
    }()
    
    let tourneysWon: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        label.textAlignment = .right
        return label
    }()
    
    let matchesWon: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        label.textAlignment = .right
        return label
    }()
    
    let matchesLost: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        label.textAlignment = .right
        return label
    }()
    
    let winRatio: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        label.textAlignment = .right
        return label
    }()
    
    @objc func handleLogout() {
//        do {
//            try Auth.auth().signOut()
//        } catch let logoutError {
//            print(logoutError)
//        }
//
//        let loginController = LoginPage()
//        loginController.startupPage = self
//        present(loginController, animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
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
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Invite Friend", style: .plain, target: self, action: #selector(sendFriendInvitation))
        } else if isFriend == 1 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Requested", style: .plain, target: self, action: #selector(sendFriendInvitation))
        } else if isFriend == 2 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Friends", style: .plain, target: self, action: #selector(sendFriendInvitation))
        }
    }
    
    func setupNavbarTitle(username: String) {
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        titleLabel.text = username
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.navigationItem.titleView = titleLabel
    }
    
    @objc func sendFriendInvitation() {
        if isFriend == 0 {
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            
            
            let ref = Database.database().reference()
            let notifications2Ref = ref.child("notifications")
            let childRef = notifications2Ref.childByAutoId()
            let toId = playerId
            let fromId = uid
            let timeStamp = Int(Date().timeIntervalSince1970)
            let values = ["type": "friend", "toId": toId, "fromId" :fromId, "timestamp": timeStamp] as [String : Any]
            childRef.updateChildValues(values, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if error != nil {
                    let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(messageSendFailed, animated: true, completion: nil)
                    print("Data could not be saved: \(String(describing: error)).")
                    return
                }
                
                let notificationsRef = Database.database().reference()
                let notificationId = childRef.key!
                let childUpdates = ["/\("friends")/\(uid)/\(self.playerId)/": false, "/\("user_notifications")/\(self.playerId)/\(notificationId)/": 1] as [String : Any]
                notificationsRef.updateChildValues(childUpdates, withCompletionBlock: {
                    (error:Error?, ref:DatabaseReference) in
                    
                    if error != nil {
                        let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                        messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(messageSendFailed, animated: true, completion: nil)
                        print("Data could not be saved: \(String(describing: error)).")
                        return
                    }
                    Database.database().reference().child("users").child(uid).child("name").observeSingleEvent(of: .value, with: {(snapshot) in
                        if let value = snapshot.value {
                            let nameOnInvite = value as? String ?? "none"
                            let pusher = PushNotificationHandler()
                            pusher.setupPushNotification(deviceId: self.playersDeviceId, message: "\(nameOnInvite) wants to be your friend", title: "Friend Request")
                            //self.setupPushNotification(deviceId: self.playersDeviceId, nameOnInvite: nameOnInvite)
                        }
                    })
                    print("Crazy data 2 saved!")
                    
                    
                })
                
                print("Crazy data saved!")
                
                
            })
            findFriends?.searchResults[whichFriend].friend = 1
            isFriend = 1
            setupNavbarButtons()
        }
        
        
    }
    
//    fileprivate func setupPushNotification(deviceId: String, nameOnInvite: String) {
//        let message = "\(nameOnInvite) sent you a friend request"
//        let title = "Friend Request"
//        let toDeviceId = deviceId
//        var headers: HTTPHeaders = HTTPHeaders()
//
//        headers = ["Content-Type":"application/json", "Authorization":"key=\(AppDelegate.ServerKey)"]
//        let notification = ["to":"\(toDeviceId)", "notification":["body":message,"title":title,"badge":1,"sound":"default"]] as [String:Any]
//
//        Alamofire.request(AppDelegate.Notification_URL as URLConvertible, method: .post as HTTPMethod, parameters: notification, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: {(response) in
//            print(response)
//        })
//    }
    
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
            if self.haloLevel.text! != "\(haloValue)" {
                self.setChart(exp: expValue)
                self.haloLevel.text = "\(haloValue)"
            }
            if self.haloLevelTitle.text! != self.player.levelTitle(level: haloValue) {
                self.haloLevelTitle.text = self.player.levelTitle(level: haloValue)
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
                self.haloLevelTitle2.text = "You moved up from level \(oldLevel) to level \(haloValue)!"
                if self.player.levelTitle(level: oldLevel) != self.player.levelTitle(level: haloValue) {
                    self.haloLevelTitle3.text = "You graduated from '\(self.player.levelTitle(level: oldLevel))' to '\(self.player.levelTitle(level: haloValue))'"
                } else {
                    self.haloLevelTitle3.text = "You're currently '\(self.player.levelTitle(level: haloValue))'"
                }
                self.openMenu2(newExp: expValue, newLevel: haloValue)
            }
            Database.database().reference().child("users").child(uid).child("oldLevel").setValue(0)
        })
    }
    
    let pieBackground2: UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
        cv.layer.cornerRadius = 10
        cv.layer.masksToBounds = true
        return cv
    }()
    
    let haloLevel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 100)
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.textAlignment = .center
        return label
    }()
    
    let levelUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Level Up!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 50)
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.textAlignment = .center
        return label
    }()
    
    let haloLevelTitle2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.text = "You leveled up!"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let haloLevelTitle3: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        label.textAlignment = .center
        return label
    }()
    
    let pieBackroundHeight2 = 440
    
    let pieChart2: PieChartView = {
        let bi = PieChartView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.isUserInteractionEnabled = true
        return bi
    }()
    
    func openMenu2(newExp: Int, newLevel: Int) {
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
        
        pieChart2.data = chartData
        pieChart2.legend.enabled = false
        pieChart2.holeRadiusPercent = 0.93
        pieChart2.transparentCircleColor = UIColor.init(r: 120, g: 207, b: 138)
        pieChart2.transparentCircleRadiusPercent = 0.94
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
            
            pieBackground2.addSubview(pieChart2)
            pieChart2.heightAnchor.constraint(equalToConstant: 230).isActive = true
            pieChart2.centerXAnchor.constraint(equalTo: pieBackground2.centerXAnchor).isActive = true
            pieChart2.widthAnchor.constraint(equalToConstant: 230).isActive = true
            pieChart2.centerYAnchor.constraint(equalTo: pieBackground2.centerYAnchor).isActive = true
            
            haloLevel2.text = "\(newLevel)"
            pieBackground2.addSubview(haloLevel2)
            haloLevel2.heightAnchor.constraint(equalToConstant: 150).isActive = true
            haloLevel2.centerXAnchor.constraint(equalTo: pieBackground2.centerXAnchor).isActive = true
            haloLevel2.widthAnchor.constraint(equalToConstant: 150).isActive = true
            haloLevel2.centerYAnchor.constraint(equalTo: pieBackground2.centerYAnchor).isActive = true
            
            pieBackground2.addSubview(haloLevelTitle2)
            haloLevelTitle2.heightAnchor.constraint(equalToConstant: 60).isActive = true
            haloLevelTitle2.centerXAnchor.constraint(equalTo: pieBackground2.centerXAnchor).isActive = true
            haloLevelTitle2.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
            haloLevelTitle2.bottomAnchor.constraint(equalTo: pieChart2.topAnchor, constant: 15).isActive = true
            
            pieBackground2.addSubview(levelUpLabel)
            levelUpLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
            levelUpLabel.centerXAnchor.constraint(equalTo: pieBackground2.centerXAnchor).isActive = true
            levelUpLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
            levelUpLabel.bottomAnchor.constraint(equalTo: haloLevelTitle2.topAnchor, constant: 0).isActive = true
            
            pieBackground2.addSubview(haloLevelTitle3)
            haloLevelTitle3.heightAnchor.constraint(equalToConstant: 80).isActive = true
            haloLevelTitle3.centerXAnchor.constraint(equalTo: pieBackground2.centerXAnchor).isActive = true
            haloLevelTitle3.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
            haloLevelTitle3.topAnchor.constraint(equalTo: pieChart2.bottomAnchor, constant: -15).isActive = true
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
        checkLevelUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.startAnimating()
        setupViews()
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        print(newUser)
        if newUser == 1 {
            print("yessss")
        }
        if playerId == "none" {
            setupNavbarButtons()
            setupCollectionView()
            fetchNotifications()
            fetchMessages()
            fetchTourneyNotifications()
            fetchMatchNotifications()
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
        if findFriendSender != 0 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Return", style: .plain, target: self, action: #selector(handleCancel))
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchTourneyNotifications() {
        var foundTourney = false
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user_tourneys").child(uid)
        ref.observe(.childAdded, with: {(snapshot) in
            guard let notificationSeen = snapshot.value else {
                return
            }
            let notifNumber = notificationSeen as? Int ?? -1
            if notifNumber == 1 && foundTourney == false {
                foundTourney = true
                if let tabItems = self.tabBarController?.tabBar.items {
                    let tabItem = tabItems[1]
                    if tabItem.badgeValue == "M" {
                        tabItem.badgeValue = "2"
                    } else {
                        tabItem.badgeValue = "T"
                    }
                }
            }
            
        })
    }
    
    func fetchMatchNotifications() {
        var foundMatch = false
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user_matches").child(uid)
        ref.observe(.childAdded, with: {(snapshot) in
            guard let notificationSeen = snapshot.value else {
                return
            }
            let notifNumber = notificationSeen as? Int ?? -1
            print(notifNumber)
            if notifNumber == 1 && foundMatch == false {
                foundMatch = true
                if let tabItems = self.tabBarController?.tabBar.items {
                    let tabItem = tabItems[1]
                    if tabItem.badgeValue == "T" {
                        tabItem.badgeValue = "2"
                    } else {
                        tabItem.badgeValue = "M"
                    }
                }
            }
            
        })
    }
    
    
    func fetchNotifications() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user_notifications").child(uid).queryLimited(toLast: 1)
        ref.observeSingleEvent(of: .childAdded, with: {(snapshot) in
            guard let notificationSeen = snapshot.value else {
                return
            }
            let notifNumber = notificationSeen as? Int ?? -1
            if notifNumber == 1 {
                if let tabItems = self.tabBarController?.tabBar.items {
                    let tabItem = tabItems[4]
                    tabItem.badgeValue = "1"
                }
            }
        })
    }
    
    func fetchMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user_messages").child(uid)
        ref.observeSingleEvent(of: .childAdded, with: {(snapshot) in
            let recipientId = snapshot.key
            let ref2 = Database.database().reference().child("user_messages").child(uid).child(recipientId).queryLimited(toLast: 1)
            ref2.observeSingleEvent(of: .childAdded, with: {(snapshot) in
                guard let messageSeen = snapshot.value else {
                    return
                }
                let messageSeenNum = messageSeen as? Int ?? -1
                if messageSeenNum == 1 {
                    if let tabItems = self.tabBarController?.tabBar.items {
                        let tabItem = tabItems[3]
                        tabItem.badgeValue = "1"
                    }
                }
            })
        })
    }
    
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
                self.skillLevelLabel.attributedText = attributedSkill
                
                let exp = value["exp"] as? Int ?? 0
                self.setChart(exp: exp)
                self.haloLevel.text = "\(self.player.haloLevel(exp: exp))"
                self.haloLevelTitle.text = self.player.levelTitle(level: self.player.haloLevel(exp: exp))
                self.playerName.text = value["name"] as? String ?? "no name"
                let state = value["state"] as? String ?? "no state"
                let username = value["username"] as? String ?? "no name"
                self.setupNavbarTitle(username: username)
                self.stopAnimatingActivity(state: state)
                let county = value["county"] as? String ?? "no state"
                self.location.text = "\(state), \(county)"
                let birthdate = value["birthdate"] as? Double ?? 0
                self.ageGroup.text = self.getAgeGroup(birthdate: birthdate)
                self.tourneysEntered.text = "\(value["tourneys_played"] as? Int ?? 0)"
                self.tourneysWon.text = "\(value["tourneys_won"] as? Int ?? 0)"
                let matchesWon1 = value["match_wins"] as? Int ?? 0
                let matchesLost1 = value["match_losses"] as? Int ?? 0
                self.matchesWon.text = "\(matchesWon1)"
                self.matchesLost.text = "\(matchesLost1)"
                let winRatio = Double(matchesWon1) / (Double(matchesWon1) + Double(matchesLost1))
                let winRatioRounded = winRatio.round(nearest: 0.01)
                self.winRatio.text = (matchesWon1 + matchesLost1) == 0 ? "\(0)" : "\(winRatioRounded)"
                
                let deviceId = value["deviceId"] as? String ?? "none"
                if self.playerId == "none" {
                    self.uploadDeviceId(deviceId: deviceId)
                } else {
                    self.playersDeviceId = deviceId
                }
            }
        }, withCancel: nil)
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
            self.pieChart.data = chartData
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
        activityView.isHidden = true
        activityView.stopAnimating()
        whiteBox.isHidden = true
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
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isScrollEnabled = true
        sv.backgroundColor = .white
        sv.minimumZoomScale = 1.0
        //sv.maximumZoomScale = 2.5
        return sv
    }()
    
    func setupPieChart() {
        let currentExp = PieChartDataEntry(value: 3, label: nil)
        let goalExp = PieChartDataEntry(value: 150, label: nil)
        let chartDataSet = PieChartDataSet(entries: [currentExp, goalExp], label: nil)
        chartDataSet.drawValuesEnabled = false
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [UIColor.init(r: 120, g: 207, b: 138), UIColor.white]
        chartDataSet.colors = colors
        pieChart.data = chartData
        pieChart.legend.enabled = false
        pieChart.holeRadiusPercent = 0.93
        pieChart.transparentCircleColor = UIColor.init(r: 120, g: 207, b: 138)
        pieChart.transparentCircleRadiusPercent = 0.94
        backgroundImage.addSubview(pieChart)
        pieChart.heightAnchor.constraint(equalToConstant: 230).isActive = true
        pieChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pieChart.widthAnchor.constraint(equalToConstant: 230).isActive = true
        pieChart.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 269 / 2).isActive = true
    }
    
    func setupViews() {
        scrollView.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        let Width = Float(view.frame.width)
        let ratio: Float = 375.0 / 550.0
        scrollView.contentSize = CGSize(width: Double(Width), height: Double(Width / ratio))
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        scrollView.addSubview(backgroundImage)
        backgroundImage.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalToConstant: CGFloat(Width / ratio)).isActive = true
        
//        view.addSubview(skillLevel)
//        let skillLevelLoc = calculateButtonPosition(x: 200, y: 140, w: 250, h: 160, wib: 750, hib: 1100, wia: 375, hia: 550)
//
//        skillLevel.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(skillLevelLoc.Y)).isActive = true
//        skillLevel.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(skillLevelLoc.X)).isActive = true
//        skillLevel.heightAnchor.constraint(equalToConstant: CGFloat(skillLevelLoc.H)).isActive = true
//        skillLevel.widthAnchor.constraint(equalToConstant: CGFloat(skillLevelLoc.W)).isActive = true
        
        setupPieChart()
        
        backgroundImage.addSubview(skillLevelLabel)
        let skillLevelLabelLoc = calculateButtonPosition(x: 540, y: 485, w: 400, h: 55, wib: 750, hib: 1100, wia: Float(view.frame.width), hia: Width / ratio)
        
        skillLevelLabel.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(skillLevelLabelLoc.Y)).isActive = true
        skillLevelLabel.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(skillLevelLabelLoc.X)).isActive = true
        skillLevelLabel.heightAnchor.constraint(equalToConstant: CGFloat(skillLevelLabelLoc.H)).isActive = true
        skillLevelLabel.widthAnchor.constraint(equalToConstant: CGFloat(skillLevelLabelLoc.W)).isActive = true
        
        backgroundImage.addSubview(haloLevel)
        let haloLevelLoc = calculateButtonPosition(x: 375, y: 236.5, w: 250, h: 200, wib: 750, hib: 1100, wia: Float(view.frame.width), hia: Width / ratio)
        
        haloLevel.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(haloLevelLoc.Y)).isActive = true
        haloLevel.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(haloLevelLoc.X)).isActive = true
        haloLevel.heightAnchor.constraint(equalToConstant: CGFloat(haloLevelLoc.H)).isActive = true
        haloLevel.widthAnchor.constraint(equalToConstant: CGFloat(haloLevelLoc.W)).isActive = true
        
        view.addSubview(haloLevelTitle)
        //let haloLevelTitleLoc = calculateButtonPosition(x: 550, y: 255, w: 200, h: 50, wib: 750, hib: 1100, wia: 375, hia: 550)

        haloLevelTitle.topAnchor.constraint(equalTo: haloLevel.bottomAnchor, constant: 2).isActive = true
        haloLevelTitle.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor).isActive = true
        haloLevelTitle.heightAnchor.constraint(equalToConstant: 25).isActive = true
        haloLevelTitle.widthAnchor.constraint(equalToConstant: 125).isActive = true
        
        backgroundImage.addSubview(playerName)
        let playerNameLoc = calculateButtonPosition(x: 375, y: 40, w: 705, h: 60, wib: 750, hib: 1100, wia: Float(view.frame.width), hia: Width / ratio)
        
        playerName.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(playerNameLoc.Y)).isActive = true
        playerName.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(playerNameLoc.X)).isActive = true
        playerName.heightAnchor.constraint(equalToConstant: CGFloat(playerNameLoc.H)).isActive = true
        playerName.widthAnchor.constraint(equalToConstant: CGFloat(playerNameLoc.W)).isActive = true
        
        backgroundImage.addSubview(location)
        let locationLoc = calculateButtonPosition(x: 216.75, y: 485, w: 383.5, h: 50, wib: 750, hib: 1100, wia: Float(view.frame.width), hia: Width / ratio)
        
        location.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(locationLoc.Y)).isActive = true
        location.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(locationLoc.X)).isActive = true
        location.heightAnchor.constraint(equalToConstant: CGFloat(locationLoc.H)).isActive = true
        location.widthAnchor.constraint(equalToConstant: CGFloat(locationLoc.W)).isActive = true
        
        backgroundImage.addSubview(ageGroup)
        let ageGroupLoc = calculateButtonPosition(x: 216.75, y: 440, w: 383.5, h: 50, wib: 750, hib: 1100, wia: Float(view.frame.width), hia: Width / ratio)
        
        ageGroup.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(ageGroupLoc.Y)).isActive = true
        ageGroup.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(ageGroupLoc.X)).isActive = true
        ageGroup.heightAnchor.constraint(equalToConstant: CGFloat(ageGroupLoc.H)).isActive = true
        ageGroup.widthAnchor.constraint(equalToConstant: CGFloat(ageGroupLoc.W)).isActive = true
        
        backgroundImage.addSubview(tourneysEntered)
        let tourneysEnteredLoc = calculateButtonPosition(x: 645, y: 630, w: 160, h: 60, wib: 750, hib: 1100, wia: Float(view.frame.width), hia: Width / ratio)
        
        tourneysEntered.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(tourneysEnteredLoc.Y)).isActive = true
        tourneysEntered.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(tourneysEnteredLoc.X)).isActive = true
        tourneysEntered.heightAnchor.constraint(equalToConstant: CGFloat(tourneysEnteredLoc.H)).isActive = true
        tourneysEntered.widthAnchor.constraint(equalToConstant: CGFloat(tourneysEnteredLoc.W)).isActive = true
        
        backgroundImage.addSubview(tourneysWon)
        let tourneysWonLoc = calculateButtonPosition(x: 645, y: 730, w: 160, h: 60, wib: 750, hib: 1100, wia: Float(view.frame.width), hia: Width / ratio)
        
        tourneysWon.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(tourneysWonLoc.Y)).isActive = true
        tourneysWon.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(tourneysWonLoc.X)).isActive = true
        tourneysWon.heightAnchor.constraint(equalToConstant: CGFloat(tourneysWonLoc.H)).isActive = true
        tourneysWon.widthAnchor.constraint(equalToConstant: CGFloat(tourneysWonLoc.W)).isActive = true
        
        backgroundImage.addSubview(matchesWon)
        let matchesWonLoc = calculateButtonPosition(x: 645, y: 830, w: 160, h: 60, wib: 750, hib: 1100, wia: Float(view.frame.width), hia: Width / ratio)
        
        matchesWon.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(matchesWonLoc.Y)).isActive = true
        matchesWon.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(matchesWonLoc.X)).isActive = true
        matchesWon.heightAnchor.constraint(equalToConstant: CGFloat(matchesWonLoc.H)).isActive = true
        matchesWon.widthAnchor.constraint(equalToConstant: CGFloat(matchesWonLoc.W)).isActive = true
        
        backgroundImage.addSubview(matchesLost)
        let matchesLostLoc = calculateButtonPosition(x: 645, y: 930, w: 160, h: 60, wib: 750, hib: 1100, wia: Float(view.frame.width), hia: Width / ratio)
        
        matchesLost.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(matchesLostLoc.Y)).isActive = true
        matchesLost.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(matchesLostLoc.X)).isActive = true
        matchesLost.heightAnchor.constraint(equalToConstant: CGFloat(matchesLostLoc.H)).isActive = true
        matchesLost.widthAnchor.constraint(equalToConstant: CGFloat(matchesLostLoc.W)).isActive = true
        
        backgroundImage.addSubview(winRatio)
        let winRatioLoc = calculateButtonPosition(x: 645, y: 1030, w: 160, h: 60, wib: 750, hib: 1100, wia: Float(view.frame.width), hia: Width / ratio)
        
        winRatio.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(winRatioLoc.Y)).isActive = true
        winRatio.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(winRatioLoc.X)).isActive = true
        winRatio.heightAnchor.constraint(equalToConstant: CGFloat(winRatioLoc.H)).isActive = true
        winRatio.widthAnchor.constraint(equalToConstant: CGFloat(winRatioLoc.W)).isActive = true
        
        view.addSubview(whiteBox)
        whiteBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        whiteBox.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        whiteBox.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        whiteBox.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        whiteBox.addSubview(activityView)
        activityView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        activityView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        activityView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        activityView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        
    }
    
    let activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let whiteBox: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

}
