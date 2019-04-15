//
//  DZGetExpressTracesModel.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/19.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNNetBaseModel.h"

@interface DZTracesModel : NSObject

@property (strong, nonatomic) NSString *AcceptTime;
@property (strong, nonatomic) NSString *AcceptStation;

@end

@interface DZExpressTracesModel : NSObject

@property (strong, nonatomic) NSString *EBusinessID;
@property (strong, nonatomic) NSString *ShipperCode;
@property (strong, nonatomic) NSString *Success;
@property (strong, nonatomic) NSString *LogisticCode;
@property (strong, nonatomic) NSString *State;
@property (strong, nonatomic) NSString *express_name;
@property (strong, nonatomic) NSString *express_code;
@property (strong, nonatomic) NSString *goods_counts;
@property (strong, nonatomic) NSArray *Traces;

@end

@interface DZGetExpressTracesModel : LNNetBaseModel

@property (strong, nonatomic) DZExpressTracesModel *data;

@end
