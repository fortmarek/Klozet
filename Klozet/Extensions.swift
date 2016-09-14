//
//  Extensions.swift
//  Klozet
//
//  Created by Marek Fořt on 29/08/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation


extension Date {
    func getTodayWeekday() -> Int {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let today = Date()
        guard let todayWeekday = (calendar as NSCalendar).components(.weekday, from: today).weekday else {return 0}
        return todayWeekday
    }

}

extension String {
    func getHours() -> Date {
        //Converting hour string to NSDate
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        guard let toiletHours = formatter.date(from: self) else {return Date()}
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        //Getting today's date then just changing hours and minutes to toilet open times, useful for later comparing
        let today = Date()
        var components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute], from: today)
        components.hour = (calendar as NSCalendar).components(.hour, from: toiletHours).hour
        components.minute = (calendar as NSCalendar).components(.minute, from: toiletHours).minute
        
        guard let date = calendar.date(from: components) else {return Date()}
        return date
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
