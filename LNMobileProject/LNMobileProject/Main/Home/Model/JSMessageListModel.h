//
//  JSMessageListModel.h
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/29.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JSMessageListData;
NS_ASSUME_NONNULL_BEGIN

@interface JSMessageListModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, strong) NSArray *data;

@end
@interface JSMessageListData : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *has_read;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *add_time;

@end

NS_ASSUME_NONNULL_END
