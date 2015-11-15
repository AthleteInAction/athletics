//
//  UserRoles.swift
//  Athletics
//
//  Created by grobinson on 11/3/15.
//  Copyright © 2015 Wambl. All rights reserved.
//
import UIKit
import Parse

class UserAccess: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var user: User!
    
    private var teams: [Team] = []
    private var userTeams: [Team] = []
    private var notUserTeams: [Team] = []
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var admin: UIView!
    @IBOutlet weak var adminSW: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        adminSW.on = user.admin
        admin.hidden = !User.currentUser()!.admin
        
        title = "\(user.name) Access"
        
        let close = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: Selector("closeTPD"))
        navigationItem.setLeftBarButtonItem(close, animated: true)
        
        navigationController?.navigationBar.translucent = false
        
        edgesForExtendedLayout = UIRectEdge()
        
        setData()
        
    }
    
    func closeTPD(){ dismissViewControllerAnimated(true, completion: nil) }
    
    func setData(){
        
        let query = Team.query()
        query?.whereKey("users", equalTo: user)
        query?.whereKey("title", notEqualTo: "All")
        query?.findObjectsInBackgroundWithBlock({ (objects,error) -> Void in
            
            if error == nil {
                
                if let objects = objects as? [Team] {
                    
                    self.userTeams = objects
                    self.setSecond()
                    
                }
                
            }
            
        })
        
    }
    
    func setSecond(){
        
        let query = Team.query()
        query?.whereKey("users", notEqualTo: user)
        query?.whereKey("title", notEqualTo: "All")
        query?.findObjectsInBackgroundWithBlock({ (objects,error) -> Void in
            
            if error == nil {
                
                if let objects = objects as? [Team] {
                    
                    self.notUserTeams = objects
                    self.teams = self.userTeams+self.notUserTeams
                    self.teams.sortInPlace { $0.title < $1.title }
                    self.table.reloadData()
                    
                }
                
            }
            
        })
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return teams.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "_")
        
        let team = teams[indexPath.row]
        
        cell.textLabel?.text = team.title
        
        if userTeams.contains(team) {
            
            cell.accessoryType = .Checkmark
            
        } else {
            
            cell.accessoryType = . None
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        
        let team = teams[indexPath.row]
        
        if cell.accessoryType == .Checkmark {
            
            team.users.removeObject(user)
            team.saveInBackgroundWithBlock { (success,error) -> Void in
                
                if success {
                    
                    cell.accessoryType = .None
                    
                }
                
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                
            }
            
        } else {
            
            team.users.addObject(user)
            team.saveInBackgroundWithBlock { (success,error) -> Void in
                
                if success {
                    
                    cell.accessoryType = .Checkmark
                    
                }
                
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                
            }
            
        }
        
    }
    
    @IBAction func adminCHG(sender: UISwitch){
        
        changeAdmin()
        
    }
    
    func changeAdmin() -> Bool {
        
        if user.objectId == User.currentUser()?.objectId {
            
            if !adminSW.on {
                
                Alert.show(title: "Message:", message: "Someone else must remove your admin access.")
                
                self.adminSW.setOn(true, animated: true)
                
                return false
                
            }
            
        }
        
        if adminSW.on {
            
            let query = Role.query()
            query?.whereKey("name", equalTo: "admin")
            query?.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
                
                if let objects = objects {
                    
                    if let role = objects.first as? Role {
                        
                        role.users.addObject(self.user)
                        role.saveInBackgroundWithBlock { (success,error) -> Void in
                            
                            if success {
                                
                                self.user.admin = true
                                
                            } else {
                                
                                self.adminSW.setOn(false, animated: true)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        } else {
            
            let query = Role.query()
            query?.whereKey("name", equalTo: "admin")
            query?.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
                
                if let objects = objects {
                    
                    if let role = objects.first as? Role {
                        
                        role.users.removeObject(self.user)
                        role.saveInBackgroundWithBlock { (success,error) -> Void in
                            
                            if success {
                                
                                self.user.admin = false
                                
                            } else {
                                
                                self.adminSW.setOn(true, animated: true)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        return true
        
    }
    
}