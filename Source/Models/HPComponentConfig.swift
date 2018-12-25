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
    case imageView = "com.pixelbleed.happyPath.imageView"
    case background = "com.pixelbleed.happyPath.background"
    case tableView = "com.pixelbleed.happyPath.tableView"
    case collectionView = "com.pixelbleed.happyPath.collectionView"
    case verticalCentering = "com.pixelbleed.happyPath.verticalCentering"
    case horizontalCentering = "com.pixelbleed.happyPath.horizontalCentering"
}

public struct HPComponentConfig: Codable {
    public let layerID: String
    public var type: ComponentType
    public let name: String
    public let isSubclass: Bool
    public let associatedLayers: [String]
}
