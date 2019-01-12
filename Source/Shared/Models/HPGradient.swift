//
//  HPGradient.swift
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

public struct HPGradient: Codable, Inspectable {
    public let stops: [HPStop]
    public let gradientType: SKLayerGradientType
    public let from: CGPoint
    public let to: CGPoint

    public init(stops: [HPStop], gradientType: SKLayerGradientType, from: CGPoint, to: CGPoint) {
        self.stops = stops
        self.gradientType = gradientType
        self.from = from
        self.to = to
    }
}
