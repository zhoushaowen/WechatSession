//
//  NSURL+Extension.m
//  Demo
//
//  Created by 周少文 on 16/8/19.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "NSURL+Extension.h"

@implementation NSURL (Extension)

+ (NSURL *)createUrlWithString:(NSString *)str
{
    NSString *string = str? str:@"";
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:string];
}

@end
