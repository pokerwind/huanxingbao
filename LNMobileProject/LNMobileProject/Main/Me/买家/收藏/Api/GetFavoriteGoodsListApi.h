//
//  GetFavoriteGoodsListApi.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/8/16.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LCBaseRequest.h"

@interface GetFavoriteGoodsListApi : LCBaseRequest<LCAPIRequest>

- (instancetype)initWithPage:(NSInteger)page;

- (void)setPage:(NSInteger)page;

@end
