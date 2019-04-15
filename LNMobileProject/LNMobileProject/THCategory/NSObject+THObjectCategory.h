//
//  NSObject+THObjectCategory.h
//  GuanTang
//
//  Created by 童浩 on 2018/9/9.
//  Copyright © 2018年 童小浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (THObjectCategory)
+ (instancetype)objectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
