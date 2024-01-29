//
//  News.swift
//  Unity Premier League
//
//  Created by APPLE on 10/8/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//

import Foundation

class News {
    var id: String = ""
    var title: String = ""
    var imageUrl: String = ""
    var body: String?
    var date: String?
    
    init() {
        
    }
    
    init(id: String, title: String, imageUrl: String, body: String) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.body = body
    }
}
