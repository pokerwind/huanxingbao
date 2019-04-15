//
//  GetVerifyAPI.h
//  LNMobileProject
//
//  Created by LNMac007 on 2017/5/25.
//  Copyright © 2017年 LiuYanQi. All rights reserved.
//

#import "LCBaseRequest.h"

@interface GetVerifyAPI : LCBaseRequest<LCAPIRequest>
- (instancetype)initWithPhone:(NSString *)phone type:(NSInteger)type;
@end
