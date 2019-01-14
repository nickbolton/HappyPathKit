//
//  HPPage.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/29/18.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public struct HPPage: Codable, Equatable, Hashable, Inspectable {
    public let id: String
    public var layers: [HPLayer]
    
    public var hashValue: Int { return id.hashValue }
    
    public func traverse(options: HPLayerTraversalOption = .deep, handler: (_ layer: HPLayer, _ parent: HPLayer?)->Bool) {
        for layer in layers {
            layer.traverse(options: options, handler: handler)
        }
    }
    
    public static func == (lhs: HPPage, rhs: HPPage) -> Bool {
        return lhs.id == rhs.id
    }
}
