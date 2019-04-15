//
//  LNTableViewModel.h
//  LNFrameWork
//
//  Created by LiuYanQi on 2017/7/22.
//  Copyright © 2017年 LiuYanQi. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "LNTableViewController.h"

@class LNTableDataController;

@protocol LNTableViewCallBack <NSObject>

@optional
- (void)tableViewDataController:(LNTableDataController *)dataController
       didRefreshDataWithResult:(id)result
                          error:(NSError *)error;
- (void)tableViewDataController:(LNTableDataController *)dataController
      didLoadMoreDataWithResult:(id)result
                          error:(NSError *)error;

@end

@interface LNTableDataController : NSObject

@property (weak, nonatomic) id<LNTableViewCallBack> viewController;

@property (strong, nonatomic) NSArray *tableArray;

- (void)loadData;
- (void)refreshData;
- (void)loadMoreData;

@property (nonatomic, assign) NSInteger currentPage;

- (void)loadDataWithPage:(NSInteger)currentPage;

@end
