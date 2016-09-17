//
//  MBProgressHUD+Extension.h
//  Demo
//
//  Created by 周少文 on 16/8/20.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Extension)

+ (MBProgressHUD *)showSuccessHUDWithMessage:(NSString *)message toView:(UIView *)view;

+ (MBProgressHUD *)showErrorHUDWithMessage:(NSString *)message toView:(UIView *)view;


@end
