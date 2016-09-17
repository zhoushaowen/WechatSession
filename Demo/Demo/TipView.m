//
//  TipView.m
//  Demo
//
//  Created by 周少文 on 16/8/20.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "TipView.h"
#import "Masonry.h"
#import "MyButton.h"

@implementation TipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{
    //先设置锚点,如果先设置frame再更改锚点,那么控件的位置会发生改变,必须要再设置position才可以
    self.layer.anchorPoint = CGPointMake(1, 0.5f);
    self.backgroundColor = [UIColor grayColor];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    CGFloat btnWidth = 80;
    CGFloat btnHeight = 40;
    NSArray *titles = @[@"转发",@"评论"];
    for(int i =0;i<2;i++)
    {
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(btnWidth*i, 0, btnWidth, btnHeight);
    }
}

+ (instancetype)tipView
{
    TipView *view = [[self alloc] initWithFrame:CGRectMake(0, 0, 80*2, 40)];
    return view;
}

- (void)show
{
    if(self.isShowing)
        return;
    self.userInteractionEnabled = false;
    self.transform = CGAffineTransformMakeScale(0.0, 1.0);
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        self.isShowing = YES;
    }];
}

- (void)hide
{
    if(!self.isShowing)
        return;
    self.userInteractionEnabled = false;
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 1.0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.isShowing = false;
    }];
    
}

- (void)btnClick:(UIButton *)sender
{
    [self hide];
    if(_delegate && [_delegate respondsToSelector:@selector(tipView:btnClick:)])
    {
        [_delegate tipView:self btnClick:sender];
    }
}


@end
