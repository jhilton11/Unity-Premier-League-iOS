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
    
    init(_ id: String, _ title: String, _ imageUrl: String) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
    }
}
