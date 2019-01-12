//
//  UIView+Helpers.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 1/11/19.
//  Copyright © 2019 Pixelbleed LLC. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UIView {

    public func insertSolidFillLayer(color: UIColor, opacity: Float, blendMode: CGBlendMode, at pos: Int) {
        let fillLayer = CALayer()
        fillLayer.opacity = opacity
        fillLayer.backgroundColor = color.cgColor
        fillLayer.compositingFilter = CIFilter.compositingFilter(blendMode: blendMode)
        layer.insertSublayer(fillLayer, at: UInt32(pos))
    }
    
    public func insertAxialGradientLayer(colors: [UIColor], locations: [Float], start: CGPoint, end: CGPoint, opacity: Float, blendMode: CGBlendMode, at pos: Int) -> CALayer {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.opacity = opacity
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations.map { NSNumber(value: $0) }
        gradientLayer.startPoint = start
        gradientLayer.endPoint = end
        gradientLayer.compositingFilter = CIFilter.compositingFilter(blendMode: blendMode)
        layer.insertSublayer(gradientLayer, at: UInt32(pos))
        return gradientLayer
    }
}

public extension CIFilter {
    
    static public func compositingFilter(blendMode: CGBlendMode?) -> CIFilter? {
        guard let blendMode = blendMode else { return nil }
        var filter: CIFilter?
        switch blendMode {
        case .multiply:
            filter = CIFilter(name: "CIMultiplyBlendMode")
        case .screen:
            filter = CIFilter(name: "CIScreenBlendMode")
        case .overlay:
            filter = CIFilter(name: "CIOverlayBlendMode")
        case .darken:
            filter = CIFilter(name: "CIDarkenBlendMode")
        case .lighten:
            filter = CIFilter(name: "CILightenBlendMode")
        case .colorDodge:
            filter = CIFilter(name: "CIColorDodgeBlendMode")
        case .colorBurn:
            filter = CIFilter(name: "CIColorBurnBlendMode")
        case .softLight:
            filter = CIFilter(name: "CISoftLightBlendMode")
        case .hardLight:
            filter = CIFilter(name: "CIHardLightBlendMode")
        case .difference:
            filter = CIFilter(name: "CIDifferenceBlendMode")
        case .exclusion:
            filter = CIFilter(name: "CIExclusionBlendMode")
        case .hue:
            filter = CIFilter(name: "CIHueBlendMode")
        case .saturation:
            filter = CIFilter(name: "CISaturationBlendMode")
        case .color:
            filter = CIFilter(name: "CIColorBlendMode")
        case .luminosity:
            filter = CIFilter(name: "CILuminosityBlendMode")
        case .clear:
            filter = nil//CIFilter(name: "CIMultiplyBlendMode")
        case .copy:
            filter = nil//CIFilter(name: "CIMultiplyBlendMode")
        case .sourceIn:
            filter = CIFilter(name: "CISourceInCompositing")
        case .sourceOut:
            filter = CIFilter(name: "CISourceOutCompositing")
        case .sourceAtop:
            filter = CIFilter(name: "CISourceAtopCompositing")
        case .destinationOver:
            filter = nil//CIFilter(name: "CIMultiplyBlendMode")
        case .destinationIn:
            filter = nil//CIFilter(name: "CIMultiplyBlendMode")
        case .destinationOut:
            filter = nil//CIFilter(name: "CIMultiplyBlendMode")
        case .destinationAtop:
            filter = nil//CIFilter(name: "CIMultiplyBlendMode")
        case .xor:
            filter = nil//CIFilter(name: "CIMultiplyBlendMode")
        case .plusDarker:
            filter = nil//CIFilter(name: "CIMultiplyBlendMode")
        case .plusLighter:
            filter = nil//CIFilter(name: "CIMultiplyBlendMode")
        default:
            break
        }
        if let filter = filter {
            return filter
        }
        return nil
    }
}

#endif
