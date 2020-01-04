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
        setupNavBar()
        checkIfUserLoggedIn()
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupTabBarController() {
        let layout = UICollectionViewFlowLayout()
        let tourneyList = TourneyList(collectionViewLayout: layout)
        tourneyList.tabBarItem = UITabBarItem(title: "Tourneys", image: UIImage(named: "map"), tag: 0)
        
        let myProfile = StartupPage()
        myProfile.tabBarItem = UITabBarItem(title: "My Profile", image: UIImage(named: "info"), tag: 1)
        
        let connect = Connect(collectionViewLayout: layout)
        connect.tabBarItem = UITabBarItem(title: "Connect", image: UIImage(named: "map"), tag: 2)
        
        
        
        let tabBarList = [myProfile, tourneyList, connect]
        viewControllers = tabBarList
    }
    
    @objc func handleViewNotifications() {
        let layout = UICollectionViewFlowLayout()
        let NotificationsPage = Notifications(collectionViewLayout: layout)
        navigationController?.pushViewController(NotificationsPage, animated: true)
    }
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            setupUserNavBarTitle()
        }
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginPage()
        loginController.mainMenu = self
        present(loginController, animated: true, completion: nil)
    }
    
    
    func setupNavBar() {
        //self.tabBarController?.navigationItem.title = "Little Cottonwood Areas"
        UINavigationBar.appearance().barTintColor = UIColor.init(r: 88, g: 148, b: 200)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "AmericanTypewriter-Bold", size: 25)!]
        //UINavigationBar.appearance().shadowImage = UIImage()
        tabBarController?.tabBar.isTranslucent = false
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let notificationButton = UIBarButtonItem(title: "Notifs", style: .plain, target: self, action: #selector(handleViewNotifications))
        navigationItem.rightBarButtonItems = [logoutButton, notificationButton]
    }
    
    func setupUserNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.navigationItem.title = dictionary["name"] as? String
            }
        })
    }

}
