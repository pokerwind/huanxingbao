//
//  DZAddressSelectionVC.h
//  LNMobileProject
//
//  Created by 童浩 on 2019/2/26.
//  Copyright © 2019 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface DZAddressSelectionAVC : LNBaseVC
@property (nonatomic,copy) void(^block) (NSString *lat,NSString *lng,NSString *adds);
@end

NS_ASSUME_NONNULL_END
