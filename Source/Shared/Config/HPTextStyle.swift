//
//  HPTextStyle.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/18/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//
#if os(iOS)
import UIKit
public typealias LineBreakModeType = Int
#else
public typealias LineBreakModeType = UInt
import Cocoa
#endif

public struct HPTextStyle: Codable, Equatable, Hashable {
    public var name: String
    public var attributes: [HPStyleAttributes]
    
    public init(name: String, attributes: [HPStyleAttributes]) {
        self.name = name
        self.attributes = attributes
    }
    
    public var hashIdentifier: String {
        return attributes.map { $0.hashIdentifier }.joined(separator: ".")
    }

    public var hashValue: Int { return hashIdentifier.hashValue }
    
    public static func == (lhs: HPTextStyle, rhs: HPTextStyle) -> Bool {
        return lhs.hashIdentifier == rhs.hashIdentifier
    }
}

public struct HPStyleAttributes: Codable, Equatable, Hashable {
    public let font: HPFontConfig
    public let textColor: SKBackgroundColor
    public let kerning: CGFloat?
    public let underline: Int?
    public let strikethrough: Int?
    public let baselineOffset: CGFloat?
    public let superscript: Int?
    public var colorName: String = ""
    public var fontName: String = ""
    public let textStyleVerticalAlignmentKey: Int?
    public let paragraph: HPParagraphStyle
    
    enum CodingKeys: String, CodingKey {
        case font = "NSFont"
        case textColor = "MSAttributedStringColorAttribute"
        case kerning = "NSKern"
        case paragraph = "NSParagraphStyle"
        case underline = "NSUnderline"
        case strikethrough = "NSStrikethrough"
        case baselineOffset = "NSBaselineOffset"
        case superscript = "NSSuperScript"
        case textStyleVerticalAlignmentKey
    }
    
    public init(font: HPFontConfig,
                textColor: SKBackgroundColor,
                kerning: CGFloat?,
                underline: Int?,
                strikethrough: Int?,
                baselineOffset: CGFloat?,
                superscript: Int?,
                textStyleVerticalAlignmentKey: Int?,
                paragraph: HPParagraphStyle) {
        self.font = font
        self.textColor = textColor
        self.kerning = kerning
        self.underline = underline
        self.strikethrough = strikethrough
        self.baselineOffset = baselineOffset
        self.superscript = superscript
        self.textStyleVerticalAlignmentKey = textStyleVerticalAlignmentKey
        self.paragraph = paragraph
    }
    
    public var hashIdentifier: String {
        return [font.hashIdentifier, textColor.rawValue, "\(kerning ?? 0.0)", "\(underline ?? 0)", "\(strikethrough ?? 0)", "\(baselineOffset ?? 0.0)", "\(superscript ?? 0)", "\(textStyleVerticalAlignmentKey ?? 0)", paragraph.hashIdentifier].joined(separator: ".")
    }
    public var hashValue: Int { return hashIdentifier.hashValue }
    
    public static func == (lhs: HPStyleAttributes, rhs: HPStyleAttributes) -> Bool {
        return lhs.hashIdentifier == rhs.hashIdentifier
    }
}

public struct HPParagraphStyle: Codable, Equatable, Hashable {
    public let alignment: Int
    public let lineBreakMode: LineBreakModeType
    public let lineHeightMultiple: CGFloat
    public let lineSpacing: CGFloat
    public let maximumLineHeight: CGFloat
    public let minimumLineHeight: CGFloat
    public let paragraphSpacing: CGFloat
    
    public init(alignment: Int,
                lineBreakMode: LineBreakModeType,
                lineHeightMultiple: CGFloat,
                lineSpacing: CGFloat,
                maximumLineHeight: CGFloat,
                minimumLineHeight: CGFloat,
                paragraphSpacing: CGFloat) {
        self.alignment = alignment
        self.lineBreakMode = lineBreakMode
        self.lineHeightMultiple = lineHeightMultiple
        self.lineSpacing = lineSpacing
        self.maximumLineHeight = maximumLineHeight
        self.minimumLineHeight = minimumLineHeight
        self.paragraphSpacing = paragraphSpacing
    }
    
    public  var hashIdentifier: String {
        return ["\(alignment)", "\(lineBreakMode)", "\(lineHeightMultiple)", "\(lineSpacing)", "\(maximumLineHeight)", "\(minimumLineHeight)", "\(paragraphSpacing)"].joined(separator: ".")
    }
    public var hashValue: Int { return hashIdentifier.hashValue }
    
    public static func == (lhs: HPParagraphStyle, rhs: HPParagraphStyle) -> Bool {
        return lhs.hashIdentifier == rhs.hashIdentifier
    }
}
