//
//  TipView.h
//  Demo
//
//  Created by 周少文 on 16/8/20.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TipView;


typedef NS_ENUM(NSUInteger, TipViewButtonType) {
    TipViewButtonTypeForward,//转发
    TipViewButtonTypeComment,//评论
};

@protocol TipViewDelegate <NSObject>
//点击转发或者评论按钮代理方法
- (void)tipView:(TipView *)tipView btnClick:(UIButton *)btn;

@end


@interface TipView : UIView

@property (nonatomic,weak) id<TipViewDelegate> delegate;

@property (nonatomic) BOOL isShowing;//记录是否正在显示

+ (instancetype)tipView;

//显示
- (void)show;
//隐藏
- (void)hide;

@end
