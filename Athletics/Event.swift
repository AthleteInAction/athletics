//
//  Event.swift
//  Athletics
//
//  Created by grobinson on 10/29/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import Foundation

class Event {
    
    var key: Key!
    var start_date: NSDate!
    var end_date: NSDate?
    var title: String!
    var details: String?
    
    init(key _key: Key,title _title: String,start_date _start_date: NSDate){
        
        key = _key
        title = _title
        start_date = _start_date
        
    }
    
    init(key _key: Key,title _title: String,details _details: String,start_date _start_date: NSDate){
        
        key = _key
        title = _title
        details = _details
        start_date = _start_date
        
    }
    
    init(key _key: Key,title _title: String,details _details: String,start_date _start_date: NSDate,end_date _end_date: NSDate){
        
        key = _key
        title = _title
        details = _details
        start_date = _start_date
        end_date = _end_date
        
    }
    
}