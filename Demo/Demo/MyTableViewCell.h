//
//  MyTableViewCell.h
//  Demo
//
//  Created by 周少文 on 16/8/19.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"

@class ListModel;

@interface MyTableViewCell : UITableViewCell

//@property (nonatomic,strong) MyButton *expandBtn;

@property (nonatomic,strong) MyButton *clickMeBtn;

@property (nonatomic,strong) ListModel *listModel;

- (CGFloat)calculateRowHeightWithModel:(ListModel *)model;

@end
