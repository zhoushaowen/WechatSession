//
//  MBProgressHUD+Extension.m
//  Demo
//
//  Created by 周少文 on 16/8/20.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "MBProgressHUD+Extension.h"

@implementation MBProgressHUD (Extension)

+ (MBProgressHUD *)showSuccessHUDWithMessage:(NSString *)message toView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBProgressHUD.bundle/success.png"]];
    hud.labelText = message;
    [hud hide:YES afterDelay:1];
    return hud;
}

+ (MBProgressHUD *)showErrorHUDWithMessage:(NSString *)message toView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MBProgressHUD.bundle/error.png"]];
    hud.labelText = message;
    [hud hide:YES afterDelay:1];
    return hud;
}


@end
