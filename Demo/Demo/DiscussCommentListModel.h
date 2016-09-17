//
//  DiscussCommentListModel.h
//  Demo
//
//  Created by 周少文 on 16/8/19.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "BaseModel.h"

@interface DiscussCommentListModel : BaseModel

@property (nonatomic,strong) NSString *commentContent;
@property (nonatomic,strong) NSString *commentCreateTime;
@property (nonatomic,strong) NSString *commentShowTime;
@property (nonatomic,strong) NSString *dc_userHeadImageUrl;
@property (nonatomic,strong) NSString *dc_userId;
@property (nonatomic,strong) NSString *dc_userNickName;
@property (nonatomic,strong) NSNumber *discussCommentID;


@end
