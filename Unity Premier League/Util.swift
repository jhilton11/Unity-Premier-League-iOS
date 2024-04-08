//
//  Util.swift
//  Unity Premier League
//
//  Created by APPLE on 11/9/20.
//  Copyright © 2020 Appify Mobile Apps. All rights reserved.
//
import UIKit

class Util {
    
    static func pushToNavigationController(navC: UINavigationController?, vc: UIViewController) {
        navC?.modalPresentationStyle = .fullScreen
        navC?.pushViewController(vc, animated: true)
    }
    
}
