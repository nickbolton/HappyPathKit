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

public struct HPFontConfig: Codable, Equatable, Hashable {
    public var userName: String
    public let fontName: String
    public let family: String
    public let systemWeight: String?
    public let attributes: HPFontAttributes
    
    public init(userName: String = "", fontName: String, family: String, systemWeight: String?, attributes: HPFontAttributes) {
        self.userName = userName
        self.fontName = fontName
        self.family = family
        self.systemWeight = systemWeight
        self.attributes = attributes
    }
    
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
    
    public var hashIdentifier: String {
        return [fontName, family, systemWeight ?? "", attributes.fontName, "\(attributes.pointSize)"].joined(separator: ".")
    }
    public var hashValue: Int { return hashIdentifier.hashValue }
    
    public static func == (lhs: HPFontConfig, rhs: HPFontConfig) -> Bool {
        return lhs.hashIdentifier == rhs.hashIdentifier
    }
}

public struct HPFontAttributes: Codable {
    public let fontName: String
    public let pointSize: CGFloat

    enum CodingKeys: String, CodingKey {
        case fontName = "NSFontNameAttribute"
        case pointSize = "NSFontSizeAttribute"
    }
    
    public init(fontName: String, pointSize: CGFloat) {
        self.fontName = fontName
        self.pointSize = pointSize
    }
}
