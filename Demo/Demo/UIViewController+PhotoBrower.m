//
//  UIViewController+PhotoBrower.m
//  Demo
//
//  Created by 周少文 on 16/8/24.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "UIViewController+PhotoBrower.h"
#import "SWPhotoBrowerController.h"

@implementation UIViewController (PhotoBrower)

- (void)showBrower:(SWPhotoBrowerController *)browerController
{
    [self presentViewController:browerController animated:NO completion:nil];
}

@end
