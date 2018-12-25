//
//  HPLayerTransformer.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/23/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

public struct HPLayerTransformer {
    
    public init() {}
    
    public func transform(layer: SKLayer, configuration: HPConfiguration) -> HPLayer? {
        let layerMap = buildLayerMap(layer: layer)
        let associatedLayerIDs = buildAssociatedLayerIDs(configuration: configuration)
        if let result = _transform(layer: layer, layerMap: layerMap, associatedLayerIDs: associatedLayerIDs, configuration: configuration) {
            attachAssociatedLayers(layer: result, layerMap: layerMap, configuration: configuration)
            return result
        }
        return nil
    }

    private func _transform(layer: SKLayer,
                            layerMap: [String: SKLayer],
                            associatedLayerIDs: Set<String>,
                            configuration: HPConfiguration) -> HPLayer? {
        let componentConfig = configuration.componentMap[layer.objectID]
        guard componentConfig?.type != .background else { return nil }
        guard !associatedLayerIDs.contains(layer.objectID) else { return nil}
        if let hpLayer = buildHPLayer(layer: layer, configuration: configuration) {
            attachStyle(layer: hpLayer)
            var subLayers = [HPLayer]()
            for child in layer.layers ?? [] {
                if let subLayer = _transform(layer: child, layerMap: layerMap, associatedLayerIDs: associatedLayerIDs, configuration: configuration) {
                    subLayers.append(subLayer)
                }
            }
            hpLayer.subLayers = subLayers
            return hpLayer
        }
        return nil
    }
    
    private func buildHPLayer(layer: SKLayer, configuration: HPConfiguration) -> HPLayer? {
        guard layer.isVisible.skBoolValue else { return nil }
        guard isValidNativeLayer(layer) else { return HPUnimplementedLayer(skLayer: layer) }
        switch layer.layerType {
        case .artboard:
            let result = HPArtboardLayer(skLayer: layer)
            var backgroundLayers = [HPBackgroundLayer]()
            findBackgroundLayers(layer: layer, configuration: configuration, result: &backgroundLayers)
            result.backgroundLayers = backgroundLayers
            return result
        case .text:
            return HPTextLayer(skLayer: layer)
        case .rectangle:
            return HPRectangleLayer(skLayer: layer)
        case .group:
            return HPLayer(skLayer: layer)
        default:
            if layer.isImageLayer {
                let result = HPLayer(skLayer: layer)
                if attachImageLocation(layer: layer, hpLayer: result, configuration: configuration) {
                    return result
                }
            }
            print("unimplemented layer type: \(layer.layerType)")
            return HPUnimplementedLayer(skLayer: layer)
        }
    }
    
    @discardableResult
    private func attachImageLocation(layer: SKLayer, hpLayer: HPLayer, configuration: HPConfiguration) -> Bool {
        var locationURL = URL(fileURLWithPath: configuration.assetsLocation)
        locationURL.appendPathComponent(layer.objectID)
        let assetURL = locationURL.appendingPathExtension("png")
        if FileManager.default.fileExists(atPath: assetURL.path) {
            hpLayer.imageLocationURL = locationURL
            return true
        }
        return false
    }
    
    private func attachAssociatedLayers(layer: HPLayer, layerMap: [String: SKLayer], configuration: HPConfiguration) {
        if let componentConfig = configuration.componentMap[layer.id] {
            var result = [HPLayer]()
            for id in componentConfig.associatedLayers {
                if let l = layerMap[id] {
                    let associatedLayer = HPAssociatedLayer(skLayer: l)
                    if l.isImageLayer {
                        attachImageLocation(layer: l, hpLayer: associatedLayer, configuration: configuration)
                    }
                    attachStyle(layer: associatedLayer)
                    result.append(associatedLayer)
                }
            }
            layer.associatedLayers = result
        }
        for child in layer.subLayers {
            attachAssociatedLayers(layer: child, layerMap: layerMap, configuration: configuration)
        }
    }
    
    private func findBackgroundLayers(layer: SKLayer, configuration: HPConfiguration, result: inout [HPBackgroundLayer]) {
        if layer.isVisible.skBoolValue, let componentConfig = configuration.componentMap[layer.objectID] {
            if componentConfig.type == .background {
                let backgroundLayer = HPBackgroundLayer(skLayer: layer)
                attachStyle(layer: backgroundLayer)
                result.append(backgroundLayer)
            }
        }
        for child in layer.layers ?? [] {
            findBackgroundLayers(layer: child, configuration: configuration, result: &result)
        }
    }
    
    private func buildAssociatedLayerIDs(configuration: HPConfiguration) -> Set<String> {
        var result = Set<String>()
        for c in configuration.components {
            for id in c.associatedLayers {
                result.insert(id)
            }
        }
        return result
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
