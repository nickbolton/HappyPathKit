//
//  HPLayerTransformer.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/23/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

public class HPLayerTransformer: NSObject {
    
    private var layerMap = [String: SKLayer]()
    private var transformedLayerMap = [String: HPLayer]()
    private var collectionViewMap = [String: SKLayer]()
    private var associatedLayerMap = [String: [SKLayer]]()
    private var configuration: HPConfiguration!
    private var holder: HPLayer?
    
    public func transform(layer: SKLayer, configuration: HPConfiguration) -> HPLayer? {
        self.configuration = configuration
        layerMap = buildLayerMap(layer: layer)
        buildAssociatedLayerMap()
        collectionViewMap = findCollections(layer: layer)
        let associatedLayerIDs = buildAssociatedLayerIDs()
        if let result = _transform(layer: layer, layerMap: layerMap, associatedLayerIDs: associatedLayerIDs) {
            attachAssociatedLayers(layer: result, layerMap: layerMap)
            return result
        }
        return nil
    }
    
    private func isAssociatedTraversableType(_ type: ComponentType?) -> Bool {
        guard let type = type else { return false }
        switch type {
        case .table, .tableHeader, .tableSectionHeader,
             .tableCell, .tableSectionFooter, .tableFooter,
             .collection, .collectionCell:
            return true
        default:
            return false
        }
    }

    private func isCollectionSubType(_ type: ComponentType?) -> Bool {
        guard let type = type else { return false }
        switch type {
        case .tableHeader, .tableSectionHeader,
             .tableCell, .tableSectionFooter, .tableFooter,
             .collectionCell:
            return true
        default:
            return false
        }
    }

    private func _transform(layer: SKLayer,
                            layerMap: [String: SKLayer],
                            associatedLayerIDs: Set<String>) -> HPLayer? {
        let componentConfig = configuration.componentMap[layer.objectID]
        guard componentConfig?.type != .background else { return nil }
        guard !associatedLayerIDs.contains(layer.objectID) || isAssociatedTraversableType(componentConfig?.type) else {
            return nil
        }
        guard !isInsideCollection(layer: layer) else {
            return nil
        }
        if let hpLayer = buildHPLayer(layer: layer) {
            transformedLayerMap[hpLayer.id] = hpLayer
            attachStyle(layer: hpLayer)
            if hpLayer.imageLocationURL == nil {
                var subLayers = [HPLayer]()
                for child in layer.layers ?? [] {
                    if let subLayer = _transform(layer: child, layerMap: layerMap, associatedLayerIDs: associatedLayerIDs) {
                        if !isCollectionSubType(subLayer.componentConfig?.type) {
                            subLayers.append(subLayer)
                        }
                    }
                }
                hpLayer.subLayers = subLayers
            }
            return hpLayer
        }
        return nil
    }
    
    private func buildHPLayer(layer: SKLayer) -> HPLayer? {
        guard layer.isVisible.skBoolValue else { return nil }
        guard isValidNativeLayer(layer) else { return HPUnimplementedLayer(skLayer: layer) }
        var result: HPLayer?
        switch layer.layerType {
        case .artboard:
            result = HPArtboardLayer(skLayer: layer)
            var backgroundLayers = [HPBackgroundLayer]()
            findBackgroundLayers(layer: layer, result: &backgroundLayers)
            result?.backgroundLayers = backgroundLayers
        case .text:
            result = HPTextLayer(skLayer: layer)
        case .rectangle:
            result = HPRectangleLayer(skLayer: layer)
        case .group:
            result = HPLayer(skLayer: layer)
        default:
            if layer.isImageLayer {
                result = HPLayer(skLayer: layer)
                if !attachImageLocation(layer: layer, hpLayer: result!) {
                    result = nil
                }
            }
            if result == nil {
                print("unimplemented layer type: \(layer.layerType)")
                return HPUnimplementedLayer(skLayer: layer)
            }
        }
        result?.componentConfig = configuration.componentMap[layer.objectID]
        return result
    }
    
    @discardableResult
    private func attachImageLocation(layer: SKLayer, hpLayer: HPLayer) -> Bool {
        var locationURL = URL(fileURLWithPath: configuration.assetsLocation)
        locationURL.appendPathComponent(layer.objectID)
        let assetURL = locationURL.appendingPathExtension("png")
        if FileManager.default.fileExists(atPath: assetURL.path) {
            hpLayer.imageLocationURL = locationURL
            return true
        }
        return false
    }
    
    private func attachAssociatedLayers(layer: HPLayer, layerMap: [String: SKLayer]) {
        var result = [HPLayer]()
        var potentials = associatedLayerMap[layer.id] ?? []
        if layer.componentConfig?.type == .table {
            potentials = potentials.filter {
                if let config = configuration.componentMap[$0.objectID] {
                   return config.type == .tableCell
                    || config.type == .tableHeader
                    || config.type == .tableFooter
                    || config.type == .tableSectionHeader
                    || config.type == .tableSectionFooter
                }
                return false
            }
        } else if layer.componentConfig?.type == .collection {
            potentials = potentials.filter {
                if let config = configuration.componentMap[$0.objectID] {
                    return config.type == .collectionCell
                }
                return false
            }
        }
        for l in potentials {
            guard l.isVisible.skBoolValue else { continue }
            let associatedLayer = transformedLayerMap[l.objectID] ?? HPAssociatedLayer(skLayer: l)
            associatedLayer.componentConfig = configuration.componentMap[l.objectID]
            if l.isImageLayer {
                attachImageLocation(layer: l, hpLayer: associatedLayer)
            }
            attachStyle(layer: associatedLayer)
            result.append(associatedLayer)
            attachAssociatedLayers(layer: associatedLayer, layerMap: layerMap)
        }
        layer.associatedLayers = result
        for child in layer.subLayers {
            attachAssociatedLayers(layer: child, layerMap: layerMap)
        }
    }
    
    private func findBackgroundLayers(layer: SKLayer, result: inout [HPBackgroundLayer]) {
        if layer.isVisible.skBoolValue, let componentConfig = configuration.componentMap[layer.objectID] {
            if componentConfig.type == .background {
                let backgroundLayer = HPBackgroundLayer(skLayer: layer)
                attachStyle(layer: backgroundLayer)
                result.append(backgroundLayer)
            }
        }
        for child in layer.layers ?? [] {
            findBackgroundLayers(layer: child, result: &result)
        }
    }
    
    private func buildAssociatedLayerIDs() -> Set<String> {
        var result = Set<String>()
        for list in associatedLayerMap.values {
            for item in list {
                result.insert(item.objectID)
            }
        }
        return result
    }
    
    private func findCollections(layer: SKLayer) -> [String: SKLayer] {
        var result = [String: SKLayer]()
        accumulateCollections(layer: layer, result: &result)
        return result
    }
    
    private func accumulateCollections(layer: SKLayer, result: inout [String: SKLayer]) {
        let type = configuration.componentMap[layer.objectID]?.type
        if type == .table || type == .collection {
            result[layer.objectID] = layer
        }
        for child in layer.layers ?? [] {
            accumulateCollections(layer: child, result: &result)
        }
    }
    
    private func isInsideCollection(layer: SKLayer) -> Bool {
        let type = configuration?.componentMap[layer.objectID]?.type
        guard !isAssociatedTraversableType(type) else { return false }
        for collection in collectionViewMap.values {
            if collection.frame.cgRect.contains(layer.frame.cgRect) {
                return true
            }
        }
        return false
    }
    
    private func buildLayerMap(layer: SKLayer) -> [String: SKLayer] {
        var result = [String: SKLayer]()
        buildLayerMap(layer: layer, result: &result)
        return result
    }
    
    private func buildLayerMap(layer: SKLayer, result: inout [String: SKLayer]) {
        result[layer.objectID] = layer
        for child in layer.layers ?? [] {
            buildLayerMap(layer: child, result: &result)
        }
    }
    
    private func buildAssociatedLayerMap() {
        for l1 in layerMap.values {
            guard let config = configuration.componentMap[l1.objectID] else { continue }
            guard isAssociatedTraversableType(config.type) || config.type == .button else { continue }
            if config.type == .tableCell {
                print("ZZZ")
            }
            for l2 in layerMap.values {
                guard l1.objectID != l2.objectID else { continue }
                if l1.frame.cgRect.contains(l2.frame.cgRect) {
                    var list = associatedLayerMap[l1.objectID] ?? []
                    list.append(l2)
                    associatedLayerMap[l1.objectID] = list
                }
            }
        }
    }
    
    private func accumulateAssociatedLayers(layer: SKLayer) {
    }
    
    private func attachStyle(layer: HPLayer) {
        guard let skStyle = layer.skLayer.style else { return }
        let hasBackgroundColor = layer.skLayer.hasBackgroundColor?.skBoolValue ?? false
        let backgroundColor = hasBackgroundColor ? layer.skLayer.backgroundColor?.uiColor : nil
        let cornerRadius = findCornerRadius(layer.skLayer)
        layer.style = HPStyle(opacity: skStyle.contextSettings.opacity,
                              fills: buildFills(layer: layer.skLayer, skStyle: skStyle),
                              borders: buildBorders(skStyle),
                              backgroundColor: backgroundColor,
                              cornerRadius: cornerRadius)
    }
    
    private func findCornerRadius(_ layer: SKLayer) -> CGFloat {
        guard let points = layer.points, points.count > 0 else { return 0.0 }
        if points.count == 4 {
            return points.reduce(points.first!.cornerRadius) { (acc, cur) in cur.cornerRadius == acc ? acc : 0.0}
        }
        return 0.0
    }
    
    private func buildFills(layer: SKLayer, skStyle: SKLayerStyle) -> [HPFill] {
        var result = [HPFill]()
        let enabledFills = skStyle.fills.filter { $0.isEnabled.skBoolValue }
        for skFill in enabledFills {
            let fill = HPFill(blendMode: skFill.contextSettings.cgBlendMode,
                              opacity: skFill.contextSettings.opacity,
                              color: skFill.color.uiColor,
                              gradient: buildGradient(skFill))
            result.append(fill)
        }
        return result
    }
    
    private func buildGradient(_ skFill: SKLayerFill) -> HPGradient? {
        guard skFill.fillType == .gradient else { return nil }
        let skGradient = skFill.gradient
        var stops = [HPStop]()
        for s in skGradient.stops {
            stops.append(HPStop(color: s.color.uiColor, position: s.position))
        }
        return HPGradient(stops: stops,
                          gradientType: skGradient.gradientType,
                          from: skGradient.from.cgPoint,
                          to: skGradient.to.cgPoint)
    }
    
    private func buildBorders(_ skStyle: SKLayerStyle) -> [HPBorder] {
        var result = [HPBorder]()
        let enabledBorders = skStyle.borders.filter { $0.isEnabled.skBoolValue }
        for border in enabledBorders {
            result.append(HPBorder(thickness: border.thickness,
                                   color: border.color.uiColor,
                                   type: .inside))
        }
        return result
    }
    
    private func isValidNativeLayer(_ layer: SKLayer) -> Bool {
        
        // only allow linear gradients
        if let style = layer.style {
            let enabledFills = style.fills.filter { $0.isEnabled.skBoolValue }
            for fill in enabledFills {
                if fill.fillType == .gradient {
                    guard fill.gradient.gradientType == .linear else {
                        return false
                    }
                }
            }
        }
        
        // only allow pure corner radius clipping path points
        if layer.layerType == .rectangle {
            if let points = layer.points, points.count > 0 {
                guard points.count == 4 else {
                    return false
                }
                
                let cornerRadius: CGFloat? = points.reduce(points.first!.cornerRadius) { (acc, cur) in cur.cornerRadius == acc ? acc : nil}
                if cornerRadius == nil {
                    return false
                }
            }
        }
        
        // only allow one inside border
        if let style = layer.style {
            let enabledBorders = style.borders.filter { $0.isEnabled.skBoolValue }
            guard enabledBorders.count <= 1 else {
                return false
            }
            if let border = enabledBorders.first {
                guard border.position == .inside else {
                    return false
                }
            }
        }
        
        return true
    }
}
