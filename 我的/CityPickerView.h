//
//  CityPickerView.h
//  AmericanMedical
//
//  Created by 王翼天 on 2017/2/10.
//  Copyright © 2017年 yb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CancelBlock)();
typedef void(^ConfirmBlock)(NSString *selectedCity);
@interface CityPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, copy) CancelBlock cancelBlock;
@property (nonatomic, copy) ConfirmBlock confirmBlock;
@property (nonatomic, strong) NSArray *siteArray;
@property (nonatomic, strong) NSString *tempSite;
@property (nonatomic, strong) NSString *tempCity;
@property (nonatomic, assign) NSInteger siteIndex;
@property (nonatomic, assign) NSInteger cityIndex;
@end
