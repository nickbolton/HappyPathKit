//
//  HPComponentConfig.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/16/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//
import Foundation

public enum ComponentType: String, Codable {
    case button = "com.pixelbleed.happyPath.button"
}

public struct HPComponentConfig: Codable {
    public let type: String
    public let name: String
    public let isSubclass: Bool
}
