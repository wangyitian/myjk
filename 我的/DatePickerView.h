//
//  DatePickerView.h
//  AmericanMedical
//
//  Created by 王翼天 on 2017/2/10.
//  Copyright © 2017年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelBlock)();
typedef void(^ConfirmBlock)(NSString *date);

@interface DatePickerView : UIView
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, copy) CancelBlock cancelBlock;
@property (nonatomic, copy) ConfirmBlock confirmBlock;
@end
