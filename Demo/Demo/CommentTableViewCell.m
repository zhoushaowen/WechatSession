//
//  CommentTableViewCell.m
//  Demo
//
//  Created by 周少文 on 16/8/19.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "DiscussCommentListModel.h"
#import "Masonry.h"

@interface CommentTableViewCell ()

@property (nonatomic,strong) UILabel *contentLab;

@end

@implementation CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.contentLab = [[UILabel alloc] init];
        _contentLab.numberOfLines = 0;
        [self.contentView addSubview:_contentLab];
        [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        _contentLab.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 75 - 15;
    }
    
    return self;
}

- (void)setModel:(DiscussCommentListModel *)model
{
    _model = model;
    _contentLab.text = model.commentContent;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",model.dc_userNickName,model.commentContent]];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[attributeStr.string rangeOfString:[model.dc_userNickName stringByAppendingString:@":"]]];
    _contentLab.attributedText = attributeStr;
}

- (CGFloat)calculateRowHeightWithModel:(DiscussCommentListModel *)model
{
    self.model = model;
    [self layoutIfNeeded];
    CGFloat height = CGRectGetMaxY(_contentLab.frame) + 1;
    return height;
}



@end
