//
//  Async.swift
//  KSquareKit
//
//  Created by Karthik Keyan on DateTime.now().
//  Copyright © KSquareKit. All rights reserved.
//

import Foundation

private let kSecondToMilliSecondConvertingConstant: Double = 1000

public typealias AsyncCloser = () -> ()

public final class Async {
    
    public class func main(_ closer: @escaping AsyncCloser) {
        DispatchQueue.main.async(execute: closer)
    }
    
    public class func global(_ closer: @escaping  AsyncCloser) {
        DispatchQueue.global().async(execute: closer)
    }
    
    public class func after(_ interval: TimeInterval, queue: DispatchQueue? = nil, closer: @escaping AsyncCloser) {
        let intervalInMillisecond = Int(interval * kSecondToMilliSecondConvertingConstant)
        let delay = DispatchTime.now() + .milliseconds(intervalInMillisecond)
        
        let executionQueue = queue ?? DispatchQueue.main
        executionQueue.asyncAfter(deadline: delay, execute: closer)
    }
    
    public class func background(_ closure: @escaping AsyncCloser) {
        DispatchQueue.global(qos: .background).async(execute: closure)
    }
    
}
