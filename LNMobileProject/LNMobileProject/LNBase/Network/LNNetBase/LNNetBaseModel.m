//
//  BaseModel.m
//  MobileProject
//
//  Created by 云网通 on 16/5/30.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "LNNetBaseModel.h"

@implementation LNNetBaseModel

@end

@implementation LNNetBaseModel (Helper)

- (BOOL)isSuccess{
    if ([self.status isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

- (NSError *)error{
    NSInteger code = [self.status integerValue];
    NSString *tempMsg = @"";
    if (self.msg) {
        tempMsg = self.msg;
    }
    NSError *error = [[NSError alloc] initWithDomain:tempMsg code:code userInfo:nil];
    return error;
}

@end
