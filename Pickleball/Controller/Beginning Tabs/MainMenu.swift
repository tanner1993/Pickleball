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
        tourneyList2.tabBarItem = UITabBarItem(title: "Tourneys", image: UIImage(named: "map"), tag: 0)
        
        let myProfile = StartupPage()
        let myProfile2 = UINavigationController(rootViewController: myProfile)
        myProfile2.navigationBar.barTintColor = UIColor.init(r: 88, g: 148, b: 200)
        myProfile2.navigationBar.isTranslucent = false
        myProfile2.tabBarItem = UITabBarItem(title: "My Profile", image: UIImage(named: "info"), tag: 1)
        
        let connect = Connect(collectionViewLayout: layout)
        let connect2 = UINavigationController(rootViewController: connect)
        connect2.navigationBar.barTintColor = UIColor.init(r: 88, g: 148, b: 200)
        connect2.navigationBar.isTranslucent = false
        connect2.navigationBar.tintColor = .white
        connect2.tabBarItem = UITabBarItem(title: "Connect", image: UIImage(named: "map"), tag: 2)
        
        let notifications = Notifications()
        let notifications2 = UINavigationController(rootViewController: notifications)
        notifications2.navigationBar.barTintColor = UIColor.init(r: 88, g: 148, b: 200)
        notifications2.navigationBar.isTranslucent = false
        notifications2.navigationBar.tintColor = .white
        notifications2.tabBarItem = UITabBarItem(title: "Notifications", image: UIImage(named: "map"), tag: 3)
        
        
        
        let tabBarList = [myProfile2, tourneyList2, connect2, notifications2]
        viewControllers = tabBarList
    }

}
