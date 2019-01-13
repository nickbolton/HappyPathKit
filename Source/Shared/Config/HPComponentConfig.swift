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
    case textView
    case background
    case table
    case tableHeader
    case tableSectionHeader
    case tableCell
    case tableSectionFooter
    case tableFooter
    case collection
    case collectionCell
    case viewController
    
    public var isContainingType: Bool {
        switch self {
        case .container, .button, .table, .collection:
            return true
        default:
            return false
        }
    }

    public var isConsumingType: Bool {
        switch self {
        case .button, .table, .collection:
            return true
        default:
            return false
        }
    }

    public var isEmbeddedType: Bool {
        switch self {
        case .background,
             .tableHeader,
             .tableSectionHeader,
             .tableCell,
             .tableSectionFooter,
             .tableFooter,
             .collectionCell:
            return true
        default:
            return false
        }
    }
    
    public func layoutTypeComponents(for layer: HPLayer, parent: HPLayer?) -> [HPComponentType] {
        switch self {
        case .table:
            return HPComponentType.tableComponents
        case .collection:
            return HPComponentType.collectionComponents
        default:
            if layer.layerType == .artboard {
                return HPComponentType.defaultComponents + [.viewController]
            } else if parent?.layerType == .artboard {
                return HPComponentType.artboardChildrenComponents
            }
            return HPComponentType.defaultComponents
        }
    }
    
    public static var defaultComponents: [HPComponentType] = [
        .none,
        .container,
        .button,
        .image,
        .label,
        .textField,
        .table,
        .collection,
        ]
    
    public static var artboardChildrenComponents: [HPComponentType] = [
        .none,
        .background,
        .container,
        .button,
        .image,
        .label,
        .textField,
        .table,
        .collection,
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
    public var isReusable: Bool
    public var isConnection: Bool
    
    public init(type: HPComponentType) {
        self.type = type
        self.isReusable = false
        self.isConnection = false
    }
}
