//
//  CreateMatch.swift
//  Pickleball
//
//  Created by Tanner Rozier on 3/3/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

class CreateMatch: UIViewController {
    
    struct player {
        var id: String
        var username: String
        var skillLevel: String
    }
    
    var teammate = player(id: "none", username: "none", skillLevel: "none")
    var opponent1 = player(id: "none", username: "none", skillLevel: "none")
    var opponent2 = player(id: "none", username: "none", skillLevel: "none")
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let createLabel: UILabel = {
        let label = UILabel()
        label.text = "Create a Match"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    func getPlayerDetails() {
        if teammate.id != "none" {
            teammateLabel.text = teammate.username
            selectTeammateButton.setTitle("", for: .normal)
            inputsContainerViewTeam1.addSubview(teammateLabel)
            teammateLabel.leftAnchor.constraint(equalTo: inputsContainerViewTeam1.leftAnchor).isActive = true
            teammateLabel.bottomAnchor.constraint(equalTo: inputsContainerViewTeam1.bottomAnchor).isActive = true
            teammateLabel.rightAnchor.constraint(equalTo: inputsContainerViewTeam1.rightAnchor).isActive = true
            teammateLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        }
        if opponent1.id != "none" {
            opponentLabel1.text = opponent1.username
            selectOpponentButton1.setTitle("", for: .normal)
            inputsContainerViewTeam2.addSubview(opponentLabel1)
            opponentLabel1.leftAnchor.constraint(equalTo: inputsContainerViewTeam2.leftAnchor).isActive = true
            opponentLabel1.topAnchor.constraint(equalTo: inputsContainerViewTeam2.topAnchor).isActive = true
            opponentLabel1.rightAnchor.constraint(equalTo: inputsContainerViewTeam2.rightAnchor).isActive = true
            opponentLabel1.heightAnchor.constraint(equalToConstant: 75).isActive = true
        }
        if opponent2.id != "none" {
            opponentLabel2.text = opponent2.username
            selectOpponentButton2.setTitle("", for: .normal)
            inputsContainerViewTeam2.addSubview(opponentLabel2)
            opponentLabel2.leftAnchor.constraint(equalTo: inputsContainerViewTeam2.leftAnchor).isActive = true
            opponentLabel2.topAnchor.constraint(equalTo: selectOpponentButton1.bottomAnchor).isActive = true
            opponentLabel2.rightAnchor.constraint(equalTo: inputsContainerViewTeam2.rightAnchor).isActive = true
            opponentLabel2.heightAnchor.constraint(equalToConstant: 75).isActive = true
        }
    }
    
    func setupNavbarAndTitle() {
        view.addSubview(cancelButton)
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(createLabel)
        createLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        createLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        createLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSelectPlayer(sender: UIButton) {
        let layout = UICollectionViewFlowLayout()
        let friendList = FriendList(collectionViewLayout: layout)
        friendList.whoSent = sender.tag
        friendList.createMatch = self
        present(friendList, animated: true, completion: nil)
    }
    
    @objc func handleCreateMatch() {
        let uid = Auth.auth().currentUser!.uid
        let timeOfChallenge = Date().timeIntervalSince1970
        let ref = Database.database().reference().child("matches")
        let createMatchRef = ref.childByAutoId()
        let values = ["active": 0, "team_1_player_1": uid, "team_1_player_2": teammate.id, "team_2_player_1": opponent1.id, "team_2_player_2": opponent2.id, "team1_scores": [0, 0, 0, 0, 0], "team2_scores": [0, 0, 0, 0, 0], "time": timeOfChallenge] as [String : Any]
        createMatchRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            }
            guard let matchId = createMatchRef.key else {
                return
            }
            
            let ref = Database.database().reference()
            let notifications2Ref = ref.child("notifications").child(matchId)
            let toId = matchId
            let fromId = uid
            let timeStamp = Int(Date().timeIntervalSince1970)
            let values = ["type": "match", "toId": toId, "fromId" :fromId, "timestamp": timeStamp] as [String : Any]
            notifications2Ref.updateChildValues(values, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if error != nil {
                    let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(messageSendFailed, animated: true, completion: nil)
                    print("Data could not be saved: \(String(describing: error)).")
                    return
                }
            
                let notificationId = matchId
            let notificationsRef = Database.database().reference().child("user_notifications")
            let childUpdates = ["/\(uid)/\(notificationId)/": 1, "/\(self.teammate.id)/\(notificationId)/": 1, "/\(self.opponent1.id)/\(notificationId)/": 1, "/\(self.opponent2.id)/\(notificationId)/": 1,] as [String : Any]
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
            
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbarAndTitle()
        view.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        setupViews()
    }
    
    let createMatchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Match", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCreateMatch), for: .touchUpInside)
        return button
    }()

    let inputsContainerViewTeam1: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separatorView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let inputsContainerViewTeam2: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let separatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let selectTeammateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Teammate", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 1
        button.addTarget(self, action: #selector(handleSelectPlayer), for: .touchUpInside)
        return button
    }()
    
    let teammateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .center
        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
        return label
    }()
    
    let selectOpponentButton1: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Opponent 1", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 2
        button.addTarget(self, action: #selector(handleSelectPlayer), for: .touchUpInside)
        return button
    }()
    
    let opponentLabel1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .center
        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
        return label
    }()
    
    let selectOpponentButton2: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Opponent 2", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 3
        button.addTarget(self, action: #selector(handleSelectPlayer), for: .touchUpInside)
        return button
    }()
    
    let opponentLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .center
        label.textColor = UIColor.init(r: 88, g: 148, b: 200)
        return label
    }()
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var inputsContainerViewCenterYAnchor: NSLayoutConstraint?
    
    var inputsContainerViewHeightAnchor2: NSLayoutConstraint?
    var inputsContainerViewCenterYAnchor2: NSLayoutConstraint?

    func setupViews() {
        view.addSubview(inputsContainerViewTeam1)
        inputsContainerViewTeam1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerViewCenterYAnchor = inputsContainerViewTeam1.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        inputsContainerViewCenterYAnchor?.isActive = true
        inputsContainerViewTeam1.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerViewTeam1.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerViewTeam1.addSubview(selectTeammateButton)
        selectTeammateButton.leftAnchor.constraint(equalTo: inputsContainerViewTeam1.leftAnchor).isActive = true
        selectTeammateButton.bottomAnchor.constraint(equalTo: inputsContainerViewTeam1.bottomAnchor).isActive = true
        selectTeammateButton.rightAnchor.constraint(equalTo: inputsContainerViewTeam1.rightAnchor).isActive = true
        selectTeammateButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        inputsContainerViewTeam1.addSubview(separatorView1)
        separatorView1.leftAnchor.constraint(equalTo: inputsContainerViewTeam1.leftAnchor).isActive = true
        separatorView1.topAnchor.constraint(equalTo: selectTeammateButton.topAnchor).isActive = true
        separatorView1.rightAnchor.constraint(equalTo: inputsContainerViewTeam1.rightAnchor).isActive = true
        separatorView1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(inputsContainerViewTeam2)
        inputsContainerViewTeam2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerViewCenterYAnchor2 = inputsContainerViewTeam2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100)
        inputsContainerViewCenterYAnchor2?.isActive = true
        inputsContainerViewTeam2.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor2 = inputsContainerViewTeam2.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor2?.isActive = true
        
        inputsContainerViewTeam2.addSubview(selectOpponentButton1)
        selectOpponentButton1.leftAnchor.constraint(equalTo: inputsContainerViewTeam2.leftAnchor).isActive = true
        selectOpponentButton1.topAnchor.constraint(equalTo: inputsContainerViewTeam2.topAnchor).isActive = true
        selectOpponentButton1.rightAnchor.constraint(equalTo: inputsContainerViewTeam2.rightAnchor).isActive = true
        selectOpponentButton1.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        inputsContainerViewTeam2.addSubview(separatorView2)
        separatorView2.leftAnchor.constraint(equalTo: inputsContainerViewTeam2.leftAnchor).isActive = true
        separatorView2.topAnchor.constraint(equalTo: selectOpponentButton1.bottomAnchor).isActive = true
        separatorView2.rightAnchor.constraint(equalTo: inputsContainerViewTeam2.rightAnchor).isActive = true
        separatorView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputsContainerViewTeam2.addSubview(selectOpponentButton2)
        selectOpponentButton2.leftAnchor.constraint(equalTo: inputsContainerViewTeam2.leftAnchor).isActive = true
        selectOpponentButton2.topAnchor.constraint(equalTo: selectOpponentButton1.bottomAnchor).isActive = true
        selectOpponentButton2.rightAnchor.constraint(equalTo: inputsContainerViewTeam2.rightAnchor).isActive = true
        selectOpponentButton2.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        view.addSubview(createMatchButton)
        createMatchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createMatchButton.topAnchor.constraint(equalTo: inputsContainerViewTeam2.bottomAnchor, constant: 50).isActive = true
        createMatchButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        createMatchButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
}
