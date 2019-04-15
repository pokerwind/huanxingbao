//
//  LNTableViewModel.m
//  LNFrameWork
//
//  Created by LiuYanQi on 2017/7/22.
//  Copyright © 2017年 LiuYanQi. All rights reserved.
//

#import "LNTableDataController.h"

@implementation LNTableDataController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentPage = 1;
    }
    return self;
}

- (void)refreshData{
    self.currentPage = 1;
    NSString *page= [NSString stringWithFormat:@"%zd",self.currentPage];
    [self loadDataWithPage:page.integerValue];
}
- (void)loadMoreData{
    self.currentPage ++;
    NSString *page= [NSString stringWithFormat:@"%zd",self.currentPage];
    [self loadDataWithPage:page.integerValue];
}

- (void)loadData{
    self.currentPage = 1;
    [self loadDataWithPage:1];
}

- (void)loadDataWithPage:(NSInteger)page{
    
}

@end
