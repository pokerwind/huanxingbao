//
//  DZMessageDetailViewController.h
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/30.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"
#import "JSMessageListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DZMessageDetailViewController : LNBaseVC
/*
 * list
 */
@property (nonatomic,strong)JSMessageListData *list;
@end

NS_ASSUME_NONNULL_END
