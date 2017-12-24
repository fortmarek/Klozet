//
//  SettingsTableView.swift
//  Klozet
//
//  Created by Marek Fořt on 08/10/2016.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import UIKit
import MessageUI


class SettingsTableView: UITableView {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        //RowHeight
        rowHeight = 60
        
        //Disable scrolling
        isScrollEnabled = false
        
        //Set height to rowHeight * 2
        heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let mailCell = SupportCell(style: .default, reuseIdentifier: "supportCell")
            mailCell.ShowDelegate = self
            supportCellDelegate = mailCell
            return mailCell
        }
            
        else {
            let shareCell = ShareCell(style: .default, reuseIdentifier: "shareCell")
            shareCell.showDelegate = self
            shareCellDelegate = shareCell
            return shareCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            supportCellDelegate?.mailCellTapped()
            settingsTableView.deselectRow(at: indexPath, animated: true)
        }
        else {
            shareCellDelegate?.shareCellTapped()
            settingsTableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

class ShareCell: UITableViewCell, ShareCellDelegate {
    
    var showDelegate: ShowDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.text = "Share".localized
        textLabel?.textAlignment = .center
        textLabel?.textColor = .mainOrange
    }
    
    func shareCellTapped() {
        
        guard let appStoreLink = URL(string: "https://itunes.apple.com/us/app/klozet-prague-toilets/id1170530956?l=cs&ls=1&mt=8") else {return}

        let myText = "The simplest way to find public toilets!".localized
        let myObjects = [myText, appStoreLink] as [Any]
        let activityVC = UIActivityViewController(activityItems: myObjects, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityType.addToReadingList]
        showDelegate?.showViewController(viewController: activityVC)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol ShareCellDelegate {
    func shareCellTapped()
}



