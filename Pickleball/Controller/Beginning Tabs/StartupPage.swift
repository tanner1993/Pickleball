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

class StartupPage: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let player = Player()
    let blackView = UIView()
    var playerId = "none"
    var isFriend = 0
    var findFriends: FindFriends?
    var whichFriend = -1
    var mainMenu: MainMenu?
    
//    var activityIndicatorView: UIActivityIndicatorView!
//
//    override func loadView() {
//        super.loadView()
//
//        activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
//    }
    
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
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 100)
        label.textColor = UIColor.init(r: 120, g: 207, b: 138)
        label.textAlignment = .center
        return label
    }()
    
    let haloLevelTitle: UILabel = {
        let label = UILabel()
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
        let layout = UICollectionViewFlowLayout()
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
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 150)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height - 150, width: window.frame.width, height: 150)
            }, completion: nil)
        }
    }
    
    @objc func dismissMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 150)
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
                    
                    print("Crazy data 2 saved!")
                    
                    
                })
                
                print("Crazy data saved!")
                
                
            })
            findFriends?.searchResults[whichFriend].friend = 1
            isFriend = 1
            setupNavbarButtons()
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.startAnimating()
        setupViews()
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        if playerId == "none" {
            setupNavbarButtons()
            setupCollectionView()
            fetchNotifications()
            fetchMessages()
            fetchTourneyNotifications()
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
    }
    
    func fetchTourneyNotifications() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("tourney_notifications").child(uid)
        ref.observeSingleEvent(of: .childAdded, with: {(snapshot) in
            guard let notificationSeen = snapshot.value else {
                return
            }
                let notifNumber = notificationSeen as? Int ?? -1
                if notifNumber == 1 {
                    if let tabItems = self.tabBarController?.tabBar.items {
                        let tabItem = tabItems[1]
                        tabItem.badgeValue = "1"
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
                self.haloLevel.text = "\(self.player.haloLevel(exp: exp))"
                self.haloLevelTitle.text = "App Level"
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
            }
        }, withCancel: nil)
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
        
//        view.addSubview(haloLevelTitle)
//        let haloLevelTitleLoc = calculateButtonPosition(x: 550, y: 255, w: 200, h: 50, wib: 750, hib: 1100, wia: 375, hia: 550)
//
//        haloLevelTitle.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(haloLevelTitleLoc.Y)).isActive = true
//        haloLevelTitle.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(haloLevelTitleLoc.X)).isActive = true
//        haloLevelTitle.heightAnchor.constraint(equalToConstant: CGFloat(haloLevelTitleLoc.H)).isActive = true
//        haloLevelTitle.widthAnchor.constraint(equalToConstant: CGFloat(haloLevelTitleLoc.W)).isActive = true
        
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
