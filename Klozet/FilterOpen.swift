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

class FilterOpenButton: ButtonColorChangeable, FilterOpen {
    
    var toiletController: ToiletController?


    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        addTarget(self, action: #selector(filterOpenButtonTapped), for: .touchUpInside)
        setButton(with: title, normalColor: .mainOrange, selectedColor: .white)
    }
    
    @objc func filterOpenButtonTapped(_ sender: FilterOpenButton) {
        DispatchQueue.main.async { [weak self] in
            self?.filterOpenToilet()
        }
    }
    
    func filterOpenToilet() {
        
        //Unwrap annotationDelegate
        guard var toiletController = self.toiletController else {return}
        
        
        // == false because state is changed after this function
        if self.isSelected  {
            //Filter toilets to open ones only
            let toiletsNotOpen = toiletController.toilets.filter({
                self.isToiletOpen($0) == false
            })
            
            //Saving closed toilets so they can be added later
            toiletController.toiletsNotOpen = toiletsNotOpen
            
            toiletController.removeToilets(toiletsNotOpen)
        }
            //Add back closed toilets (filter not applied)
        else {
            toiletController.addToilets(toiletController.toiletsNotOpen)
        }
        
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
        if openTimes.isNonstop {
            return true
        }
        
        //Getting array of ints of open weekdays
        let toiletDays = openTimes.days
        let hours = openTimes.hours
        guard toiletDays.index(of: todayWeekday) != nil else {return false}
        
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
