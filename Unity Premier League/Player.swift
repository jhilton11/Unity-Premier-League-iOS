//
//  Player.swift
//  Unity Premier League
//
//  Created by APPLE on 10/8/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import Foundation

class Player {
    var id: String = ""
    var name: String = ""
    var currentLeague: String?
    var imageUrl: String = ""
    var teamName: String?
    var goals: Int?
    var yellows: Int?
    var reds: Int?
    
    init() {
        
    }
    
    init(id: String, name: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }
}
