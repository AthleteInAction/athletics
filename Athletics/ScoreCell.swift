//
//  ScoreCell.swift
//  Athletics
//
//  Created by grobinson on 11/10/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import UIKit

class ScoreCell: UITableViewCell {

    @IBOutlet weak var leftTEAM: UILabel!
    @IBOutlet weak var leftSCORE: UILabel!
    @IBOutlet weak var rightTEAM: UILabel!
    @IBOutlet weak var rightSCORE: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        

    }
    
}

class CellObject {
    
    static func empty() -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "")
        cell.textLabel?.text = "No Games Scheduled"
        cell.textLabel?.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        cell.selectionStyle = .None
        return cell
        
    }
    
    static func score(tableView tableView: UITableView,event: Event) -> ScoreCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("score") as! ScoreCell
        
        let score = event.score!
        
        if event.home! == .Away {
            
            cell.leftTEAM.text = "Willow Glen High School"
            cell.leftSCORE.text = score[1].toString()
            cell.rightTEAM.text = event.title!
            cell.rightSCORE.text = score[0].toString()
            
        } else {
            
            cell.rightTEAM.text = "Willow Glen High School"
            cell.rightSCORE.text = score[1].toString()
            cell.leftTEAM.text = event.title!
            cell.leftSCORE.text = score[0].toString()
            
        }
        
        cell.selectionStyle = .None
        
        return cell
        
    }
    
    static func schedule(tableView tableView: UITableView,event: Event) -> ScheduleGameCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("game") as! ScheduleGameCell
        
        if let opponent = event.title {
            
            var txt = ""
            
            if event.home == .Away {
                
                txt += "@ "
                
            }
            
            txt += opponent
            
            if event.key! == .Scrimmage {
                
                txt += " (Scrimmage)"
                
            }
            
            cell.opponent.text = txt
            
        } else {
            
            cell.opponent.text = "TBD"
            
        }
        let f = NSDateFormatter()
        f.dateFormat = "h:mm a"
        if let start_time = event.start_time {
            
            cell.time.text = f.stringFromDate(start_time)
            
        } else {
            
            cell.time.text = "TBD"
            
        }
        if let location = event.loc_name {
            
            cell.location.text = location
            
        } else {
            
            cell.location.text = "TBD"
            
        }
        
        var select = false
        
        if let user  = User.currentUser() {
            
            if user.admin {
                
                select = true
                
            }
            
        }
        
        if !select { cell.selectionStyle = .None }
        
        return cell
        
    }
    
    static func dailey(tableView tableView: UITableView,event: Event) -> GameEventCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("game") as! GameEventCell
        
        cell.team.text = event.team!.title
        if let opponent = event.title {
            
            var txt = ""
            
            if event.home == .Away {
                
                txt += "@ "
                
            } else {
                
                txt += "vs "
                
            }
            
            txt += opponent
            
            if event.key! == .Scrimmage {
                
                txt += " (Scrimmage)"
                
            }
            
            cell.opponent.text = txt
            
        } else {
            
            cell.opponent.text = "TBD"
            
        }
        let f = NSDateFormatter()
        f.dateFormat = "h:mm a"
        if let start_time = event.start_time {
            
            cell.time.text = f.stringFromDate(start_time)
            
        } else {
            
            cell.time.text = "TBD"
            
        }
        if let location = event.loc_name {
            
            cell.location.text = location
            
        } else {
            
            cell.location.text = "TBD"
            
        }
        
        return cell
        
    }
    
}