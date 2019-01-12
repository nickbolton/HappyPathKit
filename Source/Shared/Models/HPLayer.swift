//
//  HPLayer.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/23/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public enum HPLayerType: Int, Codable {
    case artboard
    case group
    case bitmap
    case hotspot
    case openGL
    case shapePath
    case shapeGroup
    case slice
    case text
    case oval
    case polygon
    case rectangle
    case star
    case triangle
    case symbolInstance
    case unknown
    case component
    
    static func from(layer: SKLayer) -> HPLayerType {
        switch layer.layerType {
        case .artboard:
            return HPLayerType.artboard
        case .group:
            return HPLayerType.group
        case .bitmap:
            return HPLayerType.bitmap
        case .hotspot:
            return HPLayerType.hotspot
        case .openGL:
            return HPLayerType.openGL
        case .shapePath:
            return HPLayerType.shapePath
        case .shapeGroup:
            return HPLayerType.shapeGroup
        case .slice:
            return HPLayerType.slice
        case .text:
            return HPLayerType.text
        case .oval:
            return HPLayerType.oval
        case .polygon:
            return HPLayerType.polygon
        case .rectangle:
            return HPLayerType.rectangle
        case .star:
            return HPLayerType.star
        case .triangle:
            return HPLayerType.triangle
        case .symbolInstance:
            return HPLayerType.symbolInstance
        case .unknown:
            return HPLayerType.unknown
        }
    }
}

public struct HPLayer: Codable, Equatable, Hashable, Inspectable {
    public let skLayer: SKLayer?
    public var isSourceLayer: Bool { return skLayer != nil }

    public let id: String
    public var frame: CGRect
    public let layerType: HPLayerType
    public var name: String
    public var attributedString: SKAttributedString? { return skLayer?.attributedString }
    public var componentConfig = HPComponentConfig(type: .none)
    public var subLayers = [HPLayer]()
    public var layout: HPLayout
    public var isUnimplemented = false
    public var isRootLayer = false
    public var isLocked = false
    public var isVisible = false
    public var rotation: CGFloat { return skLayer?.rotation ?? 0.0 }
    public var isRotated: Bool { return abs(rotation) == 90.0 }
    public var isRasterized = false
    public var isLandscape: Bool { return isRotated ? frame.height > frame.width : frame.width > frame.height }
    public var assetLocationURL: URL?
    public var externalName: String?
    public var points = [HPPathPoint]()
    public var style = HPStyle()
    
    public var defaultLayout: HPLayout {
        return HPLayer.defaultLayout(for: self)
    }
    
    static public func defaultLayout(for layer: HPLayer) -> HPLayout {
        let top = HPConstraint(sourceID: layer.id, type: .top, value: layer.frame.minY)
        let left = HPConstraint(sourceID: layer.id, type: .left, value: layer.frame.minX)
        let width = HPConstraint(sourceID: layer.id, type: .width, value: layer.frame.width)
        let height = HPConstraint(sourceID: layer.id, type: .height, value: layer.frame.height)
        return HPLayout(key: layer.id, constraints: [top, left, width, height])
    }

    public var layersSortedByTopLeft: [HPLayer] {
        return HPLayer.layersSortedByTopLeft(subLayers)
    }
    
    public var flattened: [HPLayer] {
        var result = [HPLayer]()
        result.append(self)
        for child in subLayers {
            result.append(contentsOf: child.flattened)
        }
        return result
    }
    
    public static func layersSortedByTopLeft(_ layers: [HPLayer]) -> [HPLayer] {
        var result = [HPLayer]()
        let topLayers = layers.sorted { $0.frame.minY > $1.frame.minY }
        var leftLayers = layers.sorted { $0.frame.minX > $1.frame.minX }
        
        let minY = topLayers.first!.frame.minY
        let maxY = topLayers.first!.frame.maxY
        let minX = topLayers.first!.frame.minX
        let maxX = topLayers.first!.frame.maxX
        
        let rowHeight: CGFloat = 1.0
        
        var y = minY
        while y <= maxY && leftLayers.count > 0 {
            let testRect = CGRect(x: minX, y: y, width: maxX-minX, height: rowHeight)
            
            var removedIndexes = [Int]()
            var idx = leftLayers.count - 1
            for layer in leftLayers.reversed() {
                if testRect.intersects(layer.frame) {
                    result.append(layer)
                    removedIndexes.append(idx)
                }
                idx -= 1
            }
            for i in removedIndexes {
                leftLayers.remove(at: i)
            }
            y += rowHeight
        }
        
        return result;
    }
    
    public static func flattened(_ layers: [HPLayer]) -> [HPLayer] {
        var result = [HPLayer]()
        for layer in layers {
            result.append(contentsOf: layer.flattened)
        }
        return result
    }
    
    public func traverse(descendSubclasses: Bool = true, descendEmbeddables: Bool = true, handler: (_ layer: HPLayer, _ parent: HPLayer?)->Bool) {
        _traverse(parent: nil, descendSubclasses: descendSubclasses, descendEmbeddables: descendEmbeddables, handler: handler)
    }
    
    private func _traverse(parent: HPLayer?, descendSubclasses: Bool, descendEmbeddables: Bool, handler: (_ layer: HPLayer, _ parent: HPLayer?)->Bool) -> Bool {
        if !descendSubclasses {
            guard !componentConfig.isSubclass else { return false }
        }
        if !descendEmbeddables {
            guard !(parent?.componentConfig.type.isConsumingType ?? false) else { return false }
        }
        guard !handler(self, parent) else { return true }
        for child in subLayers {
            guard !child._traverse(parent: self, descendSubclasses: descendSubclasses, descendEmbeddables: descendEmbeddables, handler: handler) else { return true }
        }
        return false
    }
    
    public func indexPath(of layer: HPLayer) -> [Int] {
        var result = [Int]()
        _indexPath(of: layer, result: &result)
        return result
    }
    
    private func _indexPath(of target: HPLayer, result: inout [Int]) -> Bool {
        if let idx = subLayers.firstIndex(of: target) {
            result.append(idx)
            return true
        }
        var idx = 0
        for layer in subLayers {
            var subResult = result
            subResult.append(idx)
            if layer._indexPath(of: target, result: &subResult) {
                result = subResult
                return true
            }
            idx += 1
        }
        
        return false
    }
    
    public init(skLayer: SKLayer) {
        let frame = skLayer.frame.cgRect
        self.skLayer = skLayer
        self.frame = frame
        self.id = skLayer.objectID
        self.layerType = HPLayerType.from(layer: skLayer)
        self.name = skLayer.name
        self.isVisible = skLayer.isVisible.skBoolValue
        
        let top = HPConstraint(sourceID: skLayer.objectID, type: .top, value: frame.minY)
        let left = HPConstraint(sourceID: skLayer.objectID, type: .left, value: frame.minX)
        let width = HPConstraint(sourceID: skLayer.objectID, type: .width, value: frame.width)
        let height = HPConstraint(sourceID: skLayer.objectID, type: .height, value: frame.height)
        self.layout = HPLayout(key: skLayer.objectID, constraints: [top, left, width, height])
    }
    
    public init(frame: CGRect, name: String) {
        let id = UUID().uuidString
        self.skLayer = nil
        self.frame = frame
        self.id = id
        self.layerType = .component
        self.name = name
        self.isVisible = true
        
        let top = HPConstraint(sourceID: id, type: .top, value: frame.minY)
        let left = HPConstraint(sourceID: id, type: .left, value: frame.minX)
        let width = HPConstraint(sourceID: id, type: .width, value: frame.width)
        let height = HPConstraint(sourceID: id, type: .height, value: frame.height)
        self.layout = HPLayout(key: id, constraints: [top, left, width, height])
    }
    
    public var hashValue: Int { return id.hashValue }
    
    public static func == (lhs: HPLayer, rhs: HPLayer) -> Bool {
        return lhs.id == rhs.id
    }
}
