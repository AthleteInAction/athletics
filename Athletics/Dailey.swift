//
//  Dailey.swift
//  Athletics
//
//  Created by grobinson on 11/8/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import UIKit

class Dailey: UIViewController {
    
    var events: [Event] = []
    var date = NSDate()
    private var calendar = NSCalendar.currentCalendar()
    private var ai: UIActivityIndicatorView!
    private var at: UIView!
    var loaded = false

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.registerNib(UINib(nibName: "GameEventCell", bundle: nil), forCellReuseIdentifier: "game")
        table.registerNib(UINib(nibName: "ScoreCell", bundle: nil), forCellReuseIdentifier: "score")
        table.estimatedRowHeight = 65.0
        table.rowHeight = UITableViewAutomaticDimension
        
        loaded = true
        
        ai = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        
        title = "Schedule"
        
        at = navigationItem.titleView
        
        navigationController?.navigationBar.translucent = false
        edgesForExtendedLayout = UIRectEdge()
        
        table.delegate = self
        table.dataSource = self
        
        setDisplay()
        setAdmin()
        
    }
    
    func setAdmin(){
        
        navigationItem.setRightBarButtonItem(nil, animated: true)
        
        if let user = User.currentUser() {
            
            user.getRoles { (error) -> Void in
                
                if user.admin {
                    
                    let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addTPD"))
                    self.navigationItem.setRightBarButtonItem(add, animated: true)
                    
                }
                
            }
            
        }
        
    }
    
    func addTPD(){
        
        let vc = MS.instantiateViewControllerWithIdentifier("event_edit") as! EventEdit
        vc.delegate = self
        
        let nav = UINavigationController(rootViewController: vc)
        
        presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func setData(local: Bool){
        
        navigationItem.titleView = ai
        ai.startAnimating()
        
        let _month = calendar.components(.Month, fromDate: date).month
        let _day = calendar.components(.Day, fromDate: date).day
        let _year = calendar.components(.Year, fromDate: date).year
        
        let A = NSDate(dateString: "\(_year)-\(_month)-\(_day)")
        let B = calendar.dateByAddingUnit(.Day, value: 1, toDate: date, options: [])!
        
        let query = Event.query()
        query?.includeKey("team")
        query?.whereKey("start_date", greaterThanOrEqualTo: A)
        query?.whereKey("start_date", lessThan: B)
        if local { query?.fromLocalDatastore() }
        header.alpha = 0.3
        header.userInteractionEnabled = false
        query?.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            
            self.navigationItem.titleView = self.at
            self.ai.stopAnimating()
            
            self.header.alpha = 1
            self.header.userInteractionEnabled = true
            
            if let objects = objects as? [Event] {
                
                if local {
                    
                    self.setData(false)
                    
                } else {
                    
                    Event.pinAllInBackground(objects)
                    
                }
                
                self.events = objects
                self.table.reloadData()
                
            }
            
        }
        
    }
    
    func setDisplay(){
        
        let today = NSDate()
        let month = calendar.components(.Month, fromDate: today).month
        let day = calendar.components(.Day, fromDate: today).day
        let year = calendar.components(.Year, fromDate: today).year
        
        let _month = calendar.components(.Month, fromDate: date).month
        let _day = calendar.components(.Day, fromDate: date).day
        let _year = calendar.components(.Year, fromDate: date).year
        
        let a = "\(_year)-\(_month)-\(_day)"
        let b = "\(year)-\(month)-\(day)"
        
        if a == b {
            
            label.text = "Today"
            
        } else {
            
            let f = NSDateFormatter()
            f.dateFormat = "E, MMMM d, YYYY"
            
            label.text = f.stringFromDate(date)
            
        }
        
        setData(true)
        
    }
    
    @IBAction func chgTOD(sender: UIButton){
        
        if sender.tag == 0 {
            
            date = calendar.dateByAddingUnit(.Day, value: -1, toDate: date, options: [])!
            
        } else {
            
            date = calendar.dateByAddingUnit(.Day, value: 1, toDate: date, options: [])!
            
        }
        
        setDisplay()
        
    }

}

extension Dailey: EventEditPTC {
    
    func eventSaved(event: Event) {
        
        setData(true)
        
    }
    
    func newEvent(event: Event) {
        
        setData(true)
        
    }
    
}

extension Dailey: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if events.count == 0 {
            
            return 1
            
        } else {
            
            return events.count
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if events.count == 0 {
            
            return CellObject.empty()
            
        } else {
            
            let event = events[indexPath.section]
            
            if let _ = event.score {
                
                return CellObject.score(tableView: tableView, event: event)
                
            } else {
                
                return CellObject.dailey(tableView: tableView, event: event)
                
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if events.count > 0 {
            
            let event = events[section]
            
            if let _ = event.score {
                
                return 30
                
            }
            
        }
        
        return 0
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if events.count > 0 {
            
            let event = events[section]
            
            if let _ = event.score {
                
                let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
                view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                
                let label = UILabel(frame: CGRect(x: 8, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height))
                label.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
                label.font = UIFont.systemFontOfSize(13)
                
                label.text = event.team!.title
                
                view.addSubview(label)
                
                return view
                
            }
            
        }
        
        return nil
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let event = events[indexPath.section]
        
        let vc = EventDetail(nibName: "EventDetail",bundle: nil)
        vc.event = event
        
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
}