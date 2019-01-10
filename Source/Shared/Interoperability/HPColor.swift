//
//  HPColor.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/29/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

#if os(iOS)
import UIKit
public typealias HPColor = UIColor
#elseif os(macOS)
import Cocoa
public typealias HPColor = NSColor
#endif

extension HPColor {
    #if os(iOS)
    convenience init(backgroundColor bg: SKBackgroundColor) {
        let c = bg.color
        self.init(red: c.red / 255.0, green: c.green / 255.0, blue: c.blue / 255.0, alpha: c.alpha)
    }
    
    public func retrieveRed(_ red: UnsafeMutablePointer<CGFloat>?, green: UnsafeMutablePointer<CGFloat>?, blue: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) {
        getRed(red, green: green, blue: blue, alpha: alpha)
    }
    
    #elseif os(macOS)
    
    convenience init(backgroundColor bg: SKBackgroundColor) {
        let c = bg.color
        self.init(red: c.red / 255.0, green: c.green / 255.0, blue: c.blue / 255.0, alpha: c.alpha)
    }

    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        if red == green && red == blue {
            self.init(calibratedWhite: red, alpha: alpha)
        } else {
            self.init(calibratedRed: red, green: green, blue: blue, alpha: alpha)
        }
    }
    
    public func retrieveRed(_ red: UnsafeMutablePointer<CGFloat>?, green: UnsafeMutablePointer<CGFloat>?, blue: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) {        
        usingColorSpace(.extendedSRGB)?.getRed(red, green: green, blue: blue, alpha: alpha)
    }
    
    #endif

    public func color(withAlpha alpha: CGFloat) -> HPColor {
        var red: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var green: CGFloat = 0.0
        retrieveRed(&red, green: &green, blue: &blue, alpha: nil)
        return HPColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
