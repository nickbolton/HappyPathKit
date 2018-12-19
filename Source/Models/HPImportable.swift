//
//  HPImportable.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/16/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//
import Foundation

public struct HPImportable: Codable {
    public let symbols: SKLayerGroup
    public let layers: SKLayerGroup
    public let configuration: HPConfiguration
}
