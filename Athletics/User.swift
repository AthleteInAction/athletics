//
//  User.swift
//  Athletics
//
//  Created by grobinson on 11/3/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import Foundation
import Parse

class User: PFUser {
    
    @NSManaged var name: String
    var admin: Bool = false
    var teams: [Team] = []
    
    override class func initialize(){
        
        struct Static {
            
            static var onceToken : dispatch_once_t = 0
            
        }
        
        dispatch_once(&Static.onceToken){
            
            self.registerSubclass()
            
        }
        
    }
    
    func getRoles(completion: NSCompletion?){
        
        let _completion = completion
        
        let query = Role.query()
        query?.whereKey("users", equalTo: self)
        query?.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            
            if let objects = objects as? [Role] {
                
                Role.pinAllInBackground(objects)
                
                self.admin = false
                
                for role in objects {
                    
                    if role.name == "admin" { self.admin = true }
                    
                }
                
            }
            
            _completion?(error: error)
            
        }
        
    }
    
    func getRolesLocal(completion: NSCompletion?){
        
        let _completion = completion
        
        let query = Role.query()
        query?.fromLocalDatastore()
        query?.whereKey("users", equalTo: self)
        query?.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            
            if let objects = objects as? [Role] {
                
                self.admin = false
                
                for role in objects {
                    
                    if role.name == "admin" { self.admin = true }
                    
                }
                
            }
            
            _completion?(error: error)
            
        }
        
    }
    
    func getTeams(completion: NSCompletion?){
        
        let _completion = completion
        
        let query = Team.query()
        query?.whereKey("users", equalTo: self)
        query?.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            
            if let objects = objects as? [Team] {
                
                Team.pinAllInBackground(objects)
                
                self.teams = objects
                
            }
            
            _completion?(error: error)
            
        }
        
    }
    
    func getTeamsLocal(completion: NSCompletion?){
        
        let _completion = completion
        
        let query = Team.query()
        query?.fromLocalDatastore()
        query?.whereKey("users", equalTo: self)
        query?.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            
            if let objects = objects as? [Team] {
                
                self.teams = objects
                
            }
            
            _completion?(error: error)
            
        }
        
    }
    
}