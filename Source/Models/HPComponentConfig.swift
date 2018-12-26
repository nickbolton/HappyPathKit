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
    case image = "com.pixelbleed.happyPath.imageView"
    case label = "com.pixelbleed.happyPath.label"
    case textField = "com.pixelbleed.happyPath.textField"
    case background = "com.pixelbleed.happyPath.background"
    case table = "com.pixelbleed.happyPath.tableView"
    case tableHeader = "com.pixelbleed.happyPath.tableHeaderView"
    case tableSectionHeader = "com.pixelbleed.happyPath.tableSectionHeaderView"
    case tableCell = "com.pixelbleed.happyPath.tableViewCell"
    case tableSectionFooter = "com.pixelbleed.happyPath.tableSectionFooterView"
    case tableFooter = "com.pixelbleed.happyPath.tableFooterView"
    case collection = "com.pixelbleed.happyPath.collectionView"
    case collectionCell = "com.pixelbleed.happyPath.collectionViewCell"
    case verticalCentering = "com.pixelbleed.happyPath.verticalCentering"
    case horizontalCentering = "com.pixelbleed.happyPath.horizontalCentering"
}

public struct HPComponentConfig: Codable {
    public let layerID: String
    public var type: ComponentType
    public let name: String
    public let isSubclass: Bool
    public let isConnection: Bool
}
