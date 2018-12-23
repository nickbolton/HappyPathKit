//
//  HPCenterXAnchorConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

class HPCenterXAnchorConstraint: HPBaseAnchorConstraint, HPViewConstraint {
    public func applyConstraint(to view: UIView) -> NSLayoutConstraint {
        guard let parent = view.superview else {
            assert(false, "view must be part of a view hierarchy.")
        }
        return view.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: constraint.value.halfPointRoundValue)
    }
}
