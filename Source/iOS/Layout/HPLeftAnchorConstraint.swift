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
    public func applyConstraint(to view: UIView) -> NSLayoutConstraint {
        guard let parent = view.superview else {
            assert(false, "view must be part of a view hierarchy.")
        }
        return view.leftAnchor.constraint(equalTo: parent.leftAnchor, constant: constraint.value.halfPointRoundValue)
    }
}
