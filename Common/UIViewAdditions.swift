//
//  UIViewAdditions.swift
//  SXT
//
//  Created by sogou on 15/6/18.
//  Copyright (c) 2015年 ringsea. All rights reserved.
//

import UIKit

extension UIView {
    func relatedTableView ()-> UITableView? {
        var superview = self.superview
        while (superview != nil && !superview!.isKindOfClass(UITableView.self)) {
            superview = superview!.superview
        }
        return superview as? UITableView
    }
}

extension UIView {
    func nearestController () -> UIViewController? {
        var nextResponsder = self.nextResponder()
        while (nextResponsder != nil && !(nextResponsder! is UIViewController)) {
            nextResponsder = nextResponsder!.nextResponder()
        }
        return nextResponsder as? UIViewController
    }
}
