//
//  HPTopAnchorConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit
import Nub

public class HPTopAnchorConstraint: HPBaseAnchorConstraint, HPViewConstraint {
    override internal func applyConstraint(source: UIView, target: UIView, value: CGFloat) -> NSLayoutConstraint {
        if constraint.isProportional {
            let scaledValue = UIScreen.main.bounds.height * value
            return NSLayoutConstraint(item: source,
                                      attribute: .top,
                                      relatedBy: .equal,
                                      toItem: target,
                                      attribute: .top,
                                      multiplier: 1.0,
                                      constant: scaledValue)
        }
        return source.topAnchor.constraint(equalTo: target.topAnchor, constant: value.halfPointRoundValue)
    }
}
