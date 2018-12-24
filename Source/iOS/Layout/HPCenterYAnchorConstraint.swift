//
//  HPCenterYAnchorConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

class HPCenterYAnchorConstraint: HPBaseAnchorConstraint, HPViewConstraint {
    override internal func applyConstraint(source: UIView, target: UIView, value: CGFloat) -> NSLayoutConstraint {
        if constraint.isProportional {
            let scaledValue = UIScreen.main.bounds.height * value
            return NSLayoutConstraint(item: source,
                                      attribute: .centerY,
                                      relatedBy: .equal,
                                      toItem: target,
                                      attribute: .centerY,
                                      multiplier: 1.0,
                                      constant: scaledValue)
        }
        return source.centerYAnchor.constraint(equalTo: target.centerYAnchor, constant: value.halfPointRoundValue)
    }
}
