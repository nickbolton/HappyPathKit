//
//  HPLayoutFactory.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

public struct HPLayoutFactory {
    static public func buildLayout(_ layout: HPLayout, layers: [HPLayer]) -> HPViewLayout {
        var constraints = [HPViewConstraint]()
        let hasVerticalCentering = layers.reduce(false) { (acc, cur) in acc || (cur.componentConfig?.type == .verticalCentering)}
        let hasHorizontalCentering = layers.reduce(false) { (acc, cur) in acc || (cur.componentConfig?.type == .horizontalCentering)}
        for c in layout.layout {
            switch c.type {
            case .top:
                if !hasHorizontalCentering {
                    constraints.append(HPViewConstraint(constraint: c, layers: layers))
                }
            case .bottom:
                if !hasHorizontalCentering {
                    constraints.append(HPViewConstraint(constraint: c, layers: layers))
                }
            case .left:
                if !hasVerticalCentering {
                    constraints.append(HPViewConstraint(constraint: c, layers: layers))
                }
            case .right:
                if !hasVerticalCentering {
                    constraints.append(HPViewConstraint(constraint: c, layers: layers))
                }
            case .width:
                if !hasVerticalCentering {
                    constraints.append(HPViewConstraint(constraint: c, layers: layers))
                }
            case .height:
                if !hasHorizontalCentering {
                    constraints.append(HPViewConstraint(constraint: c, layers: layers))
                }
            case .centerY:
                constraints.append(HPViewConstraint(constraint: c, layers: layers))
            case .centerX:
                constraints.append(HPViewConstraint(constraint: c, layers: layers))
            case .verticalSpacing:
                constraints.append(HPViewConstraint(constraint: c, layers: layers))
                break
            case .horizontalSpacing:
                constraints.append(HPViewConstraint(constraint: c, layers: layers))
                break
            }
        }
        for layer in layers {
            if layer.componentConfig?.type == .verticalCentering {
                let leftConstraint = HPConstraint(type: .left, value: 0.0, proportionalValue: 0.0, isProportional: false)
                let rightConstraint = HPConstraint(type: .right, value: 0.0, proportionalValue:0.0, isProportional: false)
                constraints.append(HPViewConstraint(constraint: leftConstraint, layers: [layer]))
                constraints.append(HPViewConstraint(constraint: rightConstraint, layers: [layer]))
            }
            if layer.componentConfig?.type == .horizontalCentering {
                let topConstraint = HPConstraint(type: .top, value: 0.0, proportionalValue: 0.0, isProportional: false)
                let bottomConstraint = HPConstraint(type: .bottom, value: 0.0, proportionalValue:0.0, isProportional: false)
                constraints.append(HPViewConstraint(constraint: topConstraint, layers: [layer]))
                constraints.append(HPViewConstraint(constraint: bottomConstraint, layers: [layer]))
            }
        }
        return HPViewLayout(constraints: constraints)
    }
    
    static public func defaultLayout(layer: HPLayer) -> HPViewLayout {
        var constraints = [HPViewConstraint]()
        let frame = layer.frame
        constraints.append(HPViewConstraint(constraint: HPConstraint(type: .top, value: frame.minY, proportionalValue: 0.0, isProportional: false), layers: [layer]))
        constraints.append(HPViewConstraint(constraint: HPConstraint(type: .left, value: frame.minX, proportionalValue: 0.0, isProportional: false), layers: [layer]))
        constraints.append(HPViewConstraint(constraint: HPConstraint(type: .width, value: frame.width, proportionalValue: 0.0, isProportional: false), layers: [layer]))
        constraints.append(HPViewConstraint(constraint: HPConstraint(type: .height, value: frame.height, proportionalValue: 0.0, isProportional: false), layers: [layer]))
        return HPViewLayout(constraints: constraints)
    }
}
