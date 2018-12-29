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

public struct HPLayer: Codable, Equatable, Hashable {
    public let skLayer: SKLayer?
    public var isSourceLayer: Bool { return skLayer != nil }

    public let id: String
    public var frame: CGRect
    public let layerType: SKLayerType
    public var attributedString: SKAttributedString? { return skLayer?.attributedString }
    public var componentConfig: HPComponentConfig?
    public var associatedLayers = [HPLayer]()
    public var backgroundLayers = [HPLayer]()
    public var subLayers = [HPLayer]()
    public var isUnimplemented = false
    public var isRootLayer = false
    public var isLocked = false
    public var assetLocationURL: URL?
    public var style = HPStyle(opacity: 1.0,
                               fills: [],
                               borders: [],
                               backgroundColor: nil,
                               cornerRadius: 0.0)
    
    public static func buildLayoutKey(layers: [HPLayer]) -> String {
        return layers.map { $0.id }
            .reduce("") { (acc, cur) in acc.count > 0 ? acc + "|" + cur : cur}
    }
    
    public var defaultLayout: HPLayout {
        let key = HPLayer.buildLayoutKey(layers: [self])
        let top = HPConstraint(type: .top, value: frame.minY, proportionalValue: 0.0, isProportional: false)
        let left = HPConstraint(type: .left, value: frame.minX, proportionalValue: 0.0, isProportional: false)
        let width = HPConstraint(type: .width, value: frame.width, proportionalValue: 0.0, isProportional: false)
        let height = HPConstraint(type: .height, value: frame.height, proportionalValue: 0.0, isProportional: false)
        return HPLayout(key: key, layout: [top, left, width, height])
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
    
    public init(skLayer: SKLayer) {
        self.skLayer = skLayer
        self.frame = skLayer.frame.cgRect
        self.id = skLayer.objectID
        self.layerType = skLayer.layerType
    }
    
    public var hashValue: Int { return id.hashValue }
    
    public static func == (lhs: HPLayer, rhs: HPLayer) -> Bool {
        return lhs.id == rhs.id
    }
}
