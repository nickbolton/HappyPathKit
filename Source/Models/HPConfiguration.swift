//
//  HPConfiguration.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/16/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//
import Foundation

public struct HPConfiguration: Codable {
    public let fonts: [HPFont]
    public let colors: [HPColor]
    public let textStyles: [HPTextStyle]
    public let components: [HPComponentConfig]
}
