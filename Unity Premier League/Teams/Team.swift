//
//  Team.swift
//  Unity Premier League
//
//  Created by APPLE on 10/6/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import UIKit
import Foundation

class Team {
    var id: String = ""
    var name: String = ""
    var imageUrl: String = ""
    var address: String?
    var yearEstablished: Int = 0
    var currentLeague: String?
    var position: Int = 0
    var played: Int = 0
    var win: Int = 0
    var losses: Int = 0
    var draws: Int = 0
    var gf: Int = 0
    var ga: Int = 0
    var gd: Int = 0
    var points: Int = 0
    var deducted: Int = 0
    var leagueTeamId: String?
    
    init() {
        
    }
    
    init(_ id: String, _ name: String, _ imageUrl: String) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }
}
