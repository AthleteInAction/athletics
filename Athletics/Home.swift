//
//  Home.swift
//  Athletics
//
//  Created by grobinson on 10/29/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class Home: UITabBarController {
    
    var schedule: Dailey?
    var teams: TeamsTable?
    var more: More?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.translucent = false
        
        schedule = Dailey(nibName: "Dailey", bundle: nil)
        let scheduleNav = UINavigationController(rootViewController: schedule!)
        let scheduleTab = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Favorites, tag: 1)
        scheduleNav.tabBarItem = scheduleTab
        
        teams = TeamsTable(nibName: "TeamsTable", bundle: nil)
        let teamsNav = UINavigationController(rootViewController: teams!)
        let teamsTab = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Featured, tag: 2)
        teamsNav.tabBarItem = teamsTab
        
        more = More(nibName: "More",bundle: nil)
        let moreNav = UINavigationController(rootViewController: more!)
        let moreTab = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.More, tag: 3)
        moreNav.tabBarItem = moreTab
        
        let controllers = [scheduleNav,teamsNav,moreNav]
        
        viewControllers = controllers
        
    }

    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        if item.tag == 1 {
            
            schedule?.setAdmin()
            
        }
        
    }

}