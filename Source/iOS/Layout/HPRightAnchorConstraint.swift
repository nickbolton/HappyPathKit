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
    public func applyConstraint(to view: UIView) -> NSLayoutConstraint {
        guard let parent = view.superview else {
            assert(false, "view must be part of a view hierarchy.")
        }
        return view.rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -constraint.value.halfPointRoundValue)
    }
}
