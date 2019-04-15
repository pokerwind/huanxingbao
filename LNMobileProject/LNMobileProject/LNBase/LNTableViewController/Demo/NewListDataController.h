//
//  NewListVM.h
//  LNFrameWork
//
//  Created by LiuYanQi on 2017/7/9.
//  Copyright © 2017年 LiuYanQi. All rights reserved.
//

#import "LNTableDataController.h"

@interface NewListDataController : LNTableDataController

/**
 点击事件
 必须完善 注释说明 至少 不能报警告
 @param tableView tableView
 @param indexPath indexPath
 @param callback callback
 */
- (void)click:(UITableView *)tableView didSelected:(NSIndexPath *)indexPath callback:(UICallback)callback;

- (void)loadData;

@end
