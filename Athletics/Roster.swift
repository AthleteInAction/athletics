//
//  Roster.swift
//  Athletics
//
//  Created by grobinson on 11/8/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import UIKit

class Roster: UITableViewController {
    
    var team: Team!
    private var players: [Player] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = UIRectEdge()
        
        navigationController?.navigationBar.translucent = false
        
        setData(true)
        
    }
    
    func setData(local: Bool){
        
        let query = Player.query()
        if local { query?.fromLocalDatastore() }
        query?.whereKey("team", equalTo: team)
        query?.findObjectsInBackgroundWithBlock { (objects,error) -> Void in
            
            if let objects = objects as? [Player] {
                
                if local {
                    
                    self.setData(false)
                    
                } else {
                    
                    Player.pinAllInBackground(objects)
                    
                }
                
                self.players = objects
                self.players.sortInPlace { $0.name < $1.name }
                self.tableView.reloadData()
                
            }
            
        }
        
        navigationItem.setRightBarButtonItem(nil, animated: true)
        
        if let user = User.currentUser() {
            
            user.getRoles { (error) -> Void in
                
                if error == nil {
                    
                    if user.admin {
                        
                        let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addTPD"))
                        self.navigationItem.setRightBarButtonItem(add, animated: true)
                        
                    }
                    
                }
                
                user.getTeams { (error) -> Void in
                    
                    if error == nil {
                        
                        if user.teams.contains(self.team) {
                            
                            let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("addTPD"))
                            self.navigationItem.setRightBarButtonItem(add, animated: true)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return players.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "")
        
        let player = players[indexPath.row]
        
        cell.textLabel?.text = player.name
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func addTPD(){
        
        let vc = PlayerEdit(nibName: "PlayerEdit",bundle: nil)
        vc.team = team
        vc.delegate = self
        
        let nav = UINavigationController(rootViewController: vc)
        
        presentViewController(nav, animated: true, completion: nil)
        
    }
    
}

extension Roster: PlayerEditPTC {
    
    func playerSaved(player: Player) {
        
        tableView.reloadData()
        
    }
    
    func newPlayer(player: Player) {
        
        players.append(player)
        players.sortInPlace { $0.name < $1.name }
        tableView.reloadData()
        
    }
    
}