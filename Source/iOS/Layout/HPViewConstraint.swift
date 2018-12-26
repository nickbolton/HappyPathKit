//
//  HPViewConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

public class HPViewConstraint: NSObject {
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
            assert(layers.count == views.count, "Layers didn't match views")
            if constraint.isProportional {
                return buildPairedProportionalConstraint(source: views[0], target: views[1])
            }
            return buildPairedConstraint(source: views[0], target: views[1])
        } else if views.count == 1 {
            assert(layers.count == views.count, "Layers didn't match views")
            if constraint.isProportional {
                return buildSimpleProportionalConstraint(layer: layers[0], view: views[0])
            }
            return buildSimpleConstraint(layer: layers[0], view: views[0])
        }
        assert(false, "Unimplemented")
    }
    
    private func buildSimpleProportionalConstraint(layer: HPLayer, view: UIView) -> NSLayoutConstraint {
        let builder = HPSimpleProportionalConstraint(attribute: constraint.type.sourceAttribute,
                                                     proportionalityConstant: constraint.proportionalValue,
                                                     isSafeArea: layer.componentConfig?.isSafeArea ?? false)
        return builder.applyConstraint(to: view)
    }
    
    private func buildSimpleConstraint(layer: HPLayer, view: UIView) -> NSLayoutConstraint {
        let builder = HPSimpleConstraint(attribute: constraint.type.sourceAttribute,
                                         constant: constraint.value,
                                         isSafeArea: layer.componentConfig?.isSafeArea ?? false)
        return builder.applyConstraint(to: view)
    }
    
    private func buildPairedProportionalConstraint(source: UIView, target: UIView) -> NSLayoutConstraint {
        let builder = HPPairedProportionalConstraint(sourceAttribute: constraint.type.sourceAttribute,
                                                     targetAttribute: constraint.type.targetAttribute,
                                                     proportionalityConstant: constraint.proportionalValue)
        return builder.applyConstraint(source: source, target: target)
    }
    
    private func buildPairedConstraint(source: UIView, target: UIView) -> NSLayoutConstraint {
        let builder = HPPairedConstraint(sourceAttribute: constraint.type.sourceAttribute,
                                         targetAttribute: constraint.type.targetAttribute,
                                         constant: constraint.value)
        return builder.applyConstraint(source: source, target: target)
    }
    
    internal func applyConstraint(source: UIView, target: UIView, value: CGFloat) -> NSLayoutConstraint {
        assert(false, "Unimplemented")
    }
}
