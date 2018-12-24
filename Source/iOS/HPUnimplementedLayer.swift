//
//  HPUnimplementedLayer.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/23/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import Foundation

class HPUnimplementedLayer: HPLayer {
    
    override var isUnimplemented: Bool { return true }

    override init(skLayer: SKLayer) {
        super.init(skLayer: skLayer)
    }
}
