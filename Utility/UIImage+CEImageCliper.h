//
//  UIImage+CEImageCliper.h
//  Fang
//
//  Created by yb on 15/11/4.
//  Copyright © 2015年 wicrewoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CEImageCliper)

+ (UIImage*)createThumbImage:(UIImage *)image size:(CGSize )thumbSize;
+ (NSData *)resizeImage:(UIImage *)image maxDataSize:(uint64_t)size resizedQuality:(CGFloat *)quality;

@end
