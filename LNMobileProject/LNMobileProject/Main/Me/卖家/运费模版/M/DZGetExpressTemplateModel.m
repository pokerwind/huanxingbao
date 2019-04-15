//
//  DZGetExpressTemplateModel.m
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/30.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "DZGetExpressTemplateModel.h"
#import "DZGetRegionListModel.h"

@implementation DZExpressTemplateModel

- (NSString *)region_id{
    if (self.regionArray.count) {
        NSMutableArray *array = [NSMutableArray array];
        for (DZRegionModel *model in self.regionArray) {
            [array addObject:model.uid];
        }
        return [array componentsJoinedByString:@","];
    }else{
        return _region_id;
    }
}

- (NSString *)region_name{
    if (self.regionArray.count) {
        NSMutableArray *array = [NSMutableArray array];
        for (DZRegionModel *model in self.regionArray) {
            [array addObject:model.region_name];
        }
        return [array componentsJoinedByString:@","];
    }else{
        return _region_name;
    }
}

@end

@implementation DZGetExpressTemplateModel

+ (NSDictionary *)objectClassInArray{
    return @{@"data":@"DZExpressTemplateModel"};
}

@end
