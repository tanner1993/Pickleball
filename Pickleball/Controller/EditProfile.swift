//
//  EditProfile.swift
//  Pickleball
//
//  Created by Tanner Rozier on 1/5/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class EditProfile: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var inputsContainerViewCenterYAnchor: NSLayoutConstraint?
    let blackView = UIView()
    var selectedDropDown = 0
    var usernames = [String]()
    var emails = [String]()
    var sender = 0
    var loginPage: LoginPage?
    var startupPage: StartupPage?
    var dayInt = 0
    var monthInt = 0
    var yearInt = 0
    
    @objc func handleSaveChanges() {
        guard let email = emailTextField.text?.lowercased(), let name = nameTextField.text, let username = usernameTextField.text?.lowercased(), let state = stateTextField.text, let county = countyTextField.text, let month = monthTextField.text, let day = dayTextField.text, let year = yearTextField.text, let skillLevel = skillLevelTextField.text, let sex = sexTextField.text else {
            let newalert = UIAlertController(title: "Sorry", message: "One or more fields are incorrect", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        if name == "" || state == "" || county == "" || month == "Month" || day == "Day" || year == "Year" || skillLevel == "" || sex == "" {
            let newalert = UIAlertController(title: "Sorry", message: "One or more fields are incorrect", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
        }
        
        if username.isValidName != true {
            let newalert = UIAlertController(title: "Sorry", message: "Invalid Username. Must be between 3 and 15 characters, only letters, numbers, and underscores allowed", preferredStyle: UIAlertController.Style.alert)
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
        let newalert = UIAlertController(title: "Confirm", message: "Are you sure you want to save these changes?", preferredStyle: UIAlertController.Style.alert)
        newalert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        newalert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: saveChanges))
        self.present(newalert, animated: true, completion: nil)
    }
    
    @objc func saveChanges(action: UIAlertAction) {
        guard let email = emailTextField.text?.lowercased(), let name = nameTextField.text, let username = usernameTextField.text?.lowercased(), let state = stateTextField.text, let county = countyTextField.text, let month = monthTextField.text, let day = dayTextField.text, let year = yearTextField.text, let skillLevel = skillLevelTextField.text, let sex = sexTextField.text else {
            let newalert = UIAlertController(title: "Sorry", message: "One or more fields are incorrect", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = dayInt
        components.month = monthInt
        components.year = yearInt
        components.hour = 12
        components.minute = 0
        
        let newDate = calendar.date(from: components)
        
        let birthdate = Double((newDate?.timeIntervalSince1970)!)
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference()
        let usersref = ref.child("users").child(uid)
        let values = ["name": name, "email": email, "username": username, "exp": 0, "state": state, "county": county, "skill_level": Float(skillLevel)!, "court": "none", "match_wins": 0, "match_losses": 0, "tourneys_played": 0, "tourneys_won": 0, "birthdate": birthdate, "sex": sex] as [String : Any]
        usersref.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if error != nil {
                let newalert = UIAlertController(title: "Sorry", message: "Could not save the data", preferredStyle: UIAlertController.Style.alert)
                newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
                self.present(newalert, animated: true, completion: nil)
                return
            }
            self.dismiss(animated: true, completion: nil)
            if self.sender == 1 {
                self.loginPage?.dismiss(animated: true, completion: nil)
                self.loginPage?.startupPage?.observePlayerProfile()
            } else if self.sender == 2 {
                self.startupPage?.observePlayerProfile()
            }
            
            print("Data saved successfully!")
            
            
        })
    }
    
    func observeUsernamesEmails() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("users")
        ref.observe(.childAdded, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let username = value["username"] as? String ?? "Player not found"
                let email = value["email"] as? String ?? "Player not found"
                if snapshot.key != uid {
                    self.usernames.append(username)
                    self.emails.append(email)
                } else if snapshot.key == uid {
                    self.nameTextField.text = value["name"] as? String ?? "Player not found"
                    self.usernameTextField.text = value["username"] as? String ?? "Player not found"
                    self.emailTextField.text = value["email"] as? String ?? "Player not found"
                    if self.sender == 2 {
                        self.stateTextField.text = value["state"] as? String ?? ""
                        self.countyTextField.text = value["county"] as? String ?? ""
                        let birthdate = value["birthdate"] as? Double ?? 0
                        let calendar = Calendar.current
                        let birthdateDate = Date(timeIntervalSince1970: birthdate)
                        let components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: birthdateDate)
                        self.monthTextField.text = "\(components.month!)"
                        self.dayTextField.text = "\(components.day!)"
                        self.yearTextField.text = "\(components.year!)"
                        self.skillLevelTextField.text = "\(value["skill_level"] as? Float ?? 0)"
                        self.sexTextField.text = value["sex"] as? String ?? ""
                    }
                }
            }
            
        }, withCancel: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func handleStateDropDown() {
        selectedDropDown = 1
        collectionView.reloadData()
        collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: [], animated: false)
        handleDropDown()
    }
    
    @objc func handleCountyDropDown() {
        selectedDropDown = 2
        collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: [], animated: false)
        collectionView.reloadData()
        handleDropDown()
    }
    
    @objc func handleMonthDropDown() {
        selectedDropDown = 3
        collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: [], animated: false)
        collectionView.reloadData()
        handleDropDown()
    }
    
    @objc func handleDayDropDown() {
        selectedDropDown = 4
        for index in 1...31 {
            days.append(index)
        }
        collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: [], animated: false)
        collectionView.reloadData()
        handleDropDown()
    }
    
    @objc func handleYearDropDown() {
        selectedDropDown = 5
        for index in 1920...2020 {
            years.append(index)
        }
        collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: [], animated: false)
        years = years.reversed()
        collectionView.reloadData()
        handleDropDown()
    }
    
    @objc func handleSkillLevelDropDown() {
        selectedDropDown = 6
        collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: [], animated: false)
        collectionView.reloadData()
        handleDropDown()
    }
    
    @objc func handleSexDropDown() {
        selectedDropDown = 7
        collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: [], animated: false)
        collectionView.reloadData()
        handleDropDown()
    }
    
    func handleDropDown() {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        self.view.endEditing(true)
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu)))
            window.addSubview(blackView)
            window.addSubview(collectionView)
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 350)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height - 350, width: window.frame.width, height: 350)
            }, completion: nil)
        }
    }
    
    @objc func dismissMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 350)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        observeUsernamesEmails()
        setupViews()
        setupCollectionView()
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    let cellId = "cellId"
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProfileMenuCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch selectedDropDown {
        case 1:
            return states.count
        case 2:
            return counties.count
        case 3:
            return months.count
        case 4:
            return days.count
        case 5:
            return years.count
        case 6:
            return skillLevels.count
        case 7:
            return sexes.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProfileMenuCell
        switch selectedDropDown {
        case 1:
            cell.menuItem.text = states[indexPath.item]
        case 2:
            cell.menuItem.text = counties[indexPath.item]
        case 3:
            cell.menuItem.text = months[indexPath.item]
        case 4:
            cell.menuItem.text = "\(days[indexPath.item])"
        case 5:
            cell.menuItem.text = "\(years[indexPath.item])"
        case 6:
            cell.menuItem.text = "\(skillLevels[indexPath.item])"
        case 7:
            cell.menuItem.text = sexes[indexPath.item]
        default:
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch selectedDropDown {
        case 1:
            stateTextField.text = states[indexPath.item]
        case 2:
            countyTextField.text = counties[indexPath.item]
        case 3:
            monthTextField.text = months[indexPath.item]
            monthTextField.textColor = .black
            monthInt = monthInts[indexPath.item]
        case 4:
            dayTextField.text = "\(days[indexPath.item])"
            dayTextField.textColor = .black
            dayInt = days[indexPath.item]
        case 5:
            yearTextField.text = "\(years[indexPath.item])"
            yearTextField.textColor = .black
            yearInt = years[indexPath.item]
        case 6:
            skillLevelTextField.text = "\(skillLevels[indexPath.item])"
        case 7:
            sexTextField.text = sexes[indexPath.item]
        default:
            print("poop")
        }
        dismissMenu()
    }
    
    let saveChanges: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = .white
        button.setTitle("Save Changes", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 35)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSaveChanges), for: .touchUpInside)
        return button
    }()
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let editProfileLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Edit Profile Information"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        lb.textAlignment = .center
        lb.textColor = .white
        return lb
    }()
    
    let nameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Name"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "HelveticaNeue", size: 20)
        return lb
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        //tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let verticalSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let usernameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Username"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "HelveticaNeue", size: 20)
        return lb
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        //tf.placeholder = "Name"
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        return tf
    }()
    
    let usernameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let verticalSeparatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Email"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "HelveticaNeue", size: 20)
        return lb
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        //tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let verticalSeparatorView3: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let stateLabel: UILabel = {
        let lb = UILabel()
        lb.text = "State"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "HelveticaNeue", size: 20)
        return lb
    }()
    
    let stateTextField: UILabel = {
        let tf = UILabel()
        //tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        return tf
    }()
    
    let stateDropDown: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleStateDropDown), for: .touchUpInside)
        return button
    }()
    
    let stateSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let verticalSeparatorView4: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let countyLabel: UILabel = {
        let lb = UILabel()
        lb.text = "County"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "HelveticaNeue", size: 20)
        return lb
    }()
    
    let countyTextField: UILabel = {
        let tf = UILabel()
        //tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        return tf
    }()
    
    let countyDropDown: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCountyDropDown), for: .touchUpInside)
        return button
    }()
    
    let countySeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let verticalSeparatorView5: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    
    let inputsContainerView2: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let birthdateLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Birthdate"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "HelveticaNeue", size: 20)
        return lb
    }()
    
    let monthTextField: UILabel = {
        let tf = UILabel()
        tf.text = "Month"
        tf.textAlignment = .center
        tf.textColor = UIColor.init(r: 220, g: 220, b: 220)
        tf.translatesAutoresizingMaskIntoConstraints = false
        //tf.backgroundColor = .yellow
        tf.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        return tf
    }()
    
    let monthDropDown: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleMonthDropDown), for: .touchUpInside)
        return button
    }()
    
    let dayTextField: UILabel = {
        let tf = UILabel()
        //tf.backgroundColor = .blue
        tf.text = "Day"
        tf.textAlignment = .center
        tf.textColor = UIColor.init(r: 220, g: 220, b: 220)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        return tf
    }()
    
    let dayDropDown: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDayDropDown), for: .touchUpInside)
        return button
    }()
    
    let yearTextField: UILabel = {
        let tf = UILabel()
        //tf.backgroundColor = .brown
        tf.text = "Year"
        tf.textAlignment = .center
        tf.textColor = UIColor.init(r: 220, g: 220, b: 220)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        return tf
    }()
    
    let yearDropDown: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleYearDropDown), for: .touchUpInside)
        return button
    }()
    
    let birthdateSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let verticalSeparatorView6: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let verticalSeparatorView7: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let verticalSeparatorView8: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let skillLevelLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Skill Level"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "HelveticaNeue", size: 20)
        return lb
    }()
    
    let skillLevelTextField: UILabel = {
        let tf = UILabel()
        //tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        return tf
    }()
    
    let skillLevelDropDown: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSkillLevelDropDown), for: .touchUpInside)
        return button
    }()
    
    let skillLevelSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let verticalSeparatorView9: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let sexLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Sex"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "HelveticaNeue", size: 20)
        return lb
    }()
    
    let sexTextField: UILabel = {
        let tf = UILabel()
        //tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        return tf
    }()
    
    let sexDropDown: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSexDropDown), for: .touchUpInside)
        return button
    }()
    
    let verticalSeparatorView10: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    func setupViews() {
        view.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        
        view.addSubview(inputsContainerView)
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerViewCenterYAnchor = inputsContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)
        inputsContainerViewCenterYAnchor?.isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        view.addSubview(inputsContainerView2)
        inputsContainerView2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView2.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 40).isActive = true
        inputsContainerView2.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView2.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(saveChanges)
        saveChanges.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveChanges.topAnchor.constraint(equalTo: inputsContainerView2.bottomAnchor, constant: 40).isActive = true
        saveChanges.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        saveChanges.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        view.addSubview(editProfileLabel)
        editProfileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editProfileLabel.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -15).isActive = true
        editProfileLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        editProfileLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        inputsContainerView.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameLabel.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 110).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 8).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: 4).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        inputsContainerView.addSubview(nameSeparatorView)
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputsContainerView.addSubview(verticalSeparatorView)
        verticalSeparatorView.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        verticalSeparatorView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        verticalSeparatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView.heightAnchor.constraint(equalTo: nameLabel.heightAnchor, constant: -12).isActive = true
        
        inputsContainerView.addSubview(usernameLabel)
        usernameLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 110).isActive = true
        usernameLabel.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        inputsContainerView.addSubview(usernameTextField)
        usernameTextField.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 8).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: usernameLabel.topAnchor).isActive = true
        usernameTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: 4).isActive = true
        usernameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        inputsContainerView.addSubview(usernameSeparatorView)
        usernameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        usernameSeparatorView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
        usernameSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        usernameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputsContainerView.addSubview(verticalSeparatorView2)
        verticalSeparatorView2.rightAnchor.constraint(equalTo: usernameLabel.rightAnchor).isActive = true
        verticalSeparatorView2.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true
        verticalSeparatorView2.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView2.heightAnchor.constraint(equalTo: usernameLabel.heightAnchor, constant: -12).isActive = true
        
        inputsContainerView.addSubview(emailLabel)
        emailLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 110).isActive = true
        emailLabel.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        inputsContainerView.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: emailLabel.rightAnchor, constant: 8).isActive = true
        emailTextField.topAnchor.constraint(equalTo: emailLabel.topAnchor).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: 4).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        inputsContainerView.addSubview(emailSeparatorView)
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor).isActive = true
        emailSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputsContainerView.addSubview(verticalSeparatorView3)
        verticalSeparatorView3.rightAnchor.constraint(equalTo: emailLabel.rightAnchor).isActive = true
        verticalSeparatorView3.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor).isActive = true
        verticalSeparatorView3.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView3.heightAnchor.constraint(equalTo: emailLabel.heightAnchor, constant: -12).isActive = true
        
        inputsContainerView.addSubview(stateLabel)
        stateLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        stateLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor).isActive = true
        stateLabel.rightAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 110).isActive = true
        stateLabel.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        inputsContainerView.addSubview(stateTextField)
        stateTextField.leftAnchor.constraint(equalTo: stateLabel.rightAnchor, constant: 8).isActive = true
        stateTextField.topAnchor.constraint(equalTo: stateLabel.topAnchor).isActive = true
        stateTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: 4).isActive = true
        stateTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        inputsContainerView.addSubview(stateDropDown)
        stateDropDown.leftAnchor.constraint(equalTo: stateLabel.rightAnchor, constant: 8).isActive = true
        stateDropDown.topAnchor.constraint(equalTo: stateLabel.topAnchor).isActive = true
        stateDropDown.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: 4).isActive = true
        stateDropDown.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        inputsContainerView.addSubview(stateSeparatorView)
        stateSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        stateSeparatorView.topAnchor.constraint(equalTo: stateLabel.bottomAnchor).isActive = true
        stateSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        stateSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputsContainerView.addSubview(verticalSeparatorView4)
        verticalSeparatorView4.rightAnchor.constraint(equalTo: stateLabel.rightAnchor).isActive = true
        verticalSeparatorView4.centerYAnchor.constraint(equalTo: stateLabel.centerYAnchor).isActive = true
        verticalSeparatorView4.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView4.heightAnchor.constraint(equalTo: stateLabel.heightAnchor, constant: -12).isActive = true
        
        inputsContainerView.addSubview(countyLabel)
        countyLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        countyLabel.topAnchor.constraint(equalTo: stateLabel.bottomAnchor).isActive = true
        countyLabel.rightAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 110).isActive = true
        countyLabel.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        inputsContainerView.addSubview(countyTextField)
        countyTextField.leftAnchor.constraint(equalTo: countyLabel.rightAnchor, constant: 8).isActive = true
        countyTextField.topAnchor.constraint(equalTo: countyLabel.topAnchor).isActive = true
        countyTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: 4).isActive = true
        countyTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        inputsContainerView.addSubview(countyDropDown)
        countyDropDown.leftAnchor.constraint(equalTo: countyLabel.rightAnchor, constant: 8).isActive = true
        countyDropDown.topAnchor.constraint(equalTo: countyLabel.topAnchor).isActive = true
        countyDropDown.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: 4).isActive = true
        countyDropDown.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        
        inputsContainerView.addSubview(countySeparatorView)
        countySeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        countySeparatorView.topAnchor.constraint(equalTo: countyLabel.bottomAnchor).isActive = true
        countySeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        countySeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputsContainerView.addSubview(verticalSeparatorView5)
        verticalSeparatorView5.rightAnchor.constraint(equalTo: countyLabel.rightAnchor).isActive = true
        verticalSeparatorView5.centerYAnchor.constraint(equalTo: countyLabel.centerYAnchor).isActive = true
        verticalSeparatorView5.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView5.heightAnchor.constraint(equalTo: countyLabel.heightAnchor, constant: -12).isActive = true
        
        inputsContainerView2.addSubview(birthdateLabel)
        birthdateLabel.leftAnchor.constraint(equalTo: inputsContainerView2.leftAnchor, constant: 12).isActive = true
        birthdateLabel.topAnchor.constraint(equalTo: inputsContainerView2.topAnchor).isActive = true
        birthdateLabel.rightAnchor.constraint(equalTo: inputsContainerView2.leftAnchor, constant: 110).isActive = true
        birthdateLabel.heightAnchor.constraint(equalTo: inputsContainerView2.heightAnchor, multiplier: 1/3).isActive = true
        
        inputsContainerView2.addSubview(monthTextField)
        monthTextField.leftAnchor.constraint(equalTo: birthdateLabel.rightAnchor, constant: 0).isActive = true
        monthTextField.topAnchor.constraint(equalTo: birthdateLabel.topAnchor).isActive = true
        monthTextField.widthAnchor.constraint(equalToConstant: 125).isActive = true
        monthTextField.heightAnchor.constraint(equalTo: inputsContainerView2.heightAnchor, multiplier: 1/3).isActive = true
        
        inputsContainerView2.addSubview(monthDropDown)
        monthDropDown.leftAnchor.constraint(equalTo: birthdateLabel.rightAnchor, constant: 0).isActive = true
        monthDropDown.topAnchor.constraint(equalTo: birthdateLabel.topAnchor).isActive = true
        monthDropDown.widthAnchor.constraint(equalToConstant: 125).isActive = true
        monthDropDown.heightAnchor.constraint(equalTo: inputsContainerView2.heightAnchor, multiplier: 1/3).isActive = true
        
        inputsContainerView2.addSubview(dayTextField)
        dayTextField.leftAnchor.constraint(equalTo: monthTextField.rightAnchor, constant: 0).isActive = true
        dayTextField.topAnchor.constraint(equalTo: birthdateLabel.topAnchor).isActive = true
        dayTextField.widthAnchor.constraint(equalToConstant: 55).isActive = true
        dayTextField.heightAnchor.constraint(equalTo: inputsContainerView2.heightAnchor, multiplier: 1/3).isActive = true
        
        inputsContainerView2.addSubview(dayDropDown)
        dayDropDown.leftAnchor.constraint(equalTo: monthTextField.rightAnchor, constant: 0).isActive = true
        dayDropDown.topAnchor.constraint(equalTo: birthdateLabel.topAnchor).isActive = true
        dayDropDown.widthAnchor.constraint(equalToConstant: 55).isActive = true
        dayDropDown.heightAnchor.constraint(equalTo: inputsContainerView2.heightAnchor, multiplier: 1/3).isActive = true
        
        inputsContainerView2.addSubview(yearTextField)
        yearTextField.leftAnchor.constraint(equalTo: dayTextField.rightAnchor, constant: 0).isActive = true
        yearTextField.topAnchor.constraint(equalTo: birthdateLabel.topAnchor).isActive = true
        yearTextField.rightAnchor.constraint(equalTo: inputsContainerView2.rightAnchor, constant: -2).isActive = true
        yearTextField.heightAnchor.constraint(equalTo: inputsContainerView2.heightAnchor, multiplier: 1/3).isActive = true

        inputsContainerView2.addSubview(yearDropDown)
        yearDropDown.leftAnchor.constraint(equalTo: dayTextField.rightAnchor, constant: 0).isActive = true
        yearDropDown.topAnchor.constraint(equalTo: birthdateLabel.topAnchor).isActive = true
        yearDropDown.rightAnchor.constraint(equalTo: inputsContainerView2.rightAnchor, constant: -2).isActive = true
        yearDropDown.heightAnchor.constraint(equalTo: inputsContainerView2.heightAnchor, multiplier: 1/3).isActive = true
        
        inputsContainerView2.addSubview(birthdateSeparatorView)
        birthdateSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView2.leftAnchor).isActive = true
        birthdateSeparatorView.topAnchor.constraint(equalTo: birthdateLabel.bottomAnchor).isActive = true
        birthdateSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView2.rightAnchor).isActive = true
        birthdateSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputsContainerView2.addSubview(verticalSeparatorView6)
        verticalSeparatorView6.rightAnchor.constraint(equalTo: birthdateLabel.rightAnchor).isActive = true
        verticalSeparatorView6.centerYAnchor.constraint(equalTo: birthdateLabel.centerYAnchor).isActive = true
        verticalSeparatorView6.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView6.heightAnchor.constraint(equalTo: birthdateLabel.heightAnchor, constant: -12).isActive = true
        
        inputsContainerView2.addSubview(verticalSeparatorView7)
        verticalSeparatorView7.rightAnchor.constraint(equalTo: monthTextField.rightAnchor).isActive = true
        verticalSeparatorView7.centerYAnchor.constraint(equalTo: birthdateLabel.centerYAnchor).isActive = true
        verticalSeparatorView7.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView7.heightAnchor.constraint(equalTo: birthdateLabel.heightAnchor, constant: -12).isActive = true
        
        inputsContainerView2.addSubview(verticalSeparatorView8)
        verticalSeparatorView8.rightAnchor.constraint(equalTo: dayTextField.rightAnchor).isActive = true
        verticalSeparatorView8.centerYAnchor.constraint(equalTo: birthdateLabel.centerYAnchor).isActive = true
        verticalSeparatorView8.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView8.heightAnchor.constraint(equalTo: birthdateLabel.heightAnchor, constant: -12).isActive = true
        
        inputsContainerView2.addSubview(skillLevelLabel)
        skillLevelLabel.leftAnchor.constraint(equalTo: inputsContainerView2.leftAnchor, constant: 12).isActive = true
        skillLevelLabel.topAnchor.constraint(equalTo: birthdateLabel.bottomAnchor).isActive = true
        skillLevelLabel.rightAnchor.constraint(equalTo: inputsContainerView2.leftAnchor, constant: 110).isActive = true
        skillLevelLabel.heightAnchor.constraint(equalTo: inputsContainerView2.heightAnchor, multiplier: 1/3).isActive = true
        
        inputsContainerView2.addSubview(skillLevelTextField)
        skillLevelTextField.leftAnchor.constraint(equalTo: skillLevelLabel.rightAnchor, constant: 8).isActive = true
        skillLevelTextField.topAnchor.constraint(equalTo: skillLevelLabel.topAnchor).isActive = true
        skillLevelTextField.rightAnchor.constraint(equalTo: inputsContainerView2.rightAnchor, constant: 4).isActive = true
        skillLevelTextField.heightAnchor.constraint(equalTo: inputsContainerView2.heightAnchor, multiplier: 1/3).isActive = true
        
        inputsContainerView2.addSubview(skillLevelDropDown)
        skillLevelDropDown.leftAnchor.constraint(equalTo: skillLevelLabel.rightAnchor, constant: 8).isActive = true
        skillLevelDropDown.topAnchor.constraint(equalTo: skillLevelLabel.topAnchor).isActive = true
        skillLevelDropDown.rightAnchor.constraint(equalTo: inputsContainerView2.rightAnchor, constant: 4).isActive = true
        skillLevelDropDown.heightAnchor.constraint(equalTo: inputsContainerView2.heightAnchor, multiplier: 1/3).isActive = true
        
        inputsContainerView2.addSubview(skillLevelSeparatorView)
        skillLevelSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView2.leftAnchor).isActive = true
        skillLevelSeparatorView.topAnchor.constraint(equalTo: skillLevelLabel.bottomAnchor).isActive = true
        skillLevelSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView2.rightAnchor).isActive = true
        skillLevelSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputsContainerView2.addSubview(verticalSeparatorView9)
        verticalSeparatorView9.rightAnchor.constraint(equalTo: skillLevelLabel.rightAnchor).isActive = true
        verticalSeparatorView9.centerYAnchor.constraint(equalTo: skillLevelLabel.centerYAnchor).isActive = true
        verticalSeparatorView9.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView9.heightAnchor.constraint(equalTo: skillLevelLabel.heightAnchor, constant: -12).isActive = true
        
        inputsContainerView2.addSubview(sexLabel)
        sexLabel.leftAnchor.constraint(equalTo: inputsContainerView2.leftAnchor, constant: 12).isActive = true
        sexLabel.topAnchor.constraint(equalTo: skillLevelLabel.bottomAnchor).isActive = true
        sexLabel.rightAnchor.constraint(equalTo: inputsContainerView2.leftAnchor, constant: 110).isActive = true
        sexLabel.heightAnchor.constraint(equalTo: inputsContainerView2.heightAnchor, multiplier: 1/3).isActive = true
        
        inputsContainerView2.addSubview(sexTextField)
        sexTextField.leftAnchor.constraint(equalTo: sexLabel.rightAnchor, constant: 8).isActive = true
        sexTextField.topAnchor.constraint(equalTo: sexLabel.topAnchor).isActive = true
        sexTextField.rightAnchor.constraint(equalTo: inputsContainerView2.rightAnchor, constant: 4).isActive = true
        sexTextField.heightAnchor.constraint(equalTo: inputsContainerView2.heightAnchor, multiplier: 1/3).isActive = true
        
        inputsContainerView2.addSubview(sexDropDown)
        sexDropDown.leftAnchor.constraint(equalTo: sexLabel.rightAnchor, constant: 8).isActive = true
        sexDropDown.topAnchor.constraint(equalTo: sexLabel.topAnchor).isActive = true
        sexDropDown.rightAnchor.constraint(equalTo: inputsContainerView2.rightAnchor, constant: 4).isActive = true
        sexDropDown.heightAnchor.constraint(equalTo: inputsContainerView2.heightAnchor, multiplier: 1/3).isActive = true
        
        inputsContainerView2.addSubview(verticalSeparatorView10)
        verticalSeparatorView10.rightAnchor.constraint(equalTo: sexLabel.rightAnchor).isActive = true
        verticalSeparatorView10.centerYAnchor.constraint(equalTo: sexLabel.centerYAnchor).isActive = true
        verticalSeparatorView10.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView10.heightAnchor.constraint(equalTo: sexLabel.heightAnchor, constant: -12).isActive = true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    let states = ["Utah"]
//    let states = [ "AK - Alaska",
//                  "AL - Alabama",
//                  "AR - Arkansas",
//                  "AS - American Samoa",
//                  "AZ - Arizona",
//                  "CA - California",
//                  "CO - Colorado",
//                  "CT - Connecticut",
//                  "DC - District of Columbia",
//                  "DE - Delaware",
//                  "FL - Florida",
//                  "GA - Georgia",
//                  "GU - Guam",
//                  "HI - Hawaii",
//                  "IA - Iowa",
//                  "ID - Idaho",
//                  "IL - Illinois",
//                  "IN - Indiana",
//                  "KS - Kansas",
//                  "KY - Kentucky",
//                  "LA - Louisiana",
//                  "MA - Massachusetts",
//                  "MD - Maryland",
//                  "ME - Maine",
//                  "MI - Michigan",
//                  "MN - Minnesota",
//                  "MO - Missouri",
//                  "MS - Mississippi",
//                  "MT - Montana",
//                  "NC - North Carolina",
//                  "ND - North Dakota",
//                  "NE - Nebraska",
//                  "NH - New Hampshire",
//                  "NJ - New Jersey",
//                  "NM - New Mexico",
//                  "NV - Nevada",
//                  "NY - New York",
//                  "OH - Ohio",
//                  "OK - Oklahoma",
//                  "OR - Oregon",
//                  "PA - Pennsylvania",
//                  "PR - Puerto Rico",
//                  "RI - Rhode Island",
//                  "SC - South Carolina",
//                  "SD - South Dakota",
//                  "TN - Tennessee",
//                  "TX - Texas",
//                  "UT - Utah",
//                  "VA - Virginia",
//                  "VI - Virgin Islands",
//                  "VT - Vermont",
//                  "WA - Washington",
//                  "WI - Wisconsin",
//                  "WV - West Virginia",
//                  "WY - Wyoming"]
//
//    let statesAbb = [ "AK",
//                   "AL",
//                   "AR",
//                   "AS",
//                   "AZ",
//                   "CA",
//                   "CO",
//                   "CT",
//                   "DC",
//                   "DE",
//                   "FL",
//                   "GA",
//                   "GU",
//                   "HI",
//                   "IA",
//                   "ID",
//                   "IL",
//                   "IN",
//                   "KS",
//                   "KY",
//                   "LA",
//                   "MA",
//                   "MD",
//                   "ME",
//                   "MI",
//                   "MN",
//                   "MO",
//                   "MS",
//                   "MT",
//                   "NC",
//                   "ND",
//                   "NE",
//                   "NH",
//                   "NJ",
//                   "NM",
//                   "NV",
//                   "NY",
//                   "OH",
//                   "OK",
//                   "OR",
//                   "PA",
//                   "PR",
//                   "RI",
//                   "SC",
//                   "SD",
//                   "TN",
//                   "TX",
//                   "UT",
//                   "VA",
//                   "VI",
//                   "VT",
//                   "WA",
//                   "WI",
//                   "WV",
//                   "WY"]
    
    let counties = ["Beaver", "Box Elder", "Cache", "Carbon", "Daggett", "Davis", "Duchesne", "Emery", "Garfield", "Grand", "Iron", "Juab", "Kane", "Millard", "Morgan", "Piute", "Rich", "Salt Lake", "San Juan", "Sanpete", "Sevier", "Summit", "Tooele", "Uintah", "Utah", "Wasatch", "Washington", "Wayne", "Weber"]
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let monthInts = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    var days = [Int]()
    var years = [Int]()
    let skillLevels = [1.0, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
    let sexes = ["Male", "Female"]
}
