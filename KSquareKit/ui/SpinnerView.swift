//
//  SpinnerView.swift
//  KSquareKit
//
//  Created by Karthikkeyan on 7/5/16.
//  Copyright © 2016 KSquareKit. All rights reserved.
//

import UIKit

private let kSpinnerRotationDuration: CFTimeInterval = 3.0

public let SpinnerViewBorderInset: CGFloat = 0.0

open class SpinnerView: UIView {
    
    open fileprivate(set) var borderLayer: CAShapeLayer!
    
    open var hideWhenStops: Bool = false
    
    @IBInspectable open var borderColor: UIColor = UIColor.white {
        didSet {
            if borderLayer != nil {
                borderLayer.strokeColor = borderColor.cgColor
            }
        }
    }
    
    open var animate: Bool = false {
        willSet {
            if newValue {
                prepareToStartAnimation()
                willStartAnimation()
            }
            else {
                prepareToStopAnimation()
                willStopAnimation()
            }
        }
        didSet {
            if animate {
                startAnimation()
                didStartAnimation()
            }
            else {
                stopAnimation()
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    fileprivate func createBorderLayerIfNeeded() {
        guard borderLayer == nil else { return }
        
        borderLayer = CAShapeLayer()
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = 2.0
        borderLayer.lineCap = kCALineCapRound
        borderLayer.strokeStart = 0.0
        borderLayer.strokeEnd = 0.0
        layer.addSublayer(borderLayer)
    }
    
    fileprivate func prepareToStartAnimation() {
        createBorderLayerIfNeeded()
        
        borderLayer.path = borderPath()
        
        alpha = 1
    }
    
    private func borderPath() -> CGPath {
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: SpinnerViewBorderInset, dy: SpinnerViewBorderInset), byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: width * 0.5, height: height * 0.5))
        
        return path.cgPath
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if borderLayer != nil {
            borderLayer.path = borderPath()
        }
    }
    
    fileprivate func startAnimation() {
        UIView.animate(withDuration: 0.3, animations: { self.borderLayer.opacity = 1 })
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = NSNumber(value: 0 as Double)
        rotationAnimation.toValue = NSNumber(value: M_PI * 2 as Double)
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        rotationAnimation.duration = kSpinnerRotationDuration
        rotationAnimation.repeatCount = FLT_MAX
        rotationAnimation.fillMode = kCAFillModeForwards
        layer.add(rotationAnimation, forKey: "rotation")
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = NSNumber(value: 0.0 as Float)
        strokeEndAnimation.toValue = NSNumber(value: 1.0 as Float)
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        strokeEndAnimation.duration = kSpinnerRotationDuration * 0.5
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = NSNumber(value: 0.0 as Float)
        strokeStartAnimation.toValue = NSNumber(value: 0.95 as Float)
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        strokeStartAnimation.duration = kSpinnerRotationDuration * 0.5
        
        let combinedAnimation = CAAnimationGroup()
        combinedAnimation.animations = [strokeEndAnimation, strokeStartAnimation]
        combinedAnimation.duration = kSpinnerRotationDuration * 0.5
        combinedAnimation.repeatCount = FLT_MAX
        combinedAnimation.fillMode = kCAFillModeForwards
        borderLayer.add(combinedAnimation, forKey: "strokeRotation")
    }
    
    fileprivate func prepareToStopAnimation() { }
    
    fileprivate func stopAnimation() {
        UIView.animate(withDuration: 0.3, animations: {  self.borderLayer.opacity = 0 }, completion: { _ in
            self.borderLayer.removeAnimation(forKey: "strokeRotation")
            self.layer.removeAnimation(forKey: "rotation")
            
            if self.hideWhenStops { self.alpha = 0 }
            
            self.didStopAnimation()
        }) 
    }
    
    
    // MARK: - Public Methods
    
    open func willStartAnimation() { }
    
    open func didStartAnimation() { }
    
    open func willStopAnimation() { }
    
    open func didStopAnimation() { }
    
}
