//
//  Schedule.swift
//  Athletics
//
//  Created by grobinson on 11/7/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import UIKit
import Parse

class Schedule: UIViewController {
    
    var events: [Event] = []
    var month: Int?
    var year: Int?
    var team: Team?
    
    var schedule = [String:[Event]]()
    var sections: [(key: String,date: NSDate)] = []
    
    var refreshControl: UIRefreshControl!

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var monthTXT: UILabel!
    @IBOutlet weak var nextBTN: UIButton!
    @IBOutlet weak var prevBTN: UIButton!
    @IBOutlet weak var ai: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = UIRectEdge()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: Selector("setData"), forControlEvents: UIControlEvents.ValueChanged)
        self.table.addSubview(refreshControl)
        
        title = "Schedule"
        
        if let t = team { title = t.title }
        
        table.delegate = self
        table.dataSource = self
        
        let _date = NSDate()
        let _calendar = NSCalendar.currentCalendar()
        let _month = _calendar.components(.Month, fromDate: _date).month
        let _year = _calendar.components(.Year, fromDate: _date).year
        
        if month == nil { month = _month }
        if year == nil { year = _year }
        
        setData()
        
    }
    
    func setData(){
        
        if month > 12 {
            
            month = 1
            year!++
            
        }
        
        if month < 1 {
            
            month = 12
            year!--
            
        }
        
        let _date = NSDate(dateString: "\(year!)-\(month!)-1")
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMMM, YYYY"
        
        let dateString = dayTimePeriodFormatter.stringFromDate(_date)
        
        monthTXT.text = dateString
        
        var _year_b = year!
        var _month_b = month! + 1
        
        if _month_b > 12 {
            
            _month_b = 1
            _year_b++
            
        }
        
        if _month_b < 1 {
            
            _month_b = 12
            _year_b--
            
        }
        
        let A = NSDate(dateString: "\(year!)-\(month!)-1")
        let B = NSDate(dateString: "\(_year_b)-\(_month_b)-1")
        
        let query = Event.query()
        query?.whereKey("start_date", greaterThan: A)
        query?.whereKey("start_date", lessThan: B)
        if let t = team {
            
            query?.whereKey("team", equalTo: t)
            
        }
        query?.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            
            if let objects = objects as? [Event] {
                
                self.setEvents(events: objects)
                self.table.reloadData()
                
            }
            
            self.refreshControl.endRefreshing()
            
        }
        
        navigationItem.setRightBarButtonItem(nil, animated: false)
        
        if let user = User.currentUser() {
            
            if user.admin {
                
                let add = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addTPD"))
                self.navigationItem.setRightBarButtonItem(add, animated: true)
                
            } else {
                
                user.getTeams { (error) -> Void in
                    
                    if error == nil {
                        
                        if let team = self.team {
                            
                            if user.teams.contains(team) {
                                
                                let add = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addTPD"))
                                self.navigationItem.setRightBarButtonItem(add, animated: true)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func addTPD(){
        
        let vc = MS.instantiateViewControllerWithIdentifier("event_edit") as! EventEdit
        
        let nav = UINavigationController(rootViewController: vc)
        
        presentViewController(nav, animated: true, completion: nil)
        
    }
    
    
    func setEvents(events _events: [Event]){
        
        schedule.removeAll(keepCapacity: true)
        sections.removeAll(keepCapacity: true)
        
        events = _events
        
        let f = NSDateFormatter()
        f.dateFormat = "EEEE, MMMM d, YYYY"
        
        for event in events {
            
            let s = f.stringFromDate(event.start_date!)
            
            if schedule[s] == nil {
                
                sections.append((key: s, date: event.start_date!))
                schedule[s] = [event]
                    
            } else {
                
                schedule[s]?.append(event)
                
            }
            
        }
        
        sections.sortInPlace { $0.date.compare($1.date) == NSComparisonResult.OrderedAscending }
        
        var z: Int?
        for (i,section) in sections.enumerate() {
            
            let today = f.stringFromDate(NSDate())
            
            if section.key == today {
                
                z = i
            
            }
            
        }
        
        table.reloadData()
        if let i = z {
            
            let ns = NSIndexPath(forRow: 0, inSection: i)
            table.scrollToRowAtIndexPath(ns, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            
        }
        
    }

    @IBAction func chgTPD(sender: UIButton){
        
        if sender.tag == 0 {
            
            month!--
            
        } else {
            
            month!++
            
        }
        
        setData()
        
    }
    
}

extension Schedule: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return sections.count
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = sections[section]
        
        let item = schedule[section.key]!
        
        return item.count
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let section = sections[section]
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        view.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        
        let label = UILabel(frame: CGRect(x: 16, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height))
        label.text = section.key
        label.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        label.font = UIFont.systemFontOfSize(13)
        
        view.addSubview(label)
        
        return view
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "_")
        
        let section = sections[indexPath.section]
        
        let key = section.key
        
        let event = schedule[key]![indexPath.row]
        
        cell.textLabel?.text = event.title
        
        var select = false
        
        if let user  = User.currentUser() {
            
            if user.admin {
                
                select = true
                
            }
            
        }
        
        if !select { cell.selectionStyle = .None }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
}

extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}