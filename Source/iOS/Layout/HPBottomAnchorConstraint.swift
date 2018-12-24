//
//  HPBottomAnchorConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit
import Nub

public class HPBottomAnchorConstraint: HPBaseAnchorConstraint, HPViewConstraint {    
    override internal func applyConstraint(source: UIView, target: UIView, value: CGFloat) -> NSLayoutConstraint {        
        return source.bottomAnchor.constraint(equalTo: target.bottomAnchor, constant: -value.halfPointRoundValue)
    }
}
