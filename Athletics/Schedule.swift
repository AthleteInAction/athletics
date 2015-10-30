//
//  Schedule.swift
//  Athletics
//
//  Created by grobinson on 10/29/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class Schedule: UITableViewController {
    
    var events: [Event] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1 ... 6 {
            
            let e = Event(title: "Event #\(i)", start_date: NSDate())
            
            events.append(e)
            
        }
        
        title = "Schedule"
        
        edgesForExtendedLayout = UIRectEdge()
        
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return events.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        let event = events[indexPath.row]
        
        cell.textLabel?.text = event.title
        
        return cell
        
    }
    
}