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

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var monthTXT: UILabel!
    @IBOutlet weak var nextBTN: UIButton!
    @IBOutlet weak var prevBTN: UIButton!
    @IBOutlet weak var ai: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.translucent = false
        
        table.registerNib(UINib(nibName: "ScheduleGameCell", bundle: nil), forCellReuseIdentifier: "game")
        table.registerNib(UINib(nibName: "ScoreCell", bundle: nil), forCellReuseIdentifier: "score")
        table.estimatedRowHeight = 65.0
        table.rowHeight = UITableViewAutomaticDimension
        
        edgesForExtendedLayout = UIRectEdge()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
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
        
        setData(true)
        
    }
    
    func refresh(){ setData(true) }
    
    func setData(local: Bool){
        
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
        if local { query?.fromLocalDatastore() }
        query?.whereKey("start_date", greaterThan: A)
        query?.whereKey("start_date", lessThan: B)
        if let t = team {
            
            query?.whereKey("team", equalTo: t)
            
        }
        header.alpha = 0.3
        header.userInteractionEnabled = false
        query?.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            
            self.header.alpha = 1
            self.header.userInteractionEnabled = true
            
            if let objects = objects as? [Event] {
                
                if local {
                    
                    self.setData(false)
                    
                } else {
                    
                    Event.pinAllInBackground(objects)
                    
                }
                
                self.setEvents(events: objects)
                self.table.reloadData()
                
            }
            
            self.refreshControl.endRefreshing()
            
        }
        
        if let user = User.currentUser() {
            
            user.getRoles { (error) -> Void in
                
                if error == nil {
                    
                    if user.admin {
                        
                        let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addTPD"))
                        self.navigationItem.setRightBarButtonItem(add, animated: true)
                        
                    }
                    
                }
                
                if let team = self.team {
                    
                    user.getTeams { (error) -> Void in
                        
                        if error == nil {
                            
                            if user.teams.contains(team) {
                                
                                let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addTPD"))
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
        vc.team = team
        
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
        
        setData(true)
        
    }
    
}

extension Schedule: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if events.count == 0 {
            
            return 1
            
        } else {
            
            return sections.count
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if events.count == 0 {
            
            return 1
            
        } else {
            
            let section = sections[section]
            
            let item = schedule[section.key]!
            
            return item.count
            
        }
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if events.count == 0 {
            
            return nil
            
        } else {
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
            view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
            
            let label = UILabel(frame: CGRect(x: 8, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height))
            label.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
            label.font = UIFont.systemFontOfSize(13)
            
            label.text = sections[section].key
            
            view.addSubview(label)
            
            return view
            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if events.count == 0 {
            
            return 0
            
        } else {
            
            return 30
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if events.count == 0 {
            
            return CellObject.empty()
            
        } else {
            
            let section = sections[indexPath.section]
            
            let key = section.key
            
            let event = schedule[key]![indexPath.row]
            
            if let _ = event.score {
                
                return CellObject.score(tableView: tableView, event: event)
                
            } else {
                
                return CellObject.schedule(tableView: tableView, event: event)
                
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let section = sections[indexPath.section]
        
        let key = section.key
        
        let event = schedule[key]![indexPath.row]
        
        let vc = EventDetail(nibName: "EventDetail",bundle: nil)
        vc.event = event
        
        navigationController?.pushViewController(vc, animated: true)
        
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