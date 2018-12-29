//
//  HPTextStyle.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/18/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//
#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public struct HPTextStyle: Codable {
    public let name: String
    public let attributes: [HPStyleAttributes]
}

public struct HPStyleAttributes: Codable {
    public let font: HPFontConfig
    public let kerning: CGFloat?
    public let underline: Int?
    public let strikethrough: Int?
    public let baselineOffset: CGFloat?
    public let superscript: Int?
    public let colorName: String
    public let fontName: String
    public let textStyleVerticalAlignmentKey: Int?
    public let paragraph: HPParagraph
    
    enum CodingKeys: String, CodingKey {
        case font = "NSFont"
        case kerning = "NSKern"
        case paragraph = "NSParagraphStyle"
        case underline = "NSUnderline"
        case strikethrough = "NSStrikethrough"
        case baselineOffset = "NSBaselineOffset"
        case superscript = "NSSuperScript"
        case colorName
        case fontName
        case textStyleVerticalAlignmentKey
    }
}

public struct HPParagraph: Codable {
    public let style: HPParagraphStyle
}

public struct HPParagraphStyle: Codable {
    public let alignment: Int
    public let lineBreakMode: Int
    public let lineHeightMultiple: CGFloat
    public let lineSpacing: CGFloat
    public let maximumLineHeight: CGFloat
    public let minimumLineHeight: CGFloat
    public let paragraphSpacing: CGFloat
}
