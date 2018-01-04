//
//  LoadingDelegates.swift
//  Klozet
//
//  Created by Marek Fořt on 1/4/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol LoadingDelegate: class {
    var isExecuting: MutableProperty<Bool> {get}
    var loadingImageView: LoadingImageView {get}
}

extension LoadingDelegate where Self: UIViewController {
    func addRotatingLoadingImageView() {
        loadingImageView.loadingDelegate = self
        loadingImageView.image = UIImage(asset: Asset.loadingIconShadow)
        view.addSubview(loadingImageView)
        loadingImageView.setHeightAndWidthAnchorToConstant(50)
        loadingImageView.centerInView(view)
        isExecuting.value = true
        loadingImageView.rotateImageView()
        
        setupBindings()
    }
    
    private func setupBindings() {
        isExecuting.producer.observe(on: UIScheduler()).startWithValues { [weak self] isExecuting in
            self?.loadingImageView.isHidden = !isExecuting
        }
    }
}

class LoadingImageView: UIImageView {
    
    weak var loadingDelegate: LoadingDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init() {
        self.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func rotateImageView() {
        let loadingImageViewPropertyAnimator = UIViewPropertyAnimator(duration: 1, timingParameters: UICubicTimingParameters(animationCurve: .linear))
        loadingImageViewPropertyAnimator.addAnimations {
            let radians: Double = .pi
            self.transform = self.transform.rotated(by: CGFloat(radians))
        }
        loadingImageViewPropertyAnimator.addAnimations {
            let radians: Double = .pi
            self.transform = self.transform.rotated(by: CGFloat(radians))
        }
        loadingImageViewPropertyAnimator.startAnimation()
        loadingImageViewPropertyAnimator.addCompletion { _ in
            if self.loadingDelegate?.isExecuting.value ?? true {
                self.rotateImageView()
            }
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
