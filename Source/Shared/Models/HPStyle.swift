//
//  HPStyle.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/23/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public struct HPStyle: Codable {
    public let opacity: CGFloat
    public let fills: [HPFill]
    public let borders: [HPBorder]
    public let backgroundColor: SKBackgroundColor?
    public let cornerRadius: CGFloat
    
    public init(opacity: CGFloat = 1.0, fills: [HPFill] = [], borders: [HPBorder] = [], backgroundColor: SKBackgroundColor? = nil, cornerRadius: CGFloat = 0.0) {
        self.opacity = opacity
        self.fills = fills
        self.borders = borders
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
}
