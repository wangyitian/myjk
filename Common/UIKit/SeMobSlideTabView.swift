
//
//  SXTSlideTabView.swift
//  SXT
//
//  Created by YB on 15/6/15.
//  Copyright (c) 2015年 sogou. All rights reserved.
//

import UIKit

private  let firstTabTag = 1231115
private  let firstLayoutViewTag = 131115


@objc protocol SeMobSlideTabViewDelegate {
    optional func slideTabViewDidSelect(index:Int) -> Void
}

enum SeMobSlideTabAlignType {
    case AlignCenter
    case AlignFixMargin(left : CGFloat?, mid : CGFloat?, right : CGFloat?)
}

@IBDesignable
class SeMobSlideTabView: UIView {
    
    //MARK: --delegate--
    weak var delegate : SeMobSlideTabViewDelegate?
    
    var alignType : SeMobSlideTabAlignType = .AlignCenter
    
    
    // MARK: --class members--
    //绑定的scrollview，随着scrollview滑动改变slider滑块的位置
    var scrollview : UIScrollView? {
        didSet {
            if scrollview != oldValue {
                oldValue?.removeObserver(self, forKeyPath: "contentOffset")
                scrollview?.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
                if scrollview != nil {
                    setPortionWithScrollViewWithOffset(scrollview!.contentOffset)
                }
            }
        }
    }
    //标题
    @IBInspectable var titles : [String] = [] {
        didSet {
            while badgeTypes.count < titles.count {
                badgeTypes.append(.Number)
            }
            badgeNumbers = [Int](count: titles.count, repeatedValue: 0)
            needsRelayout = true
        }
    }
    //标题字体
    @IBInspectable var titleFont = UIFont.systemFontOfSize(13) {
        didSet {
            for view in self.subviews {
                if let label = view as? UILabel {
                    label.font = titleFont
                }
            }
        }
    }
    //竖条分隔符，预留，暂不支持
    var seperaterLineView : UIView?{
        didSet {
            needsRelayout = true
        }
    }
    //滑块自定义view
    var slideLineView : UIView?{
        didSet {
            needsRelayout = true
        }
    }
    //单色滑块颜色，优先使用slideLineView，没有则使用该颜色创建一个纯色滑块
    @IBInspectable var slideLineColor : UIColor?{
        didSet {
            needsRelayout = true
        }
    }
    //滑块大小（宽、高）
    @IBInspectable var slideLineSize = CGSizeZero{
        didSet {
            needsRelayout = true
        }
    }
    //滑块距离底部的间距
    @IBInspectable var slideLineBottom : CGFloat = 0{
        didSet {
            needsRelayout = true
        }
    }
    //选中的title颜色
    @IBInspectable var selectedTitleTextColor : UIColor!{
        didSet {
            needsRelayout = true
        }
    }
    //未选中的title颜色
    @IBInspectable var titleTextColor : UIColor = UIColor.blackColor() {
        didSet {
            needsRelayout = true
        }
    }

    @IBInspectable var selectedIndex : Int = 0 {
        didSet {
            let value =  min(titles.count, max(0, selectedIndex))
            selectedIndex = value
            if scrollview == nil {
                sliderPortion = Double(value)
            }
            for var i = 0; i < self.titles.count; i++ {
                if let label = self.viewWithTag(firstTabTag + i) as? UILabel {
                    if i != selectedIndex {
                        label.textColor = self.titleTextColor
                    } else {
                        label.textColor = self.selectedTitleTextColor
                    }
                }
            }
            if selectedIndex != oldValue {
                self.delegate?.slideTabViewDidSelect?(selectedIndex)
            }
        }
    }
    
    private var sliderPortion = 0.0 {
        didSet {
            if sliderPortion != oldValue {
                moveSlider()
                if (sliderPortion - Double(Int(sliderPortion))) < 0.00001 {
                    selectedIndex = Int(sliderPortion)
                }
            }
        }
    }
    
    //-- badge --
    enum BadgeType {
        case None;
        case Dot;
        case Number;
        //使用自定义的block添加badge，UIView参数为当前tab文字view，使用该参数作为layout依据
        case CustomView((targetView:UIView,badgeNumber:Int,viewTag:Int)->Void) ;
    }
    var badgeTypes : [BadgeType] = [.None, .Dot, .Number]
    var badgeNumbers : [Int] = []
    //-- end badge --

    private var needsRelayout = true {
        didSet {
            if needsRelayout {
                self.sliderView = nil
                self.setNeedsLayout()
            }
        }
    }
    private var sliderView : UIView?
    private var sliderPosConstraint : NSLayoutConstraint?
    
    //MARK: -- init methods --
    
    override init(frame: CGRect) {
        sliderPortion = 0
        super.init(frame:frame)
        let gr = UITapGestureRecognizer(target: self, action: "didTap:")
        self.addGestureRecognizer(gr)
    }
    
    required init?(coder aDecoder: NSCoder) {
        sliderPortion = 0
        super.init(coder:aDecoder)
        let gr = UITapGestureRecognizer(target: self, action: "didTap:")
        self.addGestureRecognizer(gr)
    }
    
    deinit {
        scrollview?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    //MARK: -- class methods --
    func didTap(gr:UITapGestureRecognizer) {
        let pt = gr.locationInView(self)
        let index = pt.x / (self.bounds.width/CGFloat(self.titles.count))
        self.selectedIndex = Int(index)
    }
    
    override func layoutSubviews() {
        if needsRelayout {
            self.relayout()
        }
        super.layoutSubviews()
    }
    
    func relayout() {
        func relayoutTitleForAlignCenter() {
            for var i = 0; i < self.titles.count; i++ {
                let label = UILabel()
                label.tag = firstTabTag + i
                label.text = self.titles[i]
                label.font = self.titleFont
                label.textAlignment = .Center
                label.textColor = self.titleTextColor
                if (self.selectedTitleTextColor != nil && i == selectedIndex) {
                    label.textColor = self.selectedTitleTextColor
                }
                self.addSubview(label)
                label.useAutoLayout()
                let multiplierBase = CGFloat(1.0) / CGFloat(self.titles.count)
                let multiplierCenterX = (multiplierBase * CGFloat(i) + multiplierBase / CGFloat(2)) * CGFloat(2)
                NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: multiplierCenterX, constant: 0).active()
                NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[label]-0-|", options: [], metrics: nil, views: ["label":label]).autolayoutInstall()
                buildBadgeNumber(atIndex: i)
            }
        }
        func relayoutTitleForAlignFixMargin(left : CGFloat?, _ mid : CGFloat? , _ right : CGFloat?) {
            for var i = 0; i < self.titles.count; i++ {
                // --label
                let label = UILabel()
                label.tag = firstTabTag + i
                label.text = self.titles[i]
                label.font = self.titleFont
                label.textAlignment = .Center
                label.textColor = self.titleTextColor
                if (self.selectedTitleTextColor != nil && i == selectedIndex) {
                    label.textColor = self.selectedTitleTextColor
                }
                self.addSubview(label)
                label.useAutoLayout()
                NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[label]-0-|", options: [], metrics: nil, views: ["label":label]).autolayoutInstall()

                //--- margin
                let leftMarginView = UIView().useAutoLayout()
                leftMarginView.tag = firstLayoutViewTag + i
                self.addSubview(leftMarginView)
                leftMarginView.backgroundColor = UIColor.clearColor()
                NSLayoutConstraint.horizontalSpace(leftMarginView, secondView: label)
                NSLayoutConstraint.centerY(leftMarginView, secondView: label)
                NSLayoutConstraint.equalHeight(firstView: leftMarginView, secondView: label)
                if i == 0 {
                    NSLayoutConstraint.pinLeading(self, secondView: leftMarginView)
                    if let left = left {
                        leftMarginView.setLayoutWidth(left)
                    }
                } else if i == 1{
                    if let mid = mid {
                        leftMarginView.setLayoutWidth(mid)
                    }
                    if let lastLabel = self.viewWithTag(firstTabTag + i - 1) {
                        NSLayoutConstraint.horizontalSpace(lastLabel, secondView: leftMarginView)
                    }
                } else {
                    if let lastMarginView = self.viewWithTag(firstLayoutViewTag + i - 1) {
                        NSLayoutConstraint.equalWidth(firstView: lastMarginView, secondView: leftMarginView)
                    }
                    if let lastLabel = self.viewWithTag(firstTabTag + i - 1) {
                        NSLayoutConstraint.horizontalSpace(lastLabel, secondView: leftMarginView)
                    }
                }
                if i == self.titles.count - 1 {
                    let rightEdgeView = UIView().useAutoLayout()
                    rightEdgeView.tag = firstLayoutViewTag + i + 1
                    self.addSubview(rightEdgeView)
                    rightEdgeView.backgroundColor = UIColor.clearColor()
                    NSLayoutConstraint.horizontalSpace(label, secondView: rightEdgeView)
                    NSLayoutConstraint.centerY(rightEdgeView, secondView: label)
                    NSLayoutConstraint.equalHeight(firstView: rightEdgeView, secondView: label)
                    NSLayoutConstraint.pinTrailing(rightEdgeView, secondView: self)
                    let leftEdgeView = self.viewWithTag(firstLayoutViewTag)!
                    if let right = right {
                        //规定了右侧的距离
                        rightEdgeView.setLayoutWidth(right)
                        if let _ = left {
                            //规定了左侧距离，已经在i=0时处理
                        } else {
                            //没有规定左侧距离
                            NSLayoutConstraint.equalWidth(firstView: leftEdgeView, secondView: leftMarginView)
                        }
                    } else if let _ = left {
                        NSLayoutConstraint.equalWidth(firstView: leftMarginView, secondView: rightEdgeView)
                    } else {
                        NSLayoutConstraint.equalWidth(firstView: leftEdgeView, secondView: rightEdgeView)
                        NSLayoutConstraint.equalWidth(firstView: leftEdgeView, secondView: leftMarginView)
                    }
                }
                buildBadgeNumber(atIndex: i)
            }
        }
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
        //titles
        switch alignType {
        case .AlignCenter:
            relayoutTitleForAlignCenter()
        case .AlignFixMargin(let left, let mid, let right) :
            relayoutTitleForAlignFixMargin(left, mid, right)
        }
        // slider
        self.createSlider()
        //text color
        for var i = 0; i < self.titles.count; i++ {
            if let label = self.viewWithTag(firstTabTag + i) as? UILabel {
                if i != selectedIndex {
                    label.textColor = self.titleTextColor
                } else {
                    label.textColor = self.selectedTitleTextColor
                }
            }
        }
        self.needsRelayout = false
    }
    
    func createSlider() {
        let targetLabel = self.viewWithTag(firstTabTag+selectedIndex)
        if slideLineView != nil {
            sliderView = slideLineView
        } else if slideLineColor != nil{
            sliderView = UIImageView(image: UIImage.imageWithColor(slideLineColor!))
        }
        if sliderView != nil {
            self.addSubview(sliderView!)
            sliderView!.useAutoLayout()
            NSLayoutConstraint.constraintsWithVisualFormat("H:[slider(width)]", options: [], metrics: ["width":slideLineSize.width], views: ["slider":sliderView!]).autolayoutInstall()
            NSLayoutConstraint.constraintsWithVisualFormat("V:[slider(height)]-bottom-|", options: [], metrics: ["bottom":slideLineBottom, "height":slideLineSize.height], views: ["slider":sliderView!]).autolayoutInstall()
            self.sliderPosConstraint = NSLayoutConstraint(item: sliderView!, attribute: .CenterX, relatedBy: .Equal, toItem: targetLabel!, attribute: .CenterX, multiplier: 1, constant: 0)
            self.sliderPosConstraint!.active()
        }
    }
    
    func moveSlider() {
        if sliderView != nil {
            self.sliderPosConstraint?.deActive()
            switch alignType {
            case .AlignCenter:
                let multiplierBase = CGFloat(1.0) / CGFloat(self.titles.count)
                let multiplierCenterX = (multiplierBase * CGFloat(self.sliderPortion) + multiplierBase / CGFloat(2)) * CGFloat(2)
                sliderPosConstraint = NSLayoutConstraint(item: sliderView!, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: multiplierCenterX, constant: 0)
            case .AlignFixMargin:
                if let targetLabel = self.viewWithTag(Int(sliderPortion) + firstTabTag) {
                    sliderPosConstraint = NSLayoutConstraint.centerX(targetLabel, secondView: sliderView!)
                }
            }

            sliderPosConstraint!.active()
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.sliderView!.layoutIfNeeded()
            })
        }
    }
    
    static let badgeTagStart = 8090

    func updateBadgeNumber(index index:Int, number: Int) {
        if index < badgeNumbers.count {
            badgeNumbers[index] = number
            buildBadgeNumber(atIndex: index)
        }
    }
    
    private func buildBadgeNumber(atIndex index:Int) {
        if index >= titles.count {
            return
        }
        let badgeType = badgeTypes[index]
        let number = badgeNumbers[index]
        if number == 0 {
            let badge = self.viewWithTag(SeMobSlideTabView.badgeTagStart+index)
            badge?.removeFromSuperview()
        } else {
            if let titleLabel = self.viewWithTag(firstTabTag+index) as? UILabel{
                let badge = self.viewWithTag(SeMobSlideTabView.badgeTagStart+index)
                badge?.removeFromSuperview()
                switch badgeType {
                case .None :
                    break
                case .Dot :
                    let badgeDot = UIView()
                    badgeDot.backgroundColor = UIColor.redColor()
                    badgeDot.cornerRadius = 2
                    badgeDot.tag = SeMobSlideTabView.badgeTagStart+index
                    self.addSubview(badgeDot)
                    badgeDot.useAutoLayout()
                    NSLayoutConstraint.constraintsWithVisualFormat("H:[title]-1-[badge(==4)]", options: [], metrics: nil, views: ["title":titleLabel,"badge":badgeDot]).autolayoutInstall()
                    NSLayoutConstraint(item: badgeDot, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Top, multiplier: 1, constant: 8).active()
                    NSLayoutConstraint(item: badgeDot, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 4).active()
                case .Number:
                    let badgeLabel = UILabel()
                    badgeLabel.backgroundColor = UIColor.redColor()
                    badgeLabel.cornerRadius = 6
                    badgeLabel.font = UIFont.systemFontOfSize(10)
                    badgeLabel.textColor = UIColor.whiteColor()
                    badgeLabel.tag = SeMobSlideTabView.badgeTagStart+index
                    self.addSubview(badgeLabel)
                    badgeLabel.useAutoLayout()
                    badgeLabel.textAlignment = .Center
                    badgeLabel.text = "\(number)"
                    let metrics = ["width" : 13]
                    NSLayoutConstraint.constraintsWithVisualFormat("H:[title]-1-[badge(>=width)]", options: [], metrics: metrics, views: ["title":titleLabel,"badge":badgeLabel]).autolayoutInstall()
                    NSLayoutConstraint(item: badgeLabel, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Top, multiplier: 1, constant: 7).active()
                    NSLayoutConstraint(item: badgeLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 12).active()
                case .CustomView(let block):
                    block(targetView: titleLabel,badgeNumber: number,viewTag: SeMobSlideTabView.badgeTagStart+index)
                }
            }
        }
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let _ = object as? UIScrollView {
            if let point = change!["new"] as? NSValue {
                var pt : CGPoint = CGPointZero
                point.getValue(&pt)
                setPortionWithScrollViewWithOffset(pt)
            }
        }
    }
    
    private func setPortionWithScrollViewWithOffset(point : CGPoint) {
        if let sv = scrollview {
            if sv.contentSize.width > 0 {
                let portion = (point.x / sv.contentSize.width) * CGFloat(titles.count)
                sliderPortion = Double(portion)
            }
        }
    }
}
