//
//  EventEdit.swift
//  Athletics
//
//  Created by grobinson on 10/30/15.
//  Copyright (c) 2015 Wambl. All rights reserved.
//

import UIKit

class EventEdit: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    var keys: [Event.Key] = [.Practice,.GameLeague,.GameNonLeague,.GamePreseason,.Scrimmage,.Fundraiser,.Other]
    
    @IBOutlet weak var keySEL: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keySEL.delegate = self
        keySEL.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return keys.count
        
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        let key = keys[row]
        
        return key.display
        
    }
    
}