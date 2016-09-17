//
//  ListModel.h
//  Demo
//
//  Created by 周少文 on 16/8/19.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "BaseModel.h"
#import "DiscussCommentListModel.h"

@interface ListModel : BaseModel

@property (nonatomic,strong) NSString *discussContent;
@property (nonatomic,strong) NSString *discussCreateTime;
@property (nonatomic,strong) NSNumber *discussID;
@property (nonatomic,strong) NSString *discussPic1;
@property (nonatomic,strong) NSString *discussPic2;
@property (nonatomic,strong) NSString *discussPic3;
@property (nonatomic,strong) NSString *discussPic4;
@property (nonatomic,strong) NSString *discussPic5;
@property (nonatomic,strong) NSString *discussPic6;
@property (nonatomic,strong) NSString *discussShow;
@property (nonatomic,strong) NSString *discussShowTime;
@property (nonatomic,strong) NSString *discussStatus;
@property (nonatomic,strong) NSString *discussTitle;
@property (nonatomic,strong) NSString *discussUrl;
@property (nonatomic,strong) NSString *discussUuid;
@property (nonatomic,strong) NSString *userHeadImageUrl;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *userLevel;
@property (nonatomic,strong) NSString *userNickName;
@property (nonatomic,strong) NSArray *discussCommentList;
@property (nonatomic,strong) NSArray<DiscussCommentListModel *> *modelArray;
@property (nonatomic,strong) NSArray<NSString *> *picArray;
@property (nonatomic) BOOL isExpand;
@property (nonatomic,strong) NSArray<NSURL *> *pictureUrls;

@end
