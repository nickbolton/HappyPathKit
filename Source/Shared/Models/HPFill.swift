//
//  HPFill.swift
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

public struct HPFill: Codable, Inspectable {
    public let color: SKBackgroundColor
    public let opacity: CGFloat
    public let gradient: HPGradient?
    public let blendMode: Int32
    public var cgBlendMode: CGBlendMode { return CGBlendMode(rawValue: blendMode) ?? .normal }
    
    public init(color: SKBackgroundColor,
                opacity: CGFloat,
                gradient: HPGradient?,
                blendMode: Int32) {
        self.color = color
        self.opacity = opacity
        self.gradient = gradient
        self.blendMode = blendMode
    }
}
