//
//  CycleScrollView.swift
//  testCaleandar
//
//  Created by yb on 15/9/24.
//  Copyright © 2015年 sogou. All rights reserved.
//

import UIKit

protocol YBCycleScrollViewDelegate : NSObjectProtocol {
    func needCycleView(index : Int) -> UIView?
}

class YBCycleScrollView: UIScrollView {
    
    var viewArray : [(view:UIView,index:Int)] = []
    
    weak var cycleDelegate : YBCycleScrollViewDelegate?
    var vertical = true {
        didSet {
            alwaysBounceVertical = vertical
            alwaysBounceHorizontal = !vertical
        }
    }
    
    func setViewArray(views : [UIView]) {
        viewArray.removeAll()
        for (index, view) in views.enumerate() {
            viewArray.append(view : view, index : index)
        }
    }
    private func commonInit() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        alwaysBounceVertical = vertical
        alwaysBounceHorizontal = !vertical
        addObserver(self, forKeyPath: "contentOffset", options: [.New,.Old], context: nil)
    }
    
    convenience init (views : [UIView]) {
        self.init(frame : CGRectZero)
        setViewArray(views)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    deinit {
        removeObserver(self, forKeyPath: "contentOffset")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        commonInit()
    }
    
    private var isFixingContentOffset = false
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard contentSize.width > 0 && contentSize.height > 0 else {
            return
        }
        if isFixingContentOffset {
            return
        }
        let currentOffset = contentOffset
        for var i = viewArray.count-1; i >= 0; i-- {
            let view = viewArray[i].view
            //向下或向右滑动，上方或左侧view已经移出视图
            if CGRectGetMaxX(view.frame) <= currentOffset.x || CGRectGetMaxY(view.frame) <= currentOffset.y {
                viewArray.removeAtIndex(i)
                view.removeFromSuperview()
                isFixingContentOffset = true
                if vertical {
                    contentOffset.y -= view.frame.height
                } else {
                    contentOffset.x -= view.frame.width
                }
                isFixingContentOffset = false
                setNeedsLayout()
            }
            //向上或向左滑动，下方或右侧view已经移出视图
            if view.frame.origin.y > currentOffset.y + frame.height || view.frame.origin.x > currentOffset.x + frame.width {
                viewArray.removeAtIndex(i)
                view.removeFromSuperview()
                setNeedsLayout()
            }
        }
        if vertical {
            if contentOffset.y >= contentSize.height - frame.height {
                if !pagingEnabled || viewArray.count < 2 {
                    if let last = viewArray.last, view = cycleDelegate?.needCycleView(last.index + 1) {
                        let c = (view : view, index : last.index + 1)
                        viewArray.append(c)
                        setNeedsLayout()
                    }
                }
            } else if (contentOffset.y < 0) {
                if !pagingEnabled || viewArray.count < 2 {

                    if let first = viewArray.first, view = cycleDelegate?.needCycleView(first.index - 1) {
                        let c = (view : view, index : first.index - 1)
                        viewArray.insert(c, atIndex: 0)
                        isFixingContentOffset = true
                        contentOffset.y += view.frame.height
                        isFixingContentOffset = false
                        setNeedsLayout()
                    }
                }
            }
        } else {
            if contentOffset.x >= contentSize.width - frame.width {
                if !pagingEnabled || viewArray.count < 2 {

                    let nextIndex = viewArray.last != nil ? viewArray.last!.index + 1 : 0;
                    if let view = cycleDelegate?.needCycleView(nextIndex) {
                        let c = (view : view, index : nextIndex)
                        viewArray.append(c)
                        setNeedsLayout()
                    }
                }
            } else if (contentOffset.x < 0) {
                if !pagingEnabled || viewArray.count < 2 {

                    let nextIndex = viewArray.first != nil ? viewArray.first!.index - 1 : 0;
                    if let view = cycleDelegate?.needCycleView(nextIndex) {
                        let c = (view : view, index : nextIndex)
                        viewArray.insert(c, atIndex: 0)
                        isFixingContentOffset = true
                        contentOffset.x += view.frame.width
                        isFixingContentOffset = false
                        setNeedsLayout()
                    }
                }
            }
        }
    }
    
    private var cycleUpdated = true
    override func setNeedsLayout() {
        cycleUpdated = true
        super.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        guard cycleUpdated else {
            super.layoutSubviews()
            return
        }
        cycleUpdated = false
        var currentOrigin = CGPointZero
        for (view,_) in viewArray {
            let frame = CGRectMake(currentOrigin.x, currentOrigin.y, view.frame.width, view.frame.height)
//            if frameIsVisiable(frame) {
                view.frame = frame
                addSubview(view)
//            }
            if vertical {
                currentOrigin.y += view.frame.height
            } else {
                currentOrigin.x += view.frame.width
            }
        }
        isFixingContentOffset = true
        if vertical {
            contentSize = CGSizeMake(frame.width, currentOrigin.y)
        } else {
            contentSize = CGSizeMake(currentOrigin.x, frame.height)
        }
        isFixingContentOffset = false
        super.layoutSubviews()
    }
    
    private func frameIsVisiable(frame : CGRect) -> Bool {
        let visiableFrame = CGRectMake(contentOffset.x, contentOffset.y, frame.width, frame.height)
        return CGRectIntersectsRect(visiableFrame, frame)
    }

}
