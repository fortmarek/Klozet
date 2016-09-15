//
//  ListViewController.swift
//  Klozet
//
//  Created by Marek Fořt on 08/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController, DirectionsDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var toilets = [Toilet]()
    var locationDelegate: UserLocation?
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.tintColor = UIColor(red: 1.00, green: 0.42, blue: 0.20, alpha: 1.0)
        
        
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = CGRect(x: 0, y: view.frame.size.height - 60, width: view.frame.size.width, height: 60)
        view.addSubview(blurredEffectView)
        
    
        let listController = ListController(items: ["first", "second"])
        listController.tintColor = UIColor.orange
        listController.translatesAutoresizingMaskIntoConstraints = false
        
        blurredEffectView.contentView.addSubview(listController)
        
        blurredEffectView.contentView.addConstraint(NSLayoutConstraint(item: listController, attribute: .leading, relatedBy: .equal, toItem: blurredEffectView.contentView, attribute: .leading, multiplier: 1.0, constant: 40))
        blurredEffectView.contentView.addConstraint(NSLayoutConstraint(item: listController, attribute: .trailing, relatedBy: .equal, toItem: blurredEffectView.contentView, attribute: .trailing, multiplier: 1.0, constant: -40))
        blurredEffectView.contentView.addConstraint(NSLayoutConstraint(item: listController, attribute: .centerY, relatedBy: .equal, toItem: blurredEffectView.contentView, attribute: .centerY, multiplier: 1.0, constant: 0))
        blurredEffectView.contentView.addConstraint(NSLayoutConstraint(item: listController, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 30))
        
        blurredEffectView.contentView.layoutIfNeeded()
        
        view.bringSubview(toFront: blurredEffectView)
    }

}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Cell as ListCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as? ListCell else {return UITableViewCell()}
        
        //Getting toilet for cell
        let toilet = toilets[(indexPath as NSIndexPath).row]
        
        cell.locationDelegate = self.locationDelegate
        cell.fillCellData(toilet)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toilets.count
    }
}

extension ListViewController: UITableViewDelegate {
    
}


class ListController: UISegmentedControl {
    
}
