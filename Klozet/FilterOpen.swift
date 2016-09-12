//
//  Filter.swift
//  Klozet
//
//  Created by Marek Fořt on 09/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit


protocol FilterOpen {
    var annotationDelegate: AnnotationController? { get }
}

class FilterOpenButton: UIButton, FilterOpen, FilterButton {
    var annotationDelegate: AnnotationController?
    var filterDelegate: FilterController?
    var constraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTarget(self, action: #selector(filterOpenButtonTapped), forControlEvents: .TouchUpInside)
    }
    
    func setInterface() {
        
        //Images
        self.setImage(UIImage(named: "Clock"), forState: .Normal)
        self.setImage(UIImage(named: "ClockSelected"), forState: .Selected)
        
        //Unwarp filteDelegate
        guard let filterDelegate = self.filterDelegate else {return}
        
        let cornerConstant = filterDelegate.cornerConstant
        
        //Trailing layout
        let trailingLayout = filterDelegate.addConstraint(self, attribute: .Trailing, constant: -cornerConstant)
        constraint = trailingLayout
        
        //Bottom layout
        filterDelegate.addConstraint(self, attribute: .Bottom, constant: -cornerConstant)
        
        setBasicInterface()
    }
    
    func filterOpenButtonTapped(sender: FilterOpenButton) {
        filterOpenToilet()
    }
    
    func filterOpenToilet() {
        
        //After function ends, change button state
        defer {
            changeButtonState()
        }
        
        //Unwrap annotationDelegate
        guard var annotationDelegate = self.annotationDelegate else {return}
        
        // == false because state is changed after this function
        if self.selected == false {
            //Filter toilets to open ones only
            let toiletsNotOpen = annotationDelegate.toilets.filter({
                isToiletOpen($0) == false
            })
            
            //Saving closed toilets so they can be added later
            annotationDelegate.toiletsNotOpen = toiletsNotOpen
            
            annotationDelegate.mapView.removeAnnotations(toiletsNotOpen)
        }
            //Add back closed toilets (filter not applied)
        else {
            annotationDelegate.mapView.addAnnotations(annotationDelegate.toiletsNotOpen)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FilterOpen {
        
    func isToiletOpen(toilet: Toilet) -> Bool {
        let toiletTimes = toilet.openTimes
        
        //Int of today's weekday
        let todayWeekday = NSDate().getTodayWeekday()
        
        //Getting dictionary of toilet opening times
        for toiletTimeDict in toiletTimes {
            
            //If the toilet is open nonstop, I can right away return true
            if toiletTimeDict["nonstop"].bool == true {
                return true
            }
            
            //Getting array of ints of open weekdays
            guard
                let toiletDays = toiletTimeDict["days"].arrayObject as? Array<Int> where toiletDays.indexOf(todayWeekday) != nil,
                let hours = toiletTimeDict["hours"].arrayObject as? Array<String>
            else {continue}
            
            //If the toilet is open on today's weekday, check additionaly time
            if isOpenInHours(hours) {
                return true
            }
        }
        
        return false
    }
    
    
    func isOpenInHours(hours: Array<String>) -> Bool {
        //If the hours interval is not set, we assume the toilet is open
        guard hours.count == 2 else {return true}
        
        //Opening and closing hour
        let startHour = hours[0].getHours()
        let closeHour = hours[1].getHours()
        
        let today = NSDate()
        
        //Is the current time in the interval? If yes, then the toilet is open as of right now
        if today.compare(startHour) == .OrderedDescending && today.compare(closeHour) == .OrderedAscending {
            return true
        }
            
        else {
            return false
        }
    }
}