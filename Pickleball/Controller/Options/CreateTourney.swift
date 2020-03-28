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

class CreateTourney: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var textFields = [UITextField]()
    var dropDownButtons = [UIButton]()
    let blackView = UIView()
    var selectedDropDown = -1
    var buttonsCreated = 0
    
    var tourneyList: TourneyList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupCollectionView()
        for index in 1...30 {
            daysTilStart.append(index)
        }
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
        case 7:
            return daysTilStart.count
        case 8:
            return lengthWeeks.count
        case 5:
            return states.count
        case 6:
            return counties.count
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
        case 7:
            cell.menuItem.text = "\(daysTilStart[indexPath.item])"
        case 8:
            cell.menuItem.text = "\(lengthWeeks[indexPath.item])"
        case 5:
            cell.menuItem.text = states[indexPath.item]
        case 6:
            cell.menuItem.text = counties[indexPath.item]
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
        case 7:
            textFields[7].text = "\(daysTilStart[indexPath.item])"
        case 8:
            textFields[8].text = "\(lengthWeeks[indexPath.item])"
        case 5:
            textFields[5].text = states[indexPath.item]
        case 6:
            textFields[6].text = counties[indexPath.item]
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
        
        guard let name = textFields[0].text, let type = textFields[1].text, let skillLevel = textFields[2].text, let sex = textFields[3].text, let ageGroup = textFields[4].text, let startTime = textFields[7].text, let duration = textFields[8].text, let state = textFields[5].text, let county = textFields[6].text else {
            let newalert = UIAlertController(title: "Sorry", message: "One or more fields are incorrect", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        if name == "" || type == "" || skillLevel == "" || sex == "" || ageGroup == "" || startTime == "" || duration == "" || state == "" || county == "" {
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
        guard let name = textFields[0].text, let type = textFields[1].text, let skillLevel = Float(textFields[2].text!), let sex = textFields[3].text, let ageGroup = textFields[4].text, let startTime = textFields[7].text, let duration = Int(textFields[8].text!), let state = textFields[5].text, let county = textFields[6].text else {
            let newalert = UIAlertController(title: "Sorry", message: "One or more fields are incorrect", preferredStyle: UIAlertController.Style.alert)
            newalert.addAction(UIAlertAction(title: "Return", style: UIAlertAction.Style.default, handler: nil))
            self.present(newalert, animated: true, completion: nil)
            return
        }
        
        let initialPeriodStartTime = Date().timeIntervalSince1970
        let startSpecific = initialPeriodStartTime + (Double(startTime)! * 86400)
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("tourneys")
        let tourneyref = ref.childByAutoId()
        let values = ["official": officialTourneyCheck.isOn ? 1 : 0, "active": 0, "name": name, "skill_level": skillLevel, "type": type, "sex": sex, "age_group": ageGroup, "start_date": startSpecific, "duration": duration, "creator": uid, "state": state, "county": county] as [String : Any]
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
    
    let officialTourneyCheck: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.isOn = false
        return uiSwitch
    }()
    
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
    
    let saveTourney: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = .white
        button.setTitle("Create Tourney", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 35)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSaveChanges), for: .touchUpInside)
        return button
    }()
    
    func setupViews() {
        view.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        
        view.addSubview(createTourneyLabel)
        createTourneyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createTourneyLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        createTourneyLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -120).isActive = true
        createTourneyLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        if uid == "ehEtZLizUaT9bahIaHQ1v5pLwK23" {
            officialTourneyCheck.isHidden = false
        } else {
            officialTourneyCheck.isHidden = true
        }
        view.addSubview(officialTourneyCheck)
        officialTourneyCheck.leftAnchor.constraint(equalTo: createTourneyLabel.rightAnchor).isActive = true
        officialTourneyCheck.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        officialTourneyCheck.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -2).isActive = true
        officialTourneyCheck.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        let inputsArray = ["Name", "Type", "Skill Level", "Sex", "Age Group"]
        let inputsArray2 = ["State", "County","Days to Begin", "Length (weeks)"]
        let inputContainer1 = createInputContainer(topAnchor: createTourneyLabel, anchorConstant: 20, numberInputs: 5, vertSepDistance: 120, inputs: inputsArray, inputTypes: [0, 1, 1, 1, 1])
        let inputContainer2 = createInputContainer(topAnchor: inputContainer1, anchorConstant: 20, numberInputs: 4, vertSepDistance: 160, inputs: inputsArray2, inputTypes: [1, 1, 1, 1])
        
        view.addSubview(saveTourney)
        saveTourney.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveTourney.topAnchor.constraint(equalTo: inputContainer2.bottomAnchor, constant: 40).isActive = true
        saveTourney.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100).isActive = true
        saveTourney.heightAnchor.constraint(equalToConstant: 50).isActive = true

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
        
        view.addSubview(inputContainer)
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
    
    let types = ["Ladder"]
    let skillLevels = [2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]
    let sexes = ["Mens", "Womens", "Mixed"]
    
    let ageGroups = ["Any", "0-18", "19 - 34", "35-49", "50+"]
    var daysTilStart = [Int]()
    let lengthWeeks = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
}
