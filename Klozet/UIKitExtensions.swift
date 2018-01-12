//
//  UIKitExtensions.swift
//  Klozet
//
//  Created by Marek Fořt on 10/20/17.
//  Copyright © 2017 Marek Fořt. All rights reserved.
//


import Foundation
import UIKit
import ReactiveSwift
import Result

extension UIView {
    func pinToView(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func pinToViewHorizontally(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func pinToViewVertically(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func centerInView(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func pinToViewWithInsets(_ view: UIView, insets: UIEdgeInsets) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right).isActive = true
    }
    
    func setHeightAndWidthAnchorToConstant(_ constant: CGFloat) {
        heightAnchor.constraint(equalToConstant: constant).isActive = true
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func setAnchorsToSizeToFit() {
        sizeToFit()
        widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        heightAnchor.constraint(equalToConstant: frame.height).isActive = true
    }
    
    func addShadowLayer(_ shadowLayer: CALayer) {
        let backgroundShadowView = UIView()
        backgroundShadowView.translatesAutoresizingMaskIntoConstraints = false
        superview?.addSubview(backgroundShadowView)
        superview?.sendSubview(toBack: backgroundShadowView)
        backgroundShadowView.backgroundColor = .mainOrange
        backgroundShadowView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        backgroundShadowView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        backgroundShadowView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundShadowView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        backgroundShadowView.layer.shadowColor = shadowLayer.shadowColor
        backgroundShadowView.layer.shadowRadius = shadowLayer.shadowRadius
        backgroundShadowView.layer.shadowOpacity = shadowLayer.shadowOpacity
        backgroundShadowView.layer.shadowOffset = shadowLayer.shadowOffset
        
        backgroundShadowView.clipsToBounds = false
    }
    
    func isLocationInside(location: CGPoint, mainSuperview: UIView) -> Bool {
        let convertedFrame = convert(bounds, to: mainSuperview)
        return convertedFrame.contains(location)
    }
    
    
}

extension UIFont {
    func getHeight() -> CGFloat{
        let label = UILabel()
        label.text = " "
        label.font = self
        label.sizeToFit()
        return label.frame.height
    }
    
    func getWidthOfText(_ text: String) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.font = self
        label.sizeToFit()
        return label.frame.width
    }
}


extension UIViewController {
    func preloadView() {
        let _ = view
    }
    
}

extension UIStackView {
    func addBackgroundViewWithColor(_ color: UIColor) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = color
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        backgroundView.pinToView(self)
    }
    
    static func createDefaultVerticalStackView() -> UIStackView {
        let defaultVerticalStackView = UIStackView()
        defaultVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        defaultVerticalStackView.alignment = .center
        defaultVerticalStackView.axis = .vertical
        return defaultVerticalStackView
    }
}

extension UIImage {
    
    convenience init?(color: UIColor, size: CGSize?) {
        let rect = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    func correctlyOrientedImage() -> UIImage? {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
}

extension UITextField {
    func setLeftPadding(_ padding: CGFloat) {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        self.leftView = leftView
        leftViewMode = .always
    }
    
    func setRightPadding(_ padding: CGFloat) {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        self.rightView = rightView
        rightViewMode = .always
    }
}

extension UIButton {
    func reselect() {
        self.isSelected = !self.isSelected
    }
    
    func deselect() {
        guard isSelected else {return}
        isSelected = !isSelected
    }
}

extension UITableView {
    func cellFromDataSource(at indexPath: IndexPath) -> UITableViewCell? {
        let cell = self.dataSource?.tableView(self, cellForRowAt: indexPath)
        return cell
    }
}


extension UINavigationController {
    
    func setDefaultNavigationBar() {
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.mainOrange]
        navigationBar.backgroundColor = .white
        view.backgroundColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = .white
        navigationBar.tintColor = .mainOrange
    }
}


//Extension to simplify setting options for UIViewKeyFrameAnimation
extension UIViewKeyframeAnimationOptions {
    init(animationOptions: UIViewAnimationOptions) {
        rawValue = animationOptions.rawValue
    }
}






