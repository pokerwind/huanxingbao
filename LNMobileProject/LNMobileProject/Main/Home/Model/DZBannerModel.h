//
//  DZBannerModel.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/9/11.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZBannerModel : NSObject
@property (nonatomic, copy) NSString *ad_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link_url;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *item_id;
@end

@interface DZBannerNetModel : LNNetBaseModel
@property (nonatomic, strong) NSArray *data;
@end
