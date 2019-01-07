//
//  HPLayout.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/21/18.
//

import Foundation

public struct HPLayout: Codable, Equatable {
    public let key: String
    public var constraints: [HPConstraint]
    
    public static func == (lhs: HPLayout, rhs: HPLayout) -> Bool {
        return lhs.key == rhs.key &&
            lhs.constraints == rhs.constraints
    }
}
