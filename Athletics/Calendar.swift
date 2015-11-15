////
////  Calendar.swift
////  Athletics
////
////  Created by grobinson on 10/30/15.
////  Copyright (c) 2015 Wambl. All rights reserved.
////
//
//import UIKit
//import CVCalendar
//
//class Calendar: UIViewController {
//    
//    var date: NSDate?
//    
//    @IBOutlet weak var menu: CVCalendarMenuView!
//    @IBOutlet weak var calendar: CVCalendarView!
//    @IBOutlet weak var monthTXT: UILabel!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        if date == nil { date = NSDate() }
//        let f = NSDateFormatter()
//        f.dateFormat = "MMMM"
//        monthTXT.text = f.stringFromDate(date!)
//        
//        menu.delegate = self
//        calendar.delegate = self
//        
//        calendar.commitCalendarViewUpdate()
//        menu.commitMenuViewUpdate()
//        
////        title = calendar
//        
//        edgesForExtendedLayout = UIRectEdge()
//        
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        
//        
//        
//    }
//
//    @IBAction func scrollTPD(sender: UIButton) {
//        
//        if sender.tag == 0 {
//            
//            calendar.loadPreviousView()
//            
//        } else {
//            
//            calendar.loadNextView()
//            
//        }
//        
//    }
//    
//}
//
//extension Calendar: CVCalendarViewDelegate,CVCalendarMenuViewDelegate {
//    
//    /// Required method to implement!
//    func presentationMode() -> CalendarMode {
//        
//        return .MonthView
//        
//    }
//    
//    /// Required method to implement!
//    func firstWeekday() -> Weekday {
//        
//        return .Sunday
//        
//    }
//    
//    func didSelectDayView(dayView: DayView) {
//        
//        JP("\(dayView.date.month) - \(dayView.date.day) - \(dayView.date.year)")
//        
//    }
//    
//    func presentedDateUpdated(date: Date) {
//        
//        monthTXT.text = date.globalDescription
//        
//    }
//    
//}
//
func JP(a: AnyObject?){
    
    if let A = a {
        print(A)
    } else {
        print("nil")
    }

}