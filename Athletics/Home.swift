//
//  Home.swift
//  Athletics
//
//  Created by grobinson on 10/29/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class Home: UITabBarController {
    
    var schedule: Schedule!
    var more: More!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.translucent = false
        
        schedule = Schedule(nibName: "Schedule", bundle: nil)
        let scheduleNav = UINavigationController(rootViewController: schedule)
        let scheduleTab = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Favorites, tag: 1)
        scheduleNav.tabBarItem = scheduleTab
        
        more = More(nibName: "More", bundle: nil)
        let moreNav = UINavigationController(rootViewController: more)
        let moreTab = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.More, tag: 2)
        moreNav.tabBarItem = moreTab
        
        var controllers = [scheduleNav,moreNav]
        
        viewControllers = controllers
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

}