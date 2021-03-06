//
//  Geometry.swift
//  HappyPath
//
//  Created by Nick Bolton on 12/9/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

#if os(iOS)
import UIKit
#else
import Cocoa
#endif

extension CGFloat {
    
    var pointAligned: CGFloat { return CGFloat(roundf(Float(self))) }
    var halfPointAligned: CGFloat { return roundToPrecision(2.0) }
    var halfPointFloor: CGFloat { return floorToPrecision(2.0) }
    var halfPointCeil: CGFloat { return ceilToPrecision(2.0) }

    var isWithinEpsilon: Bool {
        let epsilon: CGFloat = 0.000001
        return abs(self) < epsilon
    }
    
    var truncatedErrorAlignedValue: CGFloat {
        let precision: CGFloat = 10000.0
        return floor(self * precision) / precision
    }

    func roundToPrecision(_ precision: CGFloat) -> CGFloat {
        if precision > 1.0 {
            return CGFloat(roundf(Float(self * precision))) / precision
        }
        return self
    }
    
    func floorToPrecision(_ precision: CGFloat) -> CGFloat {
        if precision > 1.0 {
            return floor(self * precision) / precision
        }
        return self
    }
    
    func ceilToPrecision(_ precision: CGFloat) -> CGFloat {
        if precision > 1.0 {
            return ceil(self * precision) / precision
        }
        return self
    }

    func scale(by scale: CGFloat) -> CGFloat{
        return self * scale
    }

    func normalize(by scale: CGFloat) -> CGFloat{
        guard scale != 0.0 else { return 0.0 }
        return self / scale
    }
}

extension CGPoint {
    
    func offset(by offset: CGFloat) -> CGPoint {
        return CGPoint(x: x + offset, y: y + offset)
    }
    
    func offset(dx: CGFloat, y dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
    
    var pointAligned: CGPoint {
        return CGPoint(x: x.pointAligned, y: y.pointAligned)
    }
    
    var halfPointAligned: CGPoint {
        return CGPoint(x: x.halfPointAligned, y: y.halfPointAligned)
    }
    
    func ceilToPrecision(_ precision: CGFloat) -> CGPoint {
        return CGPoint(x: x.roundToPrecision(precision), y: y.roundToPrecision(precision))
    }
    
    func roundToPrecision(_ precision: CGFloat) -> CGPoint {
        return CGPoint(x: x.roundToPrecision(precision), y: y.roundToPrecision(precision))
    }

    func scale(by scale: CGFloat) -> CGPoint {
        return CGPoint(x: x.scale(by: scale), y: y.scale(by: scale))
    }
    
    func normalize(by scale: CGFloat) -> CGPoint {
        return CGPoint(x: x.normalize(by: scale), y: y.normalize(by: scale))
    }
    
    func pathPoint(inRect rect: CGRect) -> CGPoint {
        return CGPoint(x: rect.minX + (x * rect.width), y: rect.minY + (y * rect.height))
    }
    
    func pathPoint(inSize size: CGSize) -> CGPoint {
        return pathPoint(inRect: CGRect(origin: .zero, size: size))
    }
    
    func distance(to p: CGPoint) -> CGFloat {
        let dx = p.x - x
        let dy = p.y - y
        return sqrt(dx*dx + dy*dy)
    }
}

extension CGSize {
    
    var epsilonBoundSize: CGSize {
        let epsilon: CGFloat = 0.1
        return CGSize(width: max(width, epsilon), height: max(height, epsilon))
    }
    
    var pointAligned: CGSize {
        return CGSize(width: width.pointAligned, height: height.pointAligned)
    }
    
    var halfPointAligned: CGSize {
        return CGSize(width: width.halfPointAligned, height: height.halfPointAligned)
    }
    
    func ceilToPrecision(_ precision: CGFloat) -> CGSize {
        return CGSize(width: width.roundToPrecision(precision), height: height.roundToPrecision(precision))
    }
    
    func roundToPrecision(_ precision: CGFloat) -> CGSize {
        return CGSize(width: width.roundToPrecision(precision), height: height.roundToPrecision(precision))
    }
    
    func scale(by scale: CGFloat) -> CGSize {
        return CGSize(width: width.scale(by: scale), height: height.scale(by: scale))
    }
    
    func normalize(by scale: CGFloat) -> CGSize {
        return CGSize(width: width.normalize(by: scale), height: height.normalize(by: scale))
    }
    
    func aspectScaled(to size: CGSize) -> CGSize {
        guard width > 0.0 && height > 0.0 else { return self }
        var scaleFactor = size.height / height
        if abs(size.width - width) > abs(size.height - height) {
            scaleFactor = size.width / width
        }
        return scale(by: scaleFactor).halfPointAligned
    }
    
    var rotated: CGSize { return CGSize(width: height, height: width) }
}

extension CGRect {
    
    var epsilonBoundSize: CGRect {
        return CGRect(origin: origin, size: size.epsilonBoundSize)
    }
    
    var edgeInsets: UIEdgeInsets {
        return UIEdgeInsets(top: minY,
                            left: minX,
                            bottom: maxY,
                            right: maxX)
    }
    
    var pointAligned: CGRect {
        return CGRect(origin: origin.pointAligned, size: size.pointAligned)
    }

    var halfPointAligned: CGRect {
        return CGRect(origin: origin.halfPointAligned, size: size.halfPointAligned)
    }
    
    func ceilToPrecision(_ precision: CGFloat) -> CGRect {
        return CGRect(origin: origin.roundToPrecision(precision), size: size.roundToPrecision(precision))
    }
    
    func roundToPrecision(_ precision: CGFloat) -> CGRect {
        return CGRect(origin: origin.roundToPrecision(precision), size: size.roundToPrecision(precision))
    }
    
    func scale(by scale: CGFloat) -> CGRect {
        return CGRect(origin: origin.scale(by: scale), size: size.scale(by: scale))
    }
    
    func normalize(by scale: CGFloat) -> CGRect {
        return CGRect(origin: origin.normalize(by: scale), size: size.normalize(by: scale))
    }
    
    var rotated: CGRect {
        let center = CGPoint(x: midX, y: midY)
        return CGRect(x: center.x - (height / 2.0),
                      y: center.y - (width / 2.0),
                      width: height,
                      height: width)
    }
    
    private var smallSize: CGFloat { return 0.0001 }
    
    func distance(to p: CGPoint) -> CGFloat {
        // first of all, we check if point is inside rect. If it is, distance is zero
        guard !contains(p) else { return 0.0 }
        let dx = max(max(minX - p.x, p.x - maxX), 0.0)
        let dy = max(max(minY - p.y, p.y - maxY), 0.0);
        return sqrt(dx*dx + dy*dy)
    }
    
    func distanceToClosetHorizontalEdge(point p: CGPoint) -> CGFloat {
        let leftRect = CGRect(x: minX, y: minY, width: smallSize, height: height)
        let midRect = CGRect(x: midX - (smallSize / 2.0), y: minY, width: smallSize, height: height)
        let rightRect = CGRect(x: maxX - smallSize, y: minY, width: smallSize, height: height)
        let leftDistance = leftRect.distance(to: p)
        let rightDistance = rightRect.distance(to: p)
        let midDistance = midRect.distance(to: p)
        return min(min(leftDistance, rightDistance), midDistance)
    }
    
    func distanceToClosetVerticalEdge(point p: CGPoint) -> CGFloat {
        let topRect = CGRect(x: minX, y: minY, width: width, height: smallSize)
        let midRect = CGRect(x: minX, y: midY - (smallSize / 2.0), width: width, height: smallSize)
        let bottomRect = CGRect(x: minX, y: maxX - smallSize, width: width, height: smallSize)
        let topDistance = topRect.distance(to: p)
        let bottomDistance = bottomRect.distance(to: p)
        let midDistance = midRect.distance(to: p)
        return min(min(topDistance, bottomDistance), midDistance)
    }
    
    func distanceToClosetEdge(point p: CGPoint) -> CGFloat {
        return min(distanceToClosetHorizontalEdge(point: p), distanceToClosetVerticalEdge(point: p))
    }
    
    func vector(to rect: CGRect) -> CGVector {
        
        guard !intersects(rect) else { return .zero }
    
        let left = origin.x < rect.origin.x ? self : rect
        let right = rect.origin.x < origin.x ? self : rect;
    
        var dx = left.origin.x == right.origin.x ? 0 : right.origin.x - (left.origin.x + left.size.width)
        dx = max(dx, 0.0)
    
        let upper = origin.y < rect.origin.y ? self : rect
        let lower = rect.origin.y < origin.y ? self : rect
    
        var dy = upper.origin.y == lower.origin.y ? 0 : lower.origin.y - (upper.origin.y + upper.size.height)
        dy = max(dy, 0.0)
    
        return CGVector(dx: abs(dx), dy: abs(dy))
    }
    
    func distance(to rect: CGRect) -> CGFloat {
        let v = vector(to: rect)
        return sqrt(v.dx*v.dx + v.dy*v.dy)
    }
}

extension UIEdgeInsets {
    
    var cgRect: CGRect {
        return CGRect(x: left,
                      y: top,
                      width: right - left,
                      height: bottom - top)
    }

    func scale(by scale: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: top.scale(by: scale),
                            left: left.scale(by: scale),
                            bottom: bottom.scale(by: scale),
                            right: right.scale(by: scale))
    }
    
    func normalize(by scale: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: top.normalize(by: scale),
                            left: left.normalize(by: scale),
                            bottom: bottom.normalize(by: scale),
                            right: right.normalize(by: scale))
    }
}

#if os(macOS)
extension NSWindow {
    
    func pixelAligned(value: CGFloat) -> CGFloat {
        let scale = backingScaleFactor
        guard scale != 0.0 else { return value }
        return round(value * scale) / scale
    }
    
    func pixelAligned(point p: CGPoint) -> CGPoint {
        return CGPoint(x: pixelAligned(value: p.x), y: pixelAligned(value: p.y))
    }

    func pixelAligned(size s: CGSize) -> CGSize {
        return CGSize(width: pixelAligned(value: s.width), height: pixelAligned(value: s.height))
    }
    
    func pixelAligned(rect r: CGRect) -> CGRect {
        return CGRect(origin: pixelAligned(point: r.origin), size: pixelAligned(size: r.size))
    }
}
#endif
