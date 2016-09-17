//
//  ListModel.m
//  Demo
//
//  Created by 周少文 on 16/8/19.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "ListModel.h"
#import "NSURL+Extension.h"

@implementation ListModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if(self)
    {
        NSMutableArray *mutableArr = [NSMutableArray array];
        if(self.discussPic1.length>0)
        {
            [mutableArr addObject:[NSURL createUrlWithString:self.discussPic1]];
        }
        if(self.discussPic2.length>0)
        {
            [mutableArr addObject:[NSURL createUrlWithString:self.discussPic2]];
        }
        if(self.discussPic3.length>0)
        {
            [mutableArr addObject:[NSURL createUrlWithString:self.discussPic3]];
        }
        if(self.discussPic4.length>0)
        {
            [mutableArr addObject:[NSURL createUrlWithString:self.discussPic4]];
        }
        if(self.discussPic5.length>0)
        {
            [mutableArr addObject:[NSURL createUrlWithString:self.discussPic5]];
        }
        if(self.discussPic6.length>0)
        {
            [mutableArr addObject:[NSURL createUrlWithString:self.discussPic6]];
        }
        self.pictureUrls = mutableArr;

    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"discussCommentList"])
    {
        if([value isKindOfClass:[NSArray class]])
        {
            NSMutableArray *mutableArr = [NSMutableArray array];
            [value enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DiscussCommentListModel *model = [[DiscussCommentListModel alloc] initWithDictionary:obj];
                [mutableArr addObject:model];
            }];
            self.modelArray = mutableArr;
        }
        return;
    }
    
    return [super setValue:value forKey:key];
}

@end
