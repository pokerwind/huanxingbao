//
//  DZGetExpressListModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/4.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZExpressListModel : NSObject

@property (strong, nonatomic) NSString *express_id;
@property (strong, nonatomic) NSString *name;

@property (nonatomic) BOOL isSelected;

@end

@interface DZGetExpressListModel : LNNetBaseModel

@property (strong, nonatomic) NSArray *data;

@end
