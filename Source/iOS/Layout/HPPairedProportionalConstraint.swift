//
//  HPPairedProportionalConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/24/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

class HPPairedProportionalConstraint: NSObject {

    private (set) public var sourceAttribute: NSLayoutConstraint.Attribute
    private (set) public var targetAttribute: NSLayoutConstraint.Attribute
    private (set) public var proportionalityConstant: CGFloat
    
    init(sourceAttribute: NSLayoutConstraint.Attribute,
         targetAttribute: NSLayoutConstraint.Attribute,
         proportionalityConstant: CGFloat) {
        self.sourceAttribute = sourceAttribute
        self.targetAttribute = targetAttribute
        self.proportionalityConstant = proportionalityConstant
        super.init()
    }

    func applyConstraint(source: UIView, target: UIView) -> NSLayoutConstraint {
        let yConstant = proportionalityConstant * UIScreen.main.bounds.height
        let xConstant = proportionalityConstant * UIScreen.main.bounds.width
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
