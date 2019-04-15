//
//  JSSucceedTipViewController.h
//  iOSMedical
//
//  Created by 高盛通 on 2018/11/8.
//  Copyright © 2018年 ZJXxiaoqiang. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

@interface JSSucceedTipViewController : LNBaseVC

/*
 * image
 */
@property (nonatomic,copy)NSString *image;

/*
 * 提示内容
 */
@property (nonatomic,copy)NSString *tipStr;

/*
 * 内容
 */
@property (nonatomic,copy)NSString *contentStr;

@end

NS_ASSUME_NONNULL_END
