//
//  UIImage+CEImageCliper.m
//  Fang
//
//  Created by yb on 15/11/4.
//  Copyright © 2015年 wicrewoft. All rights reserved.
//

#import "UIImage+CEImageCliper.h"

@implementation UIImage (CEImageCliper)

+ (UIImage*)createThumbImage:(UIImage *)image size:(CGSize )thumbSize
{
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGPoint thumbPoint = CGPointMake(0.0,0.0);
    
    CGFloat widthFactor = thumbSize.width / width;
    CGFloat heightFactor = thumbSize.height / height;
    
    if (widthFactor > heightFactor)  {
        scaleFactor = widthFactor;
    } else {
        scaleFactor = heightFactor;
    }
    
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    
    if (widthFactor > heightFactor) {
        thumbPoint.y = (thumbSize.height - scaledHeight) * 0.5;
    }
    
    else if (widthFactor < heightFactor) {
        thumbPoint.x = (thumbSize.width - scaledWidth) * 0.5;
    }
    
    UIGraphicsBeginImageContext(thumbSize);
    CGRect thumbRect = CGRectZero;
    thumbRect.origin = thumbPoint;
    thumbRect.size.width  = scaledWidth;
    thumbRect.size.height = scaledHeight;
    [image drawInRect:thumbRect];
    
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumbImage;
}

+ (NSData *)resizeImage:(UIImage *)image maxDataSize:(uint64_t)size resizedQuality:(CGFloat *)quality
{
    CGFloat qualityToResize = 1.0f;
    NSData *imgData = nil;
    for (qualityToResize = 1; qualityToResize > 0; qualityToResize -= 0.1) {
        @autoreleasepool {
            imgData = UIImageJPEGRepresentation(image, qualityToResize);
            if ([imgData length] / 1024 < size) {
                imgData = imgData;
                break;
            }
        }
        // imgData now is zombie
        imgData = nil;
    }
    if(quality) *quality = qualityToResize;
    return imgData;
}

@end
