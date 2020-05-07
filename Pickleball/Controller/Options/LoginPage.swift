//
//  LoginPage.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/8/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginPage: UIViewController {
    
    var startupPage: StartupPage?
    var welcomePage: WelcomePage?
    var usernames = [String]()
    var emails = [String]()
    
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
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordReset: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = UIColor(r: 56, g: 12, b: 200)
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(.white, for: .normal)
        //button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        //button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePasswordResetPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLoginOrRegister), for: .touchUpInside)
        return button
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "First Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        return tf
    }()
    
    let lastNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Last Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let userNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        return tf
    }()
    
    let userNameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let loginRegSegControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLogRegChange), for: .valueChanged)
        return sc
    }()
    
    @objc func handlePasswordResetPressed() {
        let newalert = UIAlertController(title: "Password Reset", message: "Do you want a password reset link to be sent to your email?", preferredStyle: UIAlertController.Style.alert)
        newalert.addAction(UIAlertAction(title: "Send Password Reset", style: UIAlertAction.Style.default, handler: handleSendResetLink))
        newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
        self.present(newalert, animated: true, completion: nil)
    }
    
    @objc func handleSendResetLink (action: UIAlertAction) {
        guard let email = emailTextField.text else {
            return
        }
        if isValidEmail(email) != true {
            let newalert = UIAlertController(title: "Sorry", message: "This email is invalid", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil{
                let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(resetFailedAlert, animated: true, completion: nil)
            }else {
                let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(resetEmailSentAlert, animated: true, completion: nil)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        userNameTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func handleLogRegChange() {
        let title = loginRegSegControl.titleForSegment(at: loginRegSegControl.selectedSegmentIndex)
        registerButton.setTitle(title, for: .normal)
        
        inputsContainerViewHeightAnchor?.constant = loginRegSegControl.selectedSegmentIndex == 0 ? 100 : 200
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegSegControl.selectedSegmentIndex == 0 ? 0 : 1/4)
        nameTextFieldHeightAnchor?.isActive = true
        
        lastNameTextFieldHeightAnchor?.isActive = false
        lastNameTextFieldHeightAnchor = lastNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegSegControl.selectedSegmentIndex == 0 ? 0 : 1/4)
        lastNameTextFieldHeightAnchor?.isActive = true
        
        verticalSeparatorViewHeightAnchor?.isActive = false
        verticalSeparatorViewHeightAnchor = verticalSeparatorView.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegSegControl.selectedSegmentIndex == 0 ? 0 : 1/4)
        verticalSeparatorViewHeightAnchor?.isActive = true
        
        userNameTextFieldHeightAnchor?.isActive = false
        userNameTextFieldHeightAnchor = userNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegSegControl.selectedSegmentIndex == 0 ? 0 : 1/4)
        userNameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegSegControl.selectedSegmentIndex == 0 ? 1/2 : 1/4)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegSegControl.selectedSegmentIndex == 0 ? 1/2 : 1/4)
        passwordTextFieldHeightAnchor?.isActive = true
        
        passwordReset.isHidden = loginRegSegControl.selectedSegmentIndex == 0 ? false : true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 88, g: 148, b: 200)
        
        observeUsernamesEmails()
        setupContainerView()
        setupLoginRegSeg()
        setupLoginImageView()
        setupRegisterButton()
        setupKeyboardObservers()
    }
    
    func observeUsernamesEmails() {
        
        let ref = Database.database().reference().child("users")
        ref.observe(.childAdded, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let username = value["username"] as? String ?? "Player not found"
                self.usernames.append(username)
                let email = value["email"] as? String ?? "Player not found"
                self.emails.append(email)
            }
            
        }, withCancel: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        let height =  (keyboardFrame?.height)! - 150
        inputsContainerViewCenterYAnchor?.constant = -height
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        inputsContainerViewCenterYAnchor?.constant = 65
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    @objc func handleLoginOrRegister() {
        if loginRegSegControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        
        guard let email = emailTextField.text?.lowercased(), let password = passwordTextField.text?.lowercased() else {
            print("Form is not valid")
            let newalert = UIAlertController(title: "Sorry", message: "The email or password you entered is incorrect", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
            if error != nil {
                print(error as Any)
                let newalert = UIAlertController(title: "Sorry", message: "The email or password you entered is incorrect", preferredStyle: UIAlertController.Style.alert)
                newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
                self.present(newalert, animated: true, completion: nil)
                return
            }
//            self.startupPage?.observePlayerProfile()
//            self.startupPage?.fetchMessages()
//            self.startupPage?.fetchNotifications()
            
            self.dismiss(animated: true, completion: nil)
            print("Yay! You've logged in")
        })
    }
    
    @objc func handleRegister() {
        guard let email = emailTextField.text?.lowercased(), let password = passwordTextField.text, let name = nameTextField.text, let lastName = lastNameTextField.text, let username = userNameTextField.text?.lowercased() else {
            print("Form is not valid")
            return
        }
        if username.isValidName != true {
            let newalert = UIAlertController(title: "Sorry", message: "Invalid Username. Must be between 3 and 13 characters, only letters, numbers, and underscores allowed", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        if name.isValidFirstName != true {
            let newalert = UIAlertController(title: "Sorry", message: "Invalid First Name. Must be between 2 and 16 characters, only letters allowed", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        if lastName.isValidFirstName != true {
            let newalert = UIAlertController(title: "Sorry", message: "Invalid Last Name. Must be between 2 and 16 characters, only letters allowed", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        if usernames.contains(username) == true {
            let newalert = UIAlertController(title: "Sorry", message: "This username has already been taken, please select a different one", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        if emails.contains(email) == true {
            let newalert = UIAlertController(title: "Sorry", message: "This email has already been taken, please select a different one", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        if isValidEmail(email) != true {
            let newalert = UIAlertController(title: "Sorry", message: "This email is invalid", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        if password.count < 6 {
            let newalert = UIAlertController(title: "Sorry", message: "The password must be at least 6 characters long", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        print(username)
        Auth.auth().createUser(withEmail: email, password: password, completion: {(authDataResult: AuthDataResult?, error) in
            if error != nil {
                print(error as Any)
                return
            }
            
            guard let uid = authDataResult?.user.uid else {
                return
            }
            
            let ref = Database.database().reference()
            let usersref = ref.child("users").child(uid)
            let fullName = name + " " + lastName
            let values = ["name": fullName, "email": email, "username": username, "exp": 0, "state": "none", "county": "none", "skill_level": Float(0), "court": "none", "match_wins": 0, "match_losses": 0, "tourneys_played": 0, "tourneys_won": 0, "birthdate": Double(0), "sex": "none"] as [String : Any]
            usersref.updateChildValues(values, withCompletionBlock: {
                (error:Error?, ref:DatabaseReference) in
                
                if let error = error {
                    print("Data could not be saved: \(error).")
                    return
                }
                let editProfile = EditProfile()
                editProfile.sender = 1
                editProfile.loginPage = self
                editProfile.modalPresentationStyle = .fullScreen
                self.present(editProfile, animated: true, completion: nil)
                //self.startupPage?.observePlayerProfile()
                //self.welcomePage?.newUser = 1
                //self.dismiss(animated: true, completion: nil)
                
                print("Data saved successfully!")

                    
            })
        })
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func setupLoginRegSeg() {
        view.addSubview(loginRegSegControl)
        loginRegSegControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegSegControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegSegControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 0.5).isActive = true
        loginRegSegControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupLoginImageView() {
        view.addSubview(loginImageView)
        loginImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginImageView.bottomAnchor.constraint(equalTo: loginRegSegControl.topAnchor, constant: -15).isActive = true
        loginImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(brandImageView)
        brandImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        brandImageView.bottomAnchor.constraint(equalTo: loginImageView.topAnchor, constant: -5).isActive = true
        brandImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        brandImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var lastNameTextFieldHeightAnchor: NSLayoutConstraint?
    var userNameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var inputsContainerViewCenterYAnchor: NSLayoutConstraint?
    var verticalSeparatorViewHeightAnchor: NSLayoutConstraint?
    
    let verticalSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupContainerView() {
        view.addSubview(inputsContainerView)
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerViewCenterYAnchor = inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 65)
        inputsContainerViewCenterYAnchor?.isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: inputsContainerView.centerXAnchor, constant: -2).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        nameTextFieldHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(lastNameTextField)
        lastNameTextField.leftAnchor.constraint(equalTo: inputsContainerView.centerXAnchor, constant: 12).isActive = true
        lastNameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        lastNameTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -2).isActive = true
        lastNameTextFieldHeightAnchor = lastNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        lastNameTextFieldHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(verticalSeparatorView)
        verticalSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        verticalSeparatorView.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        verticalSeparatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorViewHeightAnchor = verticalSeparatorView.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        verticalSeparatorViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameSeparatorView)
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputsContainerView.addSubview(userNameTextField)
        userNameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        userNameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        userNameTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: 4).isActive = true
        userNameTextFieldHeightAnchor = userNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        userNameTextFieldHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(userNameSeparatorView)
        userNameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        userNameSeparatorView.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor).isActive = true
        userNameSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        userNameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputsContainerView.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: 4).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        emailTextFieldHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(emailSeparatorView)
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputsContainerView.addSubview(passwordTextField)
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: 4).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupRegisterButton() {
        view.addSubview(registerButton)
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(passwordReset)
        passwordReset.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordReset.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 12).isActive = true
        passwordReset.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        passwordReset.heightAnchor.constraint(equalToConstant: 25).isActive = true
        passwordReset.isHidden = true
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


}
