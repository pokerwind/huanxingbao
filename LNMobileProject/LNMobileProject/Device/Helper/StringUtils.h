//
//  StingUtils.h
//  EOPGentrule
//
//  Created by hahaha on 2017/7/7.
//  Copyright © 2017年 RX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringUtils : NSObject

BOOL dx_isNullOrNilWithObject(id object);
+ (BOOL)validateCellPhoneNumber:(NSString *)cellNum;
@end
