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
    
    let player = Player()
    
    let backgroundImage: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.image = UIImage(named: "user_dashboard")
        bi.isUserInteractionEnabled = true
        return bi
    }()
    
    let skillLevel: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 100)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.addTarget(self, action: #selector(handleCreateTourney), for: .touchUpInside)
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
    
    let skillLevelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Skill Level"
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    let haloLevel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 100)
        label.textAlignment = .center
        return label
    }()
    
    let haloLevelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .center
        return label
    }()
    
    let playerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        label.textAlignment = .center
        return label
    }()
    
    let location: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .left
        return label
    }()
    
    let ageGroup: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.textAlignment = .right
        return label
    }()
    
    let tourneysEntered: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        label.textAlignment = .right
        return label
    }()
    
    let tourneysWon: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        label.textAlignment = .right
        return label
    }()
    
    let matchesWon: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        label.textAlignment = .right
        return label
    }()
    
    let matchesLost: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        label.textAlignment = .right
        return label
    }()
    
    let winRatio: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        label.textAlignment = .right
        return label
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
        observePlayerProfile()
        view.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        self.navigationController?.navigationBar.isTranslucent = false
        
        view.addSubview(backgroundImage)
        backgroundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalToConstant: 550).isActive = true
        
        view.addSubview(skillLevel)
        let skillLevelLoc = calculateButtonPosition(x: 200, y: 140, w: 250, h: 160, wib: 750, hib: 1100, wia: 375, hia: 550)
        
        skillLevel.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(skillLevelLoc.Y)).isActive = true
        skillLevel.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(skillLevelLoc.X)).isActive = true
        skillLevel.heightAnchor.constraint(equalToConstant: CGFloat(skillLevelLoc.H)).isActive = true
        skillLevel.widthAnchor.constraint(equalToConstant: CGFloat(skillLevelLoc.W)).isActive = true
        
        view.addSubview(skillLevelLabel)
        let skillLevelLabelLoc = calculateButtonPosition(x: 200, y: 255, w: 200, h: 35, wib: 750, hib: 1100, wia: 375, hia: 550)
        
        skillLevelLabel.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(skillLevelLabelLoc.Y)).isActive = true
        skillLevelLabel.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(skillLevelLabelLoc.X)).isActive = true
        skillLevelLabel.heightAnchor.constraint(equalToConstant: CGFloat(skillLevelLabelLoc.H)).isActive = true
        skillLevelLabel.widthAnchor.constraint(equalToConstant: CGFloat(skillLevelLabelLoc.W)).isActive = true
        
        view.addSubview(haloLevel)
        let haloLevelLoc = calculateButtonPosition(x: 550, y: 140, w: 250, h: 160, wib: 750, hib: 1100, wia: 375, hia: 550)
        
        haloLevel.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(haloLevelLoc.Y)).isActive = true
        haloLevel.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(haloLevelLoc.X)).isActive = true
        haloLevel.heightAnchor.constraint(equalToConstant: CGFloat(haloLevelLoc.H)).isActive = true
        haloLevel.widthAnchor.constraint(equalToConstant: CGFloat(haloLevelLoc.W)).isActive = true
        
        view.addSubview(haloLevelTitle)
        let haloLevelTitleLoc = calculateButtonPosition(x: 550, y: 255, w: 200, h: 35, wib: 750, hib: 1100, wia: 375, hia: 550)
        
        haloLevelTitle.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(haloLevelTitleLoc.Y)).isActive = true
        haloLevelTitle.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(haloLevelTitleLoc.X)).isActive = true
        haloLevelTitle.heightAnchor.constraint(equalToConstant: CGFloat(haloLevelTitleLoc.H)).isActive = true
        haloLevelTitle.widthAnchor.constraint(equalToConstant: CGFloat(haloLevelTitleLoc.W)).isActive = true
        
        view.addSubview(playerName)
        let playerNameLoc = calculateButtonPosition(x: 375, y: 380, w: 700, h: 50, wib: 750, hib: 1100, wia: 375, hia: 550)
        
        playerName.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(playerNameLoc.Y)).isActive = true
        playerName.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(playerNameLoc.X)).isActive = true
        playerName.heightAnchor.constraint(equalToConstant: CGFloat(playerNameLoc.H)).isActive = true
        playerName.widthAnchor.constraint(equalToConstant: CGFloat(playerNameLoc.W)).isActive = true
        
        view.addSubview(location)
        let locationLoc = calculateButtonPosition(x: 216.75, y: 450, w: 383.5, h: 50, wib: 750, hib: 1100, wia: 375, hia: 550)
        
        location.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(locationLoc.Y)).isActive = true
        location.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(locationLoc.X)).isActive = true
        location.heightAnchor.constraint(equalToConstant: CGFloat(locationLoc.H)).isActive = true
        location.widthAnchor.constraint(equalToConstant: CGFloat(locationLoc.W)).isActive = true
        
        view.addSubview(ageGroup)
        let ageGroupLoc = calculateButtonPosition(x: 566.5, y: 450, w: 316, h: 50, wib: 750, hib: 1100, wia: 375, hia: 550)
        
        ageGroup.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(ageGroupLoc.Y)).isActive = true
        ageGroup.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(ageGroupLoc.X)).isActive = true
        ageGroup.heightAnchor.constraint(equalToConstant: CGFloat(ageGroupLoc.H)).isActive = true
        ageGroup.widthAnchor.constraint(equalToConstant: CGFloat(ageGroupLoc.W)).isActive = true
        
        view.addSubview(tourneysEntered)
        let tourneysEnteredLoc = calculateButtonPosition(x: 645, y: 630, w: 160, h: 60, wib: 750, hib: 1100, wia: 375, hia: 550)
        
        tourneysEntered.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(tourneysEnteredLoc.Y)).isActive = true
        tourneysEntered.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(tourneysEnteredLoc.X)).isActive = true
        tourneysEntered.heightAnchor.constraint(equalToConstant: CGFloat(tourneysEnteredLoc.H)).isActive = true
        tourneysEntered.widthAnchor.constraint(equalToConstant: CGFloat(tourneysEnteredLoc.W)).isActive = true
        
        view.addSubview(tourneysWon)
        let tourneysWonLoc = calculateButtonPosition(x: 645, y: 730, w: 160, h: 60, wib: 750, hib: 1100, wia: 375, hia: 550)
        
        tourneysWon.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(tourneysWonLoc.Y)).isActive = true
        tourneysWon.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(tourneysWonLoc.X)).isActive = true
        tourneysWon.heightAnchor.constraint(equalToConstant: CGFloat(tourneysWonLoc.H)).isActive = true
        tourneysWon.widthAnchor.constraint(equalToConstant: CGFloat(tourneysWonLoc.W)).isActive = true
        
        view.addSubview(matchesWon)
        let matchesWonLoc = calculateButtonPosition(x: 645, y: 830, w: 160, h: 60, wib: 750, hib: 1100, wia: 375, hia: 550)
        
        matchesWon.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(matchesWonLoc.Y)).isActive = true
        matchesWon.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(matchesWonLoc.X)).isActive = true
        matchesWon.heightAnchor.constraint(equalToConstant: CGFloat(matchesWonLoc.H)).isActive = true
        matchesWon.widthAnchor.constraint(equalToConstant: CGFloat(matchesWonLoc.W)).isActive = true
        
        view.addSubview(matchesLost)
        let matchesLostLoc = calculateButtonPosition(x: 645, y: 930, w: 160, h: 60, wib: 750, hib: 1100, wia: 375, hia: 550)
        
        matchesLost.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(matchesLostLoc.Y)).isActive = true
        matchesLost.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(matchesLostLoc.X)).isActive = true
        matchesLost.heightAnchor.constraint(equalToConstant: CGFloat(matchesLostLoc.H)).isActive = true
        matchesLost.widthAnchor.constraint(equalToConstant: CGFloat(matchesLostLoc.W)).isActive = true
        
        view.addSubview(winRatio)
        let winRatioLoc = calculateButtonPosition(x: 645, y: 1030, w: 160, h: 60, wib: 750, hib: 1100, wia: 375, hia: 550)
        
        winRatio.centerYAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: CGFloat(winRatioLoc.Y)).isActive = true
        winRatio.centerXAnchor.constraint(equalTo: backgroundImage.leftAnchor, constant: CGFloat(winRatioLoc.X)).isActive = true
        winRatio.heightAnchor.constraint(equalToConstant: CGFloat(winRatioLoc.H)).isActive = true
        winRatio.widthAnchor.constraint(equalToConstant: CGFloat(winRatioLoc.W)).isActive = true
        
    }
    
    func observePlayerProfile() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let value = snapshot.value as? NSDictionary {
                self.skillLevel.setTitle("\(self.player.level ?? 2)", for: .normal)
                let exp = value["exp"] as? Int ?? 0
                self.haloLevel.text = "\(self.player.haloLevel(exp: exp))"
                self.haloLevelTitle.text = "Pickler"
                self.playerName.text = value["name"] as? String ?? "no name"
                let state = value["state"] as? String ?? "no state"
                let county = value["county"] as? String ?? "no state"
                self.location.text = "\(state), \(county)"
                self.ageGroup.text = "46-55"
                self.tourneysEntered.text = "\(value["tourneys_played"] as? Int ?? 0)"
                self.tourneysWon.text = "\(value["tourneys_won"] as? Int ?? 0)"
                self.matchesWon.text = "\(value["match_wins"] as? Int ?? 0)"
                self.matchesLost.text = "\(value["match_losses"] as? Int ?? 0)"
                self.winRatio.text = ".5"
            }
        }, withCancel: nil)
    }
    
    func calculateButtonPosition(x: Float, y: Float, w: Float, h: Float, wib: Float, hib: Float, wia: Float, hia: Float) -> (X: Float, Y: Float, W: Float, H: Float) {
        let X = x / wib * wia
        let Y = y / hib * hia
        let W = w / wib * wia
        let H = h / hib * hia
        return (X, Y, W, H)
    }
    

}
