//
//  HPComponentConfig.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/16/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//
import Foundation

public enum HPComponentType: Int, Codable, CaseIterable {
    case none
    case container
    case button
    case image
    case label
    case textField
    case background
    case table
    case tableHeader
    case tableSectionHeader
    case tableCell
    case tableSectionFooter
    case tableFooter
    case collection
    case collectionCell
    
    public static var defaultComponents: [HPComponentType] = [
        .none,
        .container,
        .button,
        .image,
        .label,
        .textField,
        .background,
        .table,
        .collection
    ]
    
    public static var tableComponents: [HPComponentType] = [
        .none,
        .tableHeader,
        .tableSectionHeader,
        .tableCell,
        .tableSectionFooter,
        .tableFooter,
    ]
    
    public static var collectionComponents: [HPComponentType] = [
        .none,
        .collectionCell,
    ]
}

public struct HPComponentConfig: Codable {
    public var type: HPComponentType
    public var isSubclass: Bool
    public var isConnection: Bool
    
    public init(type: HPComponentType) {
        self.type = type
        self.isSubclass = false
        self.isConnection = false
    }
}
