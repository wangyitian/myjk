//
//  GlobalFunctions.swift
//
//
//  Created by yb on 15/6/18.
//  Copyright (c) 2015年 . All rights reserved.
//

import UIKit


let onePixel : CGFloat = 1 / UIScreen.mainScreen().scale

var AppRootController : UIViewController {
get {
    let ctl = UIApplication.sharedApplication().delegate?.window??.rootViewController
    return ctl!
}
}
var AppRootWindow : UIWindow {
get {
    let ctl = UIApplication.sharedApplication().delegate?.window
    return ctl!!
}
}


var AppRootView : UIView {
get {
    guard let view = UIApplication.sharedApplication().delegate?.window??.rootViewController?.view else {
        return UIView()
    }
    return view
}
}

//调整view内某些分割线的高度为1
func AdjustCertainViewHeightToMin(inview view : UIView){
    var certainTag = 9527
    var certainview = view.viewWithTag(certainTag)
    let screenScale = UIScreen.mainScreen().scale
    while(certainview != nil){
        for constarint in certainview!.constraints {
            let c = constarint
            if (c.firstItem as! NSObject == certainview! && c.firstAttribute == .Height && c.secondItem == nil && c.multiplier == 1) {
                c.constant = CGFloat(1)/screenScale
            }
        }
        certainview = view.viewWithTag(++certainTag)
        
    }
}

//调整view内某些分割线的宽为1
func AdjustCertainViewWidthToMin(inview view : UIView){
    var certainTag = 95270
    var certainview = view.viewWithTag(certainTag)
    let screenScale = UIScreen.mainScreen().scale
    while(certainview != nil){
        for constarint in certainview!.constraints {
            let c = constarint
            if (c.firstItem as! NSObject == certainview! && c.firstAttribute == .Width && c.secondItem == nil && c.multiplier == 1) {
                c.constant = CGFloat(1)/screenScale
            }
        }
        certainview = view.viewWithTag(++certainTag)
    }
}

func GetParentCell(view : UIView) -> UITableViewCell? {
    var parent = view.superview
    while parent != nil {
        if let p = parent as? UITableViewCell {
            return p
        }
        parent = parent?.superview
    }
    return nil
}

func GetParentCollectionCell(view : UIView) -> UICollectionViewCell? {
    var parent = view.superview
    while parent != nil {
        if let p = parent as? UICollectionViewCell {
            return p
        }
        parent = parent?.superview
    }
    return nil
}


func Delay(time : NSTimeInterval, queue : dispatch_queue_t = dispatch_get_main_queue(), block :dispatch_block_t) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time*NSTimeInterval(NSEC_PER_SEC))), queue, block)
}


func RGBAColor(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat = 1) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func GetTopUIBarButtonItem(target:AnyObject, action:Selector,imageName:String = "back") -> UIBarButtonItem{
    let backView = UIView(frame: CGRectMake(0, 0, 40, 40))
    let backBtn = LargerButton()
    backBtn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
    backBtn.frame = CGRectMake(0, 5, 18, 30)
    backBtn.expandEdge = UIEdgeInsetsMake(20, 50, 20, 50)
    backView.addSubview(backBtn)
    //backBtn.normalStatusBackgroundColor = UIColor(red: 36.0/255.0, green: 6.0/255.0, blue: 6.0/255.0, alpha: 1)
    backBtn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
    return UIBarButtonItem(customView: backView)
}
