//
//  DZGetFavoriteShopListModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/17.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZGetFavoriteShopListModel : LNNetBaseModel

@property (nonatomic, strong) NSArray *data;

@end

@interface DZShoopsCollectionModel : NSObject

@property (nonatomic, strong) NSString *fav_id;
@property (nonatomic, strong) NSDictionary *shop_info;

@property (nonatomic, assign) BOOL selected;

@end
