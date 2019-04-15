//
//  DZGoodPreviewVC.h
//  LNMobileProject
//
//  Created by 杨允恩 on 2017/9/12.
//  Copyright © 2017年 Liuniu. All rights reserved.
//

#import "LNBaseVC.h"

@protocol DZGoodPreviewVCDelegate <NSObject>

- (void)goodOperationSuccess:(NSString *)goodId;
- (void)goodOperationSuccess;

@end

@interface DZGoodPreviewVC : LNBaseVC

@property (nonatomic) NSString *currentType;//0:已下架1:已上架
@property (strong, nonatomic) NSString *goods_id;

@property (weak, nonatomic) id <DZGoodPreviewVCDelegate>delegate;

@end
