//
//  NSView+Layout.swift
//  HappyPathKit
//
//  Created by Nick Bolton on 12/9/18.
//  Copyright © 2018 Pixelbleed LLC. All rights reserved.
//

#if os(iOS)
import UIKit
public typealias ViewClass = UIView
#else
import Cocoa
public typealias ViewClass = NSView
public typealias UILayoutPriority = NSLayoutConstraint.Priority
#endif

public extension ViewClass {
    
    public func constraint(with attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        for constraint in constraints {
            if (attribute == constraint.firstAttribute && constraint.firstItem as! NSObject == self) ||
                (attribute == constraint.secondAttribute && constraint.secondItem as! NSObject == self) {
                return constraint
            }
        }
        return nil
    }
    
    public func constraints(with attribute: NSLayoutConstraint.Attribute) -> [NSLayoutConstraint] {
        var result = [NSLayoutConstraint]()
        for constraint in constraints {
            if (attribute == constraint.firstAttribute && constraint.firstItem as! NSObject == self) ||
                (attribute == constraint.secondAttribute && constraint.secondItem as! NSObject == self) {
                result.append(constraint)
            }
        }
        return result
    }
    
    @discardableResult
    public func layout(minWidth:CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .width,
                                        relatedBy: .greaterThanOrEqual,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0,
                                        constant: minWidth)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func layout(maxWidth:CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .width,
                                        relatedBy: .lessThanOrEqual,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0,
                                        constant: maxWidth)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func layout(width:CGFloat, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .width,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0,
                                        constant: width)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func layout(minWidth:CGFloat, maxWidth:CGFloat, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        var result = Array<NSLayoutConstraint>()
        let minConstraint = layout(minWidth: minWidth, priority: priority)
        let maxConstraint = layout(maxWidth: maxWidth, priority: priority)
        result.append(minConstraint)
        result.append(maxConstraint)
        
        return result
    }
    
    @discardableResult
    public func layout(minHeight:CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .height,
                                        relatedBy: .greaterThanOrEqual,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0,
                                        constant: minHeight)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func layout(maxHeight:CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .height,
                                        relatedBy: .lessThanOrEqual,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0,
                                        constant: maxHeight)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func layout(height:CGFloat, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .height,
                                        relatedBy: relatedBy,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 1.0,
                                        constant: height)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func layout(minHeight:CGFloat, maxHeight:CGFloat, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        var result = Array<NSLayoutConstraint>()
        let minConstraint = layout(minHeight: minHeight, priority: priority)
        let maxConstraint = layout(maxHeight: maxHeight, priority: priority)
        result.append(minConstraint)
        result.append(maxConstraint)
        
        return result
    }
    
    @discardableResult
    public func layout(size:CGSize, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        var result = Array<NSLayoutConstraint>()
        let widthConstraint = layout(width: size.width, relatedBy: relatedBy, priority: priority)
        let heightConstraint = layout(height: size.height, relatedBy: relatedBy, priority: priority)
        result.append(widthConstraint)
        result.append(heightConstraint)
        
        return result
    }
    
    @discardableResult
    public func centerView(relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        var result = Array<NSLayoutConstraint>()
        let horizontalConstraint = centerX(relatedBy: relatedBy, priority: priority)
        let verticalConstraint = centerY(relatedBy: relatedBy, priority: priority);
        result.append(horizontalConstraint)
        result.append(verticalConstraint)
        
        return result
    }
    
    @discardableResult
    public func centerX(offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return centerX(to: superview, offset: offset, relatedBy: relatedBy, priority: priority)
    }
    
    @discardableResult
    public func centerX(toLeftOf toView: ViewClass?, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return centerX(to: toView, atPosition: .left, offset: offset, relatedBy: relatedBy, priority: priority)
    }
    
    @discardableResult
    public func centerXToLeft(offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return centerX(toLeftOf: superview, offset: offset, relatedBy: relatedBy, priority: priority)
    }
    
    @discardableResult
    public func centerX(toRightOf toView: ViewClass?, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return centerX(to: toView, atPosition: .right, offset: offset, relatedBy: relatedBy, priority: priority)
    }
    
    @discardableResult
    public func centerXToRight(offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return centerX(toRightOf: superview, offset: offset, relatedBy: relatedBy, priority: priority)
    }
    
    @discardableResult
    public func centerX(to toView: ViewClass?, atPosition position: NSLayoutConstraint.Attribute = .centerX, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .centerX,
                                        relatedBy: relatedBy,
                                        toItem: toView,
                                        attribute: position,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func centerY(offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return centerY(to: superview, offset: offset, relatedBy: relatedBy, priority: priority)
    }
    
    @discardableResult
    public func centerY(toTopOf toView: ViewClass?, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return centerY(to: toView, atPosition: .top, offset: offset, relatedBy: relatedBy, priority: priority)
    }
    
    @discardableResult
    public func centerYToTop(offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return centerY(toTopOf: superview, offset: offset, relatedBy: relatedBy, priority: priority)
    }
    
    @discardableResult
    public func centerY(toBottomOf toView: ViewClass?, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return centerY(to: toView, atPosition: .bottom, offset: offset, relatedBy: relatedBy, priority: priority)
    }
    
    @discardableResult
    public func centerY(toBaselineOf toView: ViewClass?, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return centerY(to: toView, atPosition: .lastBaseline, offset: offset, relatedBy: relatedBy, priority: priority)
    }
    
    @discardableResult
    public func centerYToBottom(offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return centerY(toBottomOf: superview, offset: offset, relatedBy: relatedBy, priority: priority)
    }
    
    @discardableResult
    public func centerY(to toView: ViewClass?, atPosition position: NSLayoutConstraint.Attribute = .centerY, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .centerY,
                                        relatedBy: relatedBy,
                                        toItem: toView,
                                        attribute: position,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func expandWidth(insets:UIEdgeInsets = .zero, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        var result = Array<NSLayoutConstraint>()
        let leftConstraint = alignLeft(offset: insets.left, priority: priority)
        let rightConstraint = alignRight(offset: -insets.right, priority: priority)
        result.append(leftConstraint)
        result.append(rightConstraint)
        
        return result
    }
    
    @discardableResult
    public func expandHeight(insets:UIEdgeInsets = .zero, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        var result = Array<NSLayoutConstraint>()
        let topConstraint = alignTop(offset: insets.top, priority: priority)
        let bottomConstraint = alignBottom(offset: -insets.bottom, priority: priority)
        result.append(topConstraint)
        result.append(bottomConstraint)
        
        return result
    }
    
    @discardableResult
    public func expand(insets:UIEdgeInsets = .zero, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        var result = Array<NSLayoutConstraint>()
        let horizontalConstraint = expandWidth(insets: insets, priority: priority)
        let verticalConstraint = expandHeight(insets: insets, priority: priority)
        result.append(contentsOf: horizontalConstraint)
        result.append(contentsOf: verticalConstraint)
        
        return result
    }
    
    @discardableResult
    public func expandToSafeArea(insets:UIEdgeInsets = .zero, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false
        var safeAreaItem: Any = superview!
        #if os(iOS)
        if #available(iOS 11, *) {
            safeAreaItem = safeAreaLayoutGuide
        }
        #endif
        
        let leftConstraint = NSLayoutConstraint(item: self,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: safeAreaItem,
                                                attribute: .left,
                                                multiplier: 1.0,
                                                constant: insets.left)
        let rightConstraint = NSLayoutConstraint(item: safeAreaItem,
                                                 attribute: .right,
                                                 relatedBy: .equal,
                                                 toItem: self,
                                                 attribute: .right,
                                                 multiplier: 1.0,
                                                 constant: insets.right)
        let topConstraint = NSLayoutConstraint(item: self,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: safeAreaItem,
                                               attribute: .top,
                                               multiplier: 1.0,
                                               constant: insets.top)
        let bottomConstraint = NSLayoutConstraint(item: safeAreaItem,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: .bottom,
                                                  multiplier: 1.0,
                                                  constant: insets.bottom)
        
        let result = [leftConstraint, rightConstraint, topConstraint, bottomConstraint]
        for c in result {
            c.priority = priority
        }
        NSLayoutConstraint.activate(result)
        return result
    }
    
    @discardableResult
    public func alignWidth(offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return alignWidth(to: nil, offset: offset, relatedBy: relatedBy, priority: priority)
    }
    
    @discardableResult
    public func alignWidth(to target: ViewClass? = nil, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let targetView = target ?? superview
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .width,
                                        relatedBy: relatedBy,
                                        toItem: targetView,
                                        attribute: .width,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignWidthPercent(_ percent: CGFloat, to target: ViewClass? = nil, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let targetView = target ?? superview
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .width,
                                        relatedBy: relatedBy,
                                        toItem: targetView,
                                        attribute: .width,
                                        multiplier: percent,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignHeight(offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return alignHeight(to: nil, offset: offset, relatedBy: relatedBy, priority: priority)
    }
    
    @discardableResult
    public func alignHeight(to target: ViewClass? = nil, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let targetView = target ?? superview
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .height,
                                        relatedBy: relatedBy,
                                        toItem: targetView,
                                        attribute: .height,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignHeightPercent(_ percent: CGFloat, to target: ViewClass? = nil, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let targetView = target ?? superview
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .height,
                                        relatedBy: relatedBy,
                                        toItem: targetView,
                                        attribute: .height,
                                        multiplier: percent,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignTop(offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .top,
                                        relatedBy: relatedBy,
                                        toItem: self.superview,
                                        attribute: .top,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignBottom(offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .bottom,
                                        relatedBy: relatedBy,
                                        toItem: self.superview,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignBaseline(offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .lastBaseline,
                                        relatedBy: relatedBy,
                                        toItem: self.superview,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignLeading(offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .leading,
                                        relatedBy: relatedBy,
                                        toItem: self.superview,
                                        attribute: .leading,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignLeading(toLeadingOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .leading,
                                        relatedBy: relatedBy,
                                        toItem: toLeadingOf,
                                        attribute: .leading,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignLeading(toTrailingOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .leading,
                                        relatedBy: relatedBy,
                                        toItem: toTrailingOf,
                                        attribute: .trailing,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignLeading(toCenterOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .leading,
                                        relatedBy: relatedBy,
                                        toItem: toCenterOf,
                                        attribute: .centerX,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignTrailing(offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .trailing,
                                        relatedBy: relatedBy,
                                        toItem: self.superview,
                                        attribute: .trailing,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignTrailing(toTrailingOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .trailing,
                                        relatedBy: relatedBy,
                                        toItem: toTrailingOf,
                                        attribute: .trailing,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignTrailing(toLeadingOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .trailing,
                                        relatedBy: relatedBy,
                                        toItem: toLeadingOf,
                                        attribute: .leading,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignTrailing(toCenterOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .trailing,
                                        relatedBy: relatedBy,
                                        toItem: toCenterOf,
                                        attribute: .centerX,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignLeft(offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .left,
                                        relatedBy: relatedBy,
                                        toItem: self.superview,
                                        attribute: .left,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignRight(offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .right,
                                        relatedBy: relatedBy,
                                        toItem: self.superview,
                                        attribute: .right,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignFirstBaseline(toBaselineOf: ViewClass, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return alignFirstBaseline(toBaselineOf: toBaselineOf, offset: 0.0, relatedBy: relatedBy, priority: priority)
    }
    
    @discardableResult
    public func alignFirstBaseline(toBaselineOf: ViewClass, offset: CGFloat, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .firstBaseline,
                                        relatedBy: relatedBy,
                                        toItem: toBaselineOf,
                                        attribute: .lastBaseline,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func verticallySpace(toView: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .top,
                                        relatedBy: relatedBy,
                                        toItem: toView,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func horizontallySpace(toView: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .left,
                                        relatedBy: relatedBy,
                                        toItem: toView,
                                        attribute: .right,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignTop(toTopOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .top,
                                        relatedBy: relatedBy,
                                        toItem: toTopOf,
                                        attribute: .top,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignTop(toCenterOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .top,
                                        relatedBy: relatedBy,
                                        toItem: toCenterOf,
                                        attribute: .centerY,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignTop(toFirstBaselineOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .top,
                                        relatedBy: relatedBy,
                                        toItem: toFirstBaselineOf,
                                        attribute: .firstBaseline,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignFirstBaseline(toBottomOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .firstBaseline,
                                        relatedBy: relatedBy,
                                        toItem: toBottomOf,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignTop(toBottomOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .top,
                                        relatedBy: relatedBy,
                                        toItem: toBottomOf,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignTop(toBaselineOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .top,
                                        relatedBy: relatedBy,
                                        toItem: toBaselineOf,
                                        attribute: .lastBaseline,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignBottom(toTopOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .bottom,
                                        relatedBy: relatedBy,
                                        toItem: toTopOf,
                                        attribute: .top,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignBottom(toCenterOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .bottom,
                                        relatedBy: relatedBy,
                                        toItem: toCenterOf,
                                        attribute: .centerY,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignBottom(toBottomOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .bottom,
                                        relatedBy: relatedBy,
                                        toItem: toBottomOf,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignBottom(toBaselineOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .bottom,
                                        relatedBy: relatedBy,
                                        toItem: toBaselineOf,
                                        attribute: .lastBaseline,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignBaseline(toTopOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .lastBaseline,
                                        relatedBy: relatedBy,
                                        toItem: toTopOf,
                                        attribute: .top,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignBaseline(toBottomOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .lastBaseline,
                                        relatedBy: relatedBy,
                                        toItem: toBottomOf,
                                        attribute: .bottom,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignBaseline(toBaselineOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .lastBaseline,
                                        relatedBy: relatedBy,
                                        toItem: toBaselineOf,
                                        attribute: .lastBaseline,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignBaseline(toFirstBaselineOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .lastBaseline,
                                        relatedBy: relatedBy,
                                        toItem: toFirstBaselineOf,
                                        attribute: .firstBaseline,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignBottom(toFirstBaselineOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .bottom,
                                        relatedBy: relatedBy,
                                        toItem: toFirstBaselineOf,
                                        attribute: .firstBaseline,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignLeft(toLeftOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .left,
                                        relatedBy: relatedBy,
                                        toItem: toLeftOf,
                                        attribute: .left,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignLeft(toCenterOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .left,
                                        relatedBy: relatedBy,
                                        toItem: toCenterOf,
                                        attribute: .centerX,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignLeft(toRightOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .left,
                                        relatedBy: relatedBy,
                                        toItem: toRightOf,
                                        attribute: .right,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignRight(toRightOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .right,
                                        relatedBy: relatedBy,
                                        toItem: toRightOf,
                                        attribute: .right,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignRight(toCenterOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .right,
                                        relatedBy: relatedBy,
                                        toItem: toCenterOf,
                                        attribute: .centerX,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }
    
    @discardableResult
    public func alignRight(toLeftOf: ViewClass, offset: CGFloat = 0.0, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        let result = NSLayoutConstraint(item: self,
                                        attribute: .right,
                                        relatedBy: relatedBy,
                                        toItem: toLeftOf,
                                        attribute: .left,
                                        multiplier: 1.0,
                                        constant: offset)
        result.priority = priority
        NSLayoutConstraint.activate([result])
        
        return result
    }

    public func expand(to view: ViewClass? = nil) {
        guard let target = view ?? superview else {
            assert(false, "View needs to be part of a view hierarchy")
        }
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: target.leadingAnchor),
            trailingAnchor.constraint(equalTo: target.trailingAnchor),
            topAnchor.constraint(equalTo: target.topAnchor),
            bottomAnchor.constraint(equalTo: target.bottomAnchor),
            ])
    }
    
    public func expandWidth(to view: ViewClass? = nil) {
        guard let target = view ?? superview else {
            assert(false, "View needs to be part of a view hierarchy")
        }
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: target.leadingAnchor),
            trailingAnchor.constraint(equalTo: target.trailingAnchor),
            ])
    }
    
    public func expandHeight(to view: ViewClass? = nil) {
        guard let target = view ?? superview else {
            assert(false, "View needs to be part of a view hierarchy")
        }
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: target.topAnchor),
            bottomAnchor.constraint(equalTo: target.bottomAnchor),
            ])
    }

    public func alignLeading(to view: ViewClass? = nil, offset: CGFloat = 0.0) {
        guard let target = view ?? superview else {
            assert(false, "View needs to be part of a view hierarchy")
        }
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: target.leadingAnchor, constant: offset),
            ])
    }
    
    public func alignLeading(toLeadingView view: ViewClass, offset: CGFloat = 0.0) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: offset),
            ])
    }
    
    public func alignTrailing(to view: ViewClass? = nil, offset: CGFloat = 0.0) {
        guard let target = view ?? superview else {
            assert(false, "View needs to be part of a view hierarchy")
        }
        NSLayoutConstraint.activate([
            trailingAnchor.constraint(equalTo: target.trailingAnchor, constant: offset),
            ])
    }
    
    public func alignTrailing(toTrailingView view: ViewClass, offset: CGFloat = 0.0) {
        NSLayoutConstraint.activate([
            trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset),
            ])
    }
    
    public func alignTop(to view: ViewClass? = nil, offset: CGFloat = 0.0) {
        guard let target = view ?? superview else {
            assert(false, "View needs to be part of a view hierarchy")
        }
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: target.topAnchor, constant: offset),
            ])
    }
    
    public func alignTop(toTopView view: ViewClass, offset: CGFloat = 0.0) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.bottomAnchor, constant: offset),
            ])
    }
    
    public func alignBottom(to view: ViewClass? = nil, offset: CGFloat = 0.0) {
        guard let target = view ?? superview else {
            assert(false, "View needs to be part of a view hierarchy")
        }
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: target.bottomAnchor, constant: offset),
            ])
    }
    
    public func alignBottom(toBottomView view: ViewClass, offset: CGFloat = 0.0) {
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: view.topAnchor, constant: offset),
            ])
    }
    
    public func align(toRect rect: CGRect) {
        guard let target = superview else {
            assert(false, "View needs to be part of a view hierarchy")
        }
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: target.leadingAnchor, constant: rect.minX),
            topAnchor.constraint(equalTo: target.topAnchor, constant: rect.minY),
            widthAnchor.constraint(equalToConstant: rect.width),
            heightAnchor.constraint(equalToConstant: rect.height),
            ])
    }
    
    public func center(to view: ViewClass? = nil, offset: CGVector = .zero) {
        guard let target = view ?? superview else {
            assert(false, "View needs to be part of a view hierarchy")
        }
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: target.centerXAnchor, constant: offset.dx),
            centerYAnchor.constraint(equalTo: target.centerYAnchor, constant: offset.dy),
            ])
    }
    
    public func centerX(to view: ViewClass? = nil, offset: CGFloat = 0.0) {
        guard let target = view ?? superview else {
            assert(false, "View needs to be part of a view hierarchy")
        }
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: target.centerXAnchor, constant: offset),
            ])
    }
    
    public func centerY(to view: ViewClass? = nil, offset: CGFloat = 0.0) {
        guard let target = view ?? superview else {
            assert(false, "View needs to be part of a view hierarchy")
        }
        NSLayoutConstraint.activate([
            centerYAnchor.constraint(equalTo: target.centerYAnchor, constant: offset),
            ])
    }
    
    public func alignWidth(_ width: CGFloat) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            ])
    }
    
    public func alignHeight(_ height: CGFloat) {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: height),
            ])
    }
    
    public func size(_ size: CGSize) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height),
            ])
    }
}
