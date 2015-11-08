//
//  TimeSelector.swift
//  Athletics
//
//  Created by grobinson on 11/2/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import UIKit

protocol TimeSelPTC {
    
    func timeSelected(time: NSDate?)
    
}

class TimeSelector: UIViewController {
    
    var delegate: TimeSelPTC!
    
    var time: NSDate!

    @IBOutlet weak var timeSEL: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeSEL.date = time
        timeSEL.datePickerMode = UIDatePickerMode.Time
        
        let done = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneTPD:")
        
        navigationItem.setRightBarButtonItem(done, animated: true)
        
        edgesForExtendedLayout = UIRectEdge()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    @IBAction func tbdTPD(sender: AnyObject) {
        
        delegate.timeSelected(nil)
        
        if let n = navigationController {
            
            n.popViewControllerAnimated(true)
            
        } else {
            
            dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }
    
    func doneTPD(sender: AnyObject){

        delegate.timeSelected(timeSEL.date)
        
        if let n = navigationController {
            
            n.popViewControllerAnimated(true)
            
        } else {
            
            dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }
    
}