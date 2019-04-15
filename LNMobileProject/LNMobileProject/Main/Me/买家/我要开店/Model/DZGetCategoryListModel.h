//
//  DZGetCategoryListModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/23.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

//@interface DZCategoryModel : NSObject
//
//@property (strong, nonatomic) NSString *cat_id;
//@property (strong, nonatomic) NSString *cat_name_mobile;
//@property (strong, nonatomic) NSString *image;
//@property (strong, nonatomic) NSString *parent_id;
//@property (strong, nonatomic) NSArray *_child;
//
//@end

@interface DZCategoryListModel : NSObject

@property (strong, nonatomic) NSString *cat_id;
@property (strong, nonatomic) NSString *cat_name_mobile;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *parent_id;
@property (strong, nonatomic) NSArray *child;

@property (nonatomic) BOOL isSelected;

@end

@interface DZGetCategoryListModel : LNNetBaseModel

@property (strong, nonatomic) NSArray *data;

@end
