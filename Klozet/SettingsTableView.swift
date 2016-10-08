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
        rowHeight = 70
        
        //Disable scrolling
        isScrollEnabled = false
        
        //Set height to rowHeight * 2
        heightAnchor.constraint(equalToConstant: 140).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let mailCell = SupportCell(style: .default, reuseIdentifier: "supportCell")
            mailCell.presentDelegate = self
            supportCellDelegate = mailCell
            return mailCell
        }
            
        else {
            let mailCell = SupportCell(style: .default, reuseIdentifier: "supportCell")
            return mailCell
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
            supportCellDelegate?.mailButtonTapped()
        }
        else {
            
        }
    }
}

protocol PresentMailDelegate {
    func present(viewController: UIViewController)
}

extension SettingsViewController: PresentDelegate {
    func showViewController(viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
}

class SupportCell: UITableViewCell, MFMailComposeViewControllerDelegate, SupportCellDelegate {
    
    var presentDelegate: PresentDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mailButtonTapped() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["marekfort@me.com"])
            mail.setSubject("Klozet")
            
            presentDelegate?.showViewController(viewController: mail)
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
        let alertController = UIAlertController(title: "Mail".localized, message: "V nastavení účtů si zapněte 'Pošta'".localized, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Nastavení".localized, style: .default) { (_) -> Void in
            let settingsUrl = URL(string: "prefs:root=ACCOUNT_SETTINGS")
            if let url = settingsUrl {
                UIApplication.shared.openURL(url)
            }
        }
        
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Zrušit".localized, style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        
        presentDelegate?.showViewController(viewController: alertController)
    }
    
    
}

protocol SupportCellDelegate {
    func mailButtonTapped()
}





