//
//  FindFriends.swift
//  Pickleball
//
//  Created by Tanner Rozier on 1/13/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FindFriends: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    let cellId2 = "cellId2"
    var players = [Player]()
    var searchResults = [Player]()
    var textFields = [UITextField]()
    var dropDownButtons = [UIButton]()
    let blackView = UIView()
    var selectedDropDown = -1
    var buttonsCreated = 0
    var friends = [String]()
    var almostFriends = [String]()
    
    var tourneyList: TourneyList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsers()
        setupViews()
        
        self.collectionView!.register(FriendListCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsets(top: 281, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 281, left: 0, bottom: 0, right: 0)
        setupFilterCollectionView()
        observeUsernamesEmails()
        
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        titleLabel.text = "Find Friends"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.navigationItem.titleView = titleLabel
        
    }
    
    @objc func handleSearchFilter() {
        searchResults = players
        
        if textFields[0].text! != "Any" {
            searchResults = searchResults.filter({ (player) -> Bool in
                let skillLevel = Float(textFields[0].text!)
                return player.skill_level! == skillLevel
            })
        }
        if textFields[1].text! != "Any" {
            searchResults = searchResults.filter({ (player) -> Bool in
                let state = textFields[1].text!
                return player.state! == state
            })
        }
        if textFields[2].text! != "Any" {
            searchResults = searchResults.filter({ (player) -> Bool in
                let county = textFields[2].text!
                return player.county! == county
            })
        }
        if textFields[3].text! != "Any" {
            searchResults = searchResults.filter({ (player) -> Bool in
                let sex = textFields[3].text!
                return player.sex! == sex
            })
        }
        if textFields[4].text! != "Any" {
            searchResults = searchResults.filter({ (player) -> Bool in
                let age_group = textFields[4].text!
                return player.age_group! == age_group
            })
        }
        
        collectionView.reloadData()
    }
    
    func observeUsernamesEmails() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                self.textFields[1].text = value["state"] as? String ?? ""
                self.textFields[0].text = "\(value["skill_level"] as? Float ?? 0)"
            }
        })
        self.textFields[2].text = "Any"
        self.textFields[3].text = "Any"
        self.textFields[4].text = "Any"
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize(width: view.frame.width, height: 80)
        } else {
            return CGSize(width: view.frame.width, height: 50)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return searchResults.count
        } else {
            switch selectedDropDown {
            case 0:
                return skillLevels.count
            case 1:
                return states.count
            case 2:
                return counties.count
            case 3:
                return sexes.count
            case 4:
                return ageGroups.count
            default:
                return 0
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FriendListCell
            cell.player = searchResults[indexPath.item]
            cell.messageButton.isHidden = true
            cell.playerLocation.isHidden = false
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! ProfileMenuCell
            switch selectedDropDown {
            case 0:
                cell.menuItem.text = "\(skillLevels[indexPath.item])"
            case 1:
                cell.menuItem.text = states[indexPath.item]
            case 2:
                cell.menuItem.text = counties[indexPath.item]
            case 3:
                cell.menuItem.text = sexes[indexPath.item]
            case 4:
                cell.menuItem.text = ageGroups[indexPath.item]
            default:
                return cell
            }
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let playerProfile = StartupPage()
            playerProfile.findFriends = self
            playerProfile.playerId = searchResults[indexPath.item].id ?? "none"
            playerProfile.whichFriend = indexPath.item
            if searchResults[indexPath.item].friend == 2 {
                playerProfile.isFriend = 2
            } else if searchResults[indexPath.item].friend == 1 {
                playerProfile.isFriend = 1
            }
            navigationController?.pushViewController(playerProfile, animated: true)
        } else {
            switch selectedDropDown {
            case 0:
                textFields[0].text = "\(skillLevels[indexPath.item])"
            case 1:
                textFields[1].text = states[indexPath.item]
            case 2:
                textFields[2].text = "\(counties[indexPath.item])"
            case 3:
                textFields[3].text = sexes[indexPath.item]
            case 4:
                textFields[4].text = ageGroups[indexPath.item]
            default:
                print("failed")
            }
            dismissMenu()
        }
    }
    
    let whiteContainerView: UIView = {
        let wc = UIView()
        wc.translatesAutoresizingMaskIntoConstraints = false
        wc.backgroundColor = .white
        return wc
    }()
    
    let whiteContainerView2: UIView = {
        let wc = UIView()
        wc.translatesAutoresizingMaskIntoConstraints = false
        wc.backgroundColor = .white
        return wc
    }()
    
    let filtersLabel: UILabel = {
        let fl = UILabel()
        fl.text = "Filters"
        fl.backgroundColor = .white
        fl.textColor = UIColor.init(r: 88, g: 148, b: 200)
        fl.font = UIFont(name: "AmericanTypewriter-Bold", size: 24)
        fl.textAlignment = .center
        fl.translatesAutoresizingMaskIntoConstraints = false
        return fl
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        button.setTitle("Search Players", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSearchFilter), for: .touchUpInside)
        return button
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let inputsArray = ["Skill Level", "State", "County", "Sex", "Age Group"]
    
    func setupViews() {
        
        view.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        searchBar.delegate = self
        
        view.addSubview(whiteContainerView2)
        whiteContainerView2.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0).isActive = true
        whiteContainerView2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        whiteContainerView2.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        whiteContainerView2.heightAnchor.constraint(equalToConstant: 231).isActive = true
        
        view.addSubview(whiteContainerView)
        whiteContainerView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0).isActive = true
        whiteContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        whiteContainerView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        whiteContainerView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        whiteContainerView.addSubview(filtersLabel)
        filtersLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4).isActive = true
        filtersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        filtersLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        filtersLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let inputBox = createInputContainer(topAnchor: whiteContainerView, anchorConstant: 0, numberInputs: 5, vertSepDistance: 150, inputs: inputsArray, inputTypes: [1, 1, 1, 1, 1])
        
        view.addSubview(searchButton)
        searchButton.topAnchor.constraint(equalTo: inputBox.bottomAnchor, constant: 10).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: view.frame.width - 100).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(separatorView)
        separatorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 5).isActive = true
        separatorView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Name of player"
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    func fetchUsers() {
        let rootRef = Database.database().reference()
        let query = rootRef.child("users").queryOrdered(byChild: "name")
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? NSDictionary {
                    let player = Player()
                    let name = value["name"] as? String ?? "No Name"
                    let username = value["username"] as? String ?? "No Username"
                    let skillLevel = value["skill_level"] as? Float ?? 0.0
                    let exp = value["exp"] as? Int ?? 0
                    let haloLevel = player.haloLevel(exp: exp)
                    let state = value["state"] as? String ?? "No State"
                    let county = value["county"] as? String ?? "No County"
                    player.name = name
                    player.username = username
                    player.id = child.key
                    player.skill_level = skillLevel
                    player.halo_level = haloLevel
                    player.state = state
                    player.county = county
                    if self.friends.contains(player.id ?? "noId") == true {
                        player.friend = 2
                    } else if self.almostFriends.contains(player.id ?? "noId") == true {
                        player.friend = 1
                    } else {
                        player.friend = 0
                    }
                    
                    if player.id != Auth.auth().currentUser?.uid {
                        self.players.append(player)
                    }
                }
            }
        }
    }
    
    let filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    func setupFilterCollectionView() {
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.register(ProfileMenuCell.self, forCellWithReuseIdentifier: cellId2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func handleDropDownFinish() {
        for index in textFields {
            index.resignFirstResponder()
        }
        self.view.endEditing(true)
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenu)))
            window.addSubview(blackView)
            window.addSubview(filterCollectionView)
            filterCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 350)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.filterCollectionView.frame = CGRect(x: 0, y: window.frame.height - 350, width: window.frame.width, height: 350)
            }, completion: nil)
        }
    }
    
    @objc func dismissMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.filterCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 350)
            }
        })
    }
    
    @objc func handledropDown(sender: UIButton) {
        selectedDropDown = sender.tag
        filterCollectionView.reloadData()
        //collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: [], animated: false)
        handleDropDownFinish()
    }
    
    let states = ["Any", "Utah"]
    let counties = ["Any", "Beaver", "Box Elder", "Cache", "Carbon", "Daggett", "Davis", "Duchesne", "Emery", "Garfield", "Grand", "Iron", "Juab", "Kane", "Millard", "Morgan", "Piute", "Rich", "Salt Lake", "San Juan", "Sanpete", "Sevier", "Summit", "Tooele", "Uintah", "Utah", "Wasatch", "Washington", "Wayne", "Weber"]
    let skillLevels = ["Any", "2.0", "2.5", "3.0", "3.5", "4.0", "4.5", "5.0"]
    let sexes = ["Any", "Male", "Female"]
    let ageGroups = ["Any", "0-18", "19 - 34", "35-49", "50+"]
    
}

extension FindFriends: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchResults = players.filter({ (player) -> Bool in
            guard let text = searchBar.text else {return false}
            return player.name!.localizedCaseInsensitiveContains(text)
        })
        //handleFilter()
        collectionView.reloadData()
        
    }
    
    func createInputContainer(topAnchor: UIView, anchorConstant: Int, numberInputs: Int, vertSepDistance: Int, inputs: [String], inputTypes: [Int]) -> UIView {
        
        let inputContainer: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
            view.layer.cornerRadius = 5
            view.layer.masksToBounds = true
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        view.addSubview(inputContainer)
        inputContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainer.topAnchor.constraint(equalTo: topAnchor.bottomAnchor, constant: CGFloat(anchorConstant)).isActive = true
        inputContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -12).isActive = true
        inputContainer.heightAnchor.constraint(equalToConstant: CGFloat(numberInputs * 30)).isActive = true
        
        var anchorShift = -30
        
        for (index, element) in inputs.enumerated() {
            anchorShift += 30
            let label: UILabel = {
                let lb = UILabel()
                lb.text = element
                lb.textColor = .white
                lb.translatesAutoresizingMaskIntoConstraints = false
                lb.font = UIFont(name: "HelveticaNeue", size: 15)
                return lb
            }()
            
            let textField: UITextField = {
                let tf = UITextField()
                tf.textColor = .white
                tf.text = "Any"
                tf.translatesAutoresizingMaskIntoConstraints = false
                tf.font = UIFont(name: "HelveticaNeue-Light", size: 15)
                return tf
            }()
            
            textFields.append(textField)
            
            let separatorView: UIView = {
                let view = UIView()
                view.backgroundColor = .white
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            let verticalSeparatorView: UIView = {
                let view = UIView()
                view.backgroundColor = .white
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            inputContainer.addSubview(label)
            label.leftAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: 12).isActive = true
            label.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: CGFloat(anchorShift)).isActive = true
            label.rightAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: CGFloat(vertSepDistance)).isActive = true
            label.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            inputContainer.addSubview(textField)
            textField.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 8).isActive = true
            textField.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
            textField.rightAnchor.constraint(equalTo: inputContainer.rightAnchor, constant: 4).isActive = true
            textField.heightAnchor.constraint(equalTo: label.heightAnchor).isActive = true
            
            if inputTypes[index] == 1 {
                buttonsCreated += 1
                let dropDown: UIButton = {
                    let button = UIButton(type: .system)
                    button.translatesAutoresizingMaskIntoConstraints = false
                    button.tag = buttonsCreated - 1
                    button.addTarget(self, action: #selector(handledropDown), for: .touchUpInside)
                    return button
                }()
                dropDownButtons.append(dropDown)
                
                inputContainer.addSubview(dropDownButtons[buttonsCreated - 1])
                dropDownButtons[buttonsCreated - 1].leftAnchor.constraint(equalTo: label.rightAnchor, constant: 8).isActive = true
                dropDownButtons[buttonsCreated - 1].topAnchor.constraint(equalTo: label.topAnchor).isActive = true
                dropDownButtons[buttonsCreated - 1].rightAnchor.constraint(equalTo: inputContainer.rightAnchor, constant: 4).isActive = true
                dropDownButtons[buttonsCreated - 1].heightAnchor.constraint(equalTo: label.heightAnchor).isActive = true
            }
            
            inputContainer.addSubview(separatorView)
            separatorView.leftAnchor.constraint(equalTo: inputContainer.leftAnchor).isActive = true
            separatorView.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
            separatorView.rightAnchor.constraint(equalTo: inputContainer.rightAnchor).isActive = true
            separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            inputContainer.addSubview(verticalSeparatorView)
            verticalSeparatorView.rightAnchor.constraint(equalTo: label.rightAnchor).isActive = true
            verticalSeparatorView.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
            verticalSeparatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
            verticalSeparatorView.heightAnchor.constraint(equalTo: label.heightAnchor, constant: -8).isActive = true
            
        }
        
        return inputContainer
        
    }
    
}
