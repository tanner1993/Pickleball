//
//  TourneyStats.swift
//  Pickleball
//
//  Created by Tanner Rozier on 3/28/20.
//  Copyright © 2020 TannerRozier. All rights reserved.
//

import UIKit

class TourneyStats: UITableViewController {

    let cellId = "cellId"
    var allMatches = [Match2]()
    var teams = [Team]()
    var thisTourney = Tourney()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reorganizeTeamRanks()
        tableView.register(TeamStatsCell.self, forCellReuseIdentifier: cellId)
        tableView?.backgroundColor = .white
        self.tableView.separatorStyle = .none
    }
    
    func reorganizeTeamRanks() {
        if thisTourney.finals1 == 1 {
            teams[3].rank = 3
        } else {
            teams[0].rank = 3
        }
        
        if thisTourney.finals2 == 2 {
            teams[2].rank = 3
        } else {
            teams[1].rank = 3
        }
        
        if thisTourney.winner == 1 && thisTourney.finals2 == 3 {
            teams[2].rank = 2
        } else if thisTourney.winner == 2 && thisTourney.finals1 == 1 {
            teams[1].rank = 1
            teams[0].rank = 2
        } else if thisTourney.winner == 2 && thisTourney.finals1 == 4 {
            teams[1].rank = 1
            teams[3].rank = 2
        } else if thisTourney.winner == 3 && thisTourney.finals1 == 1 {
            teams[2].rank = 1
            teams[0].rank = 2
        } else if thisTourney.winner == 3 && thisTourney.finals1 == 4 {
            teams[2].rank = 1
            teams[3].rank = 2
        } else if thisTourney.winner == 4 && thisTourney.finals2 == 2 {
            teams[3].rank = 1
            teams[1].rank = 2
        } else if thisTourney.winner == 4 && thisTourney.finals2 == 3 {
            teams[3].rank = 1
            teams[2].rank = 2
        }
        self.teams = self.teams.sorted { p1, p2 in
            return (p1.rank!) < (p2.rank!)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TeamStatsCell
        cell.team = teams[indexPath.item]
        let points = findPointsWonLost(team: teams[indexPath.item])
        cell.pointsWon.text = "Points Won: \(points[0])"
        cell.pointsLost.text = "Points Lost: \(points[1])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(160)
    }
    
    func findPointsWonLost(team: Team) -> [Int] {
        var pointsWon = 0
        var pointsLost = 0
        for index in allMatches {
            if index.team_1_player_1 == team.player1 {
                for points in index.team1_scores! {
                    pointsWon += points
                }
                for points in index.team2_scores! {
                    pointsLost += points
                }
            } else if index.team_2_player_1 == team.player1 {
                for points in index.team2_scores! {
                    pointsWon += points
                }
                for points in index.team1_scores! {
                    pointsLost += points
                }
            }
        }
        return [pointsWon, pointsLost]
    }

}
