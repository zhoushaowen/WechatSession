//
//  MyTableViewCell.m
//  Demo
//
//  Created by 周少文 on 16/8/19.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "MyTableViewCell.h"
#import "PictureCollectionView.h"
#import "CommentTableView.h"
#import "Masonry.h"
#import "ListModel.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "NSURL+Extension.h"

#define Margin 5

@interface MyTableViewCell ()

@property (nonatomic,strong) UIImageView *headerImgV;
@property (nonatomic,strong) UILabel *nicknameLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong) PictureCollectionView *collectionView;
@property (nonatomic,strong) CommentTableView *tableView;

@end

@implementation MyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headerImgV = [[UIImageView alloc] init];
    [self.contentView addSubview:_headerImgV];
    _headerImgV.contentMode = UIViewContentModeScaleAspectFill;
    _headerImgV.clipsToBounds = YES;
    [_headerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(50);
    }];
    
    self.nicknameLab = [[UILabel alloc] init];
    _nicknameLab.textColor = [UIColor orangeColor];
    [self.contentView addSubview:_nicknameLab];
    [_nicknameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headerImgV.mas_right).offset(10);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_headerImgV);
        make.height.mas_equalTo(ceil(_nicknameLab.font.lineHeight));
    }];
    
    self.contentLab = [[UILabel alloc] init];
    _contentLab.numberOfLines = 0;
    [self.contentView addSubview:_contentLab];
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nicknameLab);
        make.top.mas_equalTo(_nicknameLab.mas_bottom).offset(10);
    }];
    _contentLab.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 75 - 15;
    
//    self.expandBtn = [MyButton buttonWithType:UIButtonTypeSystem];
//    [_expandBtn setTitle:@"全文" forState:UIControlStateNormal];
//    [self.contentView addSubview:_expandBtn];
//    [_expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(_contentLab);
//        make.top.mas_equalTo(_contentLab.mas_bottom).offset(10);
//        make.height.mas_equalTo(ceil(_expandBtn.titleLabel.font.lineHeight));
//    }];
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.minimumLineSpacing = Margin;
    self.flowLayout.minimumInteritemSpacing = Margin;
    self.flowLayout.itemSize = CGSizeMake(90, 90);
    self.collectionView = [[PictureCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.scrollEnabled = false;
    [self.contentView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contentLab);
//        make.top.mas_equalTo(_contentLab.mas_bottom).offset(10*2+ceil(_expandBtn.titleLabel.font.lineHeight));
        make.top.mas_equalTo(_contentLab.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    self.tableView = [[CommentTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.scrollEnabled = false;
    [self.contentView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contentLab);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_collectionView.mas_bottom).offset(10);
    }];
    //添加一个点我按钮
    self.clickMeBtn = [MyButton buttonWithType:UIButtonTypeCustom];
    [_clickMeBtn setTitle:@"点我" forState:UIControlStateNormal];
    [_clickMeBtn setBackgroundColor:[UIColor redColor]];
    [self.contentView addSubview:_clickMeBtn];
    [_clickMeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(5);
    }];
        
}

- (void)setListModel:(ListModel *)listModel
{
    _listModel = listModel;
    [_headerImgV sd_setImageWithURL:[NSURL createUrlWithString:listModel.userHeadImageUrl] placeholderImage:nil];
    _nicknameLab.text = listModel.userNickName;
    _contentLab.text = listModel.discussContent;
//    [self updateContentLab];
    _collectionView.array = listModel.pictureUrls;
    [self calculateSizeCompletion:^(CGSize itemSize, CGSize collectionViewSize) {
        if(!CGSizeEqualToSize(itemSize, CGSizeZero))
        {
            self.flowLayout.itemSize = itemSize;
        }
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(collectionViewSize);
        }];
        [_collectionView reloadData];
    }];
    _tableView.array = listModel.modelArray;
    CGFloat height = [_tableView getTotalRowHeight];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    [_tableView reloadData];
    
}

//- (void)updateContentLab
//{
//    CGFloat labHeight = [self getContentLabHeight];
//    if(!self.listModel.isExpand)
//    {
//        [_expandBtn setTitle:@"展开" forState:UIControlStateNormal];
//        if(labHeight>50)
//        {
//            _expandBtn.hidden = NO;
//            [_contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(50);
//            }];
//            [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(_contentLab.mas_bottom).offset(10*2+ceil(_expandBtn.titleLabel.font.lineHeight));
//            }];
//            
//        }else{
//            _expandBtn.hidden = YES;
//            [_contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(labHeight);
//            }];
//            [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(_contentLab.mas_bottom).offset(10);
//            }];
//        }
//
//    }else{
//        [_expandBtn setTitle:@"收起" forState:UIControlStateNormal];
//        _expandBtn.hidden = NO;
//        [_contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(labHeight);
//        }];
//        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_contentLab.mas_bottom).offset(10*2+ceil(_expandBtn.titleLabel.font.lineHeight));
//        }];
//
//    }
//}

//- (CGFloat)getContentLabHeight
//{
//    CGRect rect = [_contentLab.text boundingRectWithSize:CGSizeMake(_contentLab.preferredMaxLayoutWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_contentLab.font} context:nil];
//    return ceil(rect.size.height);
//}

//计算collectionView的大小和flowLayout的item大小
- (void)calculateSizeCompletion:(void(^)(CGSize itemSize,CGSize collectionViewSize))complete
{
    if(!complete)
        return;
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 90;
    CGFloat width = floor((maxWidth-Margin*2)/3.0f);
    CGFloat height = width;
    if(_collectionView.array.count == 0)
    {
        return complete(CGSizeZero,CGSizeZero);
    }
    if(_collectionView.array.count == 1)
    {
        NSLog(@"%@",_collectionView.array.firstObject.absoluteString);
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_collectionView.array.firstObject.absoluteString];
        if(image.size.width>150)
        {
            CGFloat scale = image.size.height/image.size.width;
            CGFloat pictureHeight = scale * 150;
            return complete(CGSizeMake(150, pictureHeight),CGSizeMake(150, pictureHeight));
        }
        
        return complete(image.size,image.size);
    }
    if(_collectionView.array.count == 2)
    {
        return complete(CGSizeMake(width, height),CGSizeMake(width*2+Margin, height));
    }
    
    if(_collectionView.array.count == 3)
    {
        return complete(CGSizeMake(width, height),CGSizeMake(width*3+2*Margin, height));
    }
    if(_collectionView.array.count == 4)
    {
        return complete(CGSizeMake(width, height),CGSizeMake(width*2+Margin, height*2+Margin));
    }
    if(_collectionView.array.count == 5)
    {
        return complete(CGSizeMake(width, height),CGSizeMake(width*3+2*Margin, height*2+Margin));
    }
    if(_collectionView.array.count == 6)
    {
        return complete(CGSizeMake(width, height),CGSizeMake(width*3+2*Margin, height*2+Margin));
    }
}
//计算行高
- (CGFloat)calculateRowHeightWithModel:(ListModel *)model
{
    self.listModel = model;
    [self layoutIfNeeded];
    if(_tableView.frame.size.height == 0)
    {
        return CGRectGetMaxY(_tableView.frame);

    }else{
        return CGRectGetMaxY(_tableView.frame) + 10;
    }
}








@end
