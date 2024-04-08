//
//  DropDown.swift
//  Unity Premier League
//
//  Created by student on 2024-01-07.
//  Copyright © 2024 Appify Mobile Apps. All rights reserved.
//

import Foundation
import iOSDropDown
import UIKit

class Picker: DropDown {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        checkMarkEnabled = false
        selectedRowColor = .clear
        font = UIFont.preferredFont(forTextStyle: .headline)
        textAlignment = .center
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
