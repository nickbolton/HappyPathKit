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
        for c in layout.layout {
            switch c.type {
            case .top:
                constraints.append(HPTopAnchorConstraint(constraint: c, layers: layers))
            case .bottom:
                constraints.append(HPBottomAnchorConstraint(constraint: c, layers: layers))
            case .left:
                constraints.append(HPLeftAnchorConstraint(constraint: c, layers: layers))
            case .right:
                constraints.append(HPRightAnchorConstraint(constraint: c, layers: layers))
            case .width:
                constraints.append(HPWidthAnchorConstraint(constraint: c, layers: layers))
            case .height:
                constraints.append(HPHeightAnchorConstraint(constraint: c, layers: layers))
            case .centerY:
                constraints.append(HPCenterYAnchorConstraint(constraint: c, layers: layers))
            case .centerX:
                constraints.append(HPCenterXAnchorConstraint(constraint: c, layers: layers))
            case .verticalSpacing:
                break
            case .horizontalSpacing:
                break
            }
        }
        return HPViewLayout(constraints: constraints)
    }
    
    static public func defaultLayout(layer: HPLayer) -> HPViewLayout {
        var constraints = [HPViewConstraint]()
        let frame = layer.frame
        constraints.append(HPTopAnchorConstraint(constraint: HPConstraint(type: .top, values: [frame.minY], isProportional: false), layers: [layer]))
        constraints.append(HPLeftAnchorConstraint(constraint: HPConstraint(type: .left, values: [frame.minX], isProportional: false), layers: [layer]))
        constraints.append(HPWidthAnchorConstraint(constraint: HPConstraint(type: .width, values: [frame.width], isProportional: false), layers: [layer]))
        constraints.append(HPHeightAnchorConstraint(constraint: HPConstraint(type: .height, values: [frame.height], isProportional: false), layers: [layer]))
        return HPViewLayout(constraints: constraints)
    }
}
