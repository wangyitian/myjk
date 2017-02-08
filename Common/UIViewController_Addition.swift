//
//  UIViewController_Addition.swift
//  SXT
//
//  Created by yang bin on 15/6/9.
//  Copyright (c) 2015年 ringsea. All rights reserved.
//

import UIKit

extension UIViewController {
    func addChildControllerAndView(controller:UIViewController) {
        self.addChildViewController(controller)
        self.view.addSubview(controller.view)
    }
    func removeControllerAndViewFromParent() {
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    static func keyController() -> UIViewController? {
        return UIApplication.sharedApplication().keyWindow?.rootViewController
    }
}