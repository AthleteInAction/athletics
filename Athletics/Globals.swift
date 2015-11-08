//
//  Globals.swift
//  Athletics
//
//  Created by grobinson on 11/3/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import Foundation

typealias NSCompletion = (error: NSError?) -> Void

extension Int {
    
    func toString() -> String { return "\(self)" }
    
}

extension UIApplication {
    
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            
            return topViewController(nav.visibleViewController)
            
        }
        
        if let tab = base as? UITabBarController {
            
            if let selected = tab.selectedViewController {
                
                return topViewController(selected)
                
            }
            
        }
        
        if let presented = base?.presentedViewController {
            
            return topViewController(presented)
            
        }
        
        return base
        
    }
    
}


class Alert {
    
    static func show(title _title: String,message _message: String){
        
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        alert.addAction(ok)
        
        if let topController = UIApplication.topViewController() {
            
            topController.presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    
    static func error(error: NSError){
        
        let title = "Error (\(error.code.toString()))"
        
        let message = error.localizedDescription
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        alert.addAction(ok)
        
        if let topController = UIApplication.topViewController() {
            
            topController.presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    
}

class Confirm {
    
    static func show(title _title: String,message _message: String,confirm: Void -> Void){
        
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let ok = UIAlertAction(title: "Ok", style: .Default) { (action) -> Void in
            
            confirm()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        if let topController = UIApplication.topViewController() {
            
            topController.presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    
}


extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}