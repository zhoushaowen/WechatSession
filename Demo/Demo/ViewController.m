//
//  ViewController.m
//  Demo
//
//  Created by 周少文 on 16/8/19.
//  Copyright © 2016年 YiXi. All rights reserved.
//

#import "ViewController.h"
#import "SWPhotoBrowerController.h"
#import "MyTableViewCell.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "ListModel.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"
#import "TipView.h"

NSString *const ulrStr = @"http://www.isportshow.com/qtDiscuss/toQTDiscussList";

extern NSString *const PictureCollectionViewDidSelectedNotificaton;

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,TipViewDelegate>
{
    UITableView *_tableView;
    int _startPage;
    UIButton *_currentBtn;
}

@property (nonatomic,strong) NSArray<ListModel *> *array;
@property (nonatomic,strong) NSCache *rowHeightCache;
@property (nonatomic,strong) TipView *tipView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPhotoBrower:) name:PictureCollectionViewDidSelectedNotificaton object:nil];
}

- (void)refreshData
{
    _startPage = 1;
    _tableView.footer.hidden = YES;
    [[AFHTTPRequestOperationManager manager] GET:ulrStr parameters:@{@"startPage":@(_startPage),@"sizePerPage":@10} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        BOOL isOk = [responseObject[@"isOk"] boolValue];
        if(!isOk)
            return;
        NSArray *array = responseObject[@"result"];
        NSMutableArray *mutableArr = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ListModel *model = [[ListModel alloc] initWithDictionary:obj];
            [mutableArr addObject:model];
        }];
        [self cacheImages:mutableArr completion:^{
            [_tableView.header endRefreshing];
            self.array = mutableArr;
            _tableView.footer.hidden = false;
        }];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        [_tableView.header endRefreshing];

    }];
}

- (void)loadMore
{
    _startPage ++;
    [[AFHTTPRequestOperationManager manager] GET:ulrStr parameters:@{@"startPage":@(_startPage),@"sizePerPage":@10} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        BOOL isOk = [responseObject[@"isOk"] boolValue];
        if(!isOk)
        {
            [_tableView.footer endRefreshingWithNoMoreData];
            return;
        }
        NSArray *array = responseObject[@"result"];
        NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.array];
        [array enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ListModel *model = [[ListModel alloc] initWithDictionary:obj];
            [mutableArr addObject:model];
        }];
        
        [self cacheImages:mutableArr completion:^{
            [_tableView.footer endRefreshing];
            self.array = mutableArr;
        }];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        [_tableView.footer endRefreshing];
        _startPage --;

    }];

}
//缓存图片
- (void)cacheImages:(NSArray<ListModel *> *)array completion:(void(^)())complete
{
    dispatch_group_t group = dispatch_group_create();
    for (ListModel *model in array) {
        
        for (NSURL *url in model.pictureUrls) {
            dispatch_group_enter(group);
                [[SDWebImageManager sharedManager] downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    dispatch_group_leave(group);
                }];
        }
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if(complete)
        {
            complete();
        }
    });
}

- (void)setArray:(NSArray *)array
{
    _array = array;
    [self.rowHeightCache removeAllObjects];
    [_tableView reloadData];
}
//保存行高
- (NSCache *)rowHeightCache
{
    if(!_rowHeightCache)
    {
        _rowHeightCache = [[NSCache alloc] init];
    }
    
    return _rowHeightCache;
}

- (void)setupUI
{
    self.navigationItem.title = @"朋友圈";
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    __weak typeof(self) weakSelf = self;
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMore];
    }];
    _tableView.footer.hidden = YES;
    [_tableView.header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.listModel = self.array[indexPath.row];
//    cell.expandBtn.tag = indexPath.row;
//    [cell.expandBtn addTarget:self action:@selector(expandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.clickMeBtn.tag = indexPath.row;
    [cell.clickMeBtn addTarget:self action:@selector(clickMeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListModel *model = self.array[indexPath.row];
    NSString *key = model.discussID.stringValue;
    NSNumber *value = [self.rowHeightCache objectForKey:key];
    if(value)
    {
        return [value floatValue];
    }
    MyTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
    CGFloat height = [cell calculateRowHeightWithModel:model];
    [self.rowHeightCache setObject:@(height) forKey:key];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self resetTipView];
}

//- (void)expandBtnClick:(UIButton *)sender
//{
//    ListModel *model = self.array[sender.tag];
//    model.isExpand = !model.isExpand;
//    NSString *key = model.discussID.stringValue;
//    [self.rowHeightCache removeObjectForKey:key];
//    [_tableView beginUpdates];
//    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [_tableView endUpdates];
//}

- (void)showPhotoBrower:(NSNotification *)notification
{
    [self resetTipView];
    if(!notification.userInfo[@"urls"])
    {
        NSLog(@"urls为空");
        return;
    }
    if(!notification.userInfo[@"indexPath"])
    {
        NSLog(@"indexPath为空");
        return;
    }
    

    NSArray *urls = notification.userInfo[@"urls"];
    NSIndexPath *indexPath = notification.userInfo[@"indexPath"];
//    NSMutableArray *mutableArr = [NSMutableArray array];
//    for(int i = 0;i<urls.count;i++)
//    {
//        NSURL *url = [NSURL URLWithString:@"http://img3.3lian.com/2013/v8/72/d/61.jpg"];
//        //https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1472008445&di=e1068a4a959151eaa7c48825610be094&src=http://d.hiphotos.baidu.com/zhidao/pic/item/3b87e950352ac65c1b6a0042f9f2b21193138a97.jpg
////        NSURL *url = [NSURL URLWithString:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1472008445&di=e1068a4a959151eaa7c48825610be094&src=http://d.hiphotos.baidu.com/zhidao/pic/item/3b87e950352ac65c1b6a0042f9f2b21193138a97.jpg"];
//
//        [mutableArr addObject:url];
//    }
    SWPhotoBrowerController *browerVC = [[SWPhotoBrowerController alloc] initWithIndex:indexPath.row delegate:notification.object normalImageUrls:urls bigImageUrls:nil];
    [self showBrower:browerVC];
}

- (TipView *)tipView
{
    if(!_tipView)
    {
        _tipView = [TipView tipView];
        _tipView.delegate = self;
    }
    
    return _tipView;
}

- (void)clickMeBtnClick:(UIButton *)sender
{
    self.tipView.tag = sender.tag;
    if(_currentBtn && _currentBtn != sender)
    {
        _currentBtn.selected = false;
        self.tipView.hidden = YES;
        self.tipView.isShowing = false;
        self.tipView.transform = CGAffineTransformMakeScale(0.01, 1.0);
    }
    sender.selected = !sender.selected;
    _currentBtn = sender;
    self.tipView.hidden = false;
    if(sender.isSelected)
    {
        MyTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
        CGRect rect = self.tipView.frame;
        rect.origin = CGPointMake(cell.clickMeBtn.frame.origin.x - rect.size.width - 5, cell.clickMeBtn.frame.origin.y);
        self.tipView.frame = rect;
        [cell.contentView addSubview:self.tipView];
        [self.tipView show];

    }else{
        [self.tipView hide];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self resetTipView];
}

//重置转发评论view
- (void)resetTipView
{
    if(_currentBtn)
    {
        _currentBtn.selected = false;
    }
    [self.tipView hide];

}

#pragma mark - TipViewDelegate
- (void)tipView:(TipView *)tipView btnClick:(UIButton *)btn
{
    NSLog(@"%ld",tipView.tag);
    _currentBtn.selected = false;
    switch (btn.tag) {
        case TipViewButtonTypeForward://转发
        {
            
        }
            break;
            
        case TipViewButtonTypeComment://评论
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
