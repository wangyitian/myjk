//
//  DatePickerView.m
//  AmericanMedical
//
//  Created by 王翼天 on 2017/2/10.
//  Copyright © 2017年 yb. All rights reserved.
//

#import "DatePickerView.h"

@implementation DatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancel.frame = CGRectMake(22, 10, 40, 20);
    cancel.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancel];
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    confirm.frame = CGRectMake(self.bounds.size.width - 55, 10, 40, 20);
    confirm.titleLabel.font = [UIFont systemFontOfSize:13];
    [confirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirm];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, self.bounds.size.width, 194)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.maximumDate = [NSDate date];
    [self addSubview:self.datePicker];
}

- (void)cancel {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)confirm {
    if (self.confirmBlock) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *date = [formatter stringFromDate:self.datePicker.date];
        self.confirmBlock(date);
    }
}

@end
