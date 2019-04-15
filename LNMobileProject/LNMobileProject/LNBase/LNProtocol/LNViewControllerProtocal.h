//
//  LNViewControllerProtocal.h
//  LNFrameWork
//
//  Created by LiuYanQi on 2017/7/9.
//  Copyright © 2017年 LiuYanQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LNViewControllerProtocal <NSObject>
@optional
//- (void)lnConfiguration;
//- (void)lnAddUI;


/**
 设置 UI 属性
 添加 UI 视图
 */
- (void)lnSetupUI;

/**
 组织页面需要数据
 */
- (void)lnSetupData;

/**
 加载数据
 */
- (void)lnLoadData;

/**
 刷新 当前页面
 */
- (void)lnUpdateUI;

@end
