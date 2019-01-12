//
//  UIFont+Helpers.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 1/12/19.
//  Copyright © 2019 Pixelbleed LLC. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UIFont {

    public static func resolveFont(systemWeight weightIn: String?, fontName: String, pointSize: CGFloat) -> UIFont {
        if let weight = SystemFontWeight(rawValue: weightIn ?? "") {
            return UIFont.systemFont(systemFontWeight: weight, pointSize: pointSize)
        }
        if let font = HPFont(name: fontName, size: pointSize) {
            return font
        }
        return HPFont.systemFont(ofSize: pointSize)
    }
}

#endif
