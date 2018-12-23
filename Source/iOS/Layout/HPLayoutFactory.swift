//
//  HPLayoutFactory.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

public struct HPLayoutFactory {
    static public func buildLayout(_ layout: HPLayout) -> HPViewLayout {
        var constraints = [HPViewConstraint]()
        for c in layout.layout {
            switch c.type {
            case .top:
                constraints.append(HPTopAnchorConstraint(constraint: c))
            case .bottom:
                constraints.append(HPBottomAnchorConstraint(constraint: c))
            case .left:
                constraints.append(HPLeftAnchorConstraint(constraint: c))
            case .right:
                constraints.append(HPRightAnchorConstraint(constraint: c))
            case .width:
                constraints.append(HPWidthAnchorConstraint(constraint: c))
            case .height:
                constraints.append(HPHeightAnchorConstraint(constraint: c))
            case .centerY:
                constraints.append(HPCenterYAnchorConstraint(constraint: c))
            case .centerX:
                constraints.append(HPCenterXAnchorConstraint(constraint: c))
            }
        }
        return HPViewLayout(constraints: constraints)
    }
    
    static public func defaultLayout(layer: SKLayer) -> HPViewLayout {
        var constraints = [HPViewConstraint]()
        let frame = layer.frame.cgRect
        constraints.append(HPTopAnchorConstraint(constraint: HPConstraint(type: .top, value: frame.minY, isProportional: false)))
        constraints.append(HPLeftAnchorConstraint(constraint: HPConstraint(type: .left, value: frame.minX, isProportional: false)))
        constraints.append(HPWidthAnchorConstraint(constraint: HPConstraint(type: .width, value: frame.width, isProportional: false)))
        constraints.append(HPHeightAnchorConstraint(constraint: HPConstraint(type: .height, value: frame.height, isProportional: false)))
        return HPViewLayout(constraints: constraints)
    }
}
