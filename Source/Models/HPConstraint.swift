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
    case right             = 0x001
    case width             = 0x002
    case left              = 0x004
    case bottom            = 0x008
    case height            = 0x010
    case top               = 0x020
    case centerX           = 0x040
    case centerY           = 0x080
    case verticalSpacing   = 0x100
    case horizontalSpacing = 0x200
    
    public var sourceAttribute: NSLayoutConstraint.Attribute {
        switch self {
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .centerY:
            return .centerY
        case .left:
            return .leading
        case .right:
            return .trailing
        case .centerX:
            return .centerX
        case .width:
            return .width
        case .height:
            return .height
        case .verticalSpacing:
            return .bottom
        case .horizontalSpacing:
            return .trailing
        }
    }
    
    public var targetAttribute: NSLayoutConstraint.Attribute {
        switch self {
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .centerY:
            return .centerY
        case .left:
            return .leading
        case .right:
            return .trailing
        case .centerX:
            return .centerX
        case .width:
            return .notAnAttribute
        case .height:
            return .notAnAttribute
        case .verticalSpacing:
            return .top
        case .horizontalSpacing:
            return .leading
        }
    }
}

public struct HPConstraint: Codable {
    public let type: HPConstraintType
    public let values: [CGFloat]
    public let proportionalValues: [CGFloat]
    public let isProportional: Bool
}
