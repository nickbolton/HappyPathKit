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
        self.init(displayP3Red: c.red / 255.0, green: c.green / 255.0, blue: c.blue / 255.0, alpha: c.alpha)
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
            self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
        }
    }
    #endif

}
