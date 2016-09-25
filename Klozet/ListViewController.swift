//
//  ListViewController.swift
//  Klozet
//
//  Created by Marek Fořt on 08/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

protocol ListToiletsDelegate {
    var toilets: Array<Toilet> { get set }
    var allToilets: Array<Toilet> { get set }
    var isFilterOpenSelected: Bool { get set }
    var isFilterPriceSelected: Bool { get set }
    var locationDelegate: UserLocation? { get }
    func reloadTable()
    //func startUpdating()
    func updateToilets(toilets: Array<Toilet>)
}

protocol ListTableDelegate {
    func reloadTable()
}

class ListViewController: UIViewController, DirectionsDelegate, ListTableDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var toilets = [Toilet]()
    var allToilets = [Toilet]()
    
    var isFilterOpenSelected = false
    var isFilterPriceSelected = false
    
    var locationDelegate: UserLocation?
    
    var activityView = ActivityView()
    var activityIndicator = UIActivityIndicatorView()
    
    var didOrderToilets = false
    
    
    override func viewDidLoad() {
        
        //Save all toilets (needed for filters)
        allToilets = toilets
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.tintColor = UIColor(red: 1.00, green: 0.42, blue: 0.20, alpha: 1.0)
        
        //Have not ordered toilets yet, show activityIndicator
        if didOrderToilets == false {
            activityView = ActivityView(view: view)
            activityIndicator = activityView.activityIndicator
        }
        
        let _ = ListControllerContainer(view: view, toiletsDelegate: self)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Deselect selected row
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            guard
                let detailViewController = segue.destination as? DetailViewController,
                let indexPath = tableView.indexPathForSelectedRow
            else {return}
            
            detailViewController.toilet = toilets[indexPath.row]
        }
    }
    
    

}

extension ListViewController: ListToiletsDelegate {
    
    func updateToilets(toilets: Array<Toilet>) {
        self.toilets = toilets
        reloadTable()
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityView.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    /*
    func startUpdating() {
        activityView.isHidden = false
        activityIndicator.startAnimating()
    }
 */
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

