//
//  NewListVM.m
//  LNFrameWork
//
//  Created by LiuYanQi on 2017/7/9.
//  Copyright © 2017年 LiuYanQi. All rights reserved.
//

#import "NewListDataController.h"

@implementation NewListDataController

- (void)click:(UITableView *)tableView didSelected:(NSIndexPath *)indexPath callback:(UICallback)callback{
    callback(nil,nil);
}

/**
 加载数据一般 用于 初始化 界面时数据时 调用
 */
- (void)loadData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.tableArray = @[@"1",@"2",@"3"];
        if ([self.viewController respondsToSelector:@selector(tableViewDataController:didRefreshDataWithResult:error:)]) {
            [self.viewController tableViewDataController:self didRefreshDataWithResult:nil error:nil];
        }
        
    });
}

/**
 下拉刷新
 注意调用 [super refreshData]; 会把 self.currentPage 置为 0;
 */
- (void)refreshData{
    [super refreshData];
//    self.currentPage;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableArray = @[@"1",@"2",@"3"];
        if ([self.viewController respondsToSelector:@selector(tableViewDataController:didRefreshDataWithResult:error:)]) {
            [self.viewController tableViewDataController:self didRefreshDataWithResult:nil error:nil];
        }
        
    });
}

/**
 上拉加载更多 
 注意调用 [super loadMoreData]; 会把 self.currentPage ++ ;
 */
- (void)loadMoreData{
    [super loadMoreData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *temp = @[@"a",@"b",@"c"];
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.tableArray];
        [array addObjectsFromArray:temp];
        self.tableArray = [array copy];
        if ([self.viewController respondsToSelector:@selector(tableViewDataController:didLoadMoreDataWithResult:error:)]) {
            [self.viewController tableViewDataController:self didLoadMoreDataWithResult:nil error:nil];
        }
        
    });
}


@end
