//
//  HPCenterXAnchorConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

class HPCenterXAnchorConstraint: HPBaseAnchorConstraint, HPViewConstraint {
    override internal func applyConstraint(source: UIView, target: UIView, value: CGFloat) -> NSLayoutConstraint {
        if constraint.isProportional {
            let scaledValue = UIScreen.main.bounds.width * value
            return NSLayoutConstraint(item: source,
                                      attribute: .centerX,
                                      relatedBy: .equal,
                                      toItem: target,
                                      attribute: .centerX,
                                      multiplier: 1.0,
                                      constant: scaledValue)
        }
        return source.centerXAnchor.constraint(equalTo: target.centerXAnchor, constant: value.halfPointRoundValue)
    }
}
