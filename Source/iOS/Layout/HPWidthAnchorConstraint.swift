//
//  HPWidthAnchorConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit
import Nub

public class HPWidthAnchorConstraint: HPBaseAnchorConstraint, HPViewConstraint {
    public func applyConstraint(to view: UIView) -> NSLayoutConstraint {
        return view.widthAnchor.constraint(equalToConstant: constraint.value.halfPointRoundValue)
    }
}
