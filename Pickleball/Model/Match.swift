//
//  Match.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/6/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit

class Match: NSObject {
    var winner: String?
    var submitter: String?
    var active: Int?
    var challengerTeamId: String?
    var challengedTeamId: String?
    var matchId: String?
    var tourneyId: String?
    var challengerScores: [Int]?
    var challengedScores: [Int]?
}
