//
//  EditProfile.swift
//  Pickleball
//
//  Created by Tanner Rozier on 1/5/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit

class EditProfile: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var inputsContainerViewCenterYAnchor: NSLayoutConstraint?
    let blackView = UIView()
    var selectedDropDown = 0
    
    @objc func handleStateDropDown() {
        selectedDropDown = 1
        collectionView.reloadData()
        handleDropDown()
    }
    
    @objc func handleCountyDropDown() {
        selectedDropDown = 2
        collectionView.reloadData()
        handleDropDown()
    }
    
    @objc func handleMonthDropDown() {
        selectedDropDown = 3
        collectionView.reloadData()
        handleDropDown()
    }
    
    @objc func handleDayDropDown() {
        selectedDropDown = 4
        for index in 1...31 {
            days.append(index)
        }
        collectionView.reloadData()
        handleDropDown()
    }
    
    @objc func handleYearDropDown() {
        selectedDropDown = 5
        for index in 1920...2020 {
            years.append(index)
        }
        collectionView.reloadData()
        handleDropDown()
    }
    
    func handleDropDown() {
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
        case 4:
            dayTextField.text = "\(days[indexPath.item])"
            dayTextField.textColor = .black
        case 5:
            yearTextField.text = "\(years[indexPath.item])"
            yearTextField.textColor = .black
        default:
            print("poop")
        }
        dismissMenu()
    }
    
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
        inputsContainerView2.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 80).isActive = true
        inputsContainerView2.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView2.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
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
    }
    
    let states = [ "AK - Alaska",
                  "AL - Alabama",
                  "AR - Arkansas",
                  "AS - American Samoa",
                  "AZ - Arizona",
                  "CA - California",
                  "CO - Colorado",
                  "CT - Connecticut",
                  "DC - District of Columbia",
                  "DE - Delaware",
                  "FL - Florida",
                  "GA - Georgia",
                  "GU - Guam",
                  "HI - Hawaii",
                  "IA - Iowa",
                  "ID - Idaho",
                  "IL - Illinois",
                  "IN - Indiana",
                  "KS - Kansas",
                  "KY - Kentucky",
                  "LA - Louisiana",
                  "MA - Massachusetts",
                  "MD - Maryland",
                  "ME - Maine",
                  "MI - Michigan",
                  "MN - Minnesota",
                  "MO - Missouri",
                  "MS - Mississippi",
                  "MT - Montana",
                  "NC - North Carolina",
                  "ND - North Dakota",
                  "NE - Nebraska",
                  "NH - New Hampshire",
                  "NJ - New Jersey",
                  "NM - New Mexico",
                  "NV - Nevada",
                  "NY - New York",
                  "OH - Ohio",
                  "OK - Oklahoma",
                  "OR - Oregon",
                  "PA - Pennsylvania",
                  "PR - Puerto Rico",
                  "RI - Rhode Island",
                  "SC - South Carolina",
                  "SD - South Dakota",
                  "TN - Tennessee",
                  "TX - Texas",
                  "UT - Utah",
                  "VA - Virginia",
                  "VI - Virgin Islands",
                  "VT - Vermont",
                  "WA - Washington",
                  "WI - Wisconsin",
                  "WV - West Virginia",
                  "WY - Wyoming"]
    
    let statesAbb = [ "AK",
                   "AL",
                   "AR",
                   "AS",
                   "AZ",
                   "CA",
                   "CO",
                   "CT",
                   "DC",
                   "DE",
                   "FL",
                   "GA",
                   "GU",
                   "HI",
                   "IA",
                   "ID",
                   "IL",
                   "IN",
                   "KS",
                   "KY",
                   "LA",
                   "MA",
                   "MD",
                   "ME",
                   "MI",
                   "MN",
                   "MO",
                   "MS",
                   "MT",
                   "NC",
                   "ND",
                   "NE",
                   "NH",
                   "NJ",
                   "NM",
                   "NV",
                   "NY",
                   "OH",
                   "OK",
                   "OR",
                   "PA",
                   "PR",
                   "RI",
                   "SC",
                   "SD",
                   "TN",
                   "TX",
                   "UT",
                   "VA",
                   "VI",
                   "VT",
                   "WA",
                   "WI",
                   "WV",
                   "WY"]
    
    let counties = ["Utah County", "Salt Lake County"]
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var days = [Int]()
    var years = [Int]()

}
