//
//  CircularSeeker.swift
//  KSquareKit
//
//  Created by Karthikkeyan on 11/21/15.
//  Copyright © 2015 KSquareKit. All rights reserved.
//

import UIKit

public func degreeToRadian(_ degree: Double) -> Double {
    return Double(degree * (M_PI/180))
}

public func radianToDegree(_ radian: Double) -> Double {
    return Double(radian * (180/M_PI))
}

private let kDefaultThumbSize: CGFloat = 20

private let kDefaultPathWidth: CGFloat = 4

private let kMaximumAngleInDegree: Double = 360.0

private let kThumbGrabbedSizeInset: CGFloat = -20

private let kThumbGrabbedScale: CGFloat = 1.2

private let kThumbGrabbedAnimationDuration: TimeInterval = 0.2


@IBDesignable
open class CircularSeeker: UIControl {
    
    open lazy var pathLayer = CAShapeLayer()
    
    open lazy var progressLayer = CAShapeLayer()
    
    open lazy var gradientPathLayer = CAGradientLayer()
    
    open lazy var thumbButton = UIButton(type: .custom)
    
    
    @IBInspectable open var thumbSize: CGFloat = kDefaultThumbSize {
        didSet {
            thumbButton.frame = CGRect(x: 0, y: 0, width: thumbSize, height: thumbSize)
            thumbButton.layer.cornerRadius = thumbSize * 0.5
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var pathWidth: CGFloat = kDefaultPathWidth {
        didSet {
            pathLayer.lineWidth = pathWidth
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable open var pathBeginColor: UIColor {
        didSet {
            updateGradientColors()
        }
    }
    
    @IBInspectable open var pathEndColor: UIColor {
        didSet {
            updateGradientColors()
        }
    }
    
    @IBInspectable open var progressWidth: CGFloat = kDefaultPathWidth {
        didSet {
            progressLayer.lineWidth = progressWidth
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable open var progressColor: UIColor {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable open var thumbColor: UIColor {
        didSet {
            thumbButton.backgroundColor = thumbColor
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable open var startAngle: Float = 0.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable open var endAngle: Float = 0.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable open var currentAngle: Float = 0.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        initSubViews()
    }
    
    override public init(frame: CGRect) {
        pathBeginColor = UIColor.gray
        pathEndColor = UIColor.gray
        progressColor = UIColor.blue
        thumbColor = UIColor.red
        
        super.init(frame: frame)
        
        initSubViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        pathBeginColor = UIColor.gray
        pathEndColor = UIColor.gray
        progressColor = UIColor.blue
        thumbColor = UIColor.red
        
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Private Methods -
    
    fileprivate func initSubViews() {
        addSeekerBar()
        addThumb()
    }
    
    fileprivate func addSeekerBar() {
        pathLayer.lineWidth = pathWidth
        pathLayer.lineCap = kCALineCapRound
        pathLayer.strokeColor = pathBeginColor.cgColor
        pathLayer.fillColor = UIColor.clear.cgColor
        
        let gradiantPaddingX: CGFloat = 0.25
        let gradiantMaximumRatio: CGFloat = 1.0
        gradientPathLayer.frame =  CGRect(origin: CGPoint.zero, size: self.bounds.size)
        gradientPathLayer.startPoint = CGPoint(x: gradiantPaddingX, y: gradiantMaximumRatio)
        gradientPathLayer.endPoint = CGPoint(x: gradiantMaximumRatio - gradiantPaddingX, y: gradiantMaximumRatio)
        gradientPathLayer.mask = pathLayer
        layer.addSublayer(gradientPathLayer)
        
        updateGradientColors()
        
        progressLayer.lineWidth = progressWidth
        progressLayer.lineCap = kCALineCapRound
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        if progressLayer.superlayer == nil {
            layer.addSublayer(progressLayer)
        }
        
        updatePath()
        updateProgress()
    }
    
    fileprivate func addThumb() {
        thumbButton.frame = CGRect(x: 0, y: 0, width: thumbSize, height: thumbSize)
        thumbButton.backgroundColor = thumbColor
        thumbButton.layer.masksToBounds = true
        thumbButton.isUserInteractionEnabled = false
        self.addSubview(thumbButton)
    }
    
    fileprivate func updateThumbPosition() {
        let angle = degreeToRadian(Double(angleForThumb()))
        
        let x = cos(angle)
        let y = sin(angle)
        
        var rect = thumbButton.frame
        
        let center = CGPoint(x: self.frame.size.width/2.0, y: self.frame.size.width/2.0)
        
        let thumbCenter: CGFloat = thumbSize/2.0
        let inset = thumbCenter + (pathWidth * 2)
        let radius = (self.bounds.size.width - inset)/2.0
        
        
        // x = cos(angle) * radius + CenterX;
        let finalX = (CGFloat(x) * radius) + center.x
        
        // y = sin(angle) * radius + CenterY;
        let finalY = (CGFloat(y) * radius) + center.y
        
        rect.origin.x = finalX - thumbCenter
        rect.origin.y = finalY - thumbCenter
        
        thumbButton.frame = rect
    }
    
    fileprivate func updatePath() {
        let center = CGPoint(x: self.bounds.size.width/2.0, y: self.bounds.size.height/2.0)
        
        let sAngle = degreeToRadian(Double(startAngle))
        let eAngle = degreeToRadian(Double(endAngle))
        
        let inset = (thumbSize/2.0) + (pathWidth * 2)
        let path = UIBezierPath(arcCenter: center, radius: (self.bounds.size.width - inset)/2.0, startAngle: CGFloat(sAngle), endAngle: CGFloat(eAngle), clockwise: true)
        pathLayer.path = path.cgPath
    }
    
    fileprivate func updateProgress() {
        let center = CGPoint(x: self.bounds.size.width/2.0, y: self.bounds.size.height/2.0)
        
        let sAngle = degreeToRadian(Double(startAngle))
        let eAngle = degreeToRadian(Double(angleForProgress()))
        
        let inset = (thumbSize/2.0) + (progressWidth * 2)
        let path = UIBezierPath(arcCenter: center, radius: (self.bounds.size.width - inset)/2.0, startAngle: CGFloat(sAngle), endAngle: CGFloat(eAngle), clockwise: true)
        progressLayer.path = path.cgPath
    }
    
    fileprivate func thumbMoveDidComplete() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [ .curveEaseOut, .beginFromCurrentState ], animations: { () -> Void in
            self.thumbButton.transform = CGAffineTransform.identity
            }, completion: { [weak self] _ in
                self?.fireValueChangeEvent()
            })
    }
    
    fileprivate func fireValueChangeEvent() {
        self.sendActions(for: .valueChanged)
    }
    
    fileprivate func degreeForLocation(_ location: CGPoint) -> Double {
        let dx = location.x - (self.frame.size.width/2.0)
        let dy = location.y - (self.frame.size.height/2.0)
        
        let angle = Double(atan2(Double(dy), Double(dx)))
        
        var degree = radianToDegree(angle)
        if degree < 0 {
            degree = kMaximumAngleInDegree + degree
        }
        
        return degree
    }
    
    fileprivate func moveToPoint(_ point: CGPoint) -> Bool {
        var degree = degreeForLocation(point)
        
        func moveToClosestEdge(_ degree: Double) {
            let startDistance = fabs(Float(degree) - startAngle)
            let endDistance = fabs(Float(degree) - endAngle)
            
            if startDistance < endDistance {
                currentAngle = startAngle
            }
            else {
                currentAngle = endAngle
            }
        }
        
        if startAngle > endAngle {
            if degree < Double(startAngle) && degree > Double(endAngle) {
                moveToClosestEdge(degree)
                thumbMoveDidComplete()
                return false
            }
        }
        else {
            if degree > Double(endAngle) || degree < Double(startAngle) {
                moveToClosestEdge(degree)
                thumbMoveDidComplete()
                return false
            }
        }
        
        currentAngle = Float(degree)
        
        return true;
    }
    
    fileprivate func updateGradientColors() {
        let colors = [ pathBeginColor, pathEndColor ]
        gradientPathLayer.colors = colors.map { $0.cgColor }
        setNeedsLayout()
    }
    
    
    // MARK: - Public Methods
    
    open func moveToAngle(_ angle: Float, duration: CFTimeInterval) {
        let center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        
        let sAngle = degreeToRadian(Double(startAngle))
        let eAngle = degreeToRadian(Double(angle))
        
        
        CATransaction.begin()
        
        var inset = (thumbSize/2.0) + (pathWidth * 2)
        var path = UIBezierPath(arcCenter: center, radius: (self.bounds.size.width - inset) * 0.5, startAngle: CGFloat(sAngle), endAngle: CGFloat(eAngle), clockwise: true)
        
        let thumbAnimation = CAKeyframeAnimation(keyPath: "position")
        thumbAnimation.duration = duration
        thumbAnimation.path = path.cgPath
        thumbAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        thumbButton.layer.add(thumbAnimation, forKey: "moveToAngle")
        
        
        inset = (thumbSize/2.0) + (progressWidth * 2)
        path = UIBezierPath(arcCenter: center, radius: (self.bounds.size.width - inset) * 0.5, startAngle: CGFloat(sAngle), endAngle: CGFloat(eAngle), clockwise: true)
        progressLayer.path = path.cgPath
        
        let progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        progressAnimation.duration = duration
        progressAnimation.fromValue = NSNumber(value: 0.0 as Float)
        progressAnimation.toValue = NSNumber(value: 1.0 as Float)
        progressAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        progressLayer.add(progressAnimation, forKey: "progress")
        
        CATransaction.setCompletionBlock { [weak self] in
            self?.currentAngle = angle
        }
        CATransaction.commit()
    }
    
    open func angleForThumb() -> Float {
        return currentAngle
    }
    
    open func angleForProgress() -> Float {
        return currentAngle
    }
    
    
    // MARK: - Touch Events
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        
        let rect = self.thumbButton.frame.insetBy(dx: kThumbGrabbedSizeInset, dy: kThumbGrabbedSizeInset)
        
        let canBegin = rect.contains(point)
        
        if canBegin {
            UIView.animate(withDuration: kThumbGrabbedAnimationDuration, delay: 0.0, options: [ .curveEaseIn, .beginFromCurrentState ], animations: { () -> Void in
                self.thumbButton.transform = CGAffineTransform(scaleX: kThumbGrabbedScale, y: kThumbGrabbedScale)
                }, completion: nil)
        }
        
        return canBegin
    }
    
    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard let coalescedTouches = event?.coalescedTouches(for: touch) else {
            return moveToPoint(touch.location(in: self))
        }
        
        let result = true
        for cTouch in coalescedTouches {
            let result = moveToPoint(cTouch.location(in: self))
            
            if result == false { break }
        }
        
        return result
    }
    
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        thumbMoveDidComplete()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        updatePath()
        updateThumbPosition()
        updateProgress()
        
        gradientPathLayer.frame = bounds
    }
    
}
