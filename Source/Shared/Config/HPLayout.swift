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
    
    public func isEqualWithProportionality(to: HPLayout) -> Bool {
        guard constraints.count == to.constraints.count else { return false }
        for idx in 0..<constraints.count {
            let c1 = constraints[idx]
            let c2 = to.constraints[idx]
            if c1 != c2 || c1.isProportional != c2.isProportional {
                return false
            }
        }
        return true
    }
    
    public static func == (lhs: HPLayout, rhs: HPLayout) -> Bool {
        return lhs.key == rhs.key &&
            lhs.constraints == rhs.constraints
    }
}
