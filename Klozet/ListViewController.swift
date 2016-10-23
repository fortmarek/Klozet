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
    
    var shownCells = 20
    
    
    override func viewDidLoad() {
        
        //Save all toilets (needed for filters)
        allToilets = toilets
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.tintColor = UIColor(red: 1.00, green: 0.42, blue: 0.20, alpha: 1.0)
        
        setTableFooter()
        
        //Have not ordered toilets yet, show activityIndicator
        if didOrderToilets == false {
            activityView = ActivityView(view: view)
            activityIndicator = activityView.activityIndicator
        }
        
        _ = ListControllerContainer(view: view, toiletsDelegate: self)
        
        
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
    
    private func setTableFooter() {
        //tableView.tableFooterView = ListFooter(toiletsCount: toilets.count, viewWidth: view.frame.size.width)
        tableView.tableFooterView = ListMoreFooter(viewWidth: view.frame.size.width)
        tableView.contentInset.bottom = 100
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
    @objc(tableView:willDisplayCell:forRowAtIndexPath:) func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = shownCells - 1
        
        if indexPath.row == lastElement {
            shownCells += 20
            reloadTable()
        }
    }
 */
    
    /*
    func startUpdating() {
        activityView.isHidden = false
        activityIndicator.startAnimating()
    }
 */
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listCell = getListCell(indexPath: indexPath, tableView: tableView)
        return listCell
    }
    
    
    func getListCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        //Cell as ListCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as? ListCell else {return UITableViewCell()}
        
        //Getting toilet for cell
        let toilet = toilets[(indexPath as NSIndexPath).row]
        
        cell.locationDelegate = self.locationDelegate
        cell.fillCellData(toilet)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard shownCells < (toilets.count - 20) else {
            return toilets.count
        }
        return shownCells
    }
}

extension ListViewController: UITableViewDelegate {
    
}

class ListFooter: UITableViewHeaderFooterView {
    convenience init(toiletsCount: Int, viewWidth: CGFloat) {
        self.init()
        
        let footerContentView = UIView()
        footerContentView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: 400)
        footerContentView.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.95, alpha: 1.0)
        contentView.addSubview(footerContentView)
        
        let infoLabel = UILabel()
        infoLabel.text = "Záchodů celkem: \(toiletsCount)".localized
        infoLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightLight)
        infoLabel.sizeToFit()
        infoLabel.frame.origin.x = viewWidth / 2 - infoLabel.frame.size.width / 2
        infoLabel.frame.origin.y = 16.5
        footerContentView.addSubview(infoLabel)
    }
}

class ListMoreFooter: UITableViewHeaderFooterView {
    convenience init(viewWidth: CGFloat) {
        self.init()
        
        let footerContentView = UIView()
        footerContentView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: 400)
        contentView.addSubview(footerContentView)
        
        let moreStack = UIStackView()
        moreStack.translatesAutoresizingMaskIntoConstraints = false
        footerContentView.addSubview(moreStack)
        moreStack.centerXAnchor.constraint(equalTo: footerContentView.centerXAnchor).isActive = true
        moreStack.topAnchor.constraint(equalTo: footerContentView.topAnchor, constant: 20).isActive = true
        
        
        let moreButton = UIButton()
        moreButton.setTitle("Načíst další".localized, for: .normal)
        moreButton.setTitle("Načíst další".localized, for: .selected)
        moreButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
        moreButton.titleLabel?.textColor = Colors.pumpkinColor
        moreButton.addTarget(self, action: #selector(loadMoreToilets), for: .touchUpInside)
        moreStack.addArrangedSubview(moreButton)

    }
    
    func loadMoreToilets() {
        print("Yup")
    }
}


