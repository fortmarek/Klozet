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
    func startUpdating()
}

class ListViewController: UIViewController, DirectionsDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var toilets = [Toilet]()
    var allToilets = [Toilet]()
    
    var isFilterOpenSelected = false
    var isFilterPriceSelected = false
    
    var locationDelegate: UserLocation?
    
    var activityContainerView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    
    
    
    override func viewDidLoad() {
        
        //Save all toilets (needed for filters)
        allToilets = toilets
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.tintColor = UIColor(red: 1.00, green: 0.42, blue: 0.20, alpha: 1.0)
        
        let _ = ListControllerContainer(view: view, toiletsDelegate: self)
        
        //setIndicatorView()
    }
    
    
    //For fututure implementation when loading gets too long
    fileprivate func setIndicatorView() {
        
        view.layoutIfNeeded()
        
        activityContainerView.isHidden = true
        //- 50 for listController at the bottom
        activityContainerView.frame.size = CGSize(width: tableView.frame.width, height: tableView.frame.height - 200)
        activityContainerView.backgroundColor = UIColor.white
        view.addSubview(activityContainerView)
        view.bringSubview(toFront: activityContainerView)
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = CGPoint(x: tableView.bounds.width * 0.5, y: tableView.bounds.height * 0.3)
        activityContainerView.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
    }
    
    

}

extension ListViewController: ListToiletsDelegate {
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            //self.activityContainerView.isHidden = true
            //self.activityIndicator.stopAnimating()
        }
    }
    
    func startUpdating() {
        //activityContainerView.isHidden = false
        //activityIndicator.startAnimating()
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

