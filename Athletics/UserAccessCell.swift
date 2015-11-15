////
////  UserAccessCell.swift
////  Athletics
////
////  Created by grobinson on 11/5/15.
////  Copyright © 2015 Wambl. All rights reserved.
////
//
//import UIKit
//
//class UserAccessCell: UITableViewCell {
//    
//    var user: User!
//    var team: Team!
//    private var _team: Team!
//
//    @IBOutlet weak var ai: UIActivityIndicatorView!
//    @IBOutlet weak var nameTXT: UILabel!
//    @IBOutlet weak var contributorSW: UISwitch!
//    @IBOutlet weak var coachSW: UISwitch!
//    @IBOutlet weak var playerSW: UISwitch!
//    @IBOutlet weak var parentSW: UISwitch!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        
//        
//    }
//
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        
//        
//    }
//    
//    func setData(){
//        
//        _team = team
//        
//        contributorSW.on = team.contributors.contains(user.objectId!)
//        coachSW.on = team.coaches.contains(user.objectId!)
//        playerSW.on = team.players.contains(user.objectId!)
//        parentSW.on = team.parents.contains(user.objectId!)
//        
//    }
//    
//    @IBAction func swCHG(sender: UISwitch){
//        
//        if sender == contributorSW {
//            
//            if sender.on {
//                
//                team.contributors.append(user.objectId!)
//                
//            } else {
//                
//                team.contributors.removeString(user.objectId!)
//                
//            }
//            
//        }
//        
//        if sender == coachSW {
//            
//            if sender.on {
//                
//                team.coaches.append(user.objectId!)
//                team.players.removeString(user.objectId!)
//                team.parents.removeString(user.objectId!)
//                playerSW.setOn(false, animated: true)
//                parentSW.setOn(false, animated: true)
//                
//            } else {
//                
//                team.coaches.removeString(user.objectId!)
//                
//            }
//            
//        }
//        
//        if sender == playerSW {
//            
//            if sender.on {
//                
//                team.players.append(user.objectId!)
//                team.coaches.removeString(user.objectId!)
//                team.parents.removeString(user.objectId!)
//                coachSW.setOn(false, animated: true)
//                parentSW.setOn(false, animated: true)
//                
//            } else {
//                
//                team.players.removeString(user.objectId!)
//                
//            }
//            
//        }
//        
//        if sender == parentSW {
//            
//            if sender.on {
//                
//                team.parents.append(user.objectId!)
//                team.players.removeString(user.objectId!)
//                team.coaches.removeString(user.objectId!)
//                playerSW.setOn(false, animated: true)
//                coachSW.setOn(false, animated: true)
//                
//            } else {
//                
//                team.parents.removeString(user.objectId!)
//                
//            }
//            
//        }
//        
//        ai.startAnimating()
//        team.saveInBackgroundWithBlock { (success,error) -> Void in
//            
//            if success {
//                
//                self.ai.stopAnimating()
//            
//            } else {
//                
//                self.team = self._team
//                self.setData()
//            
//            }
//            
//            if let error = error { Alert.error(error) }
//            
//        }
//        
//    }
//    
//}
//
//extension Array {
//    
//    mutating func removeString(string: String){
//        
//        self = self.filter { item in
//            
//            let s = item as! String
//            
//            return s != string
//            
//        }
//        
//    }
//    
//}