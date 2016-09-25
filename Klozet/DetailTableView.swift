//
//  DetailTableView.swift
//  Klozet
//
//  Created by Marek Fořt on 23/09/2016.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class DetailTableView: UITableView {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
                
        //RowHeight
        rowHeight = 60
        
        //Disable scrolling
        isScrollEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let toilet = toilet else {return UITableViewCell()}

            return OpenTimeCell(style: .default, reuseIdentifier: "openTimeCell", openTimes: toilet.openTimes)
        }
        
        else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}

class OpenTimeCell: UITableViewCell, LeftLabelInterface {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    convenience init(style: UITableViewCellStyle, reuseIdentifier: String?, openTimes: Array<JSON>) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let cellStackView = UIStackView()
        cellStackView.axis = .horizontal
        cellStackView.alignment = .center
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cellStackView)
        
        
        cellStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cellStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        setLeftLabel(stackView: cellStackView, text: "Otevírací doba".localized)
        
        
        setOpenTimeStack(stackView: cellStackView, openTimes: openTimes)
    }
    
    
    fileprivate func setOpenTimeStack(stackView: UIStackView, openTimes: Array<JSON>) {
        let openTimeStack = UIStackView()
        stackView.addArrangedSubview(openTimeStack)
        
        openTimeStack.axis = .vertical
        openTimeStack.alignment = .leading
        
        openTimeStack.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 5).isActive = true
        
        let openTimesAsStrings = openTimesToStrings(openTimes: openTimes)
        for openTime in openTimesAsStrings {
            let openLabel = UILabel()
            openLabel.attributedText = openTime
            openTimeStack.addArrangedSubview(openLabel)
        }
    }
    
    
    typealias AttributedArray = Array<NSAttributedString>
    
    fileprivate func openTimesToStrings(openTimes: Array<JSON>) -> AttributedArray {

        var openTimesStrings = AttributedArray()
        for openTimesData in openTimes {
            
            var openTimesString = ""
            var color = UIColor.gray
            
            if openTimesData["nonstop"].bool == true {
                //TextColor
                color = Colors.greenColor
                
                //String
                openTimesString = "Otevřeno"
            }
            
            else {
                
                guard
                    var daysArray = openTimesData["days"].array,
                    let firstElement = daysArray.first
                else {return AttributedArray()}

                if daysArray.count > 1 {
                    
                    if firstElement == 1 {
                        daysArray = Array(daysArray.dropFirst())
                        daysArray.append(firstElement)
                    }
                    
                    let edgeDays = (daysArray[0].int, daysArray.last?.int)
                    
                    let firstDay = dayIndexToString(index: edgeDays.0)
                    let endDay = dayIndexToString(index: edgeDays.1)
                    
                    if firstDay == "Ne" {
                        openTimesString += "\(endDay)-\(firstDay): "
                    }
                    else {
                        openTimesString += "\(firstDay)-\(endDay): "
                    }
                }
                
                else {
                    let dayIndex = openTimesData["days"][0].int
                    
                    let day = dayIndexToString(index: dayIndex)
                    
                    openTimesString += "\(day): "
                }
                
                
            }
            
            //Add attributedString to array
            let attributedString = NSAttributedString(string: openTimesString, attributes: [NSForegroundColorAttributeName: color])
            openTimesStrings.append(attributedString)
            
            
        }
        return openTimesStrings
    }
    
    fileprivate func dayIndexToString(index: Int?) -> String {
        guard let index = index else {return "Neznámo"}
        
        switch index {
        case 1: return "Ne"
        case 2: return "Po"
        case 3: return "Út"
        case 4: return "St"
        case 5: return "Čt"
        case 6: return "Pá"
        default: return "So"
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol LeftLabelInterface {
    
}

extension LeftLabelInterface {
    func setLeftLabel(stackView: UIStackView, text: String) {
        let label = UILabel()
        label.text = text
        label.textColor = Colors.pumpkinColor
        label.font = UIFont.systemFont(ofSize: 18)
        
        stackView.addArrangedSubview(label)
        label.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 15).isActive = true
    }
}

