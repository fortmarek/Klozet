//
//  OpenTimeCell.swift
//  Klozet
//
//  Created by Marek Fořt on 26/09/2016.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON


class OpenTimeCell: UITableViewCell, DetailCell, FilterOpen {
    
    var widthDimension = CGFloat()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    convenience init(style: UITableViewCellStyle, reuseIdentifier: String?, openTimes: Array<JSON>) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let cellStackView = setCellStack(view: self)
        
        
        setLeftLabel(stackView: cellStackView, text: "Open".localized)
        
        
        setOpenTimeStack(stackView: cellStackView, openTimes: openTimes)
    
        
    }
    
    
    fileprivate func setOpenTimeStack(stackView: UIStackView, openTimes: Array<JSON>) {
        let openTimeStack = UIStackView()
        stackView.addArrangedSubview(openTimeStack)
        
        openTimeStack.axis = .vertical
        openTimeStack.distribution = .fillEqually
        openTimeStack.spacing = 3
        
        openTimeStack.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
        
        //FIX:
//        let openTimesAsStrings = openTimesToStrings(openTimes: openTimes)
//
//        //Get fontsize depending on number of elements
//        let fontSize = getFontSize(count: openTimesAsStrings.count)
//
//        for openTime in openTimesAsStrings {
//            let openLabel = UILabel()
//            openLabel.attributedText = openTime
//            openLabel.font = UIFont.systemFont(ofSize: fontSize)
//            openLabel.minimumScaleFactor = 0.8
//            openLabel.adjustsFontSizeToFitWidth = true
//            openTimeStack.addArrangedSubview(openLabel)
//
//        }

        widthDimension = openTimeStack.frame.size.width
    }
    
    fileprivate func getFontSize(count: Int) -> CGFloat {
        
        if count == 1 {
            return 18
        }
        else if count == 2 {
            return 17
        }
        else {
            return 15
        }
    }
    
    typealias AttributedArray = Array<NSAttributedString>
    
    //FIX: 
//    fileprivate func openTimesToStrings(openTimes: OpenTimes) {
//
//
//
//        var openTimesStrings = AttributedArray()
//        for openTimesData in openTimes {
//
//            var openTimesString = ""
//            let color = getLabelColor(openTimesData: openTimesData)
//
//            //Is toilet opened nonstop?
//            if openTimesData["nonstop"].bool == true {
//                //String
//                openTimesString = "Nonstop".localized
//            }
//
//            else {
//                //Days interval
//                openTimesString += getDayInterval(openTimesDays: openTimesData["days"])
//                openTimesString += getHoursInterval(openTimesHours: openTimesData["hours"])
//            }
//
//            //Add attributedString to array
//            let attributedString = NSAttributedString(string: openTimesString, attributes: [NSAttributedStringKey.foregroundColor: color])
//            openTimesStrings.append(attributedString)
//
//
//        }
//        return openTimesStrings
//    }
    
    fileprivate func getLabelColor(openTimesData: JSON) -> UIColor {
        
        //Toilet is open, make label green
        if isToiletOpenInInterval(toiletTimeDict: openTimesData) {
            return Colors.greenColor
        }
        //Toilet is closed, make label orange
        else {
            return .mainBlue
        }
    }
    
    fileprivate func getHoursInterval(openTimesHours: JSON) -> String {
        guard let hoursArray = openTimesHours.array else {return String()}
        
        
        let firstHour = getHourString(hour: hoursArray[0].string)
        let secondHour = getHourString(hour: hoursArray[1].string)
        
        return "\(firstHour)-\(secondHour)"
    }
    
    fileprivate func getHourString(hour: String?) -> String {
        
        guard let hour = hour else {return "Unknown".localized}
        
        if hour == "null" {
            return "Unknown".localized
        }
        else {
            return hour
        }
    }
    
    fileprivate func getDayInterval(openTimesDays: JSON) -> String {
        guard let daysArray = openTimesDays.array else {return String()}
        
        if daysArray.count > 1 {
            return getMultipleDaysInterval(daysArray: daysArray)
        }
        
        //Only one day interval
        else {
            let dayIndex = daysArray[0].int
            let day = dayIndexToString(index: dayIndex)
            
            return "\(day): "
        }
        
    }
    
    fileprivate func getMultipleDaysInterval(daysArray: Array<JSON>) -> String {
        //First element of array (need to check if it is sunday or not)
        guard let firstElement = daysArray.first else {return String()}
        
        var mutableDaysArray = daysArray
        
        //Is first element sunday - if it is, put it at the end of the array so there are no intervals like Sun-Tue, etc.
        if firstElement == 1 {
            mutableDaysArray = Array(daysArray.dropFirst())
            mutableDaysArray.append(firstElement)
        }
        
        //Edge days of intervals - eg. Mon-Wed, etc.
        let edgeDays = (mutableDaysArray[0].int, mutableDaysArray.last?.int)
        
        //Convert index number of day to day abbreviation like Mon, Tue, etc.
        let firstDay = dayIndexToString(index: edgeDays.0)
        let endDay = dayIndexToString(index: edgeDays.1)
        
        return "\(firstDay)-\(endDay): "
    }
    
    fileprivate func dayIndexToString(index: Int?) -> String {
        guard let index = index else {return "Unknown".localized}
        
        switch index {
        case 1: return "Sun".localized
        case 2: return "Mon".localized
        case 3: return "Tue".localized
        case 4: return "Wed".localized
        case 5: return "Thu".localized
        case 6: return "Fri".localized
        default: return "Sat".localized
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
