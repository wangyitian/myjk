//
//  GradientColorView.m
//  Mallike
//
//  Created by yb on 15/10/20.
//  Copyright © 2015年 Mallike. All rights reserved.
//

#import "GradientColorView.h"

@implementation GradientColorView

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(!(_startColor && _endColor)){
        return;
    }
    if (!_layer) {
        _layer = [CAGradientLayer layer];
    }
    _layer.frame = self.bounds;
    _layer.colors = [NSArray arrayWithObjects:(id)[_startColor CGColor], (id)[_endColor CGColor], nil];
    [self.layer insertSublayer:_layer atIndex:0];
}


@end
