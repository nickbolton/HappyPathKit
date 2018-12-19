//
//  AppFont.swift
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

public struct HPFont: Codable {
    public let name: String
    public let family: String
    public let systemWeight: String?
    public let attributes: HPFontAttributes
}

public struct HPFontAttributes: Codable {
    public let fontName: String
    public let pointSize: CGFloat

    enum CodingKeys: String, CodingKey {
        case fontName = "NSFontNameAttribute"
        case pointSize = "NSFontSizeAttribute"
    }
}
