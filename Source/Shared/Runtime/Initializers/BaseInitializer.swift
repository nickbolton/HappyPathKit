//
//  BaseInitializer.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 1/10/19.
//  Copyright © 2019 Pixelbleed LLC. All rights reserved.
//

#if os(iOS)
import UIKit

public class BaseInitializer: NSObject {

    public func initialize(backgroundColor: UIColor?,
                           fills: [HPFill],
                           border: HPBorder?,
                           opacity: CGFloat,
                           cornerRadius: CGFloat,
                           view: UIView) {
        FillInitializer().initialize(backgroundColor: backgroundColor, fills: fills, view: view)
        view.layer.cornerRadius = cornerRadius
        view.alpha = opacity
        apply(border: border, view: view)
    }
    
    private func apply(border: HPBorder?, view: UIView) {
        guard let border = border else { return }
        view.layer.borderWidth = border.thickness
        view.layer.borderColor = border.color.nativeColor.cgColor
    }
}

#endif
