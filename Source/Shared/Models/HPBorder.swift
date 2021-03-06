//
//  HPBorder.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/23/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public enum HPBorderType: Int, Codable {
    case inside
    case outside
    case centered
}

public struct HPBorder: Codable, Inspectable {
    public let thickness: CGFloat
    public let color: SKBackgroundColor
    public let type: HPBorderType
    
    public init(thickness: CGFloat, color: SKBackgroundColor, type: HPBorderType) {
        self.thickness = thickness
        self.color = color
        self.type = type
    }
}
