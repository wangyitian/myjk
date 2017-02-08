//
//  UIColor+Additions.m
//  SeMob
//
//  Created by zheng zhang on 4/26/12.
//  Copyright (c) 2012 sogou-inc. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (UIColor_Additions)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return nil;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0x"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return nil;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}


+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    return [self colorWithHexString:stringToConvert alpha:1.0];
}

+ (UIColor *)colorWithHex:(uint) hex
{
	int red, green, blue, alpha;

	blue = hex & 0x000000FF;
	green = ((hex & 0x0000FF00) >> 8);
	red = ((hex & 0x00FF0000) >> 16);
	alpha = ((hex & 0xFF000000) >> 24);

	return [UIColor colorWithRed:red/255.0f
						   green:green/255.0f
							blue:blue/255.0f
						   alpha:alpha/255.f];
}

+ (UIColor *)colorWithHex:(uint) hex andAlpha:(float) alpha
{
	int red, green, blue;

	blue = hex & 0x000000FF;
	green = ((hex & 0x0000FF00) >> 8);
	red = ((hex & 0x00FF0000) >> 16);

	return [UIColor colorWithRed:red/255.0f
						   green:green/255.0f
							blue:blue/255.0f
						   alpha:alpha];
}

+ (UIColor *)colorARGBWithHexString:(NSString*)hexString
{
    NSString* hex=[hexString lowercaseString];
    if (![hex hasPrefix:@"0x"]) {
        hex=[@"0x" stringByAppendingString:hex];
    }
    uint hexColor;
    if (![[NSScanner scannerWithString:hex] scanHexInt:&hexColor]) {
        return nil;
    }
    return [UIColor colorWithHex:hexColor];
}

+ (UIColor *)mergeTwoColor:(uint)colorDown upColor:(uint)colorUp
{
    uint A1=((colorUp & 0xff000000) >> 24);
    uint R1=(colorUp & 0x00ff0000) >> 16;
    uint G1=(colorUp & 0x0000ff00) >> 8;
    uint B1=(colorUp & 0x000000ff);
    uint A2=((colorDown & 0xff000000) >> 24);
    uint R2=(colorDown & 0x00ff0000) >> 16;
    uint G2=(colorDown & 0x0000ff00) >> 8;
    uint B2=(colorDown & 0x000000ff);
    uint A= 255 - (255 - A1) * (255 - A2)/255;
    uint R= (R1 * A1*255 + R2 * A2 * (255 - A1))/(255*255);
    uint G= (G1 * A1*255 + G2 * A2 * (255 - A1))/(255*255);
    uint B= (B1 * A1*255 + B2 * A2 * (255 - A1))/(255*255);
    return [UIColor colorWithRed:R/255.0f
						   green:G/255.0f
							blue:B/255.0f
						   alpha:A/255.0f];
}
@end

//@implementation UIImage (color)
//
//+ (UIImage *)imageWithColor:(UIColor *)color {
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return image;
//}

//@end
