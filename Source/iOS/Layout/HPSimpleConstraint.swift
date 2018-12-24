//
//  HPSimpleConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/24/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

class HPSimpleConstraint: NSObject {

    private (set) public var constant: CGFloat
    private (set) public var attribute: NSLayoutConstraint.Attribute

    init(attribute: NSLayoutConstraint.Attribute, constant: CGFloat) {
        self.attribute = attribute
        self.constant = constant
        super.init()
    }

    func applyConstraint(to view: UIView) -> NSLayoutConstraint {
        switch attribute {
        case .width, .height:
            return NSLayoutConstraint(item: view,
                                      attribute: attribute,
                                      relatedBy: .equal,
                                      toItem: nil,
                                      attribute: .notAnAttribute,
                                      multiplier: 1.0,
                                      constant: constant)
        default:
            assert(view.superview != nil, "View must be part of a view hierarchy.")
            return NSLayoutConstraint(item: view,
                                      attribute: attribute,
                                      relatedBy: .equal,
                                      toItem: view.superview,
                                      attribute: attribute,
                                      multiplier: 1.0,
                                      constant: constant)
        }
    }
}
