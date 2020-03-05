//
//  Player.swift
//  Pickleball
//
//  Created by Tanner Rozier on 9/10/19.
//  Copyright © 2019 TannerRozier. All rights reserved.
//

import UIKit

class Player: NSObject {
    var name: String?
    var email: String?
    var id: String?
    var username: String?
    var exp: Int?
    var state: String?
    var county: String?
    var skill_level: Float?
    var halo_level: Int?
    var court: String?
    var match_wins: Int?
    var match_losses: Int?
    var tourneys_played: Int?
    var tourneys_won: Int?
    var birthdate: Double?
    var age_group: String?
    var sex: String?
    var friend: Int?
}

extension Player {
    func haloLevel(exp: Int) -> Int {
        switch exp {
        case 0...99:
            return 1
        case 100...199:
            return 2
        case 200...299:
            return 3
        case 300...399:
            return 4
        case 400...499:
            return 5
        case 500...599:
            return 6
        case 600...699:
            return 7
        case 700...799:
            return 8
        case 800...899:
            return 9
        case 900...999:
            return 10
        case 1000...1099:
            return 11
        case 1100...1199:
            return 12
        case 1200...1399:
            return 13
        case 1400...1599:
            return 14
        case 1600...1799:
            return 15
        case 1800...1999:
            return 16
        case 2000...2249:
            return 17
        case 2250...2499:
            return 18
        case 2500...2749:
            return 19
        case 2750...2999:
            return 20
        case 3000...3249:
            return 21
        case 3250...3499:
            return 22
        case 3500...3749:
            return 23
        case 3750...3999:
            return 24
        case 4000...4249:
            return 25
        default:
            return 0
        }
    }
}
