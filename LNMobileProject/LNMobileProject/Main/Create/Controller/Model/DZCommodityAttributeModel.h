//
//  DZCommodityAttributeModel.h
//  LNMobileProject
//
//  Created by liuniukeji on 2017/8/30.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZCommodityAttributeModel : NSObject
@property (nonatomic, strong) NSString *attr_id;
@property (nonatomic, strong) NSString *attr_name;
@property (nonatomic, strong) NSArray *values;
/****** 额外的辅助属性 ******/

/** cell的高度 */
@property (nonatomic, assign,readonly) CGFloat cellHeight;
@end
