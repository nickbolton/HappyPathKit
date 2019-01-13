//
//  HPColorConfig.swift
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

public struct HPColorConfig: Codable, Equatable, Hashable {
    public var name: String
    public let value: String
    
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
    public var nativeColor: HPColor {
        return HPColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    private var components: [CGFloat] {
        if value.starts(with: "rgba") {
            var colorString = value.replacingOccurrences(of: "rgba(", with: "")
            colorString = colorString.replacingOccurrences(of: ")", with: "")
            var values = colorString.split(separator: ",")
            let alpha =  CGFloat(NumberFormatter().number(from: String(values[3]))?.floatValue ?? 0.0)
            values.popLast()
            let result = (values.map { CGFloat(NumberFormatter().number(from: String($0))?.floatValue ?? 0.0) / 255.0 }) + [alpha]
            return result
        }
        
        let scanner = Scanner(string: value)
        
        if value.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        return [red, green, blue, 1.0]
    }
    
    public var red: CGFloat { return components[0] }
    public var green: CGFloat { return components[1] }
    public var blue: CGFloat { return components[2] }
    public var alpha: CGFloat { return components[3] }
    
    public var hashValue: Int { return value.hashValue }
    
    public static func == (lhs: HPColorConfig, rhs: HPColorConfig) -> Bool {
        return lhs.value == rhs.value
    }
}
