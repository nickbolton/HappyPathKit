//
//  String+HPK.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 1/10/19.
//  Copyright © 2019 Pixelbleed LLC. All rights reserved.
//

import Foundation

public extension String {
    public var trimmed: String { return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
    
    public var properIdentifier: String {
        let result = replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
            .replacingOccurrences(of: ".", with: "")
        if result.count <= 1 {
            return result.lowercased(with: Locale.current)
        }
        let second = result.index(result.startIndex, offsetBy: 1)
        return String(result.prefix(upTo: second)).lowercased(with: Locale.current) + String(result.suffix(from: second))
    }
    
    public var properClassName: String {
        let result = replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
        if result.count <= 1 {
            return result.lowercased(with: Locale.current)
        }
        let second = result.index(result.startIndex, offsetBy: 1)
        return String(result.prefix(upTo: second)).uppercased(with: Locale.current) + String(result.suffix(from: second))
    }
    
    public static func stringType(of some: Any) -> String {
        let string = (some is Any.Type) ? String(describing: some) : String(describing: type(of: some))
        return string
    }
}
