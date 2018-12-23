//
//  HPBaseAnchorConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

public class HPBaseAnchorConstraint: NSObject {
    private (set) public var constraint: HPConstraint
    init(constraint: HPConstraint) {
        self.constraint = constraint
        super.init()
    }
}
