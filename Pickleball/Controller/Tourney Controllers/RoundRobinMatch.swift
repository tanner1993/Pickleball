//
//  RoundRobinMatch.swift
//  Pickleball
//
//  Created by Tanner Rozier on 7/12/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit

class RoundRobinMatch: UIViewController {
    
    let matchViewOrganizer = MatchViewOrganizer(frame: CGRect(x: 0, y: 0, width: (UIApplication.shared.keyWindow?.frame.width)!, height: (UIApplication.shared.keyWindow?.frame.height)!))
    
    override func loadView() {
        view = matchViewOrganizer
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation

}
