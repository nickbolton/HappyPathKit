//
//  HPLayout.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/21/18.
//

import Foundation

public struct HPLayout: Codable {
    public let key: String
    public var constraints: [HPConstraint]    
}
