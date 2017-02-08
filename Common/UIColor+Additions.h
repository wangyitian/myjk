//
//  UIColor+Additions.h
//  SeMob
//
//  Created by zheng zhang on 4/26/12.
//  Copyright (c) 2012 sogou-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UIColor_Additions)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorARGBWithHexString:(NSString*)hexString;
+ (UIColor *)colorWithHex:(uint) hex;
+ (UIColor *)colorWithHex:(uint) hex andAlpha:(float) alpha;
+ (UIColor *)mergeTwoColor:(uint)colorDown upColor:(uint)colorUp;
@end

//@interface UIImage (color)
//
//+ (UIImage *)imageWithColor:(UIColor *)color;
//
//@end
