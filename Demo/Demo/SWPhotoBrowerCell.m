//
//  SWPhotoBrowerCell.m
//  Demo
//
//  Created by 周少文 on 16/8/20.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "SWPhotoBrowerCell.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Extension.h"
#import "SWPhotoBrowerController.h"
#import "SWProgressView.h"

@interface SWPhotoBrowerCell ()<UIScrollViewDelegate>

@property (nonatomic,strong) SWProgressView *progressView;

@end

@implementation SWPhotoBrowerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imagView];
    }
    
    return self;
}

- (UIScrollView *)scrollView
{
    if(!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = [UIScreen mainScreen].bounds;
        _scrollView.delegate = self;
        //单击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        singleTap.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:singleTap];
        //双击
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        //添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [_scrollView addGestureRecognizer:longPress];
    }
    
    return _scrollView;
}

- (UIImageView *)imagView
{
    if(!_imagView)
    {
        _imagView = [[UIImageView alloc] init];
        [_imagView addSubview:self.progressView];
        self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
        [_imagView addConstraint:[NSLayoutConstraint constraintWithItem:_imagView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.progressView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
        [_imagView addConstraint:[NSLayoutConstraint constraintWithItem:_imagView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.progressView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
        [_imagView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_progressView(w)]" options:0 metrics:@{@"w":@(self.progressView.frame.size.width)} views:NSDictionaryOfVariableBindings(_progressView)]];
        [_imagView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_progressView(h)]" options:0 metrics:@{@"h":@(self.progressView.frame.size.height)} views:NSDictionaryOfVariableBindings(_progressView)]];
    }
    
    return _imagView;
}

- (SWProgressView *)progressView
{
    if(!_progressView)
    {
        _progressView = [SWProgressView progressView];
    }
    
    return _progressView;
}

- (void)setNormalImageUrl:(NSURL *)normalImageUrl
{
    _normalImageUrl = normalImageUrl;
    self.scrollView.zoomScale = 1.0f;
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:normalImageUrl.absoluteString];
    self.imagView.image = image;
    CGSize size = _browerVC.normalImageViewSize;
    CGFloat offX = ([UIScreen mainScreen].bounds.size.width - size.width)*0.5f;
    offX = offX<0 ? 0 : offX;
    CGFloat offY = ([UIScreen mainScreen].bounds.size.height - size.height)*0.5f;
    offY = offY<0 ? 0: offY;
    self.imagView.frame = CGRectMake(0, 0, size.width, size.height);
    self.scrollView.contentInset = UIEdgeInsetsMake(offY, offX, offY, offX);
    self.scrollView.contentSize = size;
}

- (void)setBigImageUrl:(NSURL *)bigImageUrl
{
    _bigImageUrl = bigImageUrl;
    //先关闭缩放
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.minimumZoomScale = 1.0f;
    //从缓存中取大图
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:bigImageUrl.absoluteString];
    if(image)
    {
        [self adjustImageViewWithImage:image animated:NO];
        //开启
        self.scrollView.maximumZoomScale = 2.0f;
        self.scrollView.minimumZoomScale = 0.5f;
    }else{
        [[SDWebImageManager sharedManager] downloadImageWithURL:bigImageUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            CGFloat proress = receivedSize*1.0f/expectedSize*1.0f;
            NSLog(@"%f",proress);
            self.progressView.progress = proress;
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if(error)
                return;
            self.scrollView.maximumZoomScale = 2.0f;
            self.scrollView.minimumZoomScale = 0.5f;
            [self adjustImageViewWithImage:image animated:YES];

        }];
    }

}

//调整图片尺寸
- (void)adjustImageViewWithImage:(UIImage *)image animated:(BOOL)animated
{
    self.imagView.image = image;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat scale = image.size.height/image.size.width;
    CGFloat imageHeight = screenWidth*scale;
    if(animated)
    {
        [UIView animateWithDuration:0.25f animations:^{
            self.imagView.frame = CGRectMake(0, 0, screenWidth, imageHeight);
        } completion:nil];
        
    }else{
        self.imagView.frame = CGRectMake(0, 0, screenWidth, imageHeight);
    }
    if(imageHeight>screenHeight)
    {
        //长图
        self.scrollView.contentInset = UIEdgeInsetsZero;
    }else{
        //短图
        CGFloat inset = (screenHeight - imageHeight) * 0.5f;
        self.scrollView.contentInset = UIEdgeInsetsMake(inset, 0, inset, 0);
    }
    self.scrollView.contentSize = CGSizeMake(screenWidth, imageHeight);

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imagView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat offX = (screenWidth - self.imagView.frame.size.width)*0.5;
    CGFloat offY = (screenHeight - self.imagView.frame.size.height)*0.5;
    
    offX = offX<0 ? 0:offX;
    offY = offY<0 ? 0:offY;
    self.scrollView.contentInset = UIEdgeInsetsMake(offY, offX, offY, offX);
}

- (void)doubleTap:(UITapGestureRecognizer *)gesture
{
    if(self.scrollView.zoomScale == 1.0f)
    {
        CGPoint point = [gesture locationInView:self.imagView];
        [self.scrollView zoomToRect:CGRectMake(point.x, point.y, 1, 1) animated:YES];

    }else{
        [self.scrollView setZoomScale:1.0f animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)gesture
{
    [_browerVC photoBrowerWillHide];
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(self.imagView.image)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImageWriteToSavedPhotosAlbum(self.imagView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            });
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self.browerVC presentViewController:alert animated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error)
    {
        NSLog(@"保存失败");
        [MBProgressHUD showErrorHUDWithMessage:@"保存失败" toView:self.browerVC.view];
    }else{
        NSLog(@"保存成功");
        [MBProgressHUD showSuccessHUDWithMessage:@"保存成功" toView:self.browerVC.view];
    }
}




@end
