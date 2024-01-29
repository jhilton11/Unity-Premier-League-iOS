//
//  Label.swift
//  Unity Premier League
//
//  Created by student on 2024-01-07.
//  Copyright © 2024 Appify Mobile Apps. All rights reserved.
//

import UIKit

class Label: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        font = .systemFont(ofSize: 14)
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
