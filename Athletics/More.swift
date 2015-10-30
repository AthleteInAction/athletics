//
//  More.swift
//  Athletics
//
//  Created by grobinson on 10/30/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class More: UITableViewController {
    
    var items = [
        ["Login","Settings"],
        ["+ Add Event"]
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return items.count
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items[section].count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        
        let item = items[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = item
        
        return cell
        
    }
    
}