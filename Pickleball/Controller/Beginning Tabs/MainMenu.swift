//
//  MainMenu.swift
//  Pickleball
//
//  Created by Tanner Rozier on 12/31/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainMenu: UITabBarController {
    
    var welcomePage: WelcomePage?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarController()
    }
    
    private func setupTabBarController() {
        let layout = UICollectionViewFlowLayout()
        let tourneyList = TourneyList(collectionViewLayout: layout)
        let tourneyList2 = UINavigationController(rootViewController: tourneyList)
        tourneyList2.navigationBar.barTintColor = UIColor.init(r: 88, g: 148, b: 200)
        tourneyList2.navigationBar.tintColor = .white
        tourneyList2.navigationBar.isTranslucent = false
        tourneyList2.tabBarItem = UITabBarItem(title: "Tourneys", image: UIImage(named: "tourneys_tab"), tag: 0)
        
        let myProfile = StartupPage()
        myProfile.mainMenu = self
        let myProfile2 = UINavigationController(rootViewController: myProfile)
        myProfile2.navigationBar.barTintColor = UIColor.init(r: 88, g: 148, b: 200)
        myProfile2.navigationBar.isTranslucent = false
        myProfile2.tabBarItem = UITabBarItem(title: "My Profile", image: UIImage(named: "profile_tab"), tag: 1)
        
        let connect = Connect(collectionViewLayout: layout)
        let connect2 = UINavigationController(rootViewController: connect)
        connect2.navigationBar.barTintColor = UIColor.init(r: 88, g: 148, b: 200)
        connect2.navigationBar.isTranslucent = false
        connect2.navigationBar.tintColor = .white
        connect2.tabBarItem = UITabBarItem(title: "Connect", image: UIImage(named: "connect_tab"), tag: 3)
        
        let matchFeed = MatchFeed()
        let matchFeed2 = UINavigationController(rootViewController: matchFeed)
        matchFeed2.navigationBar.barTintColor = UIColor.init(r: 88, g: 148, b: 200)
        matchFeed2.navigationBar.isTranslucent = false
        matchFeed2.navigationBar.tintColor = .white
        matchFeed2.tabBarItem = UITabBarItem(title: "News Feed", image: UIImage(named: "news_tab"), tag: 2)
        
        let notifications = Notifications()
        let notifications2 = UINavigationController(rootViewController: notifications)
        notifications2.navigationBar.barTintColor = UIColor.init(r: 88, g: 148, b: 200)
        notifications2.navigationBar.isTranslucent = false
        notifications2.navigationBar.tintColor = .white
        notifications2.tabBarItem = UITabBarItem(title: "Events", image: UIImage(named: "event_tab"), tag: 4)
        
        
        let tabBarList = [myProfile2, tourneyList2, matchFeed2, connect2, notifications2]
        
    
        viewControllers = tabBarList
    }

}
