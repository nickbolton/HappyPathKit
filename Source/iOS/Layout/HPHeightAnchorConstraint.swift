//
//  HPHeightAnchorConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit
import Nub

public class HPHeightAnchorConstraint: HPBaseAnchorConstraint, HPViewConstraint {
    
    public override func applyConstraint(to views: [UIView]) -> NSLayoutConstraint {
        if views.count == 2 {
            return applyConstraint(source: views[0], target: views[1])
        } else if views.count == 1 {
            return applyConstraint(to: views[0])
        }
        assert(false, "Unimplemented")
    }

    private func applyConstraint(to view: UIView) -> NSLayoutConstraint {
        assert(constraint.values.count > 0, "No value was supplied")
        assert(constraint.values.count == 1, "Multiple values were supplied")
        assert(layers.count > 0, "No layers were supplied")
        assert(layers.count == 1, "Multiple layers were supplied")
        let value = constraint.values.first!
        return view.heightAnchor.constraint(equalToConstant: value.halfPointRoundValue)
    }
    
    private func applyConstraint(source: UIView, target: UIView) -> NSLayoutConstraint {
        assert(constraint.values.count > 0, "No value was supplied")
        assert(constraint.values.count == 1, "Multiple values were supplied")
        assert(layers.count > 0, "No layers were supplied")
        assert(layers.count == 2, "Operation on only two layers")
        let value = constraint.values.first!
        return source.heightAnchor.constraint(equalTo: target.heightAnchor, constant: value.halfPointRoundValue)
    }
}
