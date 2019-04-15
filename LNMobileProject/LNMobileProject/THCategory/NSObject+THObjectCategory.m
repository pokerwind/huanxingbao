//
//  NSObject+THObjectCategory.m
//  GuanTang
//
//  Created by 童浩 on 2018/9/9.
//  Copyright © 2018年 童小浩. All rights reserved.
//

#import "NSObject+THObjectCategory.h"

@implementation NSObject (THObjectCategory)

+ (instancetype)objectWithDictionary:(NSDictionary *)dict {
    return [[[self class] alloc]initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [self init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
