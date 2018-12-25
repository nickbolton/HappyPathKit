//
//  HPLayer.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/23/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

import UIKit

public class HPLayer: NSObject {
    public let skLayer: SKLayer
    
    public var id: String { return skLayer.objectID }
    public var frame: CGRect { return skLayer.frame.cgRect }
    public var layerType: SKLayerType { return skLayer.layerType }
    public var attributedString: SKAttributedString? { return skLayer.attributedString }
    public var componentConfig: HPComponentConfig?
    public var associatedLayers = [HPLayer]()
    public var backgroundLayers = [HPLayer]()
    public var subLayers = [HPLayer]()
    public var isUnimplemented: Bool { return false }
    public var imageLocationURL: URL?
    public var style = HPStyle(opacity: 1.0,
                               fills: [],
                               borders: [],
                               backgroundColor: nil,
                               cornerRadius: 0.0)
    
    static public func buildLayoutKey(layers: [HPLayer]) -> String {
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

    init(skLayer: SKLayer) {
        self.skLayer = skLayer
        super.init()
    }
}
