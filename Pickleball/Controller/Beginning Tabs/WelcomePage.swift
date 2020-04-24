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
    
    var matchNotif = false
    var tourneyNotif = false
    
    let enterProfilePageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 50)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleEnterProfilePage), for: .touchUpInside)
        return button
    }()
    
    let brandImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "brandName")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let loginImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "crossed_paddles")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let welcomeLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Welcome to"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "HelveticaNeue-Light", size: 40)
        lb.textAlignment = .center
        lb.textColor = .white
        return lb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        setupViews()
        checkIfUserLoggedIn()
    }
    
    func setupViews() {
        view.addSubview(loginImageView)
        loginImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -75).isActive = true
        loginImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        loginImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(brandImageView)
        brandImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        brandImageView.bottomAnchor.constraint(equalTo: loginImageView.topAnchor, constant: -5).isActive = true
        brandImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        brandImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(welcomeLabel)
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.bottomAnchor.constraint(equalTo: brandImageView.topAnchor, constant: 10).isActive = true
        welcomeLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(enterProfilePageButton)
        enterProfilePageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        enterProfilePageButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        enterProfilePageButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        enterProfilePageButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func handleEnterProfilePage() {
        let profilePage = MainMenu()
        UIApplication.shared.applicationIconBadgeNumber = 0
        profilePage.welcomePage = self
        profilePage.tabBar.isTranslucent = false
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
