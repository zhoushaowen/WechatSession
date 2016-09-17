//
//  CommentTableView.m
//  Demo
//
//  Created by 周少文 on 16/8/19.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentTableViewCell.h"
#import "DiscussCommentListModel.h"

@interface CommentTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat _totalRowHeight;
}
@property (nonatomic,strong) NSCache *rowHeightCache;

@end

@implementation CommentTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if(self)
    {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.scrollEnabled = false;
        [self registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    DiscussCommentListModel *model = self.array[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscussCommentListModel *model = self.array[indexPath.row];
    NSString *key = model.discussCommentID.stringValue;
    NSNumber *value = [self.rowHeightCache objectForKey:key];
    if(value)
    {
        return [value floatValue];
    }
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    CGFloat height = [cell calculateRowHeightWithModel:model];
    [self.rowHeightCache setObject:@(height) forKey:key];
    return height;
}

- (CGFloat)getTotalRowHeight
{
    _totalRowHeight = 0;
    for (DiscussCommentListModel *model in self.array) {
        CommentTableViewCell *cell = [self dequeueReusableCellWithIdentifier:@"cell"];
        CGFloat height = [cell calculateRowHeightWithModel:model];
        _totalRowHeight += height;
        NSString *key = model.discussCommentID.stringValue;
        [self.rowHeightCache setObject:@(height) forKey:key];
    }
    return _totalRowHeight;
}

- (NSCache *)rowHeightCache
{
    if(!_rowHeightCache)
    {
        _rowHeightCache = [[NSCache alloc] init];
    }
    
    return _rowHeightCache;
}









@end
