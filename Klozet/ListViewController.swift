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
        
        
        let _ = ListControllerContainer(view: view)
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

