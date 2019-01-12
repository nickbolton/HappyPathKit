//
//  BaseViewInitializer.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 1/10/19.
//  Copyright © 2019 Pixelbleed LLC. All rights reserved.
//

#if os(iOS)
import UIKit

public class BaseViewInitializer: NSObject {

    public func initialize(backgroundColor: UIColor?,
                           border: HPBorder?,
                           opacity: CGFloat,
                           cornerRadius: CGFloat,
                           view: UIView) {
        view.backgroundColor = backgroundColor
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
