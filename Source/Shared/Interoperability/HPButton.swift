//
//  HPButton.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 1/1/19.
//  Copyright © 2019 Pixelbleed LLC. All rights reserved.
//

#if os(iOS)
import UIKit
public typealias HPButton = UIButton
#elseif os(macOS)
import Cocoa
public typealias HPButton = NSButton

public struct UIControlState : OptionSet {
    public var rawValue: UInt
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    public static let normal      = UIControlState(rawValue: 0)
    public static let highlighted = UIControlState(rawValue: 1 << 0)
    public static let disabled    = UIControlState(rawValue: 1 << 1)
    public static let selected    = UIControlState(rawValue: 1 << 2)
    public static let focused     = UIControlState(rawValue: 1 << 3)
    public static let application = UIControlState(rawValue: 0x00FF0000)
    public static let reserved    = UIControlState(rawValue: 0xFF000000)
}

public extension NSButton {
    
    private struct AssociatedKey {
        static var titleColor = "hp_NSButton.titleColor"
    }
    
    private var hp_titleColor: NSColor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.titleColor) as? NSColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.titleColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var isSelected: Bool {
        get { return state == .on }
        set { state = newValue ? .on : .off }
    }

    public func image(for state: UIControlState) -> NSImage? {
        if state == .highlighted {
            return alternateImage ?? image
        }
        return image
    }
    
    public func setImage(_ image: NSImage?, for state: UIControlState) {
        if state == .normal {
            self.image = image
        } else if state == .highlighted {
            alternateImage = image
        }
    }
    
    public func title(for state: UIControlState) -> String {
        return title
    }
    
    public func setTitle(_ title: String, for state: UIControlState) {
        self.title = title
        _updateTitle()
    }
    
    public func setTitleColor(_ color: NSColor, for: UIControlState) {
        hp_titleColor = color
        _updateTitle()
    }
    
    public func titleColor(for: UIControlState) -> NSColor? {
        return hp_titleColor
    }
    
    private func _updateTitle() {
        if let color = hp_titleColor, let font = font {
            let descriptor = TextDescriptor(text: title, font: font, textColor: color, textAlignment: .center)
            attributedTitle = descriptor.attributedString
        }
    }
    
    public func setAttributedTitle(_ attributedTitle: NSAttributedString, for state: UIControlState) {
        self.attributedTitle = attributedTitle
    }
}
#endif
