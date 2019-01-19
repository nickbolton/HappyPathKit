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
    
    public var isForcedResuableType: Bool {
        switch self {
        case .tableHeader, .tableSectionHeader, .tableCell, .tableSectionFooter, .tableFooter,
             .collectionCell:
            return true
        default:
            return false
        }
    }

    public func layoutTypeComponents(for layer: HPLayer, parent: HPLayer?) -> [HPComponentType] {
        if layer.layerType == .artboard {
            return HPComponentType.defaultComponents + [.viewController]
        } else if let parent = parent {
            switch parent.componentConfig.type {
            case .table:
                return HPComponentType.tableComponents
            case .collection:
                return HPComponentType.collectionComponents
            default:
                break
            }
            switch parent.layerType {
            case .artboard:
                return HPComponentType.artboardChildrenComponents
            default:
                break
            }
        }
        return HPComponentType.defaultComponents
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
    
    public var label: String {
        switch self {
        case .none:
            return "None"
        case .container:
            return "Container"
        case .button:
            return "Button"
        case .image:
            return "Image"
        case .label:
            return "Label"
        case .textField:
            return "Text Field"
        case .textView:
            return "Text View"
        case .background:
            return "Background"
        case .table:
            return "Table"
        case .tableHeader:
            return "Table Header"
        case .tableSectionHeader:
            return "Table Section Header"
        case .tableCell:
            return "Table Cell"
        case .tableSectionFooter:
            return "Table Section Footer"
        case .tableFooter:
            return "Table Footer"
        case .collection:
            return "Collection"
        case .collectionCell:
            return "Collection Cell"
        case .viewController:
            return "View Controller"
        }
    }
}

public enum HPContentMode: Int, CaseIterable, Codable {
    case scaleToFill
    case scaleAspectFit // contents scaled to fit with fixed aspect. remainder is transparent
    case scaleAspectFill // contents scaled to fill with fixed aspect. some portion of content may be clipped.
    case redraw // redraw on bounds change (calls -setNeedsDisplay)
    case center // contents remain same size. positioned adjusted.
    case top
    case bottom
    case left
    case right
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    
    #if os(iOS)
    public var nativeContentMode: UIView.ContentMode {
        switch self {
        case .scaleToFill:
            return .scaleToFill
        case .scaleAspectFit:
            return .scaleAspectFit
        case .scaleAspectFill:
            return .scaleAspectFill
        case .redraw:
            return .redraw
        case .center:
            return .center
        case .top:
            return .top
        case .bottom:
            return .bottom
        case .left:
            return .left
        case .right:
            return .right
        case .topLeft:
            return .topLeft
        case .topRight:
            return .topRight
        case .bottomLeft:
            return .bottomLeft
        case .bottomRight:
            return .bottomRight
        }
    }
    #endif
    
    public var label: String {
        switch self {
        case .scaleToFill:
            return "Scale to Fill"
        case .scaleAspectFit:
            return "Scale Aspect Fit"
        case .scaleAspectFill:
            return "Scale Aspect Fill"
        case .redraw:
            return "Redraw"
        case .center:
            return "Center"
        case .top:
            return "Top"
        case .bottom:
            return "Bottom"
        case .left:
            return "Left"
        case .right:
            return "Right"
        case .topLeft:
            return "Top Left"
        case .topRight:
            return "Top Right"
        case .bottomLeft:
            return "Bottom Left"
        case .bottomRight:
            return "Bottom Right"
        }
    }
}

public enum HPCollectionType: Int, CaseIterable, Codable {
    case verticalFlow
    case horizontalFlow
    case custom
    
    public var label: String {
        switch self {
        case .verticalFlow:
            return "Vertical Flow"
        case .horizontalFlow:
            return "Horizontal Flow"
        case .custom:
            return "Custom"
        }
    }
}

public enum HPFlowCollectionItemPosition: Int, CaseIterable, Codable {
    case flow
    case absolute
    
    public var label: String {
        switch self {
        case .flow:
            return "Flow"
        case .absolute:
            return "Absolute"
        }
    }
}

public struct HPComponentConfig: Codable {
    public var type: HPComponentType
    public var isReusable = false
    public var isConnectable = true
    public var contentMode: HPContentMode = .scaleToFill
    public var contentSourceKey: String? = nil
    public var collectionSections = [0]
    public var backgroundColor: SKBackgroundColor?
    public var collectionType = HPCollectionType.verticalFlow
    public var flowCollectionItemPosition = HPFlowCollectionItemPosition.flow

    public init(type: HPComponentType) {
        self.type = type
    }
}
