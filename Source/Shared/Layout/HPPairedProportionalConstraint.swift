//
//  HPPairedProportionalConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/24/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

class HPPairedProportionalConstraint: NSObject {

    private (set) public var sourceAttribute: NSLayoutConstraint.Attribute
    private (set) public var targetAttribute: NSLayoutConstraint.Attribute
    private (set) public var proportionalityConstant: CGFloat
    private (set) public var screenSize: CGSize
    
    init(sourceAttribute: NSLayoutConstraint.Attribute,
         targetAttribute: NSLayoutConstraint.Attribute,
         proportionalityConstant: CGFloat,
         screenSize: CGSize) {
        self.sourceAttribute = sourceAttribute
        self.targetAttribute = targetAttribute
        self.proportionalityConstant = proportionalityConstant
        self.screenSize = screenSize
        super.init()
    }

    func applyConstraint(source: ViewClass, target: ViewClass) -> NSLayoutConstraint {
        let yConstant = (proportionalityConstant * screenSize.height).halfPointAligned
        let xConstant = (proportionalityConstant * screenSize.width).halfPointAligned
        switch targetAttribute {
        case .top, .centerY, .bottom:
            return NSLayoutConstraint(item: source,
                                      attribute: sourceAttribute,
                                      relatedBy: .equal,
                                      toItem: target,
                                      attribute: targetAttribute,
                                      multiplier: 1.0,
                                      constant: yConstant)
        case .height:
            return NSLayoutConstraint(item: source,
                                      attribute: sourceAttribute,
                                      relatedBy: .equal,
                                      toItem: nil,
                                      attribute: .notAnAttribute,
                                      multiplier: 1.0,
                                      constant: yConstant)
        case .left, .leading, .centerX, .right, .trailing:
            return NSLayoutConstraint(item: source,
                                      attribute: sourceAttribute,
                                      relatedBy: .equal,
                                      toItem: target,
                                      attribute: targetAttribute,
                                      multiplier: 1.0,
                                      constant: xConstant)
        case .width:
            return NSLayoutConstraint(item: source,
                                      attribute: sourceAttribute,
                                      relatedBy: .equal,
                                      toItem: nil,
                                      attribute: .notAnAttribute,
                                      multiplier: 1.0,
                                      constant: xConstant)
        default:
            assert(false, "Layout attribute not supported: \(targetAttribute)")
        }
    }
}
