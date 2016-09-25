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
        
        //TableViewController
        let controller = TableViewController()
        delegate = controller
        dataSource = controller
        
        //RowHeight
        rowHeight = 60
        
        //Disable scrolling
        isScrollEnabled = false
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
        
        if indexPath.row == 0 {
            return OpenTimeCell(style: .default, reuseIdentifier: "openTimeCell", openTimes: ["K"])
        }
        
        else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}

class OpenTimeCell: UITableViewCell, LeftLabelInterface {
    
    var openTimes = [String]()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let cellStackView = UIStackView()
        cellStackView.axis = .horizontal
        cellStackView.alignment = .center
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cellStackView)
        
        
        cellStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cellStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        setLeftLabel(stackView: cellStackView, text: "Otevírací doba".localized)
    }
    
    convenience init(style: UITableViewCellStyle, reuseIdentifier: String?, openTimes: Array<String>) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    
    fileprivate func setOpenTimeStack(stackView: UIStackView) {
        let openTimeStack = UIStackView()
        stackView.addArrangedSubview(openTimeStack)
        
        openTimeStack.axis = .vertical
        openTimeStack.alignment = .leading
        
        openTimeStack.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 5).isActive = true
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol LeftLabelInterface {
    
}

extension LeftLabelInterface {
    func setLeftLabel(stackView: UIStackView, text: String) {
        let label = UILabel()
        label.text = text
        label.textColor = Colors.pumpkinColor
        label.font = UIFont.systemFont(ofSize: 18)
        
        stackView.addArrangedSubview(label)
        label.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 15).isActive = true
    }
}

