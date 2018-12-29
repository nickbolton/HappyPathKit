//
//  SKImportable.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/16/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//
import Foundation

public struct SKImportable: Codable {
    public let symbols: [SKLayer]
    public let pages: [SKPage]
}
