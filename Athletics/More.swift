//
//  More.swift
//  Athletics
//
//  Created by grobinson on 11/7/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import UIKit

class More: UITableViewController,LoginPTC,UserEditPTC {
    
    var sections: [Section] = []
    
    class Section {
        
        class Cell {
            
            var label: String!
            
            init(label _label: String){
                
                label = _label
                
            }
            
        }
        
        var cells: [Cell] = []
        var title: String!
        
        init(title _title: String){
            
            title = _title
            
        }
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "More"
        
        setCells()
        
    }
    
    func setCells(){
        
        var tmp: [Section] = []
        
        let top = Section(title: "")
        top.cells.append(Section.Cell(label: "Schedules"))
        top.cells.append(Section.Cell(label: "Rosters"))
        tmp.append(top)
        
        let account = Section(title: "Account")
        
        if let user = User.currentUser() {
            
            account.cells.append(Section.Cell(label: user.name))
            account.cells.append(Section.Cell(label: "Logout"))
            
        } else {
            
            account.cells.append(Section.Cell(label: "Signup"))
            account.cells.append(Section.Cell(label: "Login"))
            
        }
        
        tmp.append(account)
        
        if let user = User.currentUser() {
            
            if user.admin {
                
                let admin = Section(title: "Admin")
                admin.cells.append(Section.Cell(label: "Users"))
                admin.cells.append(Section.Cell(label: "Teams"))
                
                tmp.append(admin)
                
            }
            
        }
        
        sections = tmp
        
        tableView.reloadData()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return sections.count
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].cells.count
        
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let section = sections[section]
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        view.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        
        let label = UILabel(frame: CGRect(x: 16, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height))
        label.text = section.title
        label.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        label.font = UIFont.systemFontOfSize(13)
        
        view.addSubview(label)
        
        return view
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let section = sections[section]
        
        if section.title == "" {
            
            return 0
            
        } else {
            
            return 30
            
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "_")
        
        cell.textLabel?.text = sections[indexPath.section].cells[indexPath.row].label
        cell.textLabel?.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let item = sections[indexPath.section].cells[indexPath.row]
        
        // SIGNUP or MY ACCOUNT
        if item.label.lowercaseString == "signup" || item.label.lowercaseString == User.currentUser()?.name.lowercaseString {
            
            let vc = UserEdit(nibName: "UserEdit",bundle: nil)
            vc.delegate = self
            
            let nav = UINavigationController(rootViewController: vc)
            
            presentViewController(nav, animated: true, completion: nil)
            
        }
        
        // SCHEDULES
        if item.label.lowercaseString == "schedules" {
            
            let vc = TeamsTable(nibName: "TeamsTable",bundle: nil)
            vc.type = "schedules"
            
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
        // LOGIN
        if item.label.lowercaseString == "login" {
            
            let vc = LoginView(nibName: "LoginView",bundle: nil)
            vc.delegate = self
            
            let nav = UINavigationController(rootViewController: vc)
            
            presentViewController(nav, animated: true, completion: nil)
            
        }
        
        // LOGOUT
        if item.label.lowercaseString == "logout" {
            
            User.logOutInBackgroundWithBlock { (error) -> Void in
                
                if let error = error {
                    
                    Alert.error(error)
                    
                } else {
                    
                    self.setCells()
                    
                }
                
            }
            
        }
        
        // USERS
        if item.label.lowercaseString == "users" {
            
            let vc = UsersTable(nibName: "UsersTable",bundle: nil)
            
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
        // TEAMS
        if item.label.lowercaseString == "teams" {
            
            let vc = TeamsTable(nibName: "TeamsTable",bundle: nil)
            vc.type = "admin"
            
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func loginSuccessfull() {
        
        setCells()
        
        User.currentUser()?.getRoles { (error) -> Void in
            
            if error == nil {
                
                self.setCells()
                
            }
            
        }
    
    }
    
    func userSaved(user: User) {
        
        setCells()
        
        User.currentUser()?.getRoles { (error) -> Void in
            
            if error == nil {
                
                self.setCells()
                
            }
            
        }
        
    }
    
}