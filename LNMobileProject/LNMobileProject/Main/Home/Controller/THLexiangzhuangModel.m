//
//  THLexiangzhuangModel.m
//  LNMobileProject
//
//  Created by 童浩 on 2019/3/14.
//  Copyright © 2019 Liuniu. All rights reserved.
//

#import "THLexiangzhuangModel.h"

@implementation THLexiangzhuangModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"goods_img"]) {
        self.goods_imgUrl = FULL_URL(value);
    }
}
@end
