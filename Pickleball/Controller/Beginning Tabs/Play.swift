//
//  Play.swift
//  Pickleball
//
//  Created by Tanner Rozier on 4/17/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit
import Firebase

class Play: UIViewController {
    
    var matchIds = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbarTitle()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        matchIds.removeAll()
        prepMatchList()
    }
    
    func prepMatchList() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user_matches").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let matchId = snapshot.key
            self.matchIds.append(matchId)
        }, withCancel: nil)
    }
    
    func setupNavbarTitle() {
        let widthofscreen = Int(view.frame.width)
        let titleLabel = UILabel(frame: CGRect(x: widthofscreen / 2, y: 0, width: 40, height: 30))
        titleLabel.text = "Play"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.navigationItem.titleView = titleLabel
    }
    
    let tourneyPlayLabel: UIButton = {
        let label = UIButton(type: .system)
        label.setTitle("Tournament\nPlay", for: .normal)
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 50)
        label.setTitleColor(UIColor.init(r: 88, g: 148, b: 200), for: .normal)
        label.titleLabel?.textAlignment = .center
        label.titleLabel?.numberOfLines = 2
        label.addTarget(self, action: #selector(enterMyTourneys), for: .touchUpInside)
        return label
    }()
    
    @objc func enterMyTourneys() {
        let tourneyMy = TourneyList()
        tourneyMy.hidesBottomBarWhenPushed = true
        tourneyMy.sender = 0
        navigationController?.pushViewController(tourneyMy, animated: true)
    }
    
    let tourneySymbol: UIImageView = {
        let bi = UIImageView()
        bi.translatesAutoresizingMaskIntoConstraints = false
        bi.contentMode = .scaleAspectFit
        bi.image = UIImage(named: "tourney_symbol")
        bi.isUserInteractionEnabled = true
        return bi
    }()
    
    let matchPlayLabel: UIButton = {
        let label = UIButton(type: .system)
        label.setTitle("Match\nPlay", for: .normal)
        label.backgroundColor = UIColor.init(r: 88, g: 148, b: 200)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 50)
        label.setTitleColor(.white, for: .normal)
        label.titleLabel?.textAlignment = .center
        label.titleLabel?.numberOfLines = 2
        label.addTarget(self, action: #selector(enterMyMatches), for: .touchUpInside)
        return label
    }()
    
    @objc func enterMyMatches() {
        let matchesMy = MatchFeed()
        matchesMy.hidesBottomBarWhenPushed = true
        matchesMy.sender = 1
        matchesMy.matchIds = matchIds.reversed()
        navigationController?.pushViewController(matchesMy, animated: true)
    }
    
    func setupViews() {
        
        view.addSubview(tourneyPlayLabel)
        tourneyPlayLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tourneyPlayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tourneyPlayLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tourneyPlayLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
//        view.addSubview(tourneySymbol)
//        tourneySymbol.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        tourneySymbol.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
//        tourneySymbol.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        tourneySymbol.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(matchPlayLabel)
        matchPlayLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        matchPlayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        matchPlayLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        matchPlayLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

}
