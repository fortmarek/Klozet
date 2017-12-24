//
//  Filter.swift
//  Klozet
//
//  Created by Marek Fořt on 09/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


protocol FilterOpen {
    
}

class FilterOpenButton: UIButton, FilterOpen, FilterOptionButton {
    
    var annotationDelegate: AnnotationController?
    var filterDelegate: FilterInterfaceDelegate?
    var filterButtonDelegate: FilterButtonDelegate?
    var constraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTarget(self, action: #selector(filterOpenButtonTapped), for: .touchUpInside)
    }
    
    func setInterface() {
        
        //Images
        self.setImage(UIImage(named: "Clock"), for: UIControlState())
        self.setImage(UIImage(named: "ClockSelected"), for: .selected)
        
        //Unwarp filteDelegate
        guard let filterDelegate = self.filterDelegate else {return}
        
        let cornerConstant = filterDelegate.cornerConstant
        
        //Trailing layout
        let trailingLayout = filterDelegate.addConstraint(self, attribute: .trailing, constant: -cornerConstant)
        constraint = trailingLayout
        
        //Bottom layout
        _ = filterDelegate.addConstraint(self, attribute: .bottom, constant: -cornerConstant)
        
        setBasicInterface()
    }
    
    @objc func filterOpenButtonTapped(_ sender: FilterOpenButton) {
        filterOpenToilet()
    }
    
    func filterOpenToilet() {
        
        OperationQueue.main.addOperation({
            //Change timeButton image
            self.isSelected = !(self.isSelected)
            
            
            //Unwrap annotationDelegate
            guard var annotationDelegate = self.annotationDelegate else {return}
            
            
            // == false because state is changed after this function
            if self.isSelected  {
                //Filter toilets to open ones only
                let toiletsNotOpen = annotationDelegate.toilets.filter({
                    self.isToiletOpen($0) == false
                })
                
                //Saving closed toilets so they can be added later
                annotationDelegate.toiletsNotOpen = toiletsNotOpen
                
                annotationDelegate.mapView.removeAnnotations(toiletsNotOpen)
            }
                //Add back closed toilets (filter not applied)
            else {
                annotationDelegate.mapView.addAnnotations(annotationDelegate.toiletsNotOpen)
            }
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FilterOpen {
        
    func isToiletOpen(_ toilet: Toilet) -> Bool {
        let toiletTimes = toilet.openTimes
        
        
        //Getting dictionary of toilet opening times
        for openTimes in toiletTimes {

            //If isToiletOpen, iteration could end, otherwise continue
            let isToiletOpen = determineIfIsToiletOpen(during: openTimes)
            
            if isToiletOpen {
                return true
            }
            
            else {
                continue
            }
        }
        
        //No dict return isToiletOpen as true => toilet is closed
        return false
    }
    
    func determineIfIsToiletOpen(during openTimes: OpenTimes) -> Bool {
        //Int of today's weekday
        let todayWeekday = Date().getTodayWeekday()
        
        //If the toilet is open nonstop, I can right away return true
        if openTimes.isNonstop ?? false {
            return true
        }
        
        
        //Getting array of ints of open weekdays
        guard
            let toiletDays = openTimes.days, toiletDays.index(of: todayWeekday) != nil,
            let hours = openTimes.hours
            else {return false}
        
        //If the toilet is open on today's weekday, check additionaly time
        if isOpenInHours(hours) {
            return true
        }
        
        return false
    }
    
    
    func isOpenInHours(_ hours: Array<String>) -> Bool {
        //If the hours interval is not set, we assume the toilet is open
        guard hours.count == 2 else {return true}
        
        //Opening and closing hour
        let startHour = hours[0].getHours()
        let closeHour = hours[1].getHours()
        
        let today = Date()
        
        //Is the current time in the interval? If yes, then the toilet is open as of right now
        if today.compare(startHour as Date) == .orderedDescending && today.compare(closeHour as Date) == .orderedAscending {
            return true
        }
            
        else {
            return false
        }
    }
}
