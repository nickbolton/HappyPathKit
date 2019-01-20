//
//  LayoutAttributesEntityWrapper.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 8/8/16.
//  Copyright © 2016 Pixelbleed LLC All rights reserved.
//

import UIKit

open class LayoutAttributesEntityWrapper: UICollectionViewLayoutAttributes {

    public var entity: Any?
    public var useCenter = false
    
    // properties passed directly to UICollectionViewLayoutAttributes

    public var point: CGPoint = .zero

    @discardableResult
    public func set(entity: Any) -> Self {
        self.entity = entity
        return self
    }
}
