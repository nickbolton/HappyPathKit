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

public struct HPFill: Codable {
    public let blendMode: Int32
    public let opacity: CGFloat
    public let color: SKBackgroundColor
    public let gradient: HPGradient?
    public var cgBlendMode: CGBlendMode { return CGBlendMode(rawValue: blendMode) ?? .normal }
}
