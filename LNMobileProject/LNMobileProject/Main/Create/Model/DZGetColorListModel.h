//
//  DZGetColorListModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/29.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZColorModel : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *item;
@property (strong, nonatomic) NSString *color_code;
@property (strong, nonatomic) NSString *color_img;

@property (nonatomic) BOOL isSelected;

@end

@interface DZGetColorListModel : LNNetBaseModel

@property (strong, nonatomic) NSArray *data;

@end
