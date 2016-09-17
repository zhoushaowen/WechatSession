//
//  CommentTableView.h
//  Demo
//
//  Created by 周少文 on 16/8/19.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscussCommentListModel;

@interface CommentTableView : UITableView

@property (nonatomic,strong) NSArray<DiscussCommentListModel *> *array;

- (CGFloat)getTotalRowHeight;

@end
