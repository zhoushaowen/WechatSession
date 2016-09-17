//
//  MyButton.m
//  Demo
//
//  Created by 周少文 on 16/8/19.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    CGFloat width = MAX(44.0f-bounds.size.width, 0);
    CGFloat height = MAX(44.0f-bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5f*width, -0.5f*height);
    return CGRectContainsPoint(bounds, point);
}

@end
