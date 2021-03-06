//
//  ListViewController.swift
//  Klozet
//
//  Created by Marek Fořt on 08/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift

protocol ListToiletsDelegate {
    var toilets: Array<Toilet> { get set }
    var isFilterOpenSelected: Bool { get set }
    var isFilterPriceSelected: Bool { get set }
    var locationDelegate: UserLocation? { get }
    func reloadTable()
    //func startUpdating()
    func updateToilets(_ toilets: Array<Toilet>)
}


class ListViewController: UIViewController, DirectionsDelegate, LoadingDelegate, UITabBarControllerDelegate {
    
    
    
    
    
    var toiletsViewModel: ToiletViewModel?
    var tableView: UITableView = UITableView()
    
    var allToilets: [Toilet] = []
    var toilets = [Toilet]()
    var toiletsNotOpen: [Toilet] = []
    
    let priceButton = FilterPriceButton(title: "Free".localized)
    let openButton = FilterOpenButton(title: "Open".localized)
    
    var isExecuting: MutableProperty<Bool> = MutableProperty(true)
    var locationDelegate: UserLocation?
    var loadingImageView: LoadingImageView = LoadingImageView()
    
    var didOrderToilets = false
    
    var shownCells = 20
    var listFooterDelegate: ListFooterDelegate?
    
    
    override func viewDidLoad() {
        
        title = "List"
        
        tabBarController?.delegate = self
        
        let filtersStackView = UIStackView()
        filtersStackView.axis = .horizontal
        filtersStackView.spacing = 8
        filtersStackView.addBackgroundViewWithColor(.white)
        filtersStackView.isLayoutMarginsRelativeArrangement = true
        filtersStackView.layoutMargins = UIEdgeInsets(top: 3, left: 0, bottom: 10, right: 0)
        filtersStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersStackView)
        filtersStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        filtersStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        
        priceButton.layer.borderWidth = 2
        priceButton.addTarget(self, action: #selector(filterToilets), for: .touchUpInside)
        filtersStackView.addArrangedSubview(priceButton)
        
        
        openButton.layer.borderWidth = 2
        openButton.addTarget(self, action: #selector(filterToilets), for: .touchUpInside)
        filtersStackView.addArrangedSubview(openButton)
        
        
        view.addSubview(tableView)
        tableView.pinToViewHorizontally(view)
        tableView.topAnchor.constraint(equalTo: filtersStackView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tableView.rowHeight = 83
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListCell.self, forCellReuseIdentifier: "listCell")
        
        navigationController?.navigationBar.tintColor = .mainOrange 
        
        setTableFooter()
        
        tableView.tableFooterView?.isHidden = true
        
        addRotatingLoadingImageView()
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = true
        
        //Deselect selected row
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    private func setupBindings() {
        
        toiletsViewModel?.toiletsForList.producer.observe(on: UIScheduler()).startWithResult { [weak self] result in
            guard let toilets = result.value else {return}
            self?.isExecuting.value = toilets.count == 0
            self?.updateToilets(toilets)
        }
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard viewController.isKind(of: UINavigationController.self) == false else {return true}
        
        let addToiletViewController = AddToiletViewController()
        let addNavigationController = UINavigationController(rootViewController: addToiletViewController)
        navigationController?.present(addNavigationController, animated: true, completion: nil)
        
        return false
    }
    
    private func setTableFooter() {
        let listFooterFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
        let listFooter = ListFooter(frame: listFooterFrame)
        listFooter.reloadDelegate = self
        listFooterDelegate = listFooter
        
        tableView.tableFooterView = listFooter
        
        tableView.contentInset.bottom = 10
    }

}

extension ListViewController: Reload {
    
    func updateToilets(_ toilets: Array<Toilet>) {
        self.toilets = toilets
        allToilets = toilets
        reloadTable()
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func filterToilets() {
    
        //Get only open and free toilets
        if openButton.isSelected && priceButton.isSelected {
            self.toilets = self.allToilets.filter({
                self.openButton.isToiletOpen($0) && $0.price == "Free".localized
            })
        }
            
            //Get open toilets
        else if openButton.isSelected {
            self.toilets = self.allToilets.filter({
                self.openButton.isToiletOpen($0)
            })
        }
            
            //Get free toilets
        else if self.priceButton.isSelected {
            self.toilets = self.allToilets.filter({
                $0.price == "Free".localized
            })
        }
            
            //Get all toilets
        else {
            toilets = allToilets
        }
        
        
        tableView.reloadData()
    }
    
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listCell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! ListCell
        
        //Getting toilet for cell
        let toilet = toilets[indexPath.row]
        
        listCell.toiletImageView.image = nil
        
        listCell.locationDelegate = self.locationDelegate
        listCell.fillCellData(toilet)

        return listCell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard shownCells < toilets.count else {
            return toilets.count
        }
        
        if toilets.count > 0 {
            tableView.tableFooterView?.isHidden = false
            listFooterDelegate?.changeToFooterWithMore()
        }
        
        return shownCells
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.toilet = toilets[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

protocol Reload {
    func reloadTable()
    var shownCells: Int { get set }
}

protocol ListFooterDelegate {
    func changeToFooterWithMore()
}

class ListFooter: UIView, ListFooterDelegate {
    
    let moreButton = UIButton(type: .roundedRect)
    let moreStack = UIStackView()
    let infoLabel = UILabel()
    
    var reloadDelegate: Reload?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setMoreStack()
        setMoreButton(moreStack: moreStack)
        
    }
    
    private func setMoreStack() {
        moreStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(moreStack)
        moreStack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        moreStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    private func setMoreButton(moreStack: UIStackView) {
        moreButton.setTitle("More toilets".localized, for: .normal)
        moreButton.setTitleColor(.mainOrange, for: .normal)
        moreButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        moreButton.addTarget(self, action: #selector(loadMoreToilets), for: .touchUpInside)
        moreStack.addArrangedSubview(moreButton)
    }
    
    @objc func loadMoreToilets() {
        reloadDelegate?.shownCells += 20
        reloadDelegate?.reloadTable()
    }
    
    func changeToFooterWithMore() {
        if moreStack.subviews.count == 0 {
            moreStack.addArrangedSubview(moreButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ListViewController: ToiletController {
    func addToilets(_ toilets: [Toilet]) {
        self.toilets += toilets
        tableView.reloadData()
    }
    
    func removeToilets(_ toilets: [Toilet]) {
        let filteredToilets = self.toilets.filter { !toilets.contains($0) }
        self.toilets = filteredToilets
        tableView.reloadData()
    }
}


