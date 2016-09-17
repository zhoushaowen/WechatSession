//
//  SWPhotoBrowerController.m
//  Demo
//
//  Created by 周少文 on 16/8/20.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "SWPhotoBrowerController.h"
#import "SWPhotoBrowerCell.h"
#import "SDImageCache.h"

@interface SWPhotoBrowerController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    BOOL _hideStatusBar;
    BOOL _isPresented;
    BOOL _flag;
    UIImageView *_originalImageView;//用来保存小图
}

@property (nonatomic,strong) UIImageView *tempImageView;


@end

@implementation SWPhotoBrowerController

- (instancetype)initWithIndex:(NSInteger)index delegate:(id<SWPhotoBrowerControllerDelegate>)delegate normalImageUrls:(NSArray<NSURL *> *)normalImageUrls bigImageUrls:(NSArray<NSURL *> *)bigImageUrls
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        self.delegate = delegate;
        _index = index;
        _normalImageUrls = normalImageUrls;
        _bigImageUrls = bigImageUrls ? bigImageUrls : normalImageUrls;
        
        NSAssert(_delegate != nil, @"delegate不能为空");
        NSAssert([_delegate respondsToSelector:@selector(photoBrowerControllerOriginalImageView:withIndex:)], @"photoBrowerControllerOriginalImageView:withIndex:代理方法必须实现");
        //获取小图
        _originalImageView =  [_delegate photoBrowerControllerOriginalImageView:self withIndex:self.index];
        _normalImageViewSize = _originalImageView.frame.size;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _hideStatusBar = YES;
    //更新状态栏
    [self setNeedsStatusBarAppearanceUpdate];
    if(_isPresented)
        return;
    _isPresented = YES;
    [self photoBrowerWillShow];

}

- (void)setupUI
{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flow];
    flow.minimumLineSpacing = 0;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    //一开始先隐藏浏览器,做法放大动画再显示
    _collectionView.hidden = YES;
    [_collectionView registerClass:[SWPhotoBrowerCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(_flag)
        return;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
    _flag = YES;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.bigImageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWPhotoBrowerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.browerVC = self;
    //先设置小图
    cell.normalImageUrl = self.normalImageUrls[indexPath.row];
    //后设置大图
    cell.bigImageUrl = self.bigImageUrls[indexPath.row];
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSInteger index = ABS(targetContentOffset->x/[UIScreen mainScreen].bounds.size.width);
    UIImageView *imageView = [_delegate photoBrowerControllerOriginalImageView:self withIndex:index];
    _normalImageViewSize = imageView.frame.size;
    NSLog(@"%@",NSStringFromCGSize(_normalImageViewSize));
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return _hideStatusBar;
}

//用于创建一个和当前点击图片一模一样的imageView
- (UIImageView *)tempImageView
{
    if(!_tempImageView)
    {
        _tempImageView = [[UIImageView alloc] init];
        _tempImageView.contentMode = UIViewContentModeScaleAspectFill;
        _tempImageView.clipsToBounds = YES;
    }
    
    return _tempImageView;
}

- (void)photoBrowerWillShow
{
    NSURL *imageUrl = _bigImageUrls[_index];
    //从缓存中获取大图
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl.absoluteString];
    if(image)//有大图直接做动画
    {
        //获取转换之后的坐标
        CGRect convertFrame = [_originalImageView.superview convertRect:_originalImageView.frame toCoordinateSpace:[UIScreen mainScreen].coordinateSpace];
        self.tempImageView.frame = convertFrame;
        self.tempImageView.image = image;
        [self.view addSubview:self.tempImageView];
        //计算临时图片放大之后的frame
        CGRect toFrame = [self getTempImageViewFrameWithImage:image];
        self.view.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.35f animations:^{
            self.tempImageView.frame = toFrame;
            self.view.backgroundColor = [UIColor blackColor];
        } completion:^(BOOL finished) {
            self.view.userInteractionEnabled = YES;
            //移除图片
            [self.tempImageView removeFromSuperview];
            //显示图片浏览器
            _collectionView.hidden = NO;
        }];

    }else{//不做动画
        _collectionView.hidden = NO;
    }
}

- (void)photoBrowerWillHide
{
    //获取当前屏幕可见cell的indexPath
    NSIndexPath *visibleIndexPath = _collectionView.indexPathsForVisibleItems.lastObject;
    _index = visibleIndexPath.row;
    if(_delegate && [_delegate respondsToSelector:@selector(photoBrowerControllerWillHide:withIndex:)])
    {
        [_delegate photoBrowerControllerWillHide:self withIndex:_index];
    }
    SWPhotoBrowerCell *cell = (SWPhotoBrowerCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:0]];
    self.tempImageView.image = cell.imagView.image;
    CGRect fromRect = [cell.imagView.superview convertRect:cell.imagView.frame toCoordinateSpace:[UIScreen mainScreen].coordinateSpace];
    self.tempImageView.frame = fromRect;
    _collectionView.hidden = YES;
    [self.view addSubview:self.tempImageView];
    UIImageView *imageView = [_delegate photoBrowerControllerOriginalImageView:self withIndex:_index];
    _normalImageViewSize = imageView.frame.size;
    CGRect convertFrame = [imageView.superview convertRect:imageView.frame toCoordinateSpace:[UIScreen mainScreen].coordinateSpace];
    self.view.userInteractionEnabled = NO;
    [_collectionView removeFromSuperview];
    [UIView animateWithDuration:0.35f animations:^{
        self.tempImageView.frame = convertFrame;
        self.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];

}

- (CGRect)getTempImageViewFrameWithImage:(UIImage *)image
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat scale = image.size.height/image.size.width;
    CGFloat imageHeight = screenWidth*scale;
    CGFloat inset = 0;
    if(imageHeight<screenHeight)
    {
        inset = (screenHeight - imageHeight)*0.5f;
    }
    return CGRectMake(0, inset, screenWidth, imageHeight);
}




@end
