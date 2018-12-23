//
//  SKLayer.swift
//  HappyPath
//
//  Created by Nick Bolton on 12/8/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//
#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public typealias SKLayerGroup = [SKLayer]

public enum SKLayerType {
    case artboard
    case group
    case bitmap
    case hotspot
    case openGL
    case shapePath
    case slice
    case text
    case oval
    case polygon
    case rectangle
    case star
    case triangle
    case symbolInstance
    case unknown
}

public struct SKLayer: Codable, Equatable, Hashable {
    
    public let shouldBreakMaskChain, rotation: Int
    public let objectID: String
    public var frame: SKLayerFrame
    public let isFlippedVertical: Int
    public let isFlippedHorizontal: Int
    public let exportOptions: SKExportOptions
    public let isVisible: Int
    public let hasBackgroundColor: Int?
    public let backgroundColor: SKBackgroundColor?
    public let booleanOperation: Int
    public let resizingConstraint: Int
    public let resizingType: Int
    public let layerClass: String
    public let isLocked: Int
    public let layerListExpandedType: Int
    public let nameIsFixed: Int
    public let isFixedToViewport: Int
    public let name: String
    public let flow: SKFlow?
    public let verticalSpacing: Int?
    public let style: SKLayerStyle?
    public let symbolID: String?
    public let clippingMaskMode: Int?
    public let hasClippingMask: Int?
    public let horizontalSpacing: CGFloat?
    public let scale: CGFloat?
    public let overrideValues: [JSONAny]?
    public let sharedStyleID: String?
    public let glyphBounds: SKClippingMask?
    public let dontSynchroniseWithSymbol: Int?
    public let lineSpacingBehaviour: Int?
    public let textBehaviour: Int?
    public let attributedString: SKAttributedString?
    public let automaticallyDrawOnUnderlyingPath: Int?
    public let hasConvertedToNewRoundCorners: Int?
    public let edited: Int?
    public let isClosed: Int?
    public let points: [SKLayerPoint]?
    public let fixedRadius: CGFloat?
    public let pointRadiusBehaviour: Int?
    public let isEquilateral: Int?
    public let radius: CGFloat?
    public let numberOfPoints: Int?
    public let image: SKLayerImage?
    public let clippingMask: SKClippingMask?
    public let fillReplacesImage: Int?
    public let intendedDPI: Int?
    public var layers: SKLayerGroup?
    public var isRootLayer = false
        
    public var layerType: SKLayerType {
        switch layerClass {
        case "MSArtboardGroup", "MSImmutableArtboardGroup":
            return .artboard
        case "MSLayerGroup", "MSImmutableLayerGroup":
            return .group
        case "MSBitmapLayer", "MSImmutableBitmapLayer":
            return .bitmap
        case "MSHotspotLayer", "MSImmutableHotspotLayer":
            return .hotspot
        case "MSOpenGLLayer":
            return .openGL
        case "MSShapePathLayer", "MSImmutableShapePathLayer":
            return .shapePath
        case "MSSliceLayer", "MSImmutableSliceLayer":
            return .slice
        case "MSTextLayer", "MSImmutableTextLayer":
            return .text
        case "MSOvalShape", "MSImmutableOvalShape":
            return .oval
        case "MSPolygonShape", "MSImmutablePolygonShape", "SVGPolygonShape":
            return .polygon
        case "MSRectangleShape", "MSImmutableRectangleShape", "SVGRectangleShape.h":
            return .rectangle
        case "MSStarShape", "MSImmutableStarShape":
            return .star
        case "MSTriangleShape", "MSImmutableTriangleShape":
            return .triangle
        case "MSSymbolInstance", "MSImmutableSymbolInstance":
            return .symbolInstance
        default:
            assert(false, "Unknown layer type: \(layerClass)")
            return .unknown
        }
    }
    
    public var flattened: [SKLayer] {
        var result = [SKLayer]()
        result.append(self)
        for child in layers ?? [] {
            result.append(contentsOf: child.flattened)
        }
        return result
    }
    
    enum CodingKeys: String, CodingKey {
        case shouldBreakMaskChain, rotation, objectID, frame, isFlippedVertical, exportOptions, isVisible, hasBackgroundColor, backgroundColor, booleanOperation, isFlippedHorizontal, resizingConstraint, resizingType
        case layerClass = "<class>"
        case isLocked, layerListExpandedType, nameIsFixed, isFixedToViewport, name, flow, verticalSpacing, style, symbolID, clippingMaskMode, hasClippingMask, horizontalSpacing, scale, overrideValues, sharedStyleID, glyphBounds, dontSynchroniseWithSymbol, lineSpacingBehaviour, textBehaviour, attributedString, automaticallyDrawOnUnderlyingPath, hasConvertedToNewRoundCorners, edited, isClosed, points, fixedRadius, pointRadiusBehaviour, isEquilateral, radius, numberOfPoints, image, clippingMask, fillReplacesImage, intendedDPI
        case layers
    }
    
    public var layersSortedByTopLeft: SKLayerGroup {
        guard let layers = layers else { return [] }
        return SKLayer.layersSortedByTopLeft(layers)
    }
    
    public static func flattened(_ layers: [SKLayer]) -> [SKLayer] {
        var result = [SKLayer]()
        for layer in layers {
            result.append(contentsOf: layer.flattened)
        }
        return result
    }
    
    public static func layersSortedByTopLeft(_ layers: SKLayerGroup) -> SKLayerGroup {
        var result = SKLayerGroup()
        let topLayers = layers.sorted { $0.frame.y > $1.frame.y }
        var leftLayers = layers.sorted { $0.frame.x > $1.frame.x }
        
        let minY = topLayers.first!.frame.y
        let maxY = topLayers.first!.frame.cgRect.maxY
        let minX = topLayers.first!.frame.x
        let maxX = topLayers.first!.frame.cgRect.maxX
        
        let rowHeight: CGFloat = 1.0
        
        var y = minY
        while y <= maxY && leftLayers.count > 0 {
            let testRect = CGRect(x: minX, y: y, width: maxX-minX, height: rowHeight)
            
            var removedIndexes = [Int]()
            var idx = leftLayers.count - 1
            for layer in leftLayers.reversed() {
                if testRect.intersects(layer.frame.cgRect) {
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
    
    public var hashValue: Int { return objectID.hashValue }
    
    public static func == (lhs: SKLayer, rhs: SKLayer) -> Bool {
        return lhs.objectID == rhs.objectID
    }
}

public struct SKColor {
    public let red: CGFloat
    public let green: CGFloat
    public let blue: CGFloat
    public let alpha: CGFloat
    public let rawValue: String
    
#if os(iOS)
    public var uiColor: UIColor { return UIColor(displayP3Red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha) }
    
    public var cgColor: CGColor { return uiColor.cgColor }

#elseif os(macOS)
#endif
        
    public init(rawValue: String) {
        self.rawValue = rawValue
        (self.red, self.green, self.blue, self.alpha) =
            rawValue.hasPrefix("rgba(") ?
                SKColor.componentsFromRGBA(rawValue) :
                SKColor.componentsFromHexcode(rawValue)
    }

    static private func componentsFromRGBA(_ rgba: String) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        let zero: (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        do {
            let regex = try NSRegularExpression(pattern: "rgba\\(([0-9]+(\\.[0-9]+)?),[\t ]*([0-9]+(\\.[0-9]+)?),[\t ]*([0-9]+(\\.[0-9]+)?),[\t ]*([0-9]+(\\.[0-9]+)?)")
            let matches = regex.matches(in: rgba,
                                        range: NSRange(rgba.startIndex..., in: rgba))
            let results = matches.map { result in
                (0..<result.numberOfRanges).map { (pos:Int) -> String in
                    let range = result.range(at: pos)
                    guard range.location != Foundation.NSNotFound else { return "" }
                    let start = rgba.index(rgba.startIndex, offsetBy: range.location)
                    let end = rgba.index(start, offsetBy: range.length)
                    return String(rgba[start..<end])
                }
            }
            guard results.count == 1 else { return zero }
            let result = results[0]
            guard result.count == 9 else { return zero }
            guard let red = NumberFormatter().number(from: result[1]) else { return zero }
            guard let green = NumberFormatter().number(from: result[3]) else { return zero }
            guard let blue = NumberFormatter().number(from: result[5]) else { return zero }
            guard let alpha = NumberFormatter().number(from: result[7]) else { return zero }
            return (CGFloat(red.floatValue), CGFloat(green.floatValue), CGFloat(blue.floatValue), CGFloat(alpha.floatValue))
        } catch {
            print(error)
        }
        return zero
    }
    
    static private func componentsFromHexcode(_ hexcode: String) -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var charSet = CharacterSet.whitespacesAndNewlines
        charSet.insert("#")
        let _hex = hexcode.trimmingCharacters(in: charSet)
        guard _hex.range(of: "^[0-9A-Fa-f]{6}$", options: .regularExpression) != nil else {
            return (0.0, 0.0, 0.0, 0.0)
        }
        var rgb: UInt32 = 0
        Scanner(string: _hex).scanHexInt32(&rgb)
        let red = CGFloat(UInt8((rgb & 0xFF0000) >> 16))
        let green = CGFloat(UInt8((rgb & 0x00FF00) >> 8))
        let blue = CGFloat(UInt8(rgb & 0x0000FF))
        return (red, green, blue, 1.0)
    }
}

public struct SKBackgroundColor: Codable {
    public let backgroundColorClass: SKBackgroundColorClass
    public let rawValue: String
    public let externalName: String
    
    public var color: SKColor { return SKColor(rawValue: rawValue) }
    
    #if os(iOS)
    public var uiColor: UIColor {
        let color = self.color
        return UIColor(displayP3Red: color.red / 255.0,
                       green: color.green / 255.0,
                       blue: color.blue / 255.0,
                       alpha: color.alpha) }
    
    public var cgColor: CGColor { return uiColor.cgColor }
    
    #elseif os(macOS)
    #endif

    enum CodingKeys: String, CodingKey {
        case backgroundColorClass = "<class>"
        case rawValue = "value"
        case externalName
    }
}

public enum SKBackgroundColorClass: String, Codable {
    case msColor = "MSColor"
    case msImmutableColor = "MSImmutableColor"
}

public struct SKExportOptions: Codable {
    public let shouldTrim: Int
    public let exportOptionsClass: SKExportOptionsClass
    public let includedLayerIDS: [JSONAny]
    public let layerOptions: Int
    public let exportFormats: [SKExportFormat]
    
    enum CodingKeys: String, CodingKey {
        case shouldTrim
        case exportOptionsClass = "<class>"
        case includedLayerIDS = "includedLayerIds"
        case layerOptions, exportFormats
    }
}

public struct SKExportFormat: Codable {
    public let absoluteSize: Int
    public let fileFormat: String
    public let namingScheme: Int
    public let exportFormatClass: String
    public let visibleScaleType: Int
    public let name: String
    public let scale: Int
    
    enum CodingKeys: String, CodingKey {
        case absoluteSize, fileFormat, namingScheme
        case exportFormatClass = "<class>"
        case visibleScaleType, name, scale
    }
}

public enum SKExportOptionsClass: String, Codable {
    case msExportOptions = "MSExportOptions"
}

public struct SKLayerFrame: Codable {
    public let x, y, width, height: CGFloat
    public let frameClass: SKFrameClass
    public let constrainProportions: Int
    
    public var cgRect: CGRect { return CGRect(x: x, y: y, width: width, height: height) }
    
    enum CodingKeys: String, CodingKey {
        case y
        case frameClass = "<class>"
        case constrainProportions, height, width, x
    }
    
    public func offsetBy(_ offset: CGVector) -> SKLayerFrame {
        return SKLayerFrame(x: x + offset.dx,
                          y: y + offset.dy,
                          width: width,
                          height: height,
                          frameClass: frameClass,
                          constrainProportions: constrainProportions)
    }
    
    public init(rect: CGRect) {
        self.x = rect.origin.x
        self.y = rect.origin.y
        self.width = rect.size.width
        self.height = rect.size.height
        self.frameClass = .msRect
        self.constrainProportions = 63
    }
    
    public init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, frameClass: SKFrameClass = .msRect, constrainProportions: Int = 63) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.frameClass = frameClass
        self.constrainProportions = constrainProportions
    }
}

public enum SKFrameClass: String, Codable {
    case msRect = "MSRect"
}

public struct SKAlRulerData: Codable {
    public let alRulerDataClass: String
    public let base: Int
    public let guides: [JSONAny]
    
    enum CodingKeys: String, CodingKey {
        case alRulerDataClass = "<class>"
        case base, guides
    }
}

public struct SKAttributedString: Codable {
    public let attributedStringClass: String
    public let value: SKValueClass
    
    enum CodingKeys: String, CodingKey {
        case attributedStringClass = "<class>"
        case value
    }
}

public struct SKValueClass: Codable {
    public let valueClass, text, externalName: String
    public let attributes: [SKAttribute]
    
    enum CodingKeys: String, CodingKey {
        case valueClass = "<class>"
        case text, attributes, externalName
    }
}

public struct SKAttribute: Codable {
    public let length: Int
    public let nsFont: SKLayerFont
    public let nsKern: CGFloat?
    public let location: Int
    public let text: String
    public let msAttributedStringColorAttribute: SKBackgroundColor
    public let nsParagraphStyle: SKParagraphStyle
    public let textStyleVerticalAlignmentKey: Int?
    
    enum CodingKeys: String, CodingKey {
        case length
        case nsFont = "NSFont"
        case nsKern = "NSKern"
        case location, text
        case msAttributedStringColorAttribute = "MSAttributedStringColorAttribute"
        case nsParagraphStyle = "NSParagraphStyle"
        case textStyleVerticalAlignmentKey
    }
}

public struct SKLayerFont: Codable {
    public let name: String
    public let externalName: String
    public let attributes: SKAttributes
    public let family: String
}

public struct SKAttributes: Codable {
    public let nsFontSizeAttribute: CGFloat
    public let nsFontNameAttribute: String
    
    enum CodingKeys: String, CodingKey {
        case nsFontSizeAttribute = "NSFontSizeAttribute"
        case nsFontNameAttribute = "NSFontNameAttribute"
    }
}

public struct SKParagraphStyle: Codable {
    public let nsParagraphStyleClass: String
    public let style: SKParagraphStyleStyle
    
    enum CodingKeys: String, CodingKey {
        case nsParagraphStyleClass = "<class>"
        case style
    }
}

public struct SKParagraphStyleStyle: Codable {
    public let headerLevel: Int
    public let paragraphSpacing: CGFloat
    public let tabStops: [Int]
    public let headIndent, lineBreakMode, tailIndent, firstLineHeadIndent: Int
    public let hyphenationFactor: CGFloat
    public let alignment: Int
    public let paragraphSpacingBefore, minimumLineHeight: CGFloat
    public let lineSpacing, maximumLineHeight, lineHeightMultiple: CGFloat
    public let baseWritingDirection: Int
    public let defaultTabInterval: Int
}

public struct SKClippingMask: Codable {
    public let x, y, width, height: CGFloat
}

public struct SKFlow: Codable {
    public let flowClass: String
    public let animationType: Int
    
    enum CodingKeys: String, CodingKey {
        case flowClass = "<class>"
        case animationType
    }
}

public struct SKLayerImage: Codable {
    public let imageClass: String
    public let rawSize: String
    public let sha1: String
    
    public var size: CGSize {
        do {
            let regex = try NSRegularExpression(pattern: "\\{([0-9]+(\\.[0-9]+)?),[\t ]*([0-9]+(\\.[0-9]+)?)\\}")
            let matches = regex.matches(in: rawSize,
                                        range: NSRange(rawSize.startIndex..., in: rawSize))
            let results = matches.map { result in
                (0..<result.numberOfRanges).map { (pos:Int) -> String in
                    let range = result.range(at: pos)
                    guard range.location != Foundation.NSNotFound else { return "" }
                    let start = rawSize.index(rawSize.startIndex, offsetBy: range.location)
                    let end = rawSize.index(start, offsetBy: range.length)
                    return String(rawSize[start..<end])
                }
            }
            guard results.count == 1 else { return .zero }
            let result = results[0]
            guard result.count == 5 else { return .zero }
            guard let width = NumberFormatter().number(from: result[1]) else { return .zero }
            guard let height = NumberFormatter().number(from: result[3]) else { return .zero }
            return CGSize(width: CGFloat(width.floatValue), height: CGFloat(height.floatValue))
        } catch {
            print(error)
        }
        return .zero
    }
    
    enum CodingKeys: String, CodingKey {
        case imageClass = "<class>"
        case rawSize = "size"
        case sha1
    }
}

public struct SKLayerPoint: Codable {
    public let hasCurveFrom, curveMode: Int
    public let curveFrom, point: SKLayerCenter
    public let pointClass: SKPointClass
    public let cornerRadius: CGFloat
    public let curveTo: SKLayerCenter
    public let hasCurveTo: Int
    
    enum CodingKeys: String, CodingKey {
        case hasCurveFrom, curveMode, curveFrom, point
        case pointClass = "<class>"
        case cornerRadius, curveTo, hasCurveTo
    }
}

public struct SKLayerCenter: Codable {
    public let x, y: CGFloat
    public var cgPoint: CGPoint { return CGPoint(x: x, y: y) }
}

public enum SKPointClass: String, Codable {
    case msCurvePoint = "MSCurvePoint"
}

public struct SKLayerStyle: Codable {
    public let startMarkerType: Int
    public let borderOptions: SKBorderOptions
    public let endMarkerType, windingRule: Int
    public let contextSettings: SKContextSettings
    public let blur: SKLayerBlur
    public let styleClass: SKStyleClass
    public let fills: [SKLayerFill]
    public let miterLimit: Int
    public let colorControls: SKColorControls
    public let innerShadows: [JSONAny]
    public let borders: [SKLayerBorder]
    public let shadows: [JSONAny]
    public let textStyle: SKTextStyle?
    public let objectID: String?
    
    enum CodingKeys: String, CodingKey {
        case startMarkerType, borderOptions, endMarkerType, windingRule, contextSettings, blur
        case styleClass = "<class>"
        case fills, miterLimit, colorControls, innerShadows, borders, shadows, textStyle, objectID
    }
}

public struct SKLayerBlur: Codable {
    public let radius: CGFloat
    public let center: SKLayerCenter
    public let blurClass: SKBlurClass
    public let type: Int
    public let isEnabled: Int
    public let motionAngle, saturation: CGFloat
    
    enum CodingKeys: String, CodingKey {
        case radius, center
        case blurClass = "<class>"
        case motionAngle, saturation, type, isEnabled
    }
}

public enum SKBlurClass: String, Codable {
    case msStyleBlur = "MSStyleBlur"
}

public struct SKBorderOptions: Codable {
    public let lineJoinStyle: Int
    public let borderOptionsClass: SKBorderOptionsClass
    public let isEnabled, lineCapStyle: Int
    public let dashPattern: [JSONAny]
    
    enum CodingKeys: String, CodingKey {
        case lineJoinStyle
        case borderOptionsClass = "<class>"
        case isEnabled, lineCapStyle, dashPattern
    }
}

public enum SKBorderOptionsClass: String, Codable {
    case msStyleBorderOptions = "MSStyleBorderOptions"
}

public enum SKBorderType: Int, Codable {
    case center
    case inside
    case outside
}

public struct SKLayerBorder: Codable {
    public let position: SKBorderType
    public let color: SKBackgroundColor
    public let borderClass: SKBorderClass
    public let gradient: SKLayerGradient
    public let fillType: Int
    public let thickness: CGFloat
    public let contextSettings: SKContextSettings
    public let isEnabled: Int
    
    enum CodingKeys: String, CodingKey {
        case position, color
        case borderClass = "<class>"
        case gradient, fillType, thickness, contextSettings, isEnabled
    }
}

public enum SKBorderClass: String, Codable {
    case msStyleBorder = "MSStyleBorder"
}

public struct SKContextSettings: Codable {
    public let contextSettingsClass: SKContextSettingsClass
    public let opacity: CGFloat
    public let blendMode: Int
    
    public var cgBlendMode: CGBlendMode {
        return CGBlendMode(rawValue: Int32(blendMode)) ?? .normal
    }
    
    enum CodingKeys: String, CodingKey {
        case contextSettingsClass = "<class>"
        case opacity, blendMode
    }
}

public enum SKContextSettingsClass: String, Codable {
    case msGraphicsContextSettings = "MSGraphicsContextSettings"
}

public enum SKLayerGradientType: Int, Codable {
    case linear = 0
    case radial
    case angular
    
    public var caGradientLayerType: CAGradientLayerType? {
        switch self {
        case .linear:
            return .axial
        default:
            return nil
        }
    }
}

public struct SKLayerGradient: Codable {
    public let stops: [SKLayerStop]
    public let gradientClass: SKGradientClass
    public let gradientType: SKLayerGradientType
    public let to: SKLayerCenter
    public let elipseLength: CGFloat
    public let from: SKLayerCenter
    
    enum CodingKeys: String, CodingKey {
        case stops
        case gradientClass = "<class>"
        case gradientType, to, elipseLength, from
    }
}

public enum SKGradientClass: String, Codable {
    case msGradient = "MSGradient"
}

public struct SKLayerStop: Codable {
    public let stopClass: SKStopClass
    public let color: SKBackgroundColor
    public let position: CGFloat
    
    enum CodingKeys: String, CodingKey {
        case stopClass = "<class>"
        case color, position
    }
}

public enum SKStopClass: String, Codable {
    case msGradientStop = "MSGradientStop"
}

public struct SKColorControls: Codable {
    public let hue: CGFloat
    public let brightness, contrast, saturation: CGFloat
    public let colorControlsClass: SKColorControlsClass
    public let isEnabled: Int

    enum CodingKeys: String, CodingKey {
        case hue
        case colorControlsClass = "<class>"
        case brightness, contrast, isEnabled, saturation
    }
}

public enum SKColorControlsClass: String, Codable {
    case msStyleColorControls = "MSStyleColorControls"
}

public enum SKFillType: Int, Codable {
    case `default` = 0
    case gradient
}

public struct SKLayerFill: Codable {
    public let contextSettings: SKContextSettings
    public let color: SKBackgroundColor
    public let fillClass: SKFillClass
    public let gradient: SKLayerGradient
    public let fillType: SKFillType
    public let noiseIntensity, patternFillType, patternTileScale: Int
    public let noiseIndex: Int
    public let isEnabled: Int
    
    enum CodingKeys: String, CodingKey {
        case contextSettings, color
        case fillClass = "<class>"
        case gradient, fillType, noiseIntensity, patternFillType, patternTileScale, noiseIndex, isEnabled
    }
}

public enum SKFillClass: String, Codable {
    case msStyleFill = "MSStyleFill"
}

public enum SKStyleClass: String, Codable {
    case msStyle = "MSStyle"
}

public struct SKTextStyle: Codable {
    public let kern: CGFloat?
    public let textStyleClass: String
    public let attributedStringColorAttribute: SKBackgroundColor
    public let font: SKLayerFont
    public let paragraphStyle: SKParagraphStyle
    public let textStyleVerticalAlignmentKey: Int?
    
    enum CodingKeys: String, CodingKey {
        case kern = "NSKern"
        case textStyleClass = "<class>"
        case attributedStringColorAttribute = "MSAttributedStringColorAttribute"
        case font = "NSFont"
        case paragraphStyle = "NSParagraphStyle"
        case textStyleVerticalAlignmentKey
    }
}

// MARK: Encode/decode helpers

public class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

public class JSONCodingKey: CodingKey {
    public let key: String
    
    public required init?(intValue: Int) {
        return nil
    }
    
    public required init?(stringValue: String) {
        key = stringValue
    }
    
    public var intValue: Int? {
        return nil
    }
    
    public var stringValue: String {
        return key
    }
}

public class JSONAny: Codable {
    public let value: Any
    
    public static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }
    
    public static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }
    
    public static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(CGFloat.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    public static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(CGFloat.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    public static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(CGFloat.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    public static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }
    
    public static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }
    
    public static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? CGFloat {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    public static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? CGFloat {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    public static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? CGFloat {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }
    
    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}

public extension Int {
    public var skBoolValue: Bool { return self != 0 }
}

public extension CGRect {
    public var cgCenter: CGPoint { return CGPoint(x: midX, y: midY) }
}
