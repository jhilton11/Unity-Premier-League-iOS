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
        
        let fixturesVC = FixturesViewController()
        let fixturesNavC = UINavigationController(rootViewController: fixturesVC)
        fixturesNavC.tabBarItem = UITabBarItem(title: "Fixtures", image: UIImage(named: "teams"), selectedImage: UIImage(named: "teams"))
        
        let statsVC = StatsViewController()
        let statsNavC = UINavigationController(rootViewController: statsVC)
        statsNavC.tabBarItem = UITabBarItem(title: "Stats", image: UIImage(named: "teams"), selectedImage: UIImage(named: "teams"))
        
        let leagueTableVC = LeagueTableViewController()
        let leagueTableNavC = UINavigationController(rootViewController: leagueTableVC)
        leagueTableNavC.tabBarItem = UITabBarItem(title: "Table", image: UIImage(named: "teams"), selectedImage: UIImage(named: "teams"))
        
        viewControllers = [newsNavC, teamNavC, fixturesNavC, statsNavC, leagueTableNavC]
    }

}
