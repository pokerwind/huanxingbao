//
//  LNTableViewController.h
//  LNFrameWork
//
//  Created by LiuYanQi on 2017/7/22.
//  Copyright © 2017年 LiuYanQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNTableDataController.h"
#import "MJRefresh.h"
#import "LNBaseVC.h"

@interface LNTableViewController : LNBaseVC <UITableViewDataSource,UITableViewDelegate,LNTableViewCallBack>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic, strong) LNTableDataController *dataController;

@property (nonatomic, assign) UITableViewStyle tableViewStyle; // 用来创建 tableView
// 是否需要下拉刷新和上拉加载
@property (nonatomic, assign) BOOL isNeedPullDownToRefreshAction;
@property (nonatomic, assign) BOOL isNeedPullUpToRefreshAction;
// 空视图
@property (nonatomic, assign) BOOL isNeedTableBlankView;

- (instancetype)initWithStyle:(UITableViewStyle)style;

@end
