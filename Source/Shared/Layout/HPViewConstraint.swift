//
//  HPViewConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public class HPViewConstraint: NSObject {
    private (set) public var constraint: HPConstraint
    private (set) public var layers: [HPLayer]
    private (set) public var isSafeArea: Bool
    private (set) public var screenSize: CGSize
    init(constraint: HPConstraint, layers: [HPLayer], isSafeArea: Bool, screenSize: CGSize) {
        self.constraint = constraint
        self.layers = layers
        self.isSafeArea = isSafeArea
        self.screenSize = screenSize
        super.init()
        guard layers.count > 0 else {
            assert(false, "You must provide at least one layer.")
        }
    }
    
    public func applyConstraint(to views: [ViewClass], screenSize: CGSize) -> NSLayoutConstraint {
        if views.count == 2 {
            assert(layers.count == views.count, "Layers didn't match views")
            if constraint.isProportional {
                return buildPairedProportionalConstraint(source: views[0], target: views[1])
            }
            return buildPairedConstraint(source: views[0], target: views[1])
        } else if views.count == 1 {
            assert(layers.count == views.count, "Layers didn't match views")
            if constraint.isProportional {
                return buildSimpleProportionalConstraint(layer: layers[0], view: views[0], screenSize: screenSize)
            }
            return buildSimpleConstraint(layer: layers[0], view: views[0])
        }
        assert(false, "Unimplemented")
    }
    
    private func buildSimpleProportionalConstraint(layer: HPLayer, view: ViewClass, screenSize: CGSize) -> NSLayoutConstraint {
        let builder = HPSimpleProportionalConstraint(attribute: constraint.type.sourceAttribute,
                                                     proportionalityConstant: constraint.proportionalValue,
                                                     isSafeArea: isSafeArea,
                                                     screenSize: screenSize)
        return builder.applyConstraint(to: view)
    }
    
    private func buildSimpleConstraint(layer: HPLayer, view: ViewClass) -> NSLayoutConstraint {
        let builder = HPSimpleConstraint(attribute: constraint.type.sourceAttribute,
                                         constant: constraint.value,
                                         isSafeArea: isSafeArea)
        return builder.applyConstraint(to: view)
    }
    
    private func buildPairedProportionalConstraint(source: ViewClass, target: ViewClass) -> NSLayoutConstraint {
        let builder = HPPairedProportionalConstraint(sourceAttribute: constraint.type.sourceAttribute,
                                                     targetAttribute: constraint.type.targetAttribute,
                                                     proportionalityConstant: constraint.proportionalValue,
                                                     screenSize: screenSize)
        return builder.applyConstraint(source: source, target: target)
    }
    
    private func buildPairedConstraint(source: ViewClass, target: ViewClass) -> NSLayoutConstraint {
        let builder = HPPairedConstraint(sourceAttribute: constraint.type.sourceAttribute,
                                         targetAttribute: constraint.type.targetAttribute,
                                         constant: constraint.value)
        return builder.applyConstraint(source: source, target: target)
    }
    
    internal func applyConstraint(source: ViewClass, target: ViewClass, value: CGFloat) -> NSLayoutConstraint {
        assert(false, "Unimplemented")
    }
}
