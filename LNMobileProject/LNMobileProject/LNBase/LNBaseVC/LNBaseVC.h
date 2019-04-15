//
//  LNBaseVC.h
//  LNBaseProject
//
//  Created by LiuNiu-MacMini-YQ on 2016/12/23.
//  Copyright © 2016年 LiuNiu-MacMini-YQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNNetBaseModel.h"
#import "DPMobileApplication.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface LNBaseVC : UIViewController<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
-(void)showTabWithIndex:(NSInteger)selectIndex needSwitch:(BOOL)needSwitch showLogin:(BOOL)showLogin;
- (BOOL)checkLogin;
- (void)chat:(NSString *)shopId;
- (void)chatWithInfo:(id)emchat;
@end
