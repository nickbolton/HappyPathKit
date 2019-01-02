//
//  HPFontConfig.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/16/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//
#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public struct HPFontConfig: Codable {
    public let name: String
    public let family: String
    public let systemWeight: String?
    public let attributes: HPFontAttributes
    
#if os(iOS)
    public var uiFontWeight: UIFont.Weight? {
        switch systemWeight {
        case "ultraLight":
            return .ultraLight
        case "thin":
            return .thin
        case "light":
            return .light
        case "regular":
            return .regular
        case "medium":
            return .medium
        case "semibold":
            return .semibold
        case "bold":
            return .bold
        case "heavy":
            return .heavy
        case "black":
            return .black
        default:
            break
        }
        return nil
    }
#endif
}

public struct HPFontAttributes: Codable {
    public let fontName: String
    public let pointSize: CGFloat

    enum CodingKeys: String, CodingKey {
        case fontName = "NSFontNameAttribute"
        case pointSize = "NSFontSizeAttribute"
    }
}
