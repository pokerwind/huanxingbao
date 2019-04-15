//
//  BaseModel.h
//  MobileProject
//
//  Created by 云网通 on 16/5/30.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNNetBaseModel : NSObject
@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSString *info;

@end

@interface LNNetBaseModel (Helper)

- (BOOL)isSuccess;

- (NSError *)error;

@end
