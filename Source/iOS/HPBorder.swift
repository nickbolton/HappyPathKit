//
//  HPBorder.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/23/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

public enum HPBorderType {
    case inside
    case outside
    case centered
}

public struct HPBorder {
    public let thickness: CGFloat
    public let color: UIColor
    public let type: HPBorderType
}
