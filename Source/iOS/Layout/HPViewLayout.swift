//
//  HPViewLayout.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/22/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

public struct HPViewLayout {
    let constraints: [HPViewConstraint]
    public func applyLayout(view: UIView) {
        var layoutConstraints = [NSLayoutConstraint]()
        for c in constraints {
            layoutConstraints.append(c.applyConstraint(to: view))
        }
        NSLayoutConstraint.activate(layoutConstraints)
    }
}
