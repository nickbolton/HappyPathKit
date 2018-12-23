//
//  HPConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/21/18.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public enum HPConstraintType: Int, Codable {
    case right   = 0x01
    case width   = 0x02
    case left    = 0x04
    case bottom  = 0x08
    case height  = 0x10
    case top     = 0x20
    case centerX = 0x40
    case centerY = 0x80
}

public struct HPConstraint: Codable {
    public let type: HPConstraintType
    public let value: CGFloat
    public let isProportional: Bool
}
