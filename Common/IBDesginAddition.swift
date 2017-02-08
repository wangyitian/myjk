//
//  IBDesginAddition.swift
//  SXT
//
//  Created by yang bin on 15/6/9.
//  Copyright (c) 2015年 ringsea. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
    @IBInspectable var borderWidth:CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.masksToBounds = true
            self.layer.borderWidth = newValue
        }
        
    }
    @IBInspectable var cornerRadius:CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = newValue
        }
    }
    @IBInspectable var boarderColor:UIColor? {
        get {
            guard let color = self.layer.borderColor else {
                return nil
            }
            return UIColor(CGColor: color)
        }
        set {
            if let _ = newValue {
                self.layer.masksToBounds = true
                self.layer.borderColor = newValue?.CGColor
            }
        }
    }
}
@IBDesignable
extension UIButton {
    @IBInspectable var normalStatusBackgroundColor : UIColor? {
        set {
            if let color = newValue {
                let img = UIImage.imageWithColor(color)
                self.setBackgroundImage(img, forState: .Normal)
            } else {
                self.setBackgroundImage(nil, forState: .Normal)
            }
        }
        get {
            return nil
        }
    }
    @IBInspectable var pressedStatusBackgroundColor : UIColor? {
        set {
            if let color = newValue {
                let img = UIImage.imageWithColor(color)
                self.setBackgroundImage(img, forState: .Highlighted)
            } else {
                self.setBackgroundImage(nil, forState: .Highlighted)
            }
        }
        get {
            return nil
        }
    }
    @IBInspectable var disabledStatusBackgroundColor : UIColor? {
        set {
            if let color = newValue {
                let img = UIImage.imageWithColor(color)
                self.setBackgroundImage(img, forState: .Disabled)
            } else {
                self.setBackgroundImage(nil, forState: .Disabled)
            }
        }
        get {
            return nil
        }
    }
}

extension UIImage {
    static func imageWithColor(color : UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context!, color.CGColor)
        CGContextFillRect(context!, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    
    }
}
