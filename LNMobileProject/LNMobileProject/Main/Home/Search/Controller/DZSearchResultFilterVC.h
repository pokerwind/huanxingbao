//
//  DZSearchResultFilterVC.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/9.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"
#define kSidebarWidth 270
@interface DZSearchResultFilterVC : LNBaseVC

@property (nonatomic, assign) BOOL isSidebarShown;
@property (nonatomic, strong) RACSubject *filterSubject;
@property (nonatomic, strong) NSArray *sizeArray;
/**
 * 显示/隐藏Sidebar
 */
- (void)showHideSidebar;
@end
