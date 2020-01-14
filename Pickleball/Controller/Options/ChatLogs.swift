//
//  ChatLogs.swift
//  Pickleball
//
//  Created by Tanner Rozier on 1/13/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

private let reuseIdentifier = "Cell"

class ChatLogs: UICollectionViewController {
    
    var recipientName = "nobody"

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        titleLabel.text = recipientName
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.navigationItem.titleView = titleLabel
    }
    
    @objc func handleSendMessage() {
        guard let message = messageField.text else {
            return
        }
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference()
        let messagesRef = ref.child("messages")
        let childRef = messagesRef.childByAutoId()
//        let values = ["name": name, "email": email, "username": username, "exp": 0, "state": state, "county": county, "skill_level": Float(skillLevel)!, "court": "none", "match_wins": 0, "match_losses": 0, "tourneys_played": 0, "tourneys_won": 0, "birthdate": birthdate, "sex": sex] as [String : Any]
//        usersref.updateChildValues(values, withCompletionBlock: {
//            (error:Error?, ref:DatabaseReference) in
//
//            if error != nil {
//                let newalert = UIAlertController(title: "Sorry", message: "Could not save the data", preferredStyle: UIAlertController.Style.alert)
//                newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
//                self.present(newalert, animated: true, completion: nil)
//                return
//            }
//
//            print("Data saved successfully!")
//
//
//        })
    }



    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
    
        return cell
    }
    
    let whiteContainerView: UIView = {
        let wc = UIView()
        wc.translatesAutoresizingMaskIntoConstraints = false
        wc.backgroundColor = .white
        return wc
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    let messageField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter message..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        //tf.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        return tf
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 222, g: 222, b: 222)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        view.addSubview(whiteContainerView)
        whiteContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        whiteContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        whiteContainerView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        whiteContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        whiteContainerView.addSubview(sendButton)
        sendButton.topAnchor.constraint(equalTo: whiteContainerView.topAnchor, constant: 0).isActive = true
        sendButton.rightAnchor.constraint(equalTo: whiteContainerView.rightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: whiteContainerView.heightAnchor).isActive = true
        
        whiteContainerView.addSubview(messageField)
        messageField.topAnchor.constraint(equalTo: whiteContainerView.topAnchor, constant: 0).isActive = true
        messageField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        messageField.leftAnchor.constraint(equalTo: whiteContainerView.leftAnchor, constant: 8).isActive = true
        messageField.heightAnchor.constraint(equalTo: whiteContainerView.heightAnchor).isActive = true
        
        whiteContainerView.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: whiteContainerView.topAnchor, constant: 0).isActive = true
        separatorView.widthAnchor.constraint(equalTo: whiteContainerView.widthAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: whiteContainerView.leftAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }


}
