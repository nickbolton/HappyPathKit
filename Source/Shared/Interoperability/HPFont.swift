//
//  HPFont.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/29/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

#if os(iOS)
import UIKit
public typealias HPFont = UIFont
#elseif os(macOS)
import Cocoa
public typealias HPFont = NSFont
#endif
