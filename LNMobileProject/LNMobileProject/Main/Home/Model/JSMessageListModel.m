//
//  JSMessageListModel.m
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/29.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "JSMessageListModel.h"

@implementation JSMessageListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [JSMessageListData class]};
}
@end

@implementation JSMessageListData

@end

