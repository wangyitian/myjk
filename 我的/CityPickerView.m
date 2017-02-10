//
//  CityPickerView.m
//  AmericanMedical
//
//  Created by 王翼天 on 2017/2/10.
//  Copyright © 2017年 yb. All rights reserved.
//

#import "CityPickerView.h"

@implementation CityPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil];
        self.siteArray = [NSArray arrayWithContentsOfFile:path];
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
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, self.bounds.size.width, 194)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self addSubview:self.pickerView];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.siteArray.count;
    } else {
        return [self.siteArray[self.siteIndex][@"cities"] count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.siteArray[row] objectForKey:@"state"];
    } else {
        return self.siteArray[self.siteIndex][@"cities"][row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.siteIndex = row;
    } else {
        self.cityIndex = row;
    }
    [pickerView reloadAllComponents];
}

- (void)cancel {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)confirm {
    if (self.confirmBlock) {
        NSString *cityStr = [NSString stringWithFormat:@"%@ %@",self.siteArray[self.siteIndex][@"state"],self.siteArray[self.siteIndex][@"cities"][self.cityIndex]];
        self.confirmBlock(cityStr);
    }
}

@end
