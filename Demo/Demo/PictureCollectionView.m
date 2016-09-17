//
//  PictureCollectionView.m
//  Demo
//
//  Created by 周少文 on 16/8/19.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "PictureCollectionView.h"
#import "PictureCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "SWPhotoBrowerController.h"

NSString *const PictureCollectionViewDidSelectedNotificaton = @"PictureCollectionViewDidSelectedNotificaton";

@interface PictureCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,SWPhotoBrowerControllerDelegate>

@end

@implementation PictureCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if(self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[PictureCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
    }
    
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSURL *url = self.array[indexPath.row];
    [cell.imgV sd_setImageWithURL:url placeholderImage:nil];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:PictureCollectionViewDidSelectedNotificaton object:self userInfo:@{@"urls":self.array,@"indexPath":indexPath}];
}

#pragma mark - SWPhotoBrowerControllerDelegate
- (UIImageView *)photoBrowerControllerOriginalImageView:(SWPhotoBrowerController *)browerController withIndex:(NSInteger)index
{
    PictureCollectionViewCell *cell = (PictureCollectionViewCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return cell.imgV;
}



@end
