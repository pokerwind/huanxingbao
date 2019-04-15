//
//  DZGetTalkRecordModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/27.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZTalkRecordModel : NSObject

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *admin_type;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *add_time;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *reason;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *refundAmont;

@end

@interface DZGetTalkRecordModel : LNNetBaseModel

@property (strong, nonatomic) NSArray *data;

@end
