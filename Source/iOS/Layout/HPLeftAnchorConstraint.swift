//
//  HPLeftAnchorConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit
import Nub

public class HPLeftAnchorConstraint: HPBaseAnchorConstraint, HPViewConstraint {
    override internal func applyConstraint(source: UIView, target: UIView, value: CGFloat) -> NSLayoutConstraint {
        if constraint.isProportional {
            let scaledValue = UIScreen.main.bounds.width * value
            return NSLayoutConstraint(item: source,
                                      attribute: .leading,
                                      relatedBy: .equal,
                                      toItem: target,
                                      attribute: .leading,
                                      multiplier: 1.0,
                                      constant: scaledValue)
        }
        return source.leadingAnchor.constraint(equalTo: target.leadingAnchor, constant: value.halfPointRoundValue)
    }
}
