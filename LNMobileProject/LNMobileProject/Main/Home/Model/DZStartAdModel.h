//
//  DZStartAdModel.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZStartAdModel : NSObject
@property (nonatomic, copy) NSString *ad_id;
@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *link_url;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *click_count;
@property (nonatomic, copy) NSString *display;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *position_id;
@end

@interface DZStartAdNetModel : LNNetBaseModel
@property (nonatomic, strong) NSArray *data;
@end
