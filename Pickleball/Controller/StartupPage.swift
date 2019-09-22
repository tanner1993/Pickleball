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

class StartupPage: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserLoggedIn()
        setupNavBar()
        setupNavBarButtons()
    }
    
    func setupNavBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "View Tourney", style: .plain, target: self, action: #selector(handleViewTourney))
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let notificationButton = UIBarButtonItem(title: "Notifs", style: .plain, target: self, action: #selector(handleViewNotifications))
        navigationItem.rightBarButtonItems = [logoutButton, notificationButton]
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
        loginController.startupPage = self
        present(loginController, animated: true, completion: nil)
    }
    
    @objc func handleViewTourney() {
        let layout = UICollectionViewFlowLayout()
        let tourneyStandingsPage = TourneyStandings(collectionViewLayout: layout)
        //let chooseNavController = UINavigationController(rootViewController: tourneyStandingsPage)
        navigationController?.pushViewController(tourneyStandingsPage, animated: true)
        //present(chooseNavController, animated: true, completion: nil)
    }
    
    func setupNavBar() {
        UINavigationBar.appearance().barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
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
