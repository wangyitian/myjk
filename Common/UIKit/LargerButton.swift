//
//  LargerButton.swift
//  HuaXueQuan
//
//  Created by yangbin on 15/8/29.
//  Copyright © 2015年 hxq. All rights reserved.
//

import UIKit

class LargerButton: UIButton {
    
    @IBInspectable var expandLeft : CGFloat = 0
    @IBInspectable var expandRight : CGFloat = 0
    @IBInspectable var expandTop : CGFloat = 0
    @IBInspectable var expandBottom : CGFloat = 0
    
    var expandEdge : UIEdgeInsets {
        set {
            expandLeft = newValue.left
            expandRight = newValue.right
            expandTop = newValue.top
            expandBottom = newValue.bottom
        }
        get {
            return UIEdgeInsetsMake(expandTop, expandLeft, expandBottom, expandRight)
        }
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let largerRect = CGRectMake(-expandLeft, -expandTop, bounds.width + expandLeft + expandRight, bounds.height + expandTop + expandBottom)
        if CGRectContainsPoint(largerRect, point) {
            return self
        } else {
            return nil
        }
    }
    
}
