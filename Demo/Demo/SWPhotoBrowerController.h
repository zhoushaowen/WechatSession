//
//  SWPhotoBrowerController.h
//  Demo
//
//  Created by 周少文 on 16/8/20.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+PhotoBrower.h"

@class SWPhotoBrowerController;

@protocol SWPhotoBrowerControllerDelegate <NSObject>

@required
//获取将要缩放的小图
- (UIImageView *)photoBrowerControllerOriginalImageView:(SWPhotoBrowerController *)browerController withIndex:(NSInteger)index;
@optional
//告诉外界图片浏览器即将消失
- (void)photoBrowerControllerWillHide:(SWPhotoBrowerController *)browerController withIndex:(NSInteger)index;

@end

@interface SWPhotoBrowerController : UIViewController

@property (nonatomic,weak) id<SWPhotoBrowerControllerDelegate> delegate;
//当前图片的索引
@property (nonatomic,readonly) NSInteger index;
//小图url
@property (nonatomic,readonly,strong) NSArray<NSURL *> *normalImageUrls;
//大图url
@property (nonatomic,readonly,strong) NSArray<NSURL *> *bigImageUrls;
//小图的大小
@property (nonatomic,readonly) CGSize normalImageViewSize;
//初始化方法
- (instancetype)initWithIndex:(NSInteger)index delegate:(id<SWPhotoBrowerControllerDelegate>)delegate normalImageUrls:(NSArray<NSURL *> *)normalImageUrls bigImageUrls:(NSArray<NSURL *> *)bigImageUrls;
//执行动画缩小图片,隐藏浏览器
- (void)photoBrowerWillHide;


@end
