//
//  WelcomePage.swift
//  Pickleball
//
//  Created by Tanner Rozier on 3/22/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

class WelcomePage: UIViewController {
    
    var newUser = 0
    
    let enterProfilePageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleEnterProfilePage), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        setupViews()
        checkIfUserLoggedIn()
    }
    
    func setupViews() {
        view.addSubview(enterProfilePageButton)
        enterProfilePageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        enterProfilePageButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        enterProfilePageButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        enterProfilePageButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc func handleEnterProfilePage() {
        let profilePage = MainMenu()
        profilePage.welcomePage = self
        present(profilePage, animated: true, completion: nil)
    }
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginPage()
        loginController.welcomePage = self
        present(loginController, animated: true, completion: nil)
    }
    


}
