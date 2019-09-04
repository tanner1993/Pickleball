//
//  ViewController.swift
//  Pickleball
//
//  Created by Tanner Rozier on 8/26/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit
import FirebaseDatabase
var ref : DatabaseReference!

class TableofTourneys: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        view.backgroundColor = UIColor.blue
        
    }
    
}

