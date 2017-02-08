//
//  CommonUtil.h
//  SXT
//
//  Created by Huang Yirong on 15/6/22.
//  Copyright (c) 2015年 ringsea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtil : NSObject

+ (NSString *)md5:(NSString *)input;

+ (NSString *)sha1:(NSString *)input;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSDictionary *)getIPAddresses;

@end
