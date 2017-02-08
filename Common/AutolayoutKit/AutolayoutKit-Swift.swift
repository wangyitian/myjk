//
//
//
//
//  Created by bin on 6/3/15.
//  Copyright (c) 2015 . All rights reserved.
//

import UIKit

extension Array {
    func autolayoutInstall()->Void {
        for constraint in self {
            if let c = constraint as? NSLayoutConstraint {
                c.active()
            }
        }
    }
    func autolayoutUnInstall()->Void {
        for constraint in self {
            if let c = constraint as? NSLayoutConstraint {
                c.deActive()
            }
        }
    }
}

extension UIView {
    func useAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func setLayoutHeight(height : CGFloat) -> Self {
        useAutoLayout()
        NSLayoutConstraint(item: self as UIView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height).active()
        return self
    }
    
    func setLayoutWidth(width : CGFloat) -> Self {
        useAutoLayout()
        NSLayoutConstraint(item: self as UIView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: width).active()
        return self
    }
}
extension NSLayoutConstraint {
    func active(priority : UILayoutPriority = UILayoutPriorityRequired) -> Self {
        if self.priority != priority {
            self.priority = priority
        }
        self.active = true
        return self
    }
    
    func deActive() {
        self.active = false
    }
}

extension NSLayoutConstraint {
    //MARK: --size
    static func equalSize(priority : UILayoutPriority = UILayoutPriorityRequired, views : UIView...) {
        equalSize(priority , views : views)
    }
    static func equalSize(priority : UILayoutPriority = UILayoutPriorityRequired, views : [UIView]) {
        equalHeight(priority, views: views)
        equalWidth(priority, views: views)
    }
    
    //--
    static func equalHeight(priority : UILayoutPriority = UILayoutPriorityRequired, views : UIView...) {
        equalHeight(priority, views: views)
    }
    static func equalHeight(priority : UILayoutPriority = UILayoutPriorityRequired, views : [UIView]) {
        guard views.count > 1 else {
            return
        }
        var lastView = views[0]
        for i in 1..<views.count {
            let current = views[i]
            let c = NSLayoutConstraint(item: lastView, attribute: .Height, relatedBy: .Equal, toItem: current, attribute: .Height, multiplier: 1, constant: 0)
            c.priority = priority
            c.active()
            lastView = current
        }
    }
    //--
    static func equalWidth(priority : UILayoutPriority = UILayoutPriorityRequired, views : UIView...) {
        equalWidth(priority, views: views)
    }
    static func equalWidth(priority : UILayoutPriority = UILayoutPriorityRequired, views : [UIView]) {
        guard views.count > 1 else {
            return
        }
        var lastView = views[0]
        for i in 1..<views.count {
            let current = views[i]
            let c = NSLayoutConstraint(item: lastView, attribute: .Width, relatedBy: .Equal, toItem: current, attribute: .Width, multiplier: 1, constant: 0)
            c.priority = priority
            c.active()
            lastView = current
        }
    }
    
    static func equalWidth(priority : UILayoutPriority = UILayoutPriorityRequired, firstView : UIView, secondView : UIView, delta : CGFloat = 0, multipler : CGFloat = 1) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: firstView, attribute: .Width, relatedBy: .Equal, toItem: secondView, attribute: .Width, multiplier: multipler, constant: delta).active()
    }
    
    static func equalHeight(priority : UILayoutPriority = UILayoutPriorityRequired, firstView : UIView, secondView : UIView, delta : CGFloat = 0, multipler : CGFloat = 1) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: firstView, attribute: .Height, relatedBy: .Equal, toItem: secondView, attribute: .Height, multiplier: multipler, constant: delta).active()
    }
    //MARK: --center
    static func alignCenter(firstView : UIView, secondView : UIView) {
        centerX(firstView, secondView: secondView)
        centerY(firstView, secondView: secondView)
    }
    static func centerX(firstView : UIView, secondView : UIView) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: firstView, attribute: .CenterX, relatedBy: .Equal, toItem: secondView, attribute: .CenterX, multiplier: 1, constant: 0).active()
    }
    
    static func centerY(firstView : UIView, secondView : UIView) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: firstView, attribute: .CenterY, relatedBy: .Equal, toItem: secondView, attribute: .CenterY, multiplier: 1, constant: 0).active()
    }
    //MARK: --space
    static func verticalSpace(firstView : UIView, secondView : UIView, space : CGFloat = 0) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: firstView, attribute: .Bottom, relatedBy: .Equal, toItem: secondView, attribute: .Top, multiplier: 1, constant: space).active()
    }
    
    static func horizontalSpace(firstView : UIView, secondView : UIView, space : CGFloat = 0) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: firstView, attribute: .Trailing, relatedBy: .Equal, toItem: secondView, attribute: .Leading, multiplier: 1, constant: space).active()
    }
    //MARK: --edge
    static func pinTop(firstView : UIView, secondView : UIView, space : CGFloat = 0, priority : UILayoutPriority = UILayoutPriorityRequired) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: firstView, attribute: .Top, relatedBy: .Equal, toItem: secondView, attribute: .Top, multiplier: 1, constant: space).active()
    }
    static func pinLeading(firstView : UIView, secondView : UIView, space : CGFloat = 0, priority : UILayoutPriority = UILayoutPriorityRequired) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: firstView, attribute: .Leading, relatedBy: .Equal, toItem: secondView, attribute: .Leading, multiplier: 1, constant: space).active()
    }
    static func pinBottom(firstView : UIView, secondView : UIView, space : CGFloat = 0, priority : UILayoutPriority = UILayoutPriorityRequired) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: firstView, attribute: .Bottom, relatedBy: .Equal, toItem: secondView, attribute: .Bottom, multiplier: 1, constant: space).active()
    }
    static func pinTrailing(firstView : UIView, secondView : UIView, space : CGFloat = 0, priority : UILayoutPriority = UILayoutPriorityRequired) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: firstView, attribute: .Trailing, relatedBy: .Equal, toItem: secondView, attribute: .Trailing, multiplier: 1, constant: space).active()
    }
}
