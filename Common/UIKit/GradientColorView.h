//
//  GradientColorView.h
//  Mallike
//
//  Created by yb on 15/10/20.
//  Copyright © 2015年 Mallike. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface GradientColorView : UIView
{
    CAGradientLayer *_layer;
}

@property (nonatomic, strong) IBInspectable UIColor *startColor;
@property (nonatomic, strong) IBInspectable UIColor *endColor;

@end
