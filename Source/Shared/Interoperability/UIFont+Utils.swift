//
//  UIFont.swift
//  Nub
//
//  Created by Nick Bolton on 3/18/18.
//

#if os(iOS)
import UIKit
#else
import Cocoa
#endif

public extension HPFont {
    
    internal static let smallTestPointSize: CGFloat = 8.0
    internal static let largeTestPointSize: CGFloat = 50.0
    
    #if os(iOS)
    public static func systemFont(systemFontWeight: SystemFontWeight, pointSize: CGFloat) -> UIFont {
        let defaultFont = UIFont.systemFont(ofSize: pointSize, weight: systemFontWeight.fontWeight)
        if systemFontWeight.isItalic {
            if let fontDescriptor = defaultFont.fontDescriptor.withSymbolicTraits(.traitItalic) {
                return UIFont(descriptor: fontDescriptor, size: pointSize)
            }
        }
        return defaultFont
    }
    #elseif os(macOS)
    public static func systemFont(systemFontWeight: SystemFontWeight, pointSize: CGFloat) -> NSFont {
        let defaultFont = NSFont.systemFont(ofSize: pointSize, weight: systemFontWeight.fontWeight)
        if systemFontWeight.isItalic {
            let fontDescriptor = defaultFont.fontDescriptor.withSymbolicTraits(.italic)
            if let font = NSFont(descriptor: fontDescriptor, size: pointSize) {
                return font
            }
        }
        return defaultFont
    }
    #endif
}
