//
//  DashView.swift
//  HuaXueQuan
//
//  Created by yb on 15/9/25.
//  Copyright © 2015年 hxq. All rights reserved.
//

import UIKit

@IBDesignable
class DashLineView: UIView {
    @IBInspectable var dashColor : UIColor?
    @IBInspectable var dashLength : CGFloat = 2
    @IBInspectable var blankLength : CGFloat = 2
    
    override func drawRect(rect: CGRect) {
        guard let dashColor = dashColor,ctx = UIGraphicsGetCurrentContext() where dashLength >= 0 && blankLength >= 0 else {
            super.drawRect(rect)
            return
        }
        let vertical = bounds.width < bounds.height
        CGContextBeginPath(ctx)
        CGContextSetLineWidth(ctx, vertical ? bounds.height : bounds.width)
        CGContextSetStrokeColorWithColor(ctx, dashColor.CGColor)
        var length = [dashLength, blankLength]
        CGContextSetLineDash(ctx, 0, &length, 2)
        CGContextMoveToPoint(ctx, 0, 0)
        if vertical {
            CGContextAddLineToPoint(ctx, 0, bounds.height)
        } else {
            CGContextAddLineToPoint(ctx, bounds.width, 0)
        }
        CGContextStrokePath(ctx)
        CGContextClosePath(ctx)
    }
}