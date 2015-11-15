//
//  PlayerEdit.swift
//  Athletics
//
//  Created by grobinson on 11/8/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import UIKit

protocol PlayerEditPTC {
    
    func playerSaved(player: Player)
    func newPlayer(player: Player)
    
}

class PlayerEdit: UIViewController {

    var player: Player?
    var team: Team?
    var new_player = true
    var delegate: PlayerEditPTC?
    var ai: UIActivityIndicatorView!
    var at: UIView!
    
    @IBOutlet weak var nameTXT: UITextField!
    var save: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = UIRectEdge()
        
        navigationController?.navigationBar.translucent = false
        
        ai = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        ai.hidesWhenStopped = true
        
        if let player = player {
            
            nameTXT.text = player.name
            title = player.name
            new_player = false
            
        } else {
            
            player = Player()
            title = "New Player"
            
        }
        
        at = navigationItem.titleView
        
        if let team = team { player!.team = team }
        
        nameTXT.addTarget(self, action: Selector("txtCHG"), forControlEvents: .EditingChanged)
        save = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: Selector("saveTPD"))
        navigationItem.setRightBarButtonItem(save, animated: true)
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: Selector("cancelTPD"))
        navigationItem.setLeftBarButtonItem(cancel, animated: true)
        
        txtCHG()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        view.endEditing(true)
        
    }
    
    func cancelTPD(){ dismissViewControllerAnimated(true, completion: nil) }
    
    func txtCHG(){
        
        save.enabled = false
        
        if let text = nameTXT.text {
            
            if text != "" { save.enabled = true }
            
        }
        
    }
    
    func saveTPD(){
        
        save.enabled = false
        ai.startAnimating()
        navigationItem.titleView = ai
        
        player!.name = nameTXT.text!
        
        player!.saveInBackgroundWithBlock { (success,error) -> Void in
            
            self.save.enabled = true
            self.ai.stopAnimating()
            self.navigationItem.titleView = self.at
            
            if success {
                
                if self.new_player {
                    
                    self.delegate?.newPlayer(self.player!)
                    
                } else {
                    
                    self.delegate?.playerSaved(self.player!)
                    
                }
                
                self.cancelTPD()
                
            }
            
            if let error = error { Alert.error(error) }
            
        }
        
    }

}