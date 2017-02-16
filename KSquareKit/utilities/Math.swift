//
//  Math.swift
//  KSquareKit
//
//  Created by Karthikkeyan on 10/12/15.
//  Copyright © 2015 KSquareKit. All rights reserved.
//

import UIKit

public final class Math {
    
    // Method finds 'Y' value for given 'X' value in cartesian coordinate by making use of given (x1, y1) & (x2, y2)
    // To do so the function uses 'y = mx + c' formula
    public class func straightLineY(_ x: Float, x1: Float, x2: Float, y1: Float, y2: Float) -> Float {
        // c = y - mx       where y = any y, x = any x
        
        let m = (y2 - y1)/(x2 - x1)
        let c = y1 - (m * x1)
        
        let y = (m * x) + c
        
        return y
    }
    
    public class func convert(imageSize: CGSize, toScrollSize scrollSize: CGSize, forContentMode contentMode: UIViewContentMode) -> CGSize {
        let ratio = aspectScaleRatio(fromSize: imageSize, toSize: scrollSize, forContentMode: contentMode)
        
        var targetSize = CGSize.zero
        targetSize.width = imageSize.width * ratio
        targetSize.height = imageSize.height * ratio
        
        return targetSize
    }
    
    public class func aspectScaleRatio(fromSize: CGSize, toSize: CGSize, forContentMode contentMode: UIViewContentMode) -> CGFloat {
        let ratioX = toSize.width / fromSize.width
        
        let ratioY = toSize.height / fromSize.height
        
        var scale: CGFloat = 0.0
        
        switch contentMode {
        case .scaleAspectFit:
            scale = (ratioX < ratioY) ? ratioX : ratioY
            
        case .scaleAspectFill:
            scale = (ratioX > ratioY) ? ratioX : ratioY
            
        default:
            scale = 1.0;
            break
        }
        
        return scale
    }
    
    public class func convert(rect cropRect: CGRect, toAssetCoordinate assetResolution: CGSize, withZoomScale zoomScale: CGFloat, contentMode: UIViewContentMode) -> CGRect {
        // Content offset could be negative values,
        // we dont need negative values when cropping
        // so converting it into positive values
        var cropRect = cropRect
        if cropRect.origin.x < 0 {
            cropRect.origin.x *= -1
        }
        
        if cropRect.origin.y < 0 {
            cropRect.origin.y *= -1
        }
        
        
        // Finding scrollview's content size for the scrollview frame
        // of course, we could have created one more function parameter for content size
        // but we are calculating it again just reduce many function parameters
        let initialRatio = aspectScaleRatio(fromSize: assetResolution, toSize: cropRect.size, forContentMode: contentMode)
        
        let initialContentSize = CGSize(width: assetResolution.width * initialRatio, height: assetResolution.height * initialRatio)
        
        
        // Find the ratio between the actuall image size and the content size
        let imageSpaceRatio = assetResolution.width / initialContentSize.width
        
        
        // Now we are converting crop rect (or visible area in the scroll view) to image coordination
        // the final rect will obviously a bigger size rect
        var imageSpaceRect = CGRect.zero
        imageSpaceRect.origin.x = cropRect.origin.x * imageSpaceRatio
        imageSpaceRect.origin.y = cropRect.origin.y * imageSpaceRatio
        imageSpaceRect.size.width = cropRect.size.width * imageSpaceRatio
        imageSpaceRect.size.height = cropRect.size.height * imageSpaceRatio
        
        
        // Calculating zoom values
        imageSpaceRect.origin.x /= zoomScale
        imageSpaceRect.origin.y /= zoomScale
        imageSpaceRect.size.width /= zoomScale
        imageSpaceRect.size.height /= zoomScale
        
        return imageSpaceRect
    }
    
}
