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
    
    var activityContainerView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    
    var didOrderToilets = false
    
    
    override func viewDidLoad() {
        
        //Save all toilets (needed for filters)
        allToilets = toilets
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.tintColor = UIColor(red: 1.00, green: 0.42, blue: 0.20, alpha: 1.0)
        
        let _ = ListControllerContainer(view: view, toiletsDelegate: self)
        
        if didOrderToilets == false || didOrderToilets {
            setIndicatorView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Deselect selected row
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    //For fututure implementation when loading gets too long
    fileprivate func setIndicatorView() {
        
        view.layoutIfNeeded()
        
        activityContainerView.isHidden = true
        //- 50 for listController at the bottom
        activityContainerView.frame.size = CGSize(width: tableView.frame.width, height: tableView.frame.height - 50)
        activityContainerView.backgroundColor = UIColor.white
        view.addSubview(activityContainerView)
        view.bringSubview(toFront: activityContainerView)
        
        let activityStack = UIStackView()
        activityStack.frame = activityContainerView.frame
        activityStack.backgroundColor = UIColor.orange
        view.addSubview(activityStack)
        view.bringSubview(toFront: activityStack)
        
        activityStack.axis = .vertical
        activityStack.spacing = 13
        activityStack.alignment = .center

        activityIndicator.sizeToFit()
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.hidesWhenStopped = true
        
        let activityLabel = UILabel()
        activityLabel.text = "...načítání".localized
        activityLabel.textColor = UIColor.gray
        
        activityStack.addArrangedSubview(activityIndicator)
        activityStack.addArrangedSubview(activityLabel)
        activityStack.translatesAutoresizingMaskIntoConstraints = false
        
        activityStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
        
        startUpdating()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            
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
            self.activityContainerView.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    func startUpdating() {
        activityContainerView.isHidden = false
        activityIndicator.startAnimating()
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

