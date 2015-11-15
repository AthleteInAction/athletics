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
        
        title = "Select Time"
        
        navigationController?.navigationBar.translucent = false
        
        timeSEL.date = time
        timeSEL.datePickerMode = UIDatePickerMode.Time
        
        let done = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneTPD:")
        navigationItem.setRightBarButtonItem(done, animated: true)
        
        let cancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("cancelTPD"))
        navigationItem.setLeftBarButtonItem(cancel, animated: true)
        
        edgesForExtendedLayout = UIRectEdge()
        
    }

    func cancelTPD(){ dismissViewControllerAnimated(true, completion: nil) }

    @IBAction func tbdTPD(sender: AnyObject) {
        
        delegate.timeSelected(nil)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func doneTPD(sender: AnyObject){

        delegate.timeSelected(timeSEL.date)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}