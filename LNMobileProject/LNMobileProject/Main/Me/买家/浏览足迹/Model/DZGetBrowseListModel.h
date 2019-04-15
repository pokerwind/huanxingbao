//
//  DZGetBrowseListModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/18.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZGetBrowseListModel : LNNetBaseModel

@property (nonatomic, strong) NSArray *data;

@end

@interface DZBrowseListGroupModel : NSObject

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSArray *goods_list;

@end

@interface DZBrowseListItemModel : NSObject

@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, strong) NSString *goods_name;
@property (nonatomic, strong) NSString *goods_img;
@property (nonatomic, strong) NSString *shop_price;
@property (nonatomic, strong) NSString *pack_price;

@property (nonatomic, assign) BOOL selected;//是否选中

@end
