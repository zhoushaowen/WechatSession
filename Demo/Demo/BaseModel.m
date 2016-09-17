



//
//  BaseModel.m
//  Demo
//
//  Created by 周少文 on 16/8/19.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if(self)
    {
        if([dic isKindOfClass:[NSDictionary class]])
        {
            [self setValuesForKeysWithDictionary:dic];
        }
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
