//
//  DZGoodCatagoryModel.h
//  LNMobileProject
//
//  Created by 高盛通 on 2019/1/22.
//  Copyright © 2019年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DZGoodCatagory : NSObject

@property (nonatomic, copy) NSString *cat_id;
@property (nonatomic, copy) NSString *cat_name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic,copy)NSString *description;
@property (nonatomic,copy)NSString *display;
@end

@interface DZGoodCatagoryModel : LNNetBaseModel
@property (nonatomic, strong) NSArray *data;
@end

NS_ASSUME_NONNULL_END
