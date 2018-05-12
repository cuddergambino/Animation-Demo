//
//  UIColorExtensions.swift
//  BoundlessKit
//
//  Created by Akash Desai on 12/1/17.
//

import Foundation

public extension UIColor {
    
    class func from(rgb: String, alpha: CGFloat = 1.0, defaultColor: UIColor = .gray) -> UIColor {
        return UIColor.from(rgba: rgb, defaultColor: defaultColor).withAlphaComponent(alpha)
    }
    
    /// This function takes a hex string and alpha value and returns its UIColor
    ///
    /// - parameters:
    ///     - rgb: A hex string with either format `"#ffffff"` or `"ffffff"` or `"#FFFFFF"`.
    ///     - alpha: The alpha value to apply to the color, default is 1.0 for opaque
    ///
    /// - returns:
    ///     The corresponding UIColor for valid hex strings, `UIColor.grayColor()` otherwise.
    ///
    class func from(rgba: String, defaultColor: UIColor = .gray) -> UIColor {
        var colorString:String = rgba.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (colorString.hasPrefix("#")) {
            colorString.removeFirst()
        }
        
        if colorString.count == 6 {
            colorString += "FF"
        } else if colorString.count != 8 {
            return defaultColor
        }
        
        var rgbaValue:UInt32 = 0
        Scanner(string: colorString).scanHexInt32(&rgbaValue)
        
        return UIColor(
            red: CGFloat((rgbaValue & 0xFF000000) >> 24) / 255.0,
            green: CGFloat((rgbaValue & 0x00FF0000) >> 16) / 255.0,
            blue: CGFloat((rgbaValue & 0x0000FF00) >> 8) / 255.0,
            alpha: CGFloat(rgbaValue & 0x000000FF) / 255.0
        )
    }
}

