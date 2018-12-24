//
//  HPBaseAnchorConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

public class HPBaseAnchorConstraint: NSObject {
    private (set) public var constraint: HPConstraint
    private (set) public var layers: [HPLayer]
    init(constraint: HPConstraint, layers: [HPLayer]) {
        self.constraint = constraint
        self.layers = layers
        super.init()
        guard layers.count > 0 else {
            assert(false, "You must provide at least one layer.")
        }
    }
    
    public func applyConstraint(to views: [UIView]) -> NSLayoutConstraint {
        if views.count == 2 {
            assert(constraint.values.count > 0, "No value was supplied")
            assert(constraint.values.count == 1, "Multiple values were supplied")
            assert(layers.count == views.count, "Layers didn't match views")
            let value = constraint.isProportional ? constraint.proportionalValues.first! : constraint.values.first!
            return applyConstraint(source: views[0], target: views[1], value: value)
        } else if views.count == 1 {
            assert(constraint.values.count > 0, "No value was supplied")
            assert(constraint.values.count == 1, "Multiple values were supplied")
            assert(layers.count == views.count, "Layers didn't match views")
            guard let parent = views[0].superview else {
                assert(false, "View must be part of a view hierarchy.")
            }
            let value = constraint.isProportional ? constraint.proportionalValues.first! : constraint.values.first!
            return applyConstraint(source: views[0], target: parent, value: value)
        }
        assert(false, "Unimplemented")
    }
    
    internal func applyConstraint(source: UIView, target: UIView, value: CGFloat) -> NSLayoutConstraint {
        assert(false, "Unimplemented")
    }
}
