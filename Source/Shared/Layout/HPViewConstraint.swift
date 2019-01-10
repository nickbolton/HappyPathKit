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
    private (set) public var isSafeArea: Bool
    init(constraint: HPConstraint, isSafeArea: Bool) {
        self.constraint = constraint
        self.isSafeArea = isSafeArea
        super.init()
    }
    
    public func applyConstraint(to views: [ViewClass], screenSize: CGSize) -> NSLayoutConstraint {
        if views.count == 2 {
            if constraint.isProportional {
                return buildPairedProportionalConstraint(source: views[0], target: views[1], screenSize: screenSize)
            }
            return buildPairedConstraint(source: views[0], target: views[1])
        } else if views.count == 1 {
            if constraint.isProportional {
                return buildSimpleProportionalConstraint(view: views[0], screenSize: screenSize)
            }
            return buildSimpleConstraint(view: views[0])
        }
        assert(false, "Unimplemented")
    }
    
    private func buildSimpleProportionalConstraint(view: ViewClass, screenSize: CGSize) -> NSLayoutConstraint {
        let builder = HPSimpleProportionalConstraint(attribute: constraint.type.sourceAttribute,
                                                     proportionalityConstant: constraint.proportionalValue,
                                                     isSafeArea: isSafeArea,
                                                     screenSize: screenSize)
        return builder.applyConstraint(to: view)
    }
    
    private func buildSimpleConstraint(view: ViewClass) -> NSLayoutConstraint {
        let builder = HPSimpleConstraint(attribute: constraint.type.sourceAttribute,
                                         constant: constraint.value,
                                         isSafeArea: isSafeArea)
        return builder.applyConstraint(to: view)
    }
    
    private func buildPairedProportionalConstraint(source: ViewClass,
                                                   target: ViewClass,
                                                   screenSize: CGSize) -> NSLayoutConstraint {
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
