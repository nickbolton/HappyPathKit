//
//  HPLayoutFactory.swift
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

public struct HPLayoutFactory {
    static public func build(layout: HPLayout) -> HPViewLayout {
        var constraints = [HPViewConstraint]()
        let isSafeArea = layout.constraints.filter { $0.type == .safeArea }.first != nil
        for c in layout.constraints {
            switch c.type {
            case .top, .bottom, .height, .centerY, .verticalSpacing, .verticalCenters:
                constraints.append(HPViewConstraint(constraint: c, isSafeArea: isSafeArea))
            case .left, .right, .width, .centerX, .horizontalSpacing, .horizontalCenters:
                constraints.append(HPViewConstraint(constraint: c, isSafeArea: isSafeArea))
            default:
                break
            }
        }
        return HPViewLayout(constraints: constraints)
    }
    
    static public func defaultLayout(layer: HPLayer, screenSize: CGSize) -> HPViewLayout {
        var constraints = [HPViewConstraint]()
        let frame = layer.frame
        constraints.append(HPViewConstraint(constraint: HPConstraint(sourceID: layer.id, type: .top, value: frame.minY), isSafeArea: true))
        constraints.append(HPViewConstraint(constraint: HPConstraint(sourceID: layer.id, type: .left, value: frame.minX), isSafeArea: true))
        constraints.append(HPViewConstraint(constraint: HPConstraint(sourceID: layer.id, type: .width, value: frame.width), isSafeArea: true))
        constraints.append(HPViewConstraint(constraint: HPConstraint(sourceID: layer.id, type: .height, value: frame.height), isSafeArea: true))
        return HPViewLayout(constraints: constraints)
    }
}
