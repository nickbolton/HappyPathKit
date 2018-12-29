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

public struct HPPage: Codable {
    public let layers: [HPLayer]
}
