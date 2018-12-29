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
    convenience init(backgroundColor bg: SKBackgroundColor) {
        let c = bg.color
        self.init(displayP3Red: c.red / 255.0, green: c.green / 255.0, blue: c.blue / 255.0, alpha: c.alpha)
    }
}
