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
    
    let backgroundImage: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        //bi.image = UIImage(named: "user_dashboard")
        bi.isUserInteractionEnabled = true
        return bi
    }()
    
    let createTourneyButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 56, g: 12, b: 200)
        button.setTitle("Create Tourney", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCreateTourney), for: .touchUpInside)
        return button
    }()
    
    let tourneyNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.backgroundColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        return tf
    }()
    
    let tourneyListButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 56, g: 12, b: 200)
        button.setTitle("View Tourney List", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleViewTourneys), for: .touchUpInside)
        return button
    }()
    
    @objc func handleViewTourneys() {
        let layout = UICollectionViewFlowLayout()
        let tourneyListPage = TourneyList(collectionViewLayout: layout)
        navigationController?.pushViewController(tourneyListPage, animated: true)
    }
    
    @objc func handleCreateTourney() {
        let ref = Database.database().reference().child("tourneys")
        guard let tourneyName = tourneyNameTextField.text else {
            return
        }
        let tourneyref = ref.childByAutoId()
        let values = ["name": tourneyName, "level": 3.5, "type": "ladder"] as [String : Any]
        tourneyref.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            
            
            print("Data saved successfully!")
            
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserLoggedIn()
        setupNavBar()
        setupNavBarButtons()
        
        view.backgroundColor = .white
        
        view.addSubview(backgroundImage)
        backgroundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalToConstant: 575).isActive = true
        
//        view.addSubview(createTourneyButton)
//        createTourneyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        createTourneyButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
//        createTourneyButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        createTourneyButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
//
//        view.addSubview(tourneyNameTextField)
//        tourneyNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        tourneyNameTextField.topAnchor.constraint(equalTo: createTourneyButton.bottomAnchor).isActive = true
//        tourneyNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        tourneyNameTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
//
        view.addSubview(tourneyListButton)
        tourneyListButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tourneyListButton.topAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tourneyListButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        tourneyListButton.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
    }
    
    
    func setupNavBarButtons() {
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
    
    
    func setupNavBar() {
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
        UINavigationBar.appearance().barTintColor = UIColor.init(r: 88, g: 148, b: 200)
    }

}
