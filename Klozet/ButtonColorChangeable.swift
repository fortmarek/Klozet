//
//  ButtonColorChangeable.swift
//  Klozet
//
//  Created by Marek Fořt on 12/27/17.
//  Copyright © 2017 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit


class ButtonColorChangeable: UIButton {
    var normalColor: UIColor = UIColor()
    var selectedColor: UIColor = UIColor()
    
    var isStateChangeable: Bool = true
    
    static let buttonHeight: CGFloat = 32
    
    let buttonBorderWidth: CGFloat = 3
    
    func setButton(with title: String, normalColor: UIColor, selectedColor: UIColor) {
        clipsToBounds = true
        titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        setTitle(title, for: .selected)
        self.normalColor = normalColor
        self.selectedColor = selectedColor
        heightAnchor.constraint(equalToConstant: ButtonColorChangeable.buttonHeight).isActive = true
        widthAnchor.constraint(equalToConstant: 83).isActive = true
        layer.cornerRadius = (ButtonColorChangeable.buttonHeight - buttonBorderWidth) / 2
        backgroundColor = selectedColor
        setTitleColor(normalColor, for: .normal)
        setTitleColor(selectedColor, for: .highlighted)
        setTitleColor(selectedColor, for: [.highlighted, .selected])
        setTitleColor(selectedColor, for: .selected)
        layer.borderColor = normalColor.cgColor
//        layer.borderWidth = buttonBorderWidth
        addTarget(self, action: #selector(changeButtonState(_:)), for: .touchUpInside)
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = normalColor
            }
            else if !isHighlighted && !isSelected {
                backgroundColor = selectedColor
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = normalColor
            }
            else {
                backgroundColor = selectedColor
            }
        }
    }
    
    @objc func changeButtonState(_ sender: UIButton) {
        guard isStateChangeable else {sender.isSelected = sender.isSelected; return}
        sender.isSelected = !sender.isSelected
    }
    
}
