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
    var time: Double?
    var submitter: String?
    var active: Int?
    var challengerTeamId: String?
    var challengedTeamId: String?
    var matchId: String?
    var tourneyId: String?
    var challengerScores: [Int]?
    var challengedScores: [Int]?
}

class Match2: NSObject {
    var winner: Int?
    var submitter: Int?
    var time: Double?
    var active: Int?
    var team_1_player_1: String?
    var team_1_player_2: String?
    var team_2_player_1: String?
    var team_2_player_2: String?
    var matchId: String?
    var team1_scores: [Int]?
    var team2_scores: [Int]?
}
