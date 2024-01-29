//
//  TabController.swift
//  Unity Premier League
//
//  Created by student on 2024-01-10.
//  Copyright © 2024 Appify Mobile Apps. All rights reserved.
//

import UIKit

class TabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let newsVC = NewsViewController()
        let newsNavC = UINavigationController(rootViewController: newsVC)
        newsNavC.tabBarItem = UITabBarItem(title: "News", image: UIImage(named: "news"), selectedImage: UIImage(named: "teams"))
        
        let teamsVC = TeamsViewController()
        let teamNavC = UINavigationController(rootViewController: teamsVC)
        teamNavC.tabBarItem = UITabBarItem(title: "Teams", image: UIImage(named: "teams"), selectedImage: UIImage(named: "teams"))
        
        viewControllers = [newsNavC, teamNavC]
    }

}
