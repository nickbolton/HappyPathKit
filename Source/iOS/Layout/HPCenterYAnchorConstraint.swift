//
//  HPCenterYAnchorConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

class HPCenterYAnchorConstraint: HPBaseAnchorConstraint, HPViewConstraint {
    public func applyConstraint(to view: UIView) -> NSLayoutConstraint {
        guard let parent = view.superview else {
            assert(false, "view must be part of a view hierarchy.")
        }
        return view.centerYAnchor.constraint(equalTo: parent.centerYAnchor, constant: constraint.value.halfPointRoundValue)
    }
}
