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
    case right             = 0x0001
    case width             = 0x0002
    case left              = 0x0004
    case bottom            = 0x0008
    case height            = 0x0010
    case top               = 0x0020
    case centerX           = 0x0040
    case centerY           = 0x0080
    case verticalSpacing   = 0x0100
    case horizontalSpacing = 0x0200
    case verticalCenters   = 0x0400
    case horizontalCenters = 0x0800
    case safeArea          = 0x1000

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
        case .verticalCenters:
            return .centerY
        case .horizontalCenters:
            return .centerX
        case .safeArea:
            return .notAnAttribute
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
        case .verticalCenters:
            return .centerY
        case .horizontalCenters:
            return .centerX
        case .safeArea:
            return .notAnAttribute
        }
    }
}

public struct HPConstraint: Codable {
    public let sourceID: String
    public let targetID: String?
    public let type: HPConstraintType
    public let value: CGFloat
    public let proportionalValue: CGFloat
    public let isProportional: Bool
    
    public init(sourceID: String,
                targetID: String? = nil,
                type: HPConstraintType,
                value: CGFloat,
                proportionalValue: CGFloat = 0.0,
                isProportional: Bool = false) {
        self.sourceID = sourceID
        self.targetID = targetID
        self.type = type
        self.value = value
        self.proportionalValue = proportionalValue
        self.isProportional = isProportional
    }
}
