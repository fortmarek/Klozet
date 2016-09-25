//
//  DetailTableView.swift
//  Klozet
//
//  Created by Marek Fořt on 23/09/2016.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit

class DetailTableView: UITableView {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        let controller = TableViewController()
        delegate = controller
        dataSource = controller
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TableViewController: NSObject {
    
}

protocol TableViewData: UITableViewDataSource, UITableViewDelegate {
    
}

extension TableViewController: TableViewData {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

