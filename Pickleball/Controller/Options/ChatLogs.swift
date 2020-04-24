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

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

class ChatLogs: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var recipientName = "nobody"
    var recipientDevice = "none"
    var recipientId = "none"
    var messages = [Message]()
    
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
        return tf
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 222, g: 222, b: 222)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        if UIDevice.current.hasNotch {
            containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 65)
        } else {
            containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        }
        containerView.backgroundColor = .white
        containerView.addSubview(sendButton)
        sendButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerView.addSubview(messageField)
        messageField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        messageField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        messageField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        messageField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerView.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        separatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return containerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchMessages()
        self.collectionView!.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 8, right: 0)
        collectionView.keyboardDismissMode = .interactive
        
        let widthofscreen = Int(view.frame.width)
        let recipientNameRef = Database.database().reference().child("users").child(recipientId)
        recipientNameRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.recipientDevice = value["deviceId"] as? String ?? "none"
                self.recipientName = value["username"] as? String ?? "noname"
                let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
                titleLabel.textColor = .white
                titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
                titleLabel.text = self.recipientName
                self.navigationItem.titleView = titleLabel
            }
        })
        setupKeyboardObservers()
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let index = messages.count - 1
        scrollToMenuIndex(menuIndex: index)
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {

    }
    
    func fetchMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user_messages").child(uid).child(recipientId).queryLimited(toLast: 15)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
                let messagesReference = Database.database().reference().child("messages").child(messageId)
                messagesReference.observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value as? NSDictionary {
                        let message = Message()
                        let messageText = value["message"] as? String ?? "No text"
                        let timeStamp = value["timestamp"] as? Double ?? Double(Date().timeIntervalSince1970)
                        let toId = value["toId"] as? String ?? "No toId"
                        let fromId = value["fromId"] as? String ?? "No fromId"
                        message.message = messageText
                        message.timeStamp = timeStamp
                        message.toId = toId
                        message.fromId = fromId
                        message.id = messageId
                        self.messages.append(message)
                        if self.messages.count > 15 {
                            self.deleteOldestMessage()
                        }
                        DispatchQueue.main.async { self.collectionView.reloadData()
                            self.scrollToMenuIndex(menuIndex: self.messages.count - 1)
                        }
                    }
                }, withCancel: nil)
            }, withCancel: nil)
    }
    
    func deleteOldestMessage() {
        guard let uid = Auth.auth().currentUser?.uid, let messageId = messages[0].id else {
            return
        }
        let ref = Database.database().reference().child("user_messages").child(uid).child(recipientId).child(messageId)
        ref.removeValue()
        let ref3 = Database.database().reference().child("user_messages").child(recipientId).child(uid).child(messageId)
        ref3.removeValue()
        let ref2 = Database.database().reference().child("messages").child(messageId)
        ref2.removeValue()
        messages.remove(at: 0)
        
    }
    
    
    @objc func handleSendMessage() {
        guard let uid = Auth.auth().currentUser?.uid, let message = messageField.text else {
            return
        }
        let ref = Database.database().reference()
        let messages2Ref = ref.child("messages")
        let childRef = messages2Ref.childByAutoId()
        let toId = recipientId
        let fromId = uid
        let timeStamp = Int(Date().timeIntervalSince1970)
        let values = ["message": message, "toId": toId, "fromId":fromId, "timestamp": timeStamp] as [String : Any]
        childRef.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if error != nil {
                let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(messageSendFailed, animated: true, completion: nil)
                print("Data could not be saved: \(String(describing: error)).")
                return
            }
            
            self.messageField.text = nil
            
            let messagesRef = Database.database().reference().child("user_messages")
            let messageId = childRef.key!
            let childUpdates = ["/\(uid)/\(self.recipientId)/\(messageId)/": 0, "/\(self.recipientId)/\(uid)/\(messageId)/": 1]
            messagesRef.updateChildValues(childUpdates, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if error != nil {
                    let messageSendFailed = UIAlertController(title: "Sending Message Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    messageSendFailed.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(messageSendFailed, animated: true, completion: nil)
                    print("Data could not be saved: \(String(describing: error)).")
                    return
                }
                
                print("Crazy data 2 saved!")
                Database.database().reference().child("users").child(uid).child("name").observeSingleEvent(of: .value, with: {(snapshot) in
                    if let value = snapshot.value {
                        let nameOnInvite = value as? String ?? "none"
                        let pusher = PushNotificationHandler()
                        pusher.setupPushNotification(deviceId: self.recipientDevice, message: message, title: "\(nameOnInvite)")
                        //self.setupPushNotification(deviceId: self.playersDeviceId, nameOnInvite: nameOnInvite)
                    }
                })
                
                
            })
            
            print("Crazy data saved!")
            
            
        })
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.item]
        if let message = messages[indexPath.item].message {
            cell.bubbleViewWidthAnchor?.constant = estimateFrameForText(text: message).width + 32
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 50
        
        if let text = messages[indexPath.item].message {
            height = estimateFrameForText(text: text).height + 20
        }
        
        
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: view.frame.width * (2/3) - 6, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    var containerBottomAnchor: NSLayoutConstraint?
    
    func setupViews() {
        view.addSubview(whiteContainerView)
        containerBottomAnchor = whiteContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        containerBottomAnchor?.isActive = true
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

class MessageCell: BaseCell {
    
    var message: Message? {
        didSet {
            messageText.text = message?.message ?? "No Message"
            if message?.chatPartnerId() == message?.toId {
                bubbleViewSideAnchor?.isActive = false
                bubbleViewSideAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -4)
                bubbleViewSideAnchor?.isActive = true
                messageTextSideAnchor?.isActive = false
                messageTextSideAnchor = messageText.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 6)
                messageTextSideAnchor?.isActive = true
                messageText.textColor = .white
                bubbleView.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
            } else {
                bubbleViewSideAnchor?.isActive = false
                bubbleViewSideAnchor = bubbleView.leftAnchor.constraint(equalTo: leftAnchor, constant: 4)
                bubbleViewSideAnchor?.isActive = true
                messageTextSideAnchor?.isActive = false
                messageTextSideAnchor = messageText.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 6)
                messageTextSideAnchor?.isActive = true
                messageText.textColor = .black
                bubbleView.backgroundColor = UIColor.init(r: 240, g: 240, b: 240)
            }
        }
    }
    
    let bubbleView: UIView = {
        let bv = UIView()
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.layer.cornerRadius = 15
        bv.layer.masksToBounds = true
        return bv
    }()
    
    let messageText: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "None"
        label.isEditable = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.backgroundColor = .clear
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Action", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAction() {
        print("worked")
    }
    
    var messageTextSideAnchor: NSLayoutConstraint?
    var bubbleViewSideAnchor: NSLayoutConstraint?
    var bubbleViewWidthAnchor: NSLayoutConstraint?
    
    override func setupViews() {
        
        addSubview(bubbleView)
        bubbleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bubbleViewSideAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -4)
        bubbleViewSideAnchor?.isActive = true
        bubbleViewWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: frame.width * (2/3))
        bubbleViewWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(messageText)
        messageText.topAnchor.constraint(equalTo: topAnchor).isActive = true
        messageTextSideAnchor = messageText.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 4)
        messageTextSideAnchor?.isActive = true
        messageText.widthAnchor.constraint(equalTo: bubbleView.widthAnchor, constant: -6).isActive = true
        messageText.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
}
