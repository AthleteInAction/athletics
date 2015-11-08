//
//  DateSelector.swift
//  Athletics
//
//  Created by grobinson on 11/2/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import UIKit

protocol DateSelPTC {
    
    func dateSelected(date: NSDate)
    
}

class DateSelector: UIViewController {
    
    var date: NSDate?
    var delegate: DateSelPTC!

    @IBOutlet weak var dateSEL: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select Date"
        
        dateSEL.datePickerMode = UIDatePickerMode.Date
        
        let done = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneTPD:")
        
        navigationItem.setRightBarButtonItem(done, animated: true)
        
        if date == nil { date = NSDate() }
        
        dateSEL.date = date!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func doneTPD(sender: AnyObject){
        
        delegate.dateSelected(dateSEL.date)
        
        if let n = navigationController {
            
            n.popViewControllerAnimated(true)
            
        } else {
            
            dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }

}