//
//  UserEdit.swift
//  Athletics
//
//  Created by grobinson on 11/3/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import UIKit
import Parse

protocol UserEditPTC {
    
    func userSaved(user: User)
    
}

class UserEdit: UIViewController {
    
    var delegate: UserEditPTC?
    
    var user: User?
    var new_user = true
    var userRoles: [PFRole] = []
    var notUserRoles: [PFRole] = []
    var ai: UIActivityIndicatorView!
    var titleView: UIView!
    
    var roles: [PFRole] = []
    
    @IBOutlet weak var nameTXT: UITextField!
    @IBOutlet weak var emailTXT: UITextField!
    @IBOutlet weak var passwordTXT: UITextField!
    @IBOutlet weak var passwordConfirmTXT: UITextField!
    
    var cancel: UIBarButtonItem!
    var save: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        
        nameTXT.addTarget(self, action: Selector("setSave"), forControlEvents: .EditingChanged)
        emailTXT.addTarget(self, action: Selector("setSave"), forControlEvents: .EditingChanged)
        passwordTXT.addTarget(self, action: Selector("setSave"), forControlEvents: .EditingChanged)
        passwordConfirmTXT.addTarget(self, action: Selector("setSave"), forControlEvents: .EditingChanged)
        
        cancel = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "cancelTPD:")
        navigationItem.setLeftBarButtonItem(cancel, animated: true)
        save = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveTPD:")
        navigationItem.setRightBarButtonItem(save, animated: true)
        
        setViewDidLoad()
        
        navigationController?.navigationBar.translucent = false
        
        edgesForExtendedLayout = UIRectEdge()
        
    }
    
    func setViewDidLoad(){
        
        user = User.currentUser()
        
        new_user = user == nil
        
        if user == nil {
            
            title = "Signup"
            titleView = navigationItem.titleView
            
            user = User()
            
        } else {
            
            title = user!.name
            titleView = navigationItem.titleView
            
            nameTXT.text = user!.name
            emailTXT.text = user!.email
            
        }
        
        setSave()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func cancelTPD(sender: UIBarButtonItem){
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        view.endEditing(true)
        
    }
    
    func setSave(){
        
        var clean = true
        
        if nameTXT.text == "" { clean = false }
        if emailTXT.text == "" { clean = false }
        if new_user {
            
            if passwordTXT.text == "" { clean = false }
            if passwordConfirmTXT.text == "" { clean = false }
            if passwordTXT.text != passwordConfirmTXT.text { clean = false }
            
        } else {
            
            if passwordTXT.text != "" || passwordConfirmTXT.text != "" {
                
                if passwordTXT.text == "" { clean = false }
                if passwordConfirmTXT.text == "" { clean = false }
                if passwordTXT.text != passwordConfirmTXT.text { clean = false }
                
            }
            
        }
        
        save.enabled = clean
        
    }
    
    func saveTPD(sender: UIBarButtonItem){
        
        self.navigationItem.titleView = self.ai
        ai.startAnimating()
        
        user?.name = nameTXT.text!
        user?.username = emailTXT.text
        user?.email = emailTXT.text
        if passwordTXT.text != "" || new_user { user?.password = passwordTXT.text }
        
        if new_user {
            
            user!.signUpInBackgroundWithBlock({ (success, error) -> Void in
                
                if success {
                    
                    self.delegate?.userSaved(self.user!)
                    self.navigationItem.titleView = self.titleView
                    self.setViewDidLoad()
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                } else {
                    
                    self.navigationItem.titleView = self.titleView
                    
                }
                
            })
            
        } else {
            
            user!.saveInBackgroundWithBlock { (success, error) -> Void in
                
                if success {
                    
                    self.delegate?.userSaved(self.user!)
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                
                self.navigationItem.titleView = self.titleView
                
            }
            
        }
        
    }

}