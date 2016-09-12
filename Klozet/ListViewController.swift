//
//  ListViewController.swift
//  Klozet
//
//  Created by Marek Fořt on 08/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var toilet = [Toilet]()
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.tintColor = UIColor(red: 1.00, green: 0.42, blue: 0.20, alpha: 1.0)
    }
    
    
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("listCell") as? ListCell else {return UITableViewCell()}
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}

extension ListViewController: UITableViewDelegate {
    
}