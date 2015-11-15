//
//  TeamsTable.swift
//  Athletics
//
//  Created by grobinson on 11/4/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import UIKit

protocol TeamsTablePTC {
    
    func teamSelected(team: Team?)
    
}

class TeamsTable: UIViewController {
    
    var type: String?
    var delegate: TeamsTablePTC?
    var teams: [Team] = []

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Teams"
        
        navigationController?.navigationBar.translucent = false
        
        table.delegate = self
        table.dataSource = self
        
        if let type = type {
            
            if type == "event_edit" {
                
                let cancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("cancelTPD"))
                navigationItem.setLeftBarButtonItem(cancel, animated: true)
                
            }
            
        }
        
        setData(true)
        
    }

    func cancelTPD(){ dismissViewControllerAnimated(true, completion: nil) }
    
    func addTPD(sender: UIBarButtonItem){
        
        let vc = TeamEdit(nibName: "TeamEdit",bundle:  nil)
        vc.delegate = self
        
        let nav = UINavigationController(rootViewController: vc)
        presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func setData(local: Bool){
        
        let query = Team.query()
        
        if local { query?.fromLocalDatastore() }
        
        if let t = type {
            
            switch t {
            case "admin":
                
                User.currentUser()!.getRoles { (error) -> Void in
                    
                    if error == nil {
                        
                        if User.currentUser()!.admin {
                            
                            let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addTPD:")
                            self.navigationItem.setRightBarButtonItem(add, animated: true)
                            
                        } else {
                            
                            self.navigationItem.setRightBarButtonItem(nil, animated: true)
                            
                        }
                        
                    }
                    
                }
                
                query?.whereKey("title", notEqualTo: "All")
                
            case "event_edit":
                
                query?.whereKey("title", notEqualTo: "All")
                if let user = User.currentUser() {
                    
                    if !user.admin {
                        
                        query?.whereKey("users", equalTo: User.currentUser()!)
                        
                    }
                    
                }
                
            default:
                
                query?.whereKey("title", notEqualTo: "All")
                
            }
            
        }
        
        query?.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            
            if let objects = objects {
                
                if local {
                    
                    self.setData(false)
                
                } else {
                    
                    Team.pinAllInBackground(objects)
                    
                }
                
                self.teams = objects as! [Team]
                self.teams.sortInPlace { $0.title < $1.title }
                self.table.reloadData()
                
            }
            
            if let error = error { Alert.error(error) }
            
        }
        
    }

}

extension TeamsTable: TeamEditPTC {
    
    func newTeam(team: Team) {
        
        teams.append(team)
        teams.sortInPlace { $0.title < $1.title }
        table.reloadData()
        
    }
    
    func teamSaved(team: Team) {
        
//        setData()
        
    }
    
}

extension TeamsTable: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return teams.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "")
        
        let team = teams[indexPath.row]
        
        cell.textLabel?.text = team.title
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let team = teams[indexPath.row]
        
        delegate?.teamSelected(team)
        
        if let t = type {
            
            switch t {
            case "event_edit":
                
                dismissViewControllerAnimated(true, completion: nil)
                
            case "schedules":
                
                let vc = Schedule(nibName: "Schedule",bundle: nil)
                vc.team = team
                
                navigationController?.pushViewController(vc, animated: true)
                
            case "rosters":
                
                let vc = Roster(nibName: "Roster",bundle: nil)
                vc.team = team
                
                navigationController?.pushViewController(vc, animated: true)
                
            case "admin":
                
                let vc = TeamEdit(nibName: "TeamEdit",bundle: nil)
                vc.delegate = self
                vc.team = team
                
                let nav = UINavigationController(rootViewController: vc)
                
                presentViewController(nav, animated: true, completion: nil)
                
            default:
                ()
            }
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
}