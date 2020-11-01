//
//  Fixture.swift
//  Unity Premier League
//
//  Created by APPLE on 10/15/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import Foundation

class Fixture {
    var id: String = ""
    var homeTeam: String = ""
    var homeTeamId: String = ""
    var homeTeamImgUrl = ""
    var homeScore: Int = 0
    var awayScore: Int = 0
    var awayTeamId: String = ""
    var awayTeamImgUrl = ""
    var awayTeam: String = ""
    var leagueId: String = ""
    var referee: String?
    var status: String = "not played"
    var report: String?
    var venue: String?
    var cellNo: Int?
    var matchNo: Int?
    
    init(id: String, homeTeam: String, homeTeamId: String, homeTeamImgUrl: String, awayTeam: String, awayTeamId: String, awayTeamImgUrl: String, leagueId: String) {
        self.id = id
        self.homeTeam = homeTeam
        self.homeTeamId = homeTeamId
        self.homeTeamImgUrl = homeTeamImgUrl
        self.awayTeam = awayTeam
        self.awayTeamId = awayTeamId
        self.awayTeamImgUrl = awayTeamImgUrl
        self.leagueId = leagueId
    }
}
