//
//  HPLayout.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/21/18.
//

import Foundation

public struct HPLayout: Codable {
    public let key: String
    public let layout: [HPConstraints]
    
    static public func buildKey(layers: [SKLayer]) -> String {
        return layers.map { $0.objectID }
            .reduce("") { (acc, cur) in acc.count > 0 ? acc + "|" + cur : cur}
    }
}
