//
//  CreateTourney.swift
//  Pickleball
//
//  Created by Tanner Rozier on 1/8/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKShareKit

class CreateTourney: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var textFields = [UITextField]()
    var dropDownButtons = [UIButton]()
    let blackView = UIView()
    var selectedDropDown = -1
    var buttonsCreated = 0
    var sender = false
    var tourneyIndex = Int()
    var tourneyInfo = Tourney()
    var tourneyList: TourneyList?
    var tourneySearch: TourneySearch?
    var referencesNeedDeletion = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupCollectionView()
        for index in 1...31 {
            days.append(index)
        }
    }
    
    func populateFields() {
        textFields[0].text = tourneyInfo.name
        textFields[1].text = tourneyInfo.type
        textFields[2].text = "\(tourneyInfo.skill_level ?? 0)"
        textFields[3].text = tourneyInfo.sex
        textFields[4].text = tourneyInfo.age_group
        textFields[5].text = tourneyInfo.state
        textFields[6].text = tourneyInfo.county
        guard let birthdate = tourneyInfo.start_date else {
            return
        }
        let calendar = Calendar.current
        let birthdateDate = Date(timeIntervalSince1970: birthdate)
        let components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: birthdateDate)
        let monthInt = components.month!
        self.monthTextField.text = "\(self.months[monthInt - 1])"
        self.dayTextField.text = "\(components.day!)"
        self.yearTextField.text = "\(components.year!)"
        guard let birthdate2 = tourneyInfo.end_date else {
            return
        }
        let calendar2 = Calendar.current
        let birthdateDate2 = Date(timeIntervalSince1970: birthdate2)
        let components2 = calendar2.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: birthdateDate2)
        let monthInt2 = components2.month!
        self.monthTextField2.text = "\(self.months[monthInt2 - 1])"
        self.dayTextField2.text = "\(components2.day!)"
        self.yearTextField2.text = "\(components2.year!)"
        
        switch tourneyInfo.style! {
        case 0:
            matchesControl.selectedSegmentIndex = 0
        case 1:
            matchesControl.selectedSegmentIndex = 1
        case 2:
            matchesControl.selectedSegmentIndex = 2
        default:
            matchesControl.selectedSegmentIndex = 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for index in textFields {
            index.resignFirstResponder()
        }
        
        self.view.endEditing(true)
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
            return types.count
        case 2:
            return skillLevels.count
        case 3:
            return sexes.count
        case 4:
            return ageGroups.count
        case 5:
            return states.count
        case 6:
            return counties.count
        case 7:
            return months.count
        case 8:
            return days.count
        case 9:
            return years.count
        case 10:
            return months.count
        case 11:
            return days.count
        case 12:
            return years.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProfileMenuCell
        switch selectedDropDown {
        case 1:
            cell.menuItem.text = types[indexPath.item]
        case 2:
            cell.menuItem.text = "\(skillLevels[indexPath.item])"
        case 3:
            cell.menuItem.text = sexes[indexPath.item]
        case 4:
            cell.menuItem.text = ageGroups[indexPath.item]
        case 5:
            cell.menuItem.text = states[indexPath.item]
        case 6:
            cell.menuItem.text = counties[indexPath.item]
        case 7:
            cell.menuItem.text = "\(months[indexPath.item])"
        case 8:
            cell.menuItem.text = "\(days[indexPath.item])"
        case 9:
            cell.menuItem.text = "\(years[indexPath.item])"
        case 10:
            cell.menuItem.text = "\(months[indexPath.item])"
        case 11:
            cell.menuItem.text = "\(days[indexPath.item])"
        case 12:
            cell.menuItem.text = "\(years[indexPath.item])"
        default:
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch selectedDropDown {
        case 1:
            textFields[1].text = types[indexPath.item]
        case 2:
            textFields[2].text = "\(skillLevels[indexPath.item])"
        case 3:
            textFields[3].text = sexes[indexPath.item]
        case 4:
            textFields[4].text = ageGroups[indexPath.item]
        case 5:
            textFields[5].text = states[indexPath.item]
        case 6:
            textFields[6].text = counties[indexPath.item]
        case 7:
            monthTextField.text = "\(months[indexPath.item])"
            monthTextField.textColor = .black
        case 8:
            dayTextField.text = "\(days[indexPath.item])"
            dayTextField.textColor = .black
        case 9:
            yearTextField.text = "\(years[indexPath.item])"
            yearTextField.textColor = .black
        case 10:
            monthTextField2.text = "\(months[indexPath.item])"
            monthTextField2.textColor = .black
        case 11:
            dayTextField2.text = "\(days[indexPath.item])"
            dayTextField2.textColor = .black
        case 12:
            yearTextField2.text = "\(years[indexPath.item])"
            yearTextField2.textColor = .black
        default:
            print("poop")
        }
        dismissMenu()
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
    
    @objc func handledropDown(sender: UIButton) {
        selectedDropDown = sender.tag
        collectionView.reloadData()
        collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: [], animated: false)
        handleDropDownFinish()
    }
    
    @objc func handleSaveChanges() {
        
        guard let name = textFields[0].text, let type = textFields[1].text, let skillLevel = textFields[2].text, let sex = textFields[3].text, let ageGroup = textFields[4].text, let state = textFields[5].text, let county = textFields[6].text, let month = monthTextField.text, let day = dayTextField.text, let year = yearTextField.text, let month2 = monthTextField2.text, let day2 = dayTextField2.text, let year2 = yearTextField2.text else {
            let newalert = UIAlertController(title: "Sorry", message: "One or more fields are incorrect", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        if name == "" || type == "" || skillLevel == "" || sex == "" || ageGroup == "" || state == "" || county == "" || month == "Month" || day == "Day" || year == "Year" || month2 == "Month" || day2 == "Day" || year2 == "Year" {
            let newalert = UIAlertController(title: "Sorry", message: "One or more fields are incorrect", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
        }

        let newalert = UIAlertController(title: "Confirm", message: "Are you sure you want to save these changes?", preferredStyle: UIAlertController.Style.alert)
        newalert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        newalert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: saveChanges))
        self.present(newalert, animated: true, completion: nil)
    }
    
    @objc func saveChanges(action: UIAlertAction) {
        guard let name = textFields[0].text, let type = textFields[1].text, let skillLevel = Float(textFields[2].text!), let sex = textFields[3].text, let ageGroup = textFields[4].text, let state = textFields[5].text, let county = textFields[6].text, let month = monthTextField.text, let day = dayTextField.text, let year = yearTextField.text, let month2 = monthTextField2.text, let day2 = dayTextField2.text, let year2 = yearTextField2.text else {
            let newalert = UIAlertController(title: "Sorry", message: "One or more fields are incorrect", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = Int(day)
        components.month = months.firstIndex(of: "\(month)")! + 1
        components.year = Int(year)
        components.hour = 12
        components.minute = 0
        
        let newDate = calendar.date(from: components)
        
        let startdate = Double((newDate?.timeIntervalSince1970)!)
        
        let calendar2 = Calendar.current
        var components2 = DateComponents()
        components2.day = Int(day2)
        components2.month = months.firstIndex(of: "\(month2)")! + 1
        components2.year = Int(year2)
        components2.hour = 12
        components2.minute = 0
        
        let newDate2 = calendar2.date(from: components2)
        
        let endDate = Double((newDate2?.timeIntervalSince1970)!)
        
        var style = Int()
        switch matchesControl.selectedSegmentIndex {
        case 0:
            style = 0
        case 1:
            style = 1
        case 2:
            style = 2
        default:
            style = 0
        }
        let publicBool = privatePublicControl.selectedSegmentIndex == 0 ? true : false
        let daysToPlay = Int(daysToPlayStepper.value)
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("tourneys")
        let tourneyref = sender == false ? ref.childByAutoId() : ref.child(tourneyInfo.id!)
        let values = ["active": 0, "name": name, "skill_level": skillLevel, "type": type, "sex": sex, "age_group": ageGroup, "start_date": startdate, "duration": endDate, "creator": uid, "state": state, "county": county, "style": style, "public": publicBool, "daysToPlay": daysToPlay] as [String : Any]
        tourneyref.updateChildValues(values, withCompletionBlock: {
            (error:Error?, ref:DatabaseReference) in
            
            if error != nil {
                let newalert = UIAlertController(title: "Sorry", message: "Could not save the data", preferredStyle: UIAlertController.Style.alert)
                newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
                self.present(newalert, animated: true, completion: nil)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            print("Data saved successfully!")
            let tourney = Tourney()
            tourney.name = name
            tourney.type = type
            tourney.skill_level = skillLevel
            tourney.id = self.sender == false ? tourneyref.key : self.tourneyInfo.id!
            tourney.sex = sex
            tourney.age_group = ageGroup
            tourney.start_date = startdate
            tourney.time = self.sender == false ? 0 : self.tourneyInfo.time!
            tourney.end_date = endDate
            tourney.creator = self.sender == false ? uid : self.tourneyInfo.creator!
            tourney.state = state
            tourney.county = county
            tourney.active = self.sender == false ? 0 : self.tourneyInfo.active!
            tourney.finals1 = self.sender == false ? 0 : self.tourneyInfo.finals1!
            tourney.finals2 = self.sender == false ? 0 : self.tourneyInfo.finals2!
            tourney.winner = self.sender == false ? 0 : self.tourneyInfo.winner!
            tourney.style = style
            tourney.daysToPlay = daysToPlay
            tourney.publicBool = publicBool
            if self.sender {
                self.tourneyList?.myTourneys[self.tourneyIndex] = tourney
                self.tourneyList?.tableView.reloadData()
                self.tourneySearch?.searchResults[self.tourneyIndex] = tourney
                self.tourneySearch?.tableView.reloadData()
            } else {
                Database.database().reference().child("user_tourneys").child(uid).child(tourneyref.key!).setValue(0)
            }
            
        })
    }
    
    @objc func handleReturn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    let createTourneyLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Tourney Settings"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        lb.textAlignment = .center
        lb.textColor = .white
        return lb
    }()
    
//    let officialTourneyCheck: UISwitch = {
//        let uiSwitch = UISwitch()
//        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
//        uiSwitch.isOn = false
//        return uiSwitch
//    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = .white
        button.setTitle("Return", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleReturn), for: .touchUpInside)
        return button
    }()
    
    let changeActive: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = .white
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 14
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleChangeActive), for: .touchUpInside)
        return button
    }()
    
    let reopenRegistration: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = .white
        button.setTitle("Reopen Registration", for: .normal)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(r: 0, g: 100, b: 0)
        button.layer.cornerRadius = 14
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(reopenReg), for: .touchUpInside)
        return button
    }()
    
    @objc func reopenReg() {
            Database.database().reference().child("tourneys").child(tourneyInfo.id ?? "none").child("active").setValue(0)
            //Database.database().reference().child("tourneys").child(tourneyInfo.id ?? "none").child("time").setValue(Date().timeIntervalSince1970)
            self.tourneyList?.myTourneys[self.tourneyIndex].active = 0
            self.tourneyList?.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
    
    @objc func handleChangeActive() {
        if tourneyInfo.active == 1 {
            let createMatchFailed = UIAlertController(title: "Are you sure?", message: "Once semi-finals start you can't go back", preferredStyle: .alert)
            createMatchFailed.addAction(UIAlertAction(title: "Nevermind", style: .default, handler: nil))
            createMatchFailed.addAction(UIAlertAction(title: "I'm sure", style: .default, handler: handleImSure))
            self.present(createMatchFailed, animated: true, completion: nil)
        } else if tourneyInfo.active == 0 {
            Database.database().reference().child("tourneys").child(tourneyInfo.id ?? "none").child("active").setValue(1)
            Database.database().reference().child("tourneys").child(tourneyInfo.id ?? "none").child("time").setValue(Date().timeIntervalSince1970)
            self.tourneyList?.myTourneys[self.tourneyIndex].active = 1
            self.tourneyList?.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        } else {

        }
    }
    
    func handleImSure(action: UIAlertAction) {
        Database.database().reference().child("tourneys").child(tourneyInfo.id ?? "none").child("active").setValue(2)
        self.tourneyList?.myTourneys[self.tourneyIndex].active = 2
        self.tourneyList?.tableView.reloadData()
        guard let allMatches = tourneyInfo.matches else {
            return
        }
        for element in allMatches {
            if element.active != 3 {
                let matchToDelete = element
                Database.database().reference().child("tourneys").child(tourneyInfo.id ?? "none").child("matches").child(matchToDelete.matchId!).removeValue()
                let tourneyFunctions = Tourney()
                tourneyFunctions.removeCantChallenge(team_1_player_1: matchToDelete.team_1_player_1!, team_1_player_2: matchToDelete.team_1_player_2!, team_2_player_1: matchToDelete.team_2_player_1!, team_2_player_2: matchToDelete.team_2_player_2!, tourneyId: tourneyInfo.id ?? "none")
            }
        }
        tourneyInfo.handleSetupSemifinal1()
        self.dismiss(animated: true, completion: nil)
    }
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = .white
        button.setTitle("Delete Tournament", for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDelete() {
        referencesNeedDeletion.removeAll()
        let ref = Database.database().reference().child("tourneys").child(tourneyInfo.id!).child("teams")
        ref.observe(.childAdded, with: {(snapshot) in
            if let value = snapshot.value as? NSDictionary {
                let player1Id = value["player1"] as? String ?? "none"
                let player2Id = value["player2"] as? String ?? "none"
                self.referencesNeedDeletion.append(player1Id)
                self.referencesNeedDeletion.append(player2Id)
            }
        }, withCancel: nil)
        let newalert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this tournament?", preferredStyle: UIAlertController.Style.alert)
        newalert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        newalert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: deleteConfirmed))
        self.present(newalert, animated: true, completion: nil)
    }
    
    let whiteCover3: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let matchDeleted: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tourney has been erased"
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textAlignment = .center
        return label
    }()
    

    @objc func deleteConfirmed(action: UIAlertAction) {
        deleteButton.isHidden = true
        self.tourneyList?.myTourneys.remove(at: tourneyIndex)
        self.tourneyList?.tableView.reloadData()
        self.tourneySearch?.searchResults.remove(at: tourneyIndex)
        self.tourneySearch?.tableView.reloadData()
        view.addSubview(whiteCover3)
        whiteCover3.topAnchor.constraint(equalTo: backButton.bottomAnchor).isActive = true
        whiteCover3.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        whiteCover3.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        whiteCover3.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        view.addSubview(matchDeleted)
        matchDeleted.topAnchor.constraint(equalTo: backButton.bottomAnchor).isActive = true
        matchDeleted.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        matchDeleted.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        matchDeleted.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        for index in referencesNeedDeletion {
            Database.database().reference().child("user_tourneys").child(index).child(self.tourneyInfo.id!).removeValue()
        }
        Database.database().reference().child("tourneys").child(tourneyInfo.id!).removeValue()
        self.tourneySearch?.tourneys.removeAll()
        self.tourneySearch?.fetchTourneys()
    }
    
    let saveTourney: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = .white
        button.setTitle("Create Tourney", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 35)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSaveChanges), for: .touchUpInside)
        return button
    }()
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isScrollEnabled = true
        sv.backgroundColor = .white
        sv.minimumZoomScale = 1.0
        //sv.maximumZoomScale = 2.5
        return sv
    }()
    
    let privatePublicControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Public", "Private"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        let font = UIFont(name: "HelveticaNeue", size: 17)
        sc.setTitleTextAttributes([NSAttributedString.Key.font: font as Any], for: .normal)
        sc.tintColor = .white
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    let matchesLabel: UILabel = {
        let label = UILabel()
        label.text = "# of games per match"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let matchesControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Single", "2 out of 3", "3 out of 5"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        let font = UIFont(name: "HelveticaNeue", size: 17)
        sc.setTitleTextAttributes([NSAttributedString.Key.font: font as Any], for: .normal)
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        return sc
    }()
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let birthdateLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Start Date"
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
        button.tag = 7
        button.addTarget(self, action: #selector(handledropDown), for: .touchUpInside)
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
        button.tag = 8
        button.addTarget(self, action: #selector(handledropDown), for: .touchUpInside)
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
        button.tag = 9
        button.addTarget(self, action: #selector(handledropDown), for: .touchUpInside)
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
    
    let birthdateLabel2: UILabel = {
        let lb = UILabel()
        lb.text = "End Date"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "HelveticaNeue", size: 20)
        return lb
    }()
    
    let monthTextField2: UILabel = {
        let tf = UILabel()
        tf.text = "Month"
        tf.textAlignment = .center
        tf.textColor = UIColor.init(r: 220, g: 220, b: 220)
        tf.translatesAutoresizingMaskIntoConstraints = false
        //tf.backgroundColor = .yellow
        tf.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        return tf
    }()
    
    let monthDropDown2: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 10
        button.addTarget(self, action: #selector(handledropDown), for: .touchUpInside)
        return button
    }()
    
    let dayTextField2: UILabel = {
        let tf = UILabel()
        //tf.backgroundColor = .blue
        tf.text = "Day"
        tf.textAlignment = .center
        tf.textColor = UIColor.init(r: 220, g: 220, b: 220)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        return tf
    }()
    
    let dayDropDown2: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 11
        button.addTarget(self, action: #selector(handledropDown), for: .touchUpInside)
        return button
    }()
    
    let yearTextField2: UILabel = {
        let tf = UILabel()
        //tf.backgroundColor = .brown
        tf.text = "Year"
        tf.textAlignment = .center
        tf.textColor = UIColor.init(r: 220, g: 220, b: 220)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        return tf
    }()
    
    let yearDropDown2: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = 12
        button.addTarget(self, action: #selector(handledropDown), for: .touchUpInside)
        return button
    }()
    
    let birthdateSeparatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let verticalSeparatorView62: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let verticalSeparatorView72: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let verticalSeparatorView82: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let daysToPlayStepper: UIStepper = {
        let view = UIStepper()
        view.backgroundColor = .white
        view.maximumValue = 7
        view.minimumValue = 1
        view.value = 3
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.stepValue = 1
        view.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)
        return view
    }()
    
    @objc func stepperChanged() {
        daysToPlayDisplay.text = "\(Int(daysToPlayStepper.value)) days"
    }
    
    let daysToPlayDisplay: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let daysToPlayLabel: UILabel = {
        let label = UILabel()
        label.text = "Days players have to complete a match:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    let shareButton = FBShareButton()
    
    func setupViews() {
        scrollView.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        let Width = Float(view.frame.width)
        scrollView.contentSize = CGSize(width: Double(Width), height: Double(940))
        view.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        
//        view.addSubview(officialTourneyCheck)
//        officialTourneyCheck.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -4).isActive = true
//        officialTourneyCheck.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
//        officialTourneyCheck.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        officialTourneyCheck.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        scrollView.addSubview(createTourneyLabel)
        createTourneyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createTourneyLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 2).isActive = true
        createTourneyLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -120).isActive = true
        createTourneyLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        if sender {
            view.addSubview(deleteButton)
            deleteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -4).isActive = true
            deleteButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
            deleteButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
            deleteButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
            
            shareButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(shareButton)
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            shareButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
            
            if tourneyInfo.active == 0 {
                changeActive.setTitle("End Registration", for: .normal)
            } else if tourneyInfo.active == 1 {
                changeActive.setTitle("Start Semifinals", for: .normal)
            } else {
                changeActive.setTitle("Semis has started", for: .normal)
                changeActive.isUserInteractionEnabled = false
            }
            scrollView.addSubview(changeActive)
            changeActive.topAnchor.constraint(equalTo: createTourneyLabel.bottomAnchor, constant: 10).isActive = true
            changeActive.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            if tourneyInfo.active == 1 {
                scrollView.addSubview(reopenRegistration)
                reopenRegistration.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -2).isActive = true
                reopenRegistration.topAnchor.constraint(equalTo: createTourneyLabel.bottomAnchor, constant: 10).isActive = true
                reopenRegistration.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4).isActive = true
                reopenRegistration.heightAnchor.constraint(equalToConstant: 40).isActive = true
                
                changeActive.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 2).isActive = true
                changeActive.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -4).isActive = true
            } else {
                changeActive.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                changeActive.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80).isActive = true
            }
        }
        
        scrollView.addSubview(privatePublicControl)
        privatePublicControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        privatePublicControl.topAnchor.constraint(equalTo: sender ? changeActive.bottomAnchor : createTourneyLabel.bottomAnchor, constant: 10).isActive = true
        privatePublicControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80).isActive = true
        privatePublicControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        let inputsArray = ["Name", "Type", "Skill Level", "Sex", "Age Group"]
        let inputsArray2 = ["State", "County"]
        let inputContainer1 = createInputContainer(topAnchor: privatePublicControl, anchorConstant: 20, numberInputs: 5, vertSepDistance: 120, inputs: inputsArray, inputTypes: [0, 1, 1, 1, 1])
        let inputContainer2 = createInputContainer(topAnchor: inputContainer1, anchorConstant: 20, numberInputs: 2, vertSepDistance: 120, inputs: inputsArray2, inputTypes: [1, 1])
        
        scrollView.addSubview(inputsContainerView)
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.topAnchor.constraint(equalTo: inputContainer2.bottomAnchor, constant: 20).isActive = true
        inputsContainerView.widthAnchor.constraint(equalToConstant: view.frame.width - 24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        inputsContainerView.addSubview(birthdateLabel)
        birthdateLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        birthdateLabel.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        birthdateLabel.rightAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 110).isActive = true
        birthdateLabel.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        inputsContainerView.addSubview(monthTextField)
        monthTextField.leftAnchor.constraint(equalTo: birthdateLabel.rightAnchor, constant: 0).isActive = true
        monthTextField.topAnchor.constraint(equalTo: birthdateLabel.topAnchor).isActive = true
        if view.frame.width < 375 {
            monthTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
            monthTextField.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        } else {
            monthTextField.widthAnchor.constraint(equalToConstant: 125).isActive = true
        }
        monthTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        inputsContainerView.addSubview(monthDropDown)
        monthDropDown.leftAnchor.constraint(equalTo: birthdateLabel.rightAnchor, constant: 0).isActive = true
        monthDropDown.topAnchor.constraint(equalTo: birthdateLabel.topAnchor).isActive = true
        if view.frame.width < 375 {
            monthDropDown.widthAnchor.constraint(equalToConstant: 100).isActive = true
        } else {
            monthDropDown.widthAnchor.constraint(equalToConstant: 125).isActive = true
        }
        monthDropDown.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        inputsContainerView.addSubview(dayTextField)
        dayTextField.leftAnchor.constraint(equalTo: monthTextField.rightAnchor, constant: 0).isActive = true
        dayTextField.topAnchor.constraint(equalTo: birthdateLabel.topAnchor).isActive = true
        if view.frame.width < 375 {
            dayTextField.widthAnchor.constraint(equalToConstant: 45).isActive = true
            dayTextField.font = UIFont(name: "HelveticaNeue-Light", size: 18)
            yearTextField.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        } else {
            dayTextField.widthAnchor.constraint(equalToConstant: 55).isActive = true
        }
        dayTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        inputsContainerView.addSubview(dayDropDown)
        dayDropDown.leftAnchor.constraint(equalTo: monthTextField.rightAnchor, constant: 0).isActive = true
        dayDropDown.topAnchor.constraint(equalTo: birthdateLabel.topAnchor).isActive = true
        if view.frame.width < 375 {
            dayDropDown.widthAnchor.constraint(equalToConstant: 45).isActive = true
        } else {
            dayDropDown.widthAnchor.constraint(equalToConstant: 55).isActive = true
        }
        dayDropDown.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        inputsContainerView.addSubview(yearTextField)
        yearTextField.leftAnchor.constraint(equalTo: dayTextField.rightAnchor, constant: 0).isActive = true
        yearTextField.topAnchor.constraint(equalTo: birthdateLabel.topAnchor).isActive = true
        yearTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -2).isActive = true
        yearTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        inputsContainerView.addSubview(yearDropDown)
        yearDropDown.leftAnchor.constraint(equalTo: dayTextField.rightAnchor, constant: 0).isActive = true
        yearDropDown.topAnchor.constraint(equalTo: birthdateLabel.topAnchor).isActive = true
        yearDropDown.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -2).isActive = true
        yearDropDown.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        inputsContainerView.addSubview(birthdateSeparatorView)
        birthdateSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        birthdateSeparatorView.topAnchor.constraint(equalTo: birthdateLabel.bottomAnchor).isActive = true
        birthdateSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        birthdateSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputsContainerView.addSubview(verticalSeparatorView6)
        verticalSeparatorView6.rightAnchor.constraint(equalTo: birthdateLabel.rightAnchor).isActive = true
        verticalSeparatorView6.centerYAnchor.constraint(equalTo: birthdateLabel.centerYAnchor).isActive = true
        verticalSeparatorView6.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView6.heightAnchor.constraint(equalTo: birthdateLabel.heightAnchor, constant: -12).isActive = true
        
        inputsContainerView.addSubview(verticalSeparatorView7)
        verticalSeparatorView7.rightAnchor.constraint(equalTo: monthTextField.rightAnchor).isActive = true
        verticalSeparatorView7.centerYAnchor.constraint(equalTo: birthdateLabel.centerYAnchor).isActive = true
        verticalSeparatorView7.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView7.heightAnchor.constraint(equalTo: birthdateLabel.heightAnchor, constant: -12).isActive = true
        
        inputsContainerView.addSubview(verticalSeparatorView8)
        verticalSeparatorView8.rightAnchor.constraint(equalTo: dayTextField.rightAnchor).isActive = true
        verticalSeparatorView8.centerYAnchor.constraint(equalTo: birthdateLabel.centerYAnchor).isActive = true
        verticalSeparatorView8.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView8.heightAnchor.constraint(equalTo: birthdateLabel.heightAnchor, constant: -12).isActive = true
        
        inputsContainerView.addSubview(birthdateLabel2)
        birthdateLabel2.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        birthdateLabel2.topAnchor.constraint(equalTo: birthdateLabel.bottomAnchor).isActive = true
        birthdateLabel2.rightAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 110).isActive = true
        birthdateLabel2.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        inputsContainerView.addSubview(monthTextField2)
        monthTextField2.leftAnchor.constraint(equalTo: birthdateLabel2.rightAnchor, constant: 0).isActive = true
        monthTextField2.topAnchor.constraint(equalTo: birthdateLabel2.topAnchor).isActive = true
        if view.frame.width < 375 {
            monthTextField2.widthAnchor.constraint(equalToConstant: 100).isActive = true
            monthTextField2.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        } else {
            monthTextField2.widthAnchor.constraint(equalToConstant: 125).isActive = true
        }
        monthTextField2.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        inputsContainerView.addSubview(monthDropDown2)
        monthDropDown2.leftAnchor.constraint(equalTo: birthdateLabel2.rightAnchor, constant: 0).isActive = true
        monthDropDown2.topAnchor.constraint(equalTo: birthdateLabel2.topAnchor).isActive = true
        if view.frame.width < 375 {
            monthDropDown2.widthAnchor.constraint(equalToConstant: 100).isActive = true
        } else {
            monthDropDown2.widthAnchor.constraint(equalToConstant: 125).isActive = true
        }
        monthDropDown2.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        inputsContainerView.addSubview(dayTextField2)
        dayTextField2.leftAnchor.constraint(equalTo: monthTextField2.rightAnchor, constant: 0).isActive = true
        dayTextField2.topAnchor.constraint(equalTo: birthdateLabel2.topAnchor).isActive = true
        if view.frame.width < 375 {
            dayTextField2.widthAnchor.constraint(equalToConstant: 45).isActive = true
            dayTextField2.font = UIFont(name: "HelveticaNeue-Light", size: 18)
            yearTextField2.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        } else {
            dayTextField2.widthAnchor.constraint(equalToConstant: 55).isActive = true
        }
        dayTextField2.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        inputsContainerView.addSubview(dayDropDown2)
        dayDropDown2.leftAnchor.constraint(equalTo: monthTextField2.rightAnchor, constant: 0).isActive = true
        dayDropDown2.topAnchor.constraint(equalTo: birthdateLabel2.topAnchor).isActive = true
        if view.frame.width < 375 {
            dayDropDown2.widthAnchor.constraint(equalToConstant: 45).isActive = true
        } else {
            dayDropDown2.widthAnchor.constraint(equalToConstant: 55).isActive = true
        }
        dayDropDown2.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        inputsContainerView.addSubview(yearTextField2)
        yearTextField2.leftAnchor.constraint(equalTo: dayTextField2.rightAnchor, constant: 0).isActive = true
        yearTextField2.topAnchor.constraint(equalTo: birthdateLabel2.topAnchor).isActive = true
        yearTextField2.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -2).isActive = true
        yearTextField2.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        inputsContainerView.addSubview(yearDropDown2)
        yearDropDown2.leftAnchor.constraint(equalTo: dayTextField2.rightAnchor, constant: 0).isActive = true
        yearDropDown2.topAnchor.constraint(equalTo: birthdateLabel2.topAnchor).isActive = true
        yearDropDown2.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -2).isActive = true
        yearDropDown2.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        inputsContainerView.addSubview(birthdateSeparatorView2)
        birthdateSeparatorView2.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        birthdateSeparatorView2.topAnchor.constraint(equalTo: birthdateLabel2.bottomAnchor).isActive = true
        birthdateSeparatorView2.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        birthdateSeparatorView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputsContainerView.addSubview(verticalSeparatorView62)
        verticalSeparatorView62.rightAnchor.constraint(equalTo: birthdateLabel2.rightAnchor).isActive = true
        verticalSeparatorView62.centerYAnchor.constraint(equalTo: birthdateLabel2.centerYAnchor).isActive = true
        verticalSeparatorView62.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView62.heightAnchor.constraint(equalTo: birthdateLabel.heightAnchor, constant: -12).isActive = true
        
        inputsContainerView.addSubview(verticalSeparatorView72)
        verticalSeparatorView72.rightAnchor.constraint(equalTo: monthTextField2.rightAnchor).isActive = true
        verticalSeparatorView72.centerYAnchor.constraint(equalTo: birthdateLabel2.centerYAnchor).isActive = true
        verticalSeparatorView72.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView72.heightAnchor.constraint(equalTo: birthdateLabel2.heightAnchor, constant: -12).isActive = true
        
        inputsContainerView.addSubview(verticalSeparatorView82)
        verticalSeparatorView82.rightAnchor.constraint(equalTo: dayTextField2.rightAnchor).isActive = true
        verticalSeparatorView82.centerYAnchor.constraint(equalTo: birthdateLabel2.centerYAnchor).isActive = true
        verticalSeparatorView82.widthAnchor.constraint(equalToConstant: 1).isActive = true
        verticalSeparatorView82.heightAnchor.constraint(equalTo: birthdateLabel2.heightAnchor, constant: -12).isActive = true
        
        if sender {
            populateFields()
        }
        
        scrollView.addSubview(matchesLabel)
        matchesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        matchesLabel.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 10).isActive = true
        matchesLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        matchesLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(matchesControl)
        matchesControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        matchesControl.topAnchor.constraint(equalTo: matchesLabel.bottomAnchor, constant: 4).isActive = true
        matchesControl.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        matchesControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(daysToPlayLabel)
        daysToPlayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        daysToPlayLabel.topAnchor.constraint(equalTo: matchesControl.bottomAnchor, constant: 8).isActive = true
        daysToPlayLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 14).isActive = true
        daysToPlayLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        scrollView.addSubview(daysToPlayStepper)
        daysToPlayStepper.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -10).isActive = true
        daysToPlayStepper.topAnchor.constraint(equalTo: daysToPlayLabel.bottomAnchor, constant: 4).isActive = true
        
        daysToPlayDisplay.text = "\(Int(daysToPlayStepper.value)) days"
        scrollView.addSubview(daysToPlayDisplay)
        daysToPlayDisplay.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
        daysToPlayDisplay.topAnchor.constraint(equalTo: daysToPlayLabel.bottomAnchor, constant: 0).isActive = true
        daysToPlayDisplay.widthAnchor.constraint(equalToConstant: 100).isActive = true
        daysToPlayDisplay.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        scrollView.addSubview(saveTourney)
        saveTourney.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveTourney.topAnchor.constraint(equalTo: daysToPlayStepper.bottomAnchor, constant: 20).isActive = true
        saveTourney.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        saveTourney.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        if sender {
            saveTourney.setTitle("Save Changes", for: .normal)
        }

    }
    
    func createInputContainer(topAnchor: UIView, anchorConstant: Int, numberInputs: Int, vertSepDistance: Int, inputs: [String], inputTypes: [Int]) -> UIView {
        
        let inputContainer: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 5
            view.layer.masksToBounds = true
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        scrollView.addSubview(inputContainer)
        inputContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainer.topAnchor.constraint(equalTo: topAnchor.bottomAnchor, constant: CGFloat(anchorConstant)).isActive = true
        inputContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainer.heightAnchor.constraint(equalToConstant: CGFloat(numberInputs * 50)).isActive = true
        
        var anchorShift = -50
        
        for (index, element) in inputs.enumerated() {
            anchorShift += 50
            let label: UILabel = {
                let lb = UILabel()
                lb.text = element
                lb.translatesAutoresizingMaskIntoConstraints = false
                lb.font = UIFont(name: "HelveticaNeue", size: 20)
                return lb
            }()
            
            let textField: UITextField = {
                let tf = UITextField()
                //tf.placeholder = "Name"
//                if inputTypes[index] == 1 {
//                    tf.is
//                }
                tf.translatesAutoresizingMaskIntoConstraints = false
                tf.font = UIFont(name: "HelveticaNeue-Light", size: 20)
                return tf
            }()
            
            textFields.append(textField)
            
            let separatorView: UIView = {
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
            
            inputContainer.addSubview(label)
            label.leftAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: 12).isActive = true
            label.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: CGFloat(anchorShift)).isActive = true
            label.rightAnchor.constraint(equalTo: inputContainer.leftAnchor, constant: CGFloat(vertSepDistance)).isActive = true
            label.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
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
                    button.tag = buttonsCreated
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
            verticalSeparatorView.heightAnchor.constraint(equalTo: label.heightAnchor, constant: -12).isActive = true
            
        }
        
        return inputContainer
        
    }
    let states = ["Utah"]
    let counties = ["Beaver", "Box Elder", "Cache", "Carbon", "Daggett", "Davis", "Duchesne", "Emery", "Garfield", "Grand", "Iron", "Juab", "Kane", "Millard", "Morgan", "Piute", "Rich", "Salt Lake", "San Juan", "Sanpete", "Sevier", "Summit", "Tooele", "Uintah", "Utah", "Wasatch", "Washington", "Wayne", "Weber"]
    
    let types = ["Ladder", "Round Robin"]
    let skillLevels = [2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
    let sexes = ["Mens", "Womens", "Mixed", "Any"]
    
    let ageGroups = ["Any", "0-18", "19 - 34", "35-49", "50+"]
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var days = [Int]()
    let years = [2020, 2021, 2022]
    
}
