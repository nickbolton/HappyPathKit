//
//  HPLayerTransformer.swift
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

public class HPLayerTransformer: NSObject {
    
    private var layerMap = [String: SKLayer]()
    private var transformedLayerMap = [String: HPLayer]()
    
    public func transform(pages: [SKPage], assetsLocation: URL) -> [HPPage] {
        var result = [HPPage]()
        for skPage in pages {
            result.append(HPPage(id: skPage.objectID, layers: transform(layers: skPage.layers, assetsLocation: assetsLocation)))
        }
        
        return result
    }
    
    public func transform(layers: [SKLayer], assetsLocation: URL) -> [HPLayer] {
        var result = [HPLayer]()
        for skLayer in layers {
            if let layer = transform(layer: skLayer, assetsLocation: assetsLocation) {
                result.append(layer)
            }
        }
        return result
    }
    
    private func transform(layer: SKLayer, assetsLocation: URL) -> HPLayer? {
        layerMap = buildLayerMap(layer: layer)
        if let result = _transform(layer: layer, isRootLayer: true, layerMap: layerMap, assetsLocation: assetsLocation) {
            return result
        }
        return nil
    }
    
    private func _transform(layer: SKLayer,
                            isRootLayer: Bool,
                            layerMap: [String: SKLayer],
                            assetsLocation: URL) -> HPLayer? {
        if var hpLayer = buildHPLayer(layer: layer, isRootLayer: isRootLayer, assetsLocation: assetsLocation) {
            transformedLayerMap[hpLayer.id] = hpLayer
            attachStyle(layer: &hpLayer)
            hpLayer.points = buildPathPoints(layer: layer)
            var subLayers = [HPLayer]()
            for child in layer.layers ?? [] {
                if var subLayer = _transform(layer: child, isRootLayer: false, layerMap: layerMap, assetsLocation: assetsLocation) {
                    subLayer.layout = subLayer.defaultLayout(parent: hpLayer)
                    subLayers.append(subLayer)
                }
            }
            hpLayer.subLayers = subLayers
            return hpLayer
        }
        return nil
    }
    
    private func buildHPLayer(layer: SKLayer, isRootLayer: Bool, assetsLocation: URL) -> HPLayer? {
        guard layer.isVisible.skBoolValue else { return nil }
        var result = HPLayer(skLayer: layer)
        result.isRasterized = isRasterized(layer)
        result.isRootLayer = isRootLayer
        if isRootLayer {
            result.frame = CGRect(origin: .zero, size: result.frame.size)
        }
        if !attachImageLocation(layer: layer, hpLayer: &result, assetsLocation: assetsLocation) {
            result.isRasterized = false
            switch layer.layerType {
            case .artboard, .text, .rectangle, .group:
                break
            default:
                print("unimplemented layer type: \(layer.objectID) \(layer.layerType)")
                return buildUnimplementedLayer(skLayer: layer)
            }
        }
        return result
    }
    
    @discardableResult
    private func attachImageLocation(layer: SKLayer, hpLayer: inout HPLayer, assetsLocation: URL) -> Bool {
        var locationURL = assetsLocation
        locationURL.appendPathComponent(layer.objectID)
        let assetURL = locationURL.appendingPathExtension("png")
        if FileManager.default.fileExists(atPath: assetURL.path) {
            print("settings asset location: \(layer.objectID) \(assetsLocation)")
            hpLayer.assetLocationURL = assetsLocation
            return true
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
    
    private func buildPathPoints(layer: SKLayer) -> [HPPathPoint] {
        var result = [HPPathPoint]()
        for point in layer.points ?? [] {
            let pp = HPPathPoint(point: point.point.cgPoint,
                                 curveMode: point.curveMode,
                                 curveFrom: point.hasCurveFrom.skBoolValue ? point.curveFrom.cgPoint : nil,
                                 curveTo: point.hasCurveTo.skBoolValue ? point.curveTo.cgPoint : nil,
                                 cornerRadius: point.cornerRadius)
            result.append(pp)
        }
        return result
    }
    
    private func attachStyle(layer: inout HPLayer) {
        guard let skStyle = layer.skLayer?.style else { return }
        let hasBackgroundColor = layer.skLayer?.hasBackgroundColor?.skBoolValue ?? false
        let backgroundColor = hasBackgroundColor ? layer.skLayer!.backgroundColor : nil
        let cornerRadius = findCornerRadius(layer.skLayer)
        layer.style = HPStyle(opacity: skStyle.contextSettings.opacity,
                              fills: buildFills(layer: layer.skLayer, skStyle: skStyle),
                              borders: buildBorders(skStyle),
                              backgroundColor: backgroundColor,
                              cornerRadius: cornerRadius)
    }
    
    private func findCornerRadius(_ layer: SKLayer?) -> CGFloat {
        guard let layer = layer else { return 0.0 }
        guard let points = layer.points, points.count > 0 else { return 0.0 }
        if points.count == 4 {
            return points.reduce(points.first!.cornerRadius) { (acc, cur) in cur.cornerRadius == acc ? acc : 0.0}
        }
        return 0.0
    }
    
    private func buildFills(layer: SKLayer?, skStyle: SKLayerStyle) -> [HPFill] {
        guard let layer = layer else { return [] }
        var result = [HPFill]()
        let enabledFills = skStyle.fills.filter { $0.isEnabled.skBoolValue }
        for skFill in enabledFills {
            let fill = HPFill(color: skFill.color,
                              opacity: skFill.contextSettings.opacity,
                              gradient: buildGradient(skFill),
                              blendMode: Int32(skFill.contextSettings.blendMode))
            result.append(fill)
        }
        return result
    }
    
    private func buildGradient(_ skFill: SKLayerFill) -> HPGradient? {
        guard skFill.fillType == .gradient else { return nil }
        let skGradient = skFill.gradient
        var stops = [HPStop]()
        for s in skGradient.stops {
            stops.append(HPStop(color: s.color, position: s.position))
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
                                   color: border.color,
                                   type: .inside))
        }
        return result
    }
    
    private func buildUnimplementedLayer(skLayer: SKLayer) -> HPLayer {
        var result = HPLayer(skLayer: skLayer)
        result.isUnimplemented = true
        return result
    }
    
    private func isRasterized(_ layer: SKLayer) -> Bool {
        
        switch layer.layerType {
        case .bitmap, .shapePath, .shapeGroup, .slice:
            return true
        default:
            break
        }
        
        // only allow linear gradients
        if let style = layer.style {
            let enabledFills = style.fills.filter { $0.isEnabled.skBoolValue }
            for fill in enabledFills {
                if fill.fillType == .gradient {
                    guard fill.gradient.gradientType == .linear else {
                        return true
                    }
                }
            }
        }
        
        // only allow pure corner radius clipping path points
        if layer.layerType == .rectangle {
            if let points = layer.points, points.count > 0 {
                guard points.count == 4 else {
                    return true
                }
                
                let cornerRadius: CGFloat? = points.reduce(points.first!.cornerRadius) { (acc, cur) in cur.cornerRadius == acc ? acc : nil}
                if cornerRadius == nil {
                    return true
                }
            }
        }
        
        // only allow one inside border
        if let style = layer.style {
            let enabledBorders = style.borders.filter { $0.isEnabled.skBoolValue }
            guard enabledBorders.count <= 1 else {
                return true
            }
            if let border = enabledBorders.first {
                guard border.position == .inside else {
                    return true
                }
            }
        }
        
        return false
    }
}
