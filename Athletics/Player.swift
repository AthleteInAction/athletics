//
//  Player.swift
//  Athletics
//
//  Created by grobinson on 11/8/15.
//  Copyright © 2015 Wambl. All rights reserved.
//
import Foundation
import Parse

class Player: PFObject,PFSubclassing {
    
    @NSManaged var name: String
    @NSManaged var team: Team
    
}

extension Player {
    
    override class func initialize(){
        
        struct Static { static var onceToken : dispatch_once_t = 0 }
        
        dispatch_once(&Static.onceToken){ self.registerSubclass() }
        
    }
    
    static func parseClassName() -> String { return "Players" }
    
}