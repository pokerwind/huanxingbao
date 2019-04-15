//
//  CancelGoodsFavoriteApi.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/17.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LCBaseRequest.h"

@interface CancelGoodsFavoriteApi : LCBaseRequest<LCAPIRequest>

- (instancetype)initWithIds:(NSString *)ids;

@end
