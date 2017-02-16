//
//  Utilities.swift
//  KSquareKit
//
//  Created by Karthikkeyan on 8/27/16.
//  Copyright © 2016 KSquareKit. All rights reserved.
//

import UIKit

// Mark: - UI Utilities

public extension CGFloat {
    
    public static var hidden: CGFloat { return 0.0 }
    
    public static var visible: CGFloat { return 1.0 }
    
    public static var disabled: CGFloat { return 0.5 }
    
}

public extension Double {
    
    public var toRadians: Double {
        return Double(self * (M_PI/180.0))
    }
    
    public var toDegree: Double {
        return Double(self * (180.0/M_PI))
    }
    
    public var toFahrenheit: Double {
        return (self * 9.0)/5.0 + 32.0
    }
    
    public var toCelcius: Double {
        return (self - 32.0) * 5.0/9.0
    }
    
    public var toKiloMeters: Double {
        return self * 1.60934
    }
    
    public var toMiles: Double {
        return self/1.60934
    }
    
    
}

public extension Int {
    
    public var toRadians: Int {
        return Int(Double(self).toRadians)
    }
    
    public var toDegree: Int {
        return Int(Double(self).toDegree)
    }
    
    public var toFahrenheit: Int {
        return Int(round(Double(self).toFahrenheit))
    }
    
    public var toCelcius: Int {
        return Int(round(Double(self).toCelcius))
    }
    
    public var toKiloMeters: Int {
        return Int(Double(self).toKiloMeters)
    }
    
    public var toMiles: Int {
        return Int(Double(self).toMiles)
    }
    
}

public extension Float {
    
    public var toRadians: Float {
        return Float(Double(self).toRadians)
    }
    
    public var toDegree: Float {
        return Float(Double(self).toDegree)
    }
    
    public var toFahrenheit: Float {
        return Float(Double(self).toFahrenheit)
    }
    
    public var toCelcius: Float {
        return Float(Double(self).toCelcius)
    }
    
    public var toKiloMeters: Float {
        return Float(Double(self).toKiloMeters)
    }
    
    public var toMiles: Float {
        return Float(Double(self).toMiles)
    }
    
}


public struct Console {
    
    public static func log(_ message: Any) {
        #if DEBUG
        print(message)
        #endif
    }
    
}


// MARK: - NSRange

extension NSRange {
    /// For calculating range
    /// - parameter string: Input string that will passed for calculating range
    /// - Returns: Range for the input string
    
    func toRange(string: String) -> Range<String.Index> {
        let startIndex = string.index(string.startIndex, offsetBy: location)
        let endIndex = string.index(string.startIndex, offsetBy: length)
        return startIndex..<endIndex
    }
    
}

