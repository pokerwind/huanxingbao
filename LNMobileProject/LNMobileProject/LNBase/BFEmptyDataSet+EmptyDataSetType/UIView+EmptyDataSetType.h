//
//  UIView+EmptyDataSetType.h
//  BFEmptyDataSet
//
//  Created by LiuNiu-MacMini-YQ on 16/8/27.
//  Copyright © 2016年 qtone_yzt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EmptyDataType) {
    EmptyDataTypeLoading,       // 加载中
    EmptyDataTypeConnectError,    // 无网络连接
    EmptyDataTypeLogin,         // 提示登录按钮
    EmptyDataTypeList,          // 列表数据为空
};

@interface UIView (EmptyDataSetType)

@property (nonatomic, assign) NSUInteger emptyDataType;

@end
