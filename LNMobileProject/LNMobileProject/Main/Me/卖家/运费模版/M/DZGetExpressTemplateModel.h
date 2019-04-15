//
//  DZGetExpressTemplateModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/30.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZExpressTemplateModel : NSObject

@property (strong, nonatomic) NSString *express_template_id;
@property (strong, nonatomic) NSString *express_template_name;
@property (strong, nonatomic) NSString *shop_id;
@property (strong, nonatomic) NSString *first_weight;
@property (strong, nonatomic) NSString *add_weight;
@property (strong, nonatomic) NSString *first_money;
@property (strong, nonatomic) NSString *add_money;
@property (strong, nonatomic) NSString *add_time;
@property (strong, nonatomic) NSString *is_default;
@property (strong, nonatomic) NSString *region_id;
@property (strong, nonatomic) NSString *region_name;


@property (strong, nonatomic) NSArray *regionArray;

@end

@interface DZGetExpressTemplateModel : LNNetBaseModel

@property (strong, nonatomic) NSArray *data;

@end
