//
//  HPConstraint.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/21/18.
//

import Foundation

public enum HPConstraintType: Int, Codable {
    case top = 1
    case left = 2
    case bottom = 4
    case right = 8
    case width = 16
    case height = 32
}

public struct HPConstraint: Codable {
    public let type: HPConstraintType
}
