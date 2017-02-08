//
//  YBToastView.swift
//  SXT
//
//  Created by sogou on 15/6/18.
//  Copyright (c) 2015年 ringsea. All rights reserved.
//

import UIKit

class YBToastView: UIView {

    //文字
    var text : String = "" {
        didSet {
            label.text = text
        }
    }
    
    //字体
    var textFont = UIFont.systemFontOfSize(15)
    var textColor = UIColor.whiteColor()
    
    //转菊花等待指示
    lazy var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
//    与父view的centerX距离
    var centerXPadding : CGFloat = 0
    
//    与父view的centerX比例
    var centerXMultiplier : CGFloat = 1
    
//    --
    var centerYPadding : CGFloat = 0
    var centerYMultiplier : CGFloat = 1
//    中间文字上下左右间距
    var labelEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10){
        didSet {
            if !UIEdgeInsetsEqualToEdgeInsets(labelEdgeInsets, oldValue) {
                self.setNeedsUpdateConstraints()
            }
        }
    }
//    边界圆角
    var viewCornerRadius : CGFloat = 5 {
        didSet {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = viewCornerRadius
        }
    }
    private var showing = false
    
    //文字toast
    func showToast(inView superview : UIView, duration : NSTimeInterval) {
        showing = true
        self.superview?.userInteractionEnabled = true
        if label.superview != self {
            self.addSubview(label)
            activityIndicatorView.removeFromSuperview()
//            self.setNeedsUpdateConstraints()
            addLabelConstraints()
        }

        self.addToSuperView(superview, duration: duration)
    }
    //菊花toast
    func showLoadingToast(inView superview: UIView, blockSuperView : Bool) {
        showing = true
        self.performTimer?.invalidate()
        self.superview?.userInteractionEnabled = true
        label.removeFromSuperview()
        self.addAcitvityIndicatorAndAddConstraints()
        activityIndicatorView.startAnimating()
        
        if blockSuperView {
            superview.userInteractionEnabled = false
        }
        self.addToSuperView(superview, duration: 0)
    }
    func hideLoadingToast() {
        showing = false
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
        self.dismiss()
    }
    
    func addToSuperView(superview : UIView, duration: NSTimeInterval) {
        superview.addSubview(self)
        self.layer.removeAllAnimations()
        self.alpha = 1
        // constrains to superview
        self.useAutoLayout()
        self.constraintCenterX = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: superview, attribute: .CenterX, multiplier: centerXMultiplier, constant: centerXPadding)
        self.constraintCenterX!.active()
        self.constraintCenterY = NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: superview, attribute: .CenterY, multiplier: centerYMultiplier, constant: centerYPadding)
        self.constraintCenterY!.active()
        if self.bounds.width == 0 {
            self.superview?.layoutIfNeeded()
        }
        self.layoutIfNeeded()
        self.performTimer?.invalidate()
        if duration > 0 {
            self.performTimer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: "dismiss", userInfo: nil, repeats: false)
        }
    }
    
    func dismiss() {
        showing = false
        UIView.animateWithDuration(0.2, animations: {
            self.alpha = 0
            }) { _ in
                self.superview?.userInteractionEnabled = true
                if !self.showing {
                    self.removeFromSuperview()
                }
                self.alpha = 1
        }
    }

    class func showToast(inView superview : UIView, withText text : String) -> YBToastView {
        defaultInstance.text = text
        defaultInstance.showToast(inView: superview, duration: 2)
        return defaultInstance
    }
    
    class func hideLoadingToast() {
        defaultInstance.hideLoadingToast()
    }
    
    class func showLoadingToast(inView superview : UIView, blockSuperView block : Bool) -> YBToastView {
        defaultInstance.showLoadingToast(inView: superview, blockSuperView : block)
        return defaultInstance
    }
    
    
// MARK: --private--
    static private let defaultInstance = YBToastView(frame: CGRectZero)
    private let label = UILabel()
    private var constraintCenterX : NSLayoutConstraint?
    private var constraintCenterY : NSLayoutConstraint?
    private var innerConstraints : [NSLayoutConstraint] = []
    private var performTimer : NSTimer?
    
    private func applyDefaultSetting() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.8)
        self.addSubview(label)
        label.textColor = self.textColor
        label.font = self.textFont
        label.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
        label.setContentCompressionResistancePriority(1000, forAxis: .Vertical)
        label.setContentHuggingPriority(1000, forAxis: .Horizontal)
        label.setContentHuggingPriority(1000, forAxis: .Vertical)
        self.viewCornerRadius = 5;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.applyDefaultSetting()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.applyDefaultSetting()
    }

    override func didMoveToSuperview() {
        if superview == nil {
            self.constraintCenterX = nil
            self.constraintCenterY = nil
        }
    }
//    override func updateConstraints() {
//        self.addLabelConstraints()
//        super.updateConstraints()
//    }
    
    func addLabelConstraints() {
        innerConstraints.autolayoutUnInstall()
        if label.superview == self {
            label.useAutoLayout()
            let metrics = ["left":labelEdgeInsets.left, "right":labelEdgeInsets.right, "top":labelEdgeInsets.top, "bottom":labelEdgeInsets.bottom]
            innerConstraints.removeAll(keepCapacity: true)
            innerConstraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-left-[label(>=10@1)]-right-|", options: [], metrics: metrics, views: ["label":label])
            innerConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-top-[label(>=10@1)]-bottom-|", options: [], metrics: metrics, views: ["label":label])
            innerConstraints.autolayoutInstall()
        }
    }
    
    private func addAcitvityIndicatorAndAddConstraints() {
        if activityIndicatorView.superview != self {
            self.addSubview(activityIndicatorView)
            activityIndicatorView.useAutoLayout()
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-30-[Indicator]-30-|", options: [], metrics: nil, views: ["Indicator":activityIndicatorView]).autolayoutInstall()
            NSLayoutConstraint.constraintsWithVisualFormat("V:|-30-[Indicator]-30-|", options: [], metrics: nil, views: ["Indicator":activityIndicatorView]).autolayoutInstall()
        }
        
    }
}
