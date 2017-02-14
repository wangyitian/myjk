//
//  YBPhoneCodeButton
//  loginbutton
//
//  Created by yb on 15/12/30.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

enum YBPhoneCodeButtonState {
    case Normal;
    case Countdowning;
}

@IBDesignable
class YBPhoneCodeButton: UIButton {
    @IBInspectable var countdownFormat : NSString = "%ds"
    @IBInspectable var countdownTime : CGFloat = 60
    var btnState = YBPhoneCodeButtonState.Normal {
        didSet {
            switch btnState {
            case .Normal:
                enabled = true
                label.hidden = true
                disableTimer()
            case .Countdowning:
                enabled = false
                label.hidden = false
                label.text = NSString(format: countdownFormat, Int(countdownTime)) as String
                label.font = titleLabel?.font
                label.textColor = titleColorForState(.Disabled)
                createTimer()
            }
        }
    }
    
    private var timer : NSTimer?
    private var label = UILabel()
    
    private func disableTimer() {
        timer?.invalidate()
        timer = nil
        lastTime = 0
    }
    private func createTimer() {
        disableTimer()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(YBPhoneCodeButton.timerFire), userInfo: nil, repeats: true)
        lastTime = NSDate().timeIntervalSince1970
    }
    
    private var lastTime : NSTimeInterval = 0
    dynamic private func timerFire() {
        let timeCurrent = Int64(NSDate().timeIntervalSince1970)
        let delta = timeCurrent - Int64(lastTime)
        let remainTime = max(Int64(countdownTime)-delta,0)
        label.text = NSString(format: countdownFormat, remainTime) as String
        if remainTime <= 0 {
            btnState = .Normal
        }

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        label.hidden = true
        label.textAlignment = .Center
        label.useAutoLayout()
        addSubview(label)
        NSLayoutConstraint.equalSize(100, views: self, label)
        NSLayoutConstraint.alignCenter(self, secondView: label)
        setTitle("", forState: .Disabled)
    }
    
    override func intrinsicContentSize() -> CGSize {
        let selfSize = super.intrinsicContentSize()
        let labelSize = label.intrinsicContentSize()
        return CGSizeMake(max(selfSize.width, labelSize.width), max(selfSize.height, labelSize.height))
    }
}
