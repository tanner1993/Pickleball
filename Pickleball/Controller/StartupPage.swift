//
//  StartupPage.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/12/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit

class StartupPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupNavBarButtons()
    }
    
    func setupNavBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "View Tourney", style: .plain, target: self, action: #selector(handleViewTourney))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Notifications", style: .plain, target: self, action: #selector(handleViewNotifications))
    }
    @objc func handleViewNotifications() {
        let layout = UICollectionViewFlowLayout()
        let NotificationsPage = Notifications(collectionViewLayout: layout)
        navigationController?.pushViewController(NotificationsPage, animated: true)
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

}
