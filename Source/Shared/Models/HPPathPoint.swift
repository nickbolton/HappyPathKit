//
//  HPPathPoint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/30/18.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public struct HPPathPoint: Codable {
    public let point: CGPoint
    public let curveMode: SKCurveMode
    public let curveFrom: CGPoint?
    public let curveTo: CGPoint?
    public let cornerRadius: CGFloat
}
