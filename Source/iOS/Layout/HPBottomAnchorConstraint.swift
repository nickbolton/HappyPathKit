//
//  HPBottomAnchorConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit
import Nub

public class HPBottomAnchorConstraint: HPBaseAnchorConstraint, HPViewConstraint {    
    override internal func applyConstraint(source: UIView, target: UIView, value: CGFloat) -> NSLayoutConstraint {
        if constraint.isProportional {
            let scaledValue = UIScreen.main.bounds.height * value
            if layers.count > 1 {
                if constraint.type == .verticalSpacing {
                    return NSLayoutConstraint(item: source,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: target,
                                              attribute: .top,
                                              multiplier: 1.0,
                                              constant: -scaledValue)
                }
            }
            return NSLayoutConstraint(item: source,
                                      attribute: .bottom,
                                      relatedBy: .equal,
                                      toItem: target,
                                      attribute: .bottom,
                                      multiplier: 1.0,
                                      constant: -scaledValue)
        }
        if layers.count > 1 {
            if constraint.type == .verticalSpacing {
                return source.bottomAnchor.constraint(equalTo: target.topAnchor, constant: -value.halfPointRoundValue)
            }
        }
        return source.bottomAnchor.constraint(equalTo: target.bottomAnchor, constant: -value.halfPointRoundValue)
    }
}
