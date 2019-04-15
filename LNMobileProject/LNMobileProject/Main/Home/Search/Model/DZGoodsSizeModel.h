//
//  DZGoodsSizeModel.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/10/25.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZGoodsSizeModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *item;
@property (nonatomic, copy) NSString *color_code;
@end

@interface DZGoodsSizeNetModel : LNNetBaseModel
@property (nonatomic, copy) NSArray *data;
@end
