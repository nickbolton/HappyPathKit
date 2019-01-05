//
//  HPConfiguration.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/16/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//
import Foundation

public struct HPConfiguration: Codable {
    public var fonts: [HPFontConfig]
    public var colors: [HPColorConfig]
    public var textStyles: [HPTextStyle]

    public enum CodingKeys: String, CodingKey {
        case fonts, colors, textStyles
    }
        
    public init() {
        self.init(fonts: [], colors: [], textStyles: [])
    }
    
    public init(fonts: [HPFontConfig], colors: [HPColorConfig], textStyles: [HPTextStyle]) {
        self.fonts = fonts
        self.colors = colors
        self.textStyles = textStyles
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.fonts = try values.decode([HPFontConfig].self, forKey: .fonts)
        self.colors = try values.decode([HPColorConfig].self, forKey: .colors)
        self.textStyles = try values.decode([HPTextStyle].self, forKey: .textStyles)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fonts, forKey: .fonts)
        try container.encode(colors, forKey: .colors)
        try container.encode(textStyles, forKey: .textStyles)
    }
}
