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
        let isSafeArea = layout.layout.filter { $0.type == .safeArea }.first != nil
        for c in layout.layout {
            switch c.type {
            case .top, .bottom, .height, .centerY, .verticalSpacing, .verticalCenters:
                constraints.append(HPViewConstraint(constraint: c, layers: layers, isSafeArea: isSafeArea))
            case .left, .right, .width, .centerX, .horizontalSpacing, .horizontalCenters:
                constraints.append(HPViewConstraint(constraint: c, layers: layers, isSafeArea: isSafeArea))
            case .safeArea:
                break
            }
        }
        return HPViewLayout(constraints: constraints)
    }
    
    static public func defaultLayout(layer: HPLayer) -> HPViewLayout {
        var constraints = [HPViewConstraint]()
        let frame = layer.frame
        constraints.append(HPViewConstraint(constraint: HPConstraint(type: .top, value: frame.minY, proportionalValue: 0.0, isProportional: false), layers: [layer], isSafeArea: true))
        constraints.append(HPViewConstraint(constraint: HPConstraint(type: .left, value: frame.minX, proportionalValue: 0.0, isProportional: false), layers: [layer], isSafeArea: true))
        constraints.append(HPViewConstraint(constraint: HPConstraint(type: .width, value: frame.width, proportionalValue: 0.0, isProportional: false), layers: [layer], isSafeArea: true))
        constraints.append(HPViewConstraint(constraint: HPConstraint(type: .height, value: frame.height, proportionalValue: 0.0, isProportional: false), layers: [layer], isSafeArea: true))
        return HPViewLayout(constraints: constraints)
    }
}
