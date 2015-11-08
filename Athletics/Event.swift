//
//  Event.swift
//  Athletics
//
//  Created by grobinson on 10/29/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import Foundation
import CoreLocation
import Parse

class Event : PFObject,PFSubclassing {
    
    enum Key: String {
        
        case Practice = "practice"
        case GameLeague = "game_league"
        case GameNonLeague = "game_non_league"
        case GamePreseason = "game_preseason"
        case Scrimmage = "scrimmage"
        case Fundraiser = "fundraiser"
        case Other = "other"
        
        var display: String {
            
            switch self {
            case .Practice: return "Practice"
            case .GameLeague: return "League Game"
            case .GameNonLeague: return "Non-League Game"
            case .GamePreseason: return "Preseason Game"
            case .Scrimmage: return "Scrimmage"
            case .Fundraiser: return "Fundraiser"
            default: return "Other"
            }
            
        }
        
    }
    
    @NSManaged var team: Team?
    @NSManaged private var keyRaw: String?
    var key: Key? {
        
        get {
            
            if let k = keyRaw {
                
                return Key(rawValue: k)
                
            } else {
                
                return nil
                
            }
            
        }
        
        set { keyRaw = newValue?.rawValue }
        
    }
    @NSManaged var start_date: NSDate?
    @NSManaged var start_time: NSDate?
    @NSManaged var title: String?
    @NSManaged private var locationRaw: PFGeoPoint?
    var location: CLLocation? {
        
        get {
            
            if let loc = locationRaw {
                
                return CLLocation(latitude: loc.latitude, longitude: loc.longitude)
                
            } else {
                
                return nil
                
            }
            
        }
        
        set {
            
            if let n = newValue {
                
                locationRaw = PFGeoPoint(location: n)
                
            } else {
                
                locationRaw = nil
                
            }
            
        }
        
    }
    @NSManaged var loc_name: String?
    @NSManaged var loc_address: String?
    
    override class func initialize(){
        
        struct Static {
            
            static var onceToken : dispatch_once_t = 0
            
        }
        
        dispatch_once(&Static.onceToken){
            
            self.registerSubclass()
            
        }
        
    }
    
    static func parseClassName() -> String {
        
        return "Schedule"
        
    }
    
}