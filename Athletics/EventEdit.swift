//
//  EventEdit.swift
//  Athletics
//
//  Created by grobinson on 10/31/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI

protocol EventEditPTC {
    
    func eventSaved(event: Event)
    func newEvent(event: Event)
    
}

class EventEdit: UITableViewController {
    
    var delegate: EventEditPTC?
    
    var event: Event?
    var new_event = true
    
    var keys: [Event.Key] = [.GameLeague,.GameNonLeague,.GamePreseason,.Scrimmage]
    
    var label: String = "Opponent"
    
    let f = NSDateFormatter()
    let z = NSDateFormatter()
    
    @IBOutlet weak var keyTXT: UILabel!
    @IBOutlet weak var keyDISPLAY: UITableViewCell!
    @IBOutlet weak var teamTXT: UILabel!
    @IBOutlet weak var teamDISPLAY: UITableViewCell!
    @IBOutlet weak var opponentTXT: UILabel!
    @IBOutlet weak var opponentDISPLAY: UITableViewCell!
    @IBOutlet weak var opponentLBL: UILabel!
    @IBOutlet weak var startDateCELL: UITableViewCell!
    @IBOutlet weak var startDateTXT: UILabel!
    @IBOutlet weak var startTimeCELL: UITableViewCell!
    @IBOutlet weak var startTimeTXT: UILabel!
    @IBOutlet weak var locCELL: UITableViewCell!
    @IBOutlet weak var locTXT: UILabel!
    
    var tap: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = event {
            title = "Event Edit"
            new_event = false
        } else {
            title = "New Event"
            new_event = true
        }
        
        f.dateFormat = "E, MMM d, YYYY"
        z.dateFormat = "h:mm a"
        
        setData()
        
        tap = UITapGestureRecognizer()
        tap.addTarget(self, action: Selector("dismissKeyboard"))
        
        opponentLBL.alpha = 0.3
        opponentDISPLAY.userInteractionEnabled = false
        
        let save = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveTPD:")
        navigationItem.setRightBarButtonItem(save, animated: true)
        
        let cancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("cancelTPD"))
        navigationItem.setLeftBarButtonItem(cancel, animated: true)
        
    }

    func cancelTPD(){
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func setData(){
        
        opponentTXT.text = ""
        teamTXT.text = ""
        keyTXT.text = ""
        locTXT.text = ""
        startDateTXT.text = ""
        startTimeTXT.text = ""
        
        if let e = event {
            
            if let team = e.team { teamTXT.text = team.title }
            
            if let key = e.key { keyTXT.text = key.display }
            
            if let o = e.title { opponentTXT.text = o }
            
            if let n = e.loc_name { locTXT.text = n }
            
            if let start_date = e.start_date { startDateTXT.text = f.stringFromDate(start_date) }
            
            if let t = e.start_time { startTimeTXT.text = z.stringFromDate(t) }
            
        } else {
            
            event = Event()
            
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        
        switch cell {
        case opponentDISPLAY:
            
            let alert = UIAlertController(title: label, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            
            var txt: UITextField!
            
            func configurationTextField(textField: UITextField!){
                
                textField.placeholder = label
                txt = textField
                
            }
            
            alert.addTextFieldWithConfigurationHandler(configurationTextField)
            
            let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                
                self.opponentTXT.text = txt.text
                
                self.event?.title = txt.text
                
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
                
                
                
            })
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            presentViewController(alert, animated: true, completion: nil)
            
        case locCELL:
            
            let vc = LocationSearch(nibName: "LocationSearch",bundle: nil)
            vc.delegate = self
            
            navigationController?.pushViewController(vc, animated: true)
            
        case startDateCELL:
            
            let vc = DateSelector(nibName: "DateSelector",bundle: nil)
            vc.delegate = self
            vc.date = event!.start_date
            
            navigationController?.pushViewController(vc, animated: true)
            
        case startTimeCELL:
            
            let vc = TimeSelector(nibName: "TimeSelector",bundle: nil)
            vc.delegate = self
            if let t = event!.start_time {
                
                vc.time = t
                
            } else {
                
                vc.time = event!.start_date
                
            }
            
            navigationController?.pushViewController(vc, animated: true)
            
        case keyDISPLAY:
            
            let alert = UIAlertController(title: "Event Type", message: "Select an event type:", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            for key in keys {
                
                let action = UIAlertAction(title: key.display, style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    
                    self.keyTXT.text = key.display
                    
                    switch key {
                    case .Practice,.Fundraiser,.Other:
                        
                        self.opponentLBL.alpha = 0.3
                        self.opponentDISPLAY.userInteractionEnabled = false
                        self.opponentTXT.text = ""
                        
                    default:
                        
                        self.opponentLBL.alpha = 1
                        self.opponentDISPLAY.userInteractionEnabled = true
                        
                    }
                    
                    switch key {
                    case .Fundraiser,.Other:
                        self.label = "Event Title"
                        self.opponentLBL.text = self.label+":"
                    default:
                        self.label = "Opponent"
                        self.opponentLBL.text = self.label+":"
                    }
                    
                    self.event?.key = key
                    
                })
                
                alert.addAction(action)
                
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
                
                
                
            })
            
            alert.addAction(cancel)
            
            presentViewController(alert, animated: true, completion: nil)
            
        case teamDISPLAY:
            
            let vc = TeamsTable(nibName: "TeamsTable",bundle: nil)
            vc.delegate = self
            vc.shouldClose = true
            
            navigationController?.pushViewController(vc, animated: true)
            
        default:()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func dismissKeyboard(){
        
        tableView.endEditing(true)
        
    }
    
    func saveTPD(sender: UIBarButtonItem){
        
        var clean = true
        
        let e = event!
        
        if let key = e.key {
            
            switch key {
            case .Practice,.Fundraiser,.Other:
                
                ()
                
            default:
                
                if e.title == nil {
                    
                    clean = false
                    
                }
                
            }
            
        } else {
            
            clean = false
            
        }
        
        if e.team == nil { clean = false }
        
        if e.start_date == nil { clean = false }
        
        if clean {
            
            e.saveInBackgroundWithBlock { (success, error) -> Void in
                
                if success {
                    
                    if self.new_event {
                        
                        self.delegate?.newEvent(e)
                        
                    } else {
                        
                        self.delegate?.eventSaved(e)
                        
                    }
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                
                if let error = error { Alert.error(error) }
                
            }
            
        }
        
    }
    
}

extension EventEdit: TimeSelPTC,DateSelPTC,LocationSearchPTC,TeamsTablePTC {
    
    func teamSelected(team: Team?) {
        
        event?.team = team
        
        if let t = team { teamTXT.text = t.title }
        
    }
    
    func timeSelected(time: NSDate?) {
        
        if let T = time {
            
            event?.start_time = T
            
            startTimeTXT.text = z.stringFromDate(T)
            
        } else {
            
            startTimeTXT.text = "TBD"
            
        }
        
    }
    
    func dateSelected(date: NSDate) {
        
        event?.start_date = date
        
        startDateTXT.text = f.stringFromDate(date)
        
    }
    
    func locationSelected(item: MKMapItem) {
        
        event?.location = item.placemark.location
        event?.loc_name = item.name
        if let d = item.placemark.addressDictionary { event?.loc_address = ABCreateStringWithAddressDictionary(d, false) }
            
        locTXT.text = item.name
        
    }
    
}