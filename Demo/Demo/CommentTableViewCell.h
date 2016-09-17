//
//  CommentTableViewCell.h
//  Demo
//
//  Created by 周少文 on 16/8/19.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscussCommentListModel;

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic,strong) DiscussCommentListModel *model;

- (CGFloat)calculateRowHeightWithModel:(DiscussCommentListModel *)model;

@end
