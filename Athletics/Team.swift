//
//  Team.swift
//  Athletics
//
//  Created by grobinson on 11/2/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import Foundation
import Parse

class Team : PFObject,PFSubclassing {
    
    enum Sport: String {
        
        case Basketball = "basketball"
        case Baseball = "baseball"
        case Football = "football"
        case Volleyball = "volleyball"
        case Soccer = "soccer"
        case All = "all"
        
        var display: String {
            
            switch self {
            case .Basketball: return "Basketball"
            case .Baseball: return "Baseball"
            case .Football: return "Football"
            case .Volleyball: return "Volleyball"
            case .Soccer: return "Soccer"
            default: return "All"
            }
            
        }
        
    }
    
    @NSManaged var title: String?
    @NSManaged private var sport_key: String?
    @NSManaged var users: PFRelation
    var sport: Sport? {
        
        get {
            
            if let s = sport_key {
                
                return Sport(rawValue: s)
                
            } else {
                
                return nil
                
            }
            
        }
        
        set {
            
            sport_key = newValue?.rawValue
            
        }
        
    }
    
    override class func initialize(){
        
        struct Static {
            
            static var onceToken : dispatch_once_t = 0
            
        }
        
        dispatch_once(&Static.onceToken){
            
            self.registerSubclass()
            
        }
        
    }
    
    static func parseClassName() -> String {
        
        return "Teams"
        
    }
    
}