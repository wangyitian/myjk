//
//  KeyboardScrollable.swift
//  AmericanMedical
//
//  Created by yb on 16/1/19.
//  Copyright © 2016年 yb. All rights reserved.
//

import UIKit

protocol KeyboardScrollable {
    var keyboardScrollView : UIScrollView! {get}
    
    func setUpKeyboardScrollable()
}

private class KeyboardScrollableNotificationReceiver {
    weak var parent : protocol<NSObjectProtocol, KeyboardScrollable>?
    dynamic func keyBoardDidShow(notification : NSNotification) {
        guard let scrollView = parent?.keyboardScrollView, userInfo = notification.userInfo, kbFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let frame = kbFrame.CGRectValue()
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, frame.height, 0)
    }
    dynamic func keyBoardDidHide(notification : NSNotification) {
        guard let scrollView = parent?.keyboardScrollView else {
            return
        }
        scrollView.contentInset = UIEdgeInsetsZero
    }
}

private var ReceiverAssociateKey = "KeyboardScrollableNotificationReceiver"

extension KeyboardScrollable where Self : NSObject {
    func setUpKeyboardScrollable() {
        let receiver = KeyboardScrollableNotificationReceiver()
        receiver.parent = self
        objc_setAssociatedObject(self, &ReceiverAssociateKey, receiver, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        keyboardScrollView.keyboardDismissMode = .Interactive
        NSNotificationCenter.defaultCenter().addObserver(receiver, selector: "keyBoardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(receiver, selector: "keyBoardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func disableKeyboardScrollable() {
        let receiver = objc_getAssociatedObject(self, &ReceiverAssociateKey)
        if receiver != nil {
            NSNotificationCenter.defaultCenter().removeObserver(receiver)
        }
        objc_setAssociatedObject(self, ReceiverAssociateKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        keyboardScrollView.contentInset = UIEdgeInsetsZero
    }
    
}