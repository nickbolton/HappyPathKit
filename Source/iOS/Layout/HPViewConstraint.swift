//
//  HPViewConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

public protocol HPViewConstraint {
    var constraint: HPConstraint { get }
    func applyConstraint(to view: UIView) -> NSLayoutConstraint
}
