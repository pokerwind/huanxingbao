//
//  DZChatroomModel.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/26.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZChatroomModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *room_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *max_member;
@property (nonatomic, copy) NSString *litpic;
@property (nonatomic, copy) NSString *create_time;
@end

@interface DZChatroomNetModel : LNNetBaseModel
@property (nonatomic, strong) NSArray *data;
@end
