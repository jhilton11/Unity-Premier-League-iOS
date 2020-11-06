//
//  MatchStat.swift
//  Unity Premier League
//
//  Created by APPLE on 10/16/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import Foundation

class MatchStat {
    var id: String = ""
    var playerName: String = ""
    var playerId: String = ""
    var minute: String?
    var playerImageUrl: String = ""
    var matchId: String = ""
    var eventType: String = ""
    var leagueId: String = ""
    var isHome: Bool?
    var teamName: String?
    
    init(id: String, name: String, playerId: String, url: String, matchId: String, type: String, league: String) {
        self.id = id
        self.playerName = name
        self.playerId = playerId
        self.playerImageUrl = url
        self.matchId = matchId
        self.matchId = matchId
        self.eventType = type
    }
}
