//
//  GlobalFunc.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/28.
//  Copyright © 2015年 yb. All rights reserved.
//

import Foundation

func GetLeftBarButtonItem(target:AnyObject, action:Selector,imageName:String = "back") -> UIBarButtonItem{
    //let backView = UIView(frame: CGRectMake(0, 0, 40, 40))
    let backBtn = LargerButton()
    //let backBtn = UIButton()
    backBtn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
    //backBtn.frame = CGRectMake(0, 5, 18, 30)
    backBtn.sizeToFit()
    backBtn.expandEdge = UIEdgeInsetsMake(20, 50, 20, 50)
    //backView.addSubview(backBtn)
    //backBtn.normalStatusBackgroundColor = UIColor(red: 36.0/255.0, green: 6.0/255.0, blue: 6.0/255.0, alpha: 1)
    backBtn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
    return UIBarButtonItem(customView: backBtn)
}