//
//  SupportCell.swift
//  Klozet
//
//  Created by Marek Fořt on 08/10/2016.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit
import MessageUI



class SupportCell: UITableViewCell, MFMailComposeViewControllerDelegate, SupportCellDelegate {
    
    var ShowDelegate: ShowDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        
        textLabel?.textColor = .mainBlue
        textLabel?.text = "Support".localized
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mailCellTapped() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["marekfort@me.com"])
            mail.setSubject("Klozet")
            
            ShowDelegate?.showViewController(viewController: mail)
        }
            //TODO - handle the possibility that the user doesn't use the native mail client
        else {
            // show failure alert - open settings to enable email account
            presentMailAlert()
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func presentMailAlert() {
        
        // Push notifications are disabled in setting by user.
        let alertController = UIAlertController(title: "Mail".localized, message: "Turn on Mail".localized, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings".localized, style: .default) { (_) -> Void in
            let settingsUrl = URL(string: "prefs:root=ACCOUNT_SETTINGS")
            if let url = settingsUrl {
                UIApplication.shared.openURL(url)
            }
        }
        
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        
        ShowDelegate?.showViewController(viewController: alertController)
    }
    
    
}

protocol SupportCellDelegate {
    func mailCellTapped()
}

