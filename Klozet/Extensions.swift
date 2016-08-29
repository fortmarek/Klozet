//
//  Extensions.swift
//  Klozet
//
//  Created by Marek Fořt on 29/08/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation


extension NSDate {
    func getTodayWeekday() -> Int {
        guard let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) else {return 0}
        let today = NSDate()
        let todayWeekday = calendar.components(.Weekday, fromDate: today).weekday
        return todayWeekday
    }

}

extension String {
    func getHours() -> NSDate {
        //Converting hour string to NSDate
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        guard
            let toiletHours = formatter.dateFromString(self),
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        else {return NSDate()}
        
        //Getting today's date then just changing hours and minutes to toilet open times, useful for later comparing
        let today = NSDate()
        let components = calendar.components([.Year, .Month, .Day, .Hour, .Minute], fromDate: today)
        components.hour = calendar.components(.Hour, fromDate: toiletHours).hour
        components.minute = calendar.components(.Minute, fromDate: toiletHours).minute
        
        guard let date = calendar.dateFromComponents(components) else {return NSDate()}
        return date
    }
}