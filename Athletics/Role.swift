//
//  Role.swift
//  Athletics
//
//  Created by grobinson on 11/4/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import Foundation
import Parse

class Role : PFRole {
    
    override class func initialize(){
        
        struct Static { static var onceToken : dispatch_once_t = 0 }
        
        dispatch_once(&Static.onceToken){ self.registerSubclass() }
        
    }
    
}