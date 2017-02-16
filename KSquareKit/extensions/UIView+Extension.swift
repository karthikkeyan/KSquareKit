//
//  UIView+Extension.swift
//  KSquareKit
//
//  Created by Karthikkeyan on 11/21/15.
//  Copyright © 2015 KSquareKit. All rights reserved.
//

import UIKit

public extension UIView {
    
    // MARK: Computed Properties -
    
    public var top: CGFloat {
        return self.frame.minY;
    }
    
    public var bottom: CGFloat {
        return self.frame.maxY;
    }
    
    public var left: CGFloat {
        return self.frame.minX;
    }
    
    public var right: CGFloat {
        return self.frame.maxX;
    }
    
    public var width: CGFloat {
        return self.frame.width;
    }
    
    public var height: CGFloat {
        return self.frame.height;
    }
    
    public var innerWidth: CGFloat {
        return self.bounds.width;
    }
    
    public var innerHeight: CGFloat {
        return self.bounds.height;
    }
    
    public var horizontalCenter: CGFloat {
        return self.frame.midX;
    }
    
    public var verticalCenter: CGFloat {
        return self.frame.midY;
    }
    
    public var horizontalInnerCenter: CGFloat {
        return self.bounds.midX;
    }
    
    public var verticalInnerCenter: CGFloat {
        return self.bounds.midY;
    }
    
    
    // MARK: Public Methods -
    
    public func handleKeyboardNotification(_ notification: Notification, animation: (_ keyboardRect: CGRect, _ duration: TimeInterval, _ animationOptions: UIViewAnimationOptions) -> (), completion: ((Bool)->())?) {
        var duration: TimeInterval = 0.25
        
        if let d = (notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            duration = d.doubleValue as TimeInterval
        }
        
        
        var animationOptions = UIViewAnimationOptions.curveLinear
        
        if let c = (notification as NSNotification).userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
            animationOptions = UIViewAnimationOptions(rawValue: UInt(c.uintValue))
        }
        
        
        var rect = CGRect.zero
        
        if let r = (notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            rect = r.cgRectValue
        }
        
        animation(rect, duration, animationOptions)
        
        self.setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration, delay: 0.0, options: animationOptions, animations: { () -> Void in
            self.layoutIfNeeded()
            }, completion: completion)
    }
    
    public func shake(x: CGFloat = 8, y: CGFloat = 0, z: CGFloat = 0, duration: CFTimeInterval = 7/100) {
        let anim = CAKeyframeAnimation(keyPath: "transform")
        anim.values = [
            NSValue(caTransform3D: CATransform3DTranslate(layer.transform, -x, -y, -z)),
            NSValue(caTransform3D: CATransform3DTranslate(layer.transform, x, y, z))
        ]
        
        anim.autoreverses = true
        anim.repeatCount = 2
        anim.duration = duration
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        self.layer.add( anim, forKey: nil)
    }
    
    public func firstSubview<T: UIView>(ofType type: T.Type) -> T? {
        return self.subviews.flatMap{ $0 as? T }.first
    }

}
