//
//  HPSimpleProportionalConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/24/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

class HPSimpleProportionalConstraint: NSObject {

    private (set) public var proportionalityConstant: CGFloat
    private (set) public var attribute: NSLayoutConstraint.Attribute
    private (set) public var isSafeArea: Bool

    init(attribute: NSLayoutConstraint.Attribute, proportionalityConstant: CGFloat, isSafeArea: Bool) {
        self.attribute = attribute
        self.proportionalityConstant = proportionalityConstant
        self.isSafeArea = isSafeArea
        super.init()
    }
    
    func applyConstraint(to view: UIView) -> NSLayoutConstraint {
        assert(view.superview != nil || attribute == .width || attribute == .height, "View must be part of a view hierarchy.")

        let yConstant = proportionalityConstant * UIScreen.main.bounds.height
        let xConstant = proportionalityConstant * UIScreen.main.bounds.width
        switch attribute {
        case .top, .centerY, .bottom:
            return NSLayoutConstraint(item: view,
                                      attribute: attribute,
                                      relatedBy: .equal,
                                      toItem: isSafeArea ? view.superview?.safeAreaLayoutGuide : view.superview,
                                      attribute: attribute,
                                      multiplier: 1.0,
                                      constant: yConstant)
        case .height:
            return NSLayoutConstraint(item: view,
                                      attribute: attribute,
                                      relatedBy: .equal,
                                      toItem: nil,
                                      attribute: .notAnAttribute,
                                      multiplier: 1.0,
                                      constant: yConstant)
        case .left, .leading, .centerX, .right, .trailing:
            return NSLayoutConstraint(item: view,
                                      attribute: attribute,
                                      relatedBy: .equal,
                                      toItem: isSafeArea ? view.superview?.safeAreaLayoutGuide : view.superview,
                                      attribute: attribute,
                                      multiplier: 1.0,
                                      constant: yConstant)
        case .width:
            return NSLayoutConstraint(item: view,
                                      attribute: attribute,
                                      relatedBy: .equal,
                                      toItem: nil,
                                      attribute: .notAnAttribute,
                                      multiplier: 1.0,
                                      constant: xConstant)
        default:
            assert(false, "Layout attribute not supported: \(attribute)")
        }
    }
}
