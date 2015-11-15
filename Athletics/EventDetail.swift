//
//  EventDetail.swift
//  Athletics
//
//  Created by grobinson on 11/9/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import UIKit
import MapKit

class EventDetail: UIViewController,EventEditPTC {
    
    var event: Event!

    @IBOutlet weak var titleTXT: UILabel!
    @IBOutlet weak var subtitleTXT: UILabel!
    @IBOutlet weak var timeTXT: UILabel!
    @IBOutlet weak var locationTXT: UILabel!
    @IBOutlet weak var directionsBTN: UIButton!
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        directionsBTN.contentHorizontalAlignment = .Left
        setData()
        
    }
    
    func editTPD(){
        
        let vc = MS.instantiateViewControllerWithIdentifier("event_edit") as! EventEdit
        vc.event = event
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func eventSaved(event: Event) {
        
        self.event = event
        setData()
        
    }
    func newEvent(event: Event) {
        
        
        
    }
    @IBAction func openMap(sender: AnyObject) {
        
        if let location = event.location {
            
            let regionDistance: CLLocationDistance = 10000
            let regionSpan = MKCoordinateRegionMakeWithDistance(location.coordinate, regionDistance, regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            if let name = event.loc_name { mapItem.name = name }
            mapItem.openInMapsWithLaunchOptions(options)
            
        }
        
    }
    
    func setData(){
        
        self.navigationItem.setRightBarButtonItem(nil, animated: true)
        
        if let user = User.currentUser() {
            
            event.team!.checkUser(user: user, completion: { (admit) -> Void in
                
                if admit {
                    
                    let edit = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("editTPD"))
                    self.navigationItem.setRightBarButtonItem(edit, animated: true)
                    
                }
                
            })
            
            user.getRoles({ (error) -> Void in
                
                if user.admin {
                    
                    let edit = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: Selector("editTPD"))
                    self.navigationItem.setRightBarButtonItem(edit, animated: true)
                    
                }
                
            })
            
        }
        
        titleTXT.text = event.team!.title
        var txt = "vs "
        if event.home == .Away {
            
            txt = "@ "
            
        }
        txt += event.title!
        if let time = event.start_time {
            
            let f = NSDateFormatter()
            f.dateFormat = "h:mm a"
            timeTXT.text = f.stringFromDate(time)
            
        } else {
            
            timeTXT.text = "TBD"
            
        }
        
        if let name = event.loc_name {
            
            locationTXT.text = name
            
        } else {
            
            locationTXT.text = "TBD"
            
        }
        
        if let address = event.loc_address {
            
            directionsBTN.setTitle(address, forState: .Normal)
            directionsBTN.hidden = false
            
        } else {
            
            directionsBTN.hidden = true
            
        }
        
        if let location = event.location {
            
            let span = MKCoordinateSpanMake(0.05,0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            
            map.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            if let name = event.loc_name { annotation.title = name }
            
            map.addAnnotation(annotation)
            
            map.hidden = false
            
        } else {
            
            map.hidden = true
            
        }
        
    }

}