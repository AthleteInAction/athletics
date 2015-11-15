//
//  LoginView.swift
//  Athletics
//
//  Created by grobinson on 11/3/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import UIKit
import Parse

protocol LoginPTC {
    
    func loginSuccessfull()
    
}

class LoginView: UIViewController {
    
    var delegate: LoginPTC?

    @IBOutlet weak var emailTXT: UITextField!
    @IBOutlet weak var passwordTXT: UITextField!
    @IBOutlet weak var ai: UIActivityIndicatorView!
    @IBOutlet weak var submitBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login"
        
        submitBTN.layer.cornerRadius = 4
        
        emailTXT.addTarget(self, action: Selector("txtCHG"), forControlEvents: .EditingChanged)
        passwordTXT.addTarget(self, action: Selector("txtCHG"), forControlEvents: .EditingChanged)
        
        let close = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: Selector("closeTPD"))
        
        navigationItem.setLeftBarButtonItem(close, animated: true)
        
        txtCHG()
        
        navigationController?.navigationBar.translucent = false
        
        edgesForExtendedLayout = UIRectEdge()
        
    }
    
    func closeTPD(){
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func txtCHG(){
        
        if emailTXT.text == "" || passwordTXT.text == "" {
            
            submitBTN.alpha = 0.3
            submitBTN.userInteractionEnabled = false
            
        } else {
            
            submitBTN.alpha = 1
            submitBTN.userInteractionEnabled = true
            
        }
        
    }

    @IBAction func submitTPD(sender: AnyObject){
        
        submitBTN.hidden = true
        ai.startAnimating()
        
        User.logInWithUsernameInBackground(emailTXT.text!, password: passwordTXT.text!) { (user,error) -> Void in
            
            if error == nil {
                
                User.currentUser()!.getRoles(nil)
                
                self.delegate?.loginSuccessfull()
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            } else {
                
                Alert.error(error!)
                
            }
            
            self.submitBTN.hidden = false
            self.ai.stopAnimating()
            
        }
        
    }
    
}