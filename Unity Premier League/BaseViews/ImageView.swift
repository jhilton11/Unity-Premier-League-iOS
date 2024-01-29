//
//  ImageView.swift
//  Unity Premier League
//
//  Created by student on 2024-01-07.
//  Copyright © 2024 Appify Mobile Apps. All rights reserved.
//

import UIKit

class ImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        layer.borderWidth = 5
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
