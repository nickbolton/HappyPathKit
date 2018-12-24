//
//  HPRightAnchorConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit
import Nub

public class HPRightAnchorConstraint: HPBaseAnchorConstraint, HPViewConstraint {
    override internal func applyConstraint(source: UIView, target: UIView, value: CGFloat) -> NSLayoutConstraint {
        if constraint.isProportional {
            let scaledValue = UIScreen.main.bounds.width * value
            if layers.count > 1 {
                if constraint.type == .horizontalSpacing {
                    return NSLayoutConstraint(item: source,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: target,
                                              attribute: .leading,
                                              multiplier: 1.0,
                                              constant: -scaledValue)
                }
            }
            return NSLayoutConstraint(item: source,
                                      attribute: .trailing,
                                      relatedBy: .equal,
                                      toItem: target,
                                      attribute: .leading,
                                      multiplier: 1.0,
                                      constant: -scaledValue)
        }
        if constraint.type == .horizontalSpacing {
            return source.trailingAnchor.constraint(equalTo: target.leadingAnchor, constant: -value.halfPointRoundValue)
        }
        return source.trailingAnchor.constraint(equalTo: target.trailingAnchor, constant: -value.halfPointRoundValue)
    }
}
