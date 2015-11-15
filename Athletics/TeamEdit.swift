//
//  TeamEdit.swift
//  Athletics
//
//  Created by grobinson on 11/4/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import UIKit

protocol TeamEditPTC {
    
    func teamSaved(team: Team)
    func newTeam(team: Team)
    
}

class TeamEdit: UIViewController {
    
    var delegate: TeamEditPTC?

    var team: Team?
    var new_team = true
    
    var sports: [Team.Sport] = [.Basketball,.Baseball,.Football,.Volleyball,.Soccer]
    
    var save: UIBarButtonItem!
    
    @IBOutlet weak var nameTXT: UITextField!
    @IBOutlet weak var sportSEL: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = UIRectEdge()
        
        navigationController?.navigationBar.translucent = false
        
        sportSEL.delegate = self
        sportSEL.dataSource = self
        
        if team == nil {
            
            title = "New Team"
            team = Team()
            
        } else {
            
            title = team!.title
            new_team = false
            
        }
        
        nameTXT.text = team!.title
        
        save = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveTPD:")
        
        let close = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: Selector("closeTPD"))
        navigationItem.setLeftBarButtonItem(close, animated: true)
        navigationItem.setRightBarButtonItem(save, animated: true)
        
        nameTXT.addTarget(self, action: Selector("validate"), forControlEvents: .EditingChanged)
        
        validate()
        
    }
    
    func closeTPD(){
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func validate(){
        
        save.enabled = nameTXT.text != ""
        
    }

    func saveTPD(sender: UIBarButtonItem){
        
        team!.title = nameTXT.text
        team?.saveInBackgroundWithBlock { (success,error) -> Void in
            
            if success {
                
                if self.new_team {
                    
                    self.delegate?.newTeam(self.team!)
                    
                } else {
                    
                    self.delegate?.teamSaved(self.team!)
                    
                }
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }
            
            if let error = error { Alert.error(error) }
            
        }
        
    }

}

extension TeamEdit: UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return sports.count
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let sport = sports[row]
        
        return sport.display
        
    }
    
}