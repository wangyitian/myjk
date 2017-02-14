//
//  UserEducationController.swift
//  HuaXueQuan
//
//  Created by yb on 15/10/28.
//  Copyright © 2015年 hxq. All rights reserved.
//

import UIKit

class UserEducationController: UIViewController {
    
    let scrollView = UIScrollView().useAutoLayout()
    var images = [UIImage(named: "引导页1")!,UIImage(named: "引导页2")!,UIImage(named: "引导页3")!]
    
    private var retainSelf : UserEducationController?
    func show() {
        retainSelf = self
        AppRootWindow.addSubview(view.useAutoLayout())
        NSLayoutConstraint.equalSize(views: AppRootWindow, view)
        NSLayoutConstraint.alignCenter(AppRootWindow, secondView: view)
    }
    
    func hide() {
        retainSelf = nil
        view.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.pagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        NSLayoutConstraint.equalSize(views: scrollView, view)
        NSLayoutConstraint.alignCenter(scrollView, secondView: view)
        //BuildImages
        var lastImageView : UIImageView! = nil
        for (index, image) in images.enumerate() {
            let imageView = UIImageView(image: image).useAutoLayout()
            imageView.contentMode = .ScaleAspectFill
            scrollView.addSubview(imageView)
            NSLayoutConstraint.equalSize(views: imageView, view)
            if index == 0 {
                NSLayoutConstraint.pinTop(imageView, secondView: scrollView)
                NSLayoutConstraint.pinBottom(imageView, secondView: scrollView)
                NSLayoutConstraint.pinLeading(imageView, secondView: scrollView)
            } else {
                NSLayoutConstraint.horizontalSpace(lastImageView, secondView: imageView)
                NSLayoutConstraint.centerY(lastImageView, secondView: imageView)
            }
            lastImageView = imageView
        }
        NSLayoutConstraint.pinTrailing(lastImageView, secondView: scrollView)
        //Tap
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(UserEducationController.didTap))
        tapGR.delegate = self
        view.addGestureRecognizer(tapGR)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}

extension UserEducationController : UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if scrollView.contentOffset.x  == scrollView.frame.width * CGFloat(images.count - 1) {
            let scale = UIScreen.mainScreen().bounds.width / 320.0
            let rect = CGRectMake(90*scale, 480*scale, 145*scale, 40*scale)
            if CGRectContainsPoint(rect, touch.locationInView(view)) {
                return true
            }
            return false
        }
        return false
    }
    
    func didTap() {
        hide()
    }
}
