//
//  YBBannerScrollView.swift
//  HuaXueQuan
//
//  Created by yangbin on 15/11/12.
//  Copyright © 2015年 hxq. All rights reserved.
//

import UIKit

@IBDesignable
class YBBannerScrollView: UIView, YBCycleScrollViewDelegate, UIScrollViewDelegate {
    
    var scrollView : YBCycleScrollView
    let pageControl = UIPageControl()
    var showPage = true
    @IBInspectable var pageBottom : CGFloat = 5
    @IBInspectable var play : Bool = true
    var views : [UIView]
    var timeInterval : NSTimeInterval = 2.5 {
        didSet {
            if timeInterval != oldValue {
                recreateTimer()
            }
        }
    }
    
    private var innerTimer : NSTimer?
    private var pageBottomConstraint : NSLayoutConstraint!
    
    init(views : [UIView]) {
        self.views = views
        scrollView = YBCycleScrollView(views: views)
        super.init(frame: CGRectZero)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        scrollView = YBCycleScrollView()
        self.views = [UIView]()
        super.init(coder : aDecoder)
        setUp()
    }
    
    func setVews(views : [UIView]) {
        self.views = views
        scrollView.removeFromSuperview()
        scrollView = YBCycleScrollView(views: views).useAutoLayout()
        scrollView.cycleDelegate = self
        scrollView.vertical = false
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        pageControl.numberOfPages = views.count
        pageControl.currentPage = 0
        addSubview(scrollView)
        NSLayoutConstraint.equalSize(views: self, scrollView)
        NSLayoutConstraint.alignCenter(self, secondView: scrollView)
        bringSubviewToFront(pageControl)
    }
    
    func setUp() {
        scrollView.cycleDelegate = self
        scrollView.vertical = false
        scrollView.delegate = self
        scrollView.useAutoLayout()
        scrollView.pagingEnabled = true
        pageControl.useAutoLayout()
        addSubview(scrollView)
        addSubview(pageControl)
        NSLayoutConstraint.equalSize(views: self, scrollView)
        NSLayoutConstraint.alignCenter(self, secondView: scrollView)
        NSLayoutConstraint.centerX(pageControl, secondView: self)
        pageBottomConstraint = NSLayoutConstraint.pinBottom(self, secondView: pageControl, space: pageBottom)
        pageControl.numberOfPages = views.count
    }
    
    func needCycleView(index: Int) -> UIView? {
        guard views.count > 0 else {
            return nil
        }
        var page = index % views.count
        if page < 0 {
            page = views.count + page
        }
        return views[page]
    }
    
    override func didMoveToWindow() {
        recreateTimer()
    }
    
    func recreateTimer() {
        innerTimer?.invalidate()
        if play && window != nil {
            innerTimer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "timerFire", userInfo: nil, repeats: true)
        }
    }
    
    func timerFire() {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width + 1)
        let target = CGFloat(page) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPointMake(target, 0), animated: true)

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let viewDisplay = self.scrollView.viewArray.filter { (view: UIView, index: Int) -> Bool in
            if CGRectContainsPoint(view.frame, scrollView.contentOffset) {
                return true
            }
            return false
        }
        if let current = viewDisplay.first {
            var page = current.index % views.count
            if page < 0 {
                page = views.count + page
            }
            pageControl.currentPage = page
        }
    }
}
