//
//  PictureCollectionViewCell.m
//  Demo
//
//  Created by 周少文 on 16/8/19.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "PictureCollectionViewCell.h"
#import "Masonry.h"

@implementation PictureCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.imgV = [[UIImageView alloc] initWithFrame:self.bounds];
        _imgV.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.clipsToBounds = YES;
        _imgV.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_imgV];
    }
    
    return self;
}

@end
