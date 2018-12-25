//
//  HPConfiguration.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/16/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//
import Foundation

public struct HPConfiguration: Codable {
    public let assetsLocation: String
    public let fonts: [HPFont]
    public let colors: [HPColor]
    public let textStyles: [HPTextStyle]
    public let components: [HPComponentConfig]
    public let layouts: [HPLayout]
    private (set) public var layoutMap: [String: HPLayout]
    private (set) public var componentMap: [String: HPComponentConfig]

    public enum CodingKeys: String, CodingKey {
        case assetsLocation, fonts, colors, textStyles, components, layouts
    }
    
    static private func buildLayoutMap(_ layouts: [HPLayout]) -> [String: HPLayout] {
        var result = [String: HPLayout]()
        for l in layouts {
            result[l.key] = l
        }
        return result
    }
    
    static private func buildComponentMap(_ components: [HPComponentConfig]) -> [String: HPComponentConfig] {
        var result = [String: HPComponentConfig]()
        for c in components {
            result[c.layerID] = c
        }
        return result
    }
    
    public init(assetsLocation: String, fonts: [HPFont], colors: [HPColor], textStyles: [HPTextStyle], components: [HPComponentConfig], layouts: [HPLayout]) {
        self.assetsLocation = assetsLocation
        self.fonts = fonts
        self.colors = colors
        self.textStyles = textStyles
        self.components = components
        self.layouts = layouts
        self.layoutMap = HPConfiguration.buildLayoutMap(layouts)
        self.componentMap = HPConfiguration.buildComponentMap(components)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.assetsLocation = try values.decode(String.self, forKey: .assetsLocation)
        self.fonts = try values.decode([HPFont].self, forKey: .fonts)
        self.colors = try values.decode([HPColor].self, forKey: .colors)
        self.textStyles = try values.decode([HPTextStyle].self, forKey: .textStyles)
        self.components = try values.decode([HPComponentConfig].self, forKey: .components)
        self.layouts = try values.decode([HPLayout].self, forKey: .layouts)
        self.layoutMap = HPConfiguration.buildLayoutMap(self.layouts)
        self.componentMap = HPConfiguration.buildComponentMap(self.components)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(assetsLocation, forKey: .assetsLocation)
        try container.encode(fonts, forKey: .fonts)
        try container.encode(colors, forKey: .colors)
        try container.encode(textStyles, forKey: .textStyles)
        try container.encode(components, forKey: .components)
        try container.encode(layouts, forKey: .layouts)
    }
}
