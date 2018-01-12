//
//  PricePickerView.swift
//  
//
//  Created by Marek Fořt on 1/12/18.
//

import UIKit

import UIKit

protocol PricePickerViewDelegate {
    func dismissPicker()
    var selectedPrice: String {get set}
}

class PricePickerView: UIStackView {
    
    let pricePicker: UIPickerView = UIPickerView()
    var pickerStackBottomAnchor: NSLayoutConstraint?
    var prices: [String] = []
    var pricePickerViewDelegate: PricePickerViewDelegate?
    
    init() {
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = .mainOrange
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton, doneButton], animated: false)
        addArrangedSubview(toolbar)
        toolbar.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        pricePicker.delegate = self
        pricePicker.tintColor = .mainOrange
        pricePicker.backgroundColor = .white
        prices = createPricesArray()
        addArrangedSubview(pricePicker)
        pricePicker.pinToViewHorizontally(self)
        pricePicker.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    
    @objc func doneButtonTapped() {
        pricePickerViewDelegate?.dismissPicker()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PricePickerView: UIPickerViewDataSource, UIPickerViewDelegate, PricePickerDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return prices.count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedTitle = NSAttributedString(string: prices[prices.endIndex - row - 1], attributes: [.foregroundColor: UIColor.mainOrange])
        return attributedTitle
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let price: String = prices[prices.endIndex - row - 1]
        pricePickerViewDelegate?.selectedPrice = price
    }
}
