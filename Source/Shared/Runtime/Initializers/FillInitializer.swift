//
//  FillInitializer.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 1/9/19.
//

#if os(iOS)
import UIKit

class FillInitializer: NSObject {

    func initialize(backgroundColor: UIColor?, fills: [HPFill], view: UIView) {
        
        var layers = [CALayer]()

        if let backgroundColor = backgroundColor {
            // background color
            let fillLayer = CALayer()
            fillLayer.opacity = 1.0
            fillLayer.backgroundColor = backgroundColor.cgColor
            layers.append(fillLayer)
        }
        
        for fill in fills {
            if let gradient = fill.gradient {
                let gradientLayer = CAGradientLayer()
                gradientLayer.type = .axial
                gradientLayer.opacity = Float(fill.opacity)
                gradientLayer.colors = gradient.stops.map { $0.color.nativeColor.cgColor }
                gradientLayer.startPoint = gradient.from
                gradientLayer.locations = gradient.stops.map { NSNumber(value: Float($0.position)) }
                gradientLayer.endPoint = gradient.to
                gradientLayer.compositingFilter = buildBlendMode(CGBlendMode(rawValue: fill.blendMode))
                layers.append(gradientLayer)
            } else {
                let fillLayer = CALayer()
                fillLayer.opacity = Float(fill.opacity)
                fillLayer.backgroundColor = fill.color.nativeColor.cgColor
                fillLayer.compositingFilter = buildBlendMode(CGBlendMode(rawValue: fill.blendMode))
                layers.append(fillLayer)
            }
        }
        
        var addLayers = layers.count > 1
        if layers.count == 1 {
            if let _ = layers[0] as? CAGradientLayer {
                addLayers = true
            }
        }
        
        if addLayers {
            for l in layers.reversed() {
                view.layer.insertSublayer(l, at: 0)
            }
        } else if layers.count > 0 {
            if let backgroundColor = backgroundColor {
                view.backgroundColor = backgroundColor
            } else if let backgroundColor = layers[0].backgroundColor {
                var color = UIColor(cgColor: backgroundColor)
                var colorAlpha: CGFloat = 1.0
                color.retrieveRed(nil, green: nil, blue: nil, alpha: &colorAlpha)
                color = color.color(withAlpha: colorAlpha * CGFloat(layers[0].opacity))
                view.backgroundColor = color
            }
        }
    }
    
    private func buildBlendMode(_ blendMode: CGBlendMode?) -> CIFilter? {
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
