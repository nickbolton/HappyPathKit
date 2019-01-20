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
    let constraint: HPConstraint
    let sourceView: ViewClass
    let targetView: ViewClass?
    let scale: CGFloat
    private (set) public var isSafeArea: Bool
    init(constraint: HPConstraint, scale: CGFloat, isSafeArea: Bool, sourceView: ViewClass, targetView: ViewClass? = nil) {
        self.constraint = constraint
        self.scale = scale
        self.isSafeArea = isSafeArea
        self.sourceView = sourceView
        self.targetView = targetView
        super.init()
    }
    
    public func applyConstraint(screenSize: CGSize) -> NSLayoutConstraint {
        if let targetView = targetView {
            if constraint.isProportional {
                return buildPairedProportionalConstraint(source: sourceView, target: targetView, screenSize: screenSize)
            }
            return buildPairedConstraint(source: sourceView, target: targetView)
        }
        if constraint.isProportional {
            return buildSimpleProportionalConstraint(view: sourceView, screenSize: screenSize)
        }
        return buildSimpleConstraint(view: sourceView)
    }
    
    private func buildSimpleProportionalConstraint(view: ViewClass, screenSize: CGSize) -> NSLayoutConstraint {
        let builder = HPSimpleProportionalConstraint(attribute: constraint.type.sourceAttribute,
                                                     proportionalityConstant: constraint.proportionalValue,
                                                     isSafeArea: isSafeArea,
                                                     scale: scale,
                                                     screenSize: screenSize)
        return builder.applyConstraint(to: view)
    }
    
    private func buildSimpleConstraint(view: ViewClass) -> NSLayoutConstraint {
        let builder = HPSimpleConstraint(attribute: constraint.type.sourceAttribute,
                                         constant: constraint.value,
                                         scale: scale,
                                         isSafeArea: isSafeArea)
        return builder.applyConstraint(to: view)
    }
    
    private func buildPairedProportionalConstraint(source: ViewClass,
                                                   target: ViewClass,
                                                   screenSize: CGSize) -> NSLayoutConstraint {
        let builder = HPPairedProportionalConstraint(sourceAttribute: constraint.type.sourceAttribute,
                                                     targetAttribute: constraint.type.targetAttribute,
                                                     proportionalityConstant: constraint.proportionalValue,
                                                     scale: scale,
                                                     screenSize: screenSize)
        return builder.applyConstraint(source: source, target: target)
    }
    
    private func buildPairedConstraint(source: ViewClass, target: ViewClass) -> NSLayoutConstraint {
        let builder = HPPairedConstraint(sourceAttribute: constraint.type.sourceAttribute,
                                         targetAttribute: constraint.type.targetAttribute,
                                         constant: constraint.value,
                                         scale: scale)
        return builder.applyConstraint(source: source, target: target)
    }
    
    internal func applyConstraint(source: ViewClass, target: ViewClass, value: CGFloat) -> NSLayoutConstraint {
        assert(false, "Unimplemented")
    }
}
